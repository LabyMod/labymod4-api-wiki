!!! info
    The World Object API has been refactored. The new API described here is available starting with the next LabyMod version.

World Objects allow you to render custom 3D content at fixed positions in the Minecraft world.
The system uses immutable snapshots to decouple game-state from rendering, preparing for
Mojang's upcoming render thread separation.

Common use cases include markers, indicators, waypoints, or any custom geometry tied to a world position.

## Overview

The World Object system consists of three main parts:

1. **WorldObject** - defines the game-state (position, lifecycle)
2. **WorldObjectSnapshot** - immutable render-state captured each frame
3. **WorldObjectSubmitter** - creates snapshots and submits render geometry

Each frame, the pipeline interpolates positions, creates an immutable snapshot, and
passes it to the submitter for rendering.

## Creating a World Object

Extend `AbstractWorldObject` and implement lifecycle methods as needed.

=== ":octicons-file-code-16: BeaconObject"
    ```java
    package org.example.myaddon.object;

    import net.labymod.api.client.world.object.AbstractWorldObject;
    import net.labymod.api.client.world.object.CullVolume;
    import net.labymod.api.util.math.vector.DoubleVector3;
    import org.jetbrains.annotations.NotNull;

    public class BeaconObject extends AbstractWorldObject {

        private static final float HALF_WIDTH = 0.5F;
        private static final float HEIGHT = 3.0F;

        private final int color;
        private boolean removed;

        public BeaconObject(@NotNull DoubleVector3 position, int color) {
            super(position);
            this.color = color;
        }

        @Override
        @NotNull
        public CullVolume cullVolume() {
            DoubleVector3 pos = this.position();
            return CullVolume.box(
                pos.getX() - HALF_WIDTH, pos.getY(), pos.getZ() - HALF_WIDTH,
                pos.getX() + HALF_WIDTH, pos.getY() + HEIGHT, pos.getZ() + HALF_WIDTH
            );
        }

        @Override
        public boolean shouldRemove() {
            return this.removed;
        }

        @Override
        public void onRemove() {
            // Cleanup logic when removed from the registry
        }

        public int getColor() {
            return this.color;
        }

        public void markRemoved() {
            this.removed = true;
        }
    }
    ```

### Key Methods

| Method | Description |
|---|---|
| `position()` | Returns the world position. Override for dynamic positions (e.g. entity-tracking). |
| `previousPosition()` | Returns the previous tick's position. Used for interpolation. Defaults to `position()`. |
| `cullVolume()` | Bounding volume for frustum culling. Defaults to a point at `position()`. |
| `canBeCulled()` | Return `false` to skip frustum culling entirely. Default `true`. |
| `shouldRemove()` | Return `true` when the object should be removed. Checked every frame. |
| `onRemove()` | Called once when the object is removed. Use for cleanup. |
| `createWidget()` | Return a `Widget` if this object should have a 2D overlay. |
| `shouldRenderInOverlay()` | Whether the widget should render in the overlay pass. Default `true`. |

## Creating a Snapshot

The snapshot captures all render-relevant state at a specific point in time. Extend
`AbstractWorldObjectSnapshot` which provides camera-relative position (`x`, `y`, `z`) and
`lightCoords` automatically.

=== ":octicons-file-code-16: BeaconSnapshot"
    ```java
    package org.example.myaddon.object;

    import net.labymod.api.client.world.object.snapshot.AbstractWorldObjectSnapshot;
    import net.labymod.api.laby3d.renderer.snapshot.Extras;

    public final class BeaconSnapshot extends AbstractWorldObjectSnapshot {

        private final int color;
        private final float cameraYaw;

        public BeaconSnapshot(
            double x, double y, double z,
            int lightCoords,
            int color,
            float cameraYaw
        ) {
            super(x, y, z, lightCoords, Extras.empty());
            this.color = color;
            this.cameraYaw = cameraYaw;
        }

        public int color() {
            return this.color;
        }

        public float cameraYaw() {
            return this.cameraYaw;
        }
    }
    ```

!!! warning
    Snapshots **must be immutable**. All fields must be `final`, and any referenced objects
    (lists, maps, vectors, etc.) must also be immutable or defensively copied. The snapshot is
    created on the game thread and will be read from a separate render thread once Mojang
    completes their render thread separation. Mutable state will cause race conditions and
    visual glitches.

!!! tip
    Only include data that is needed for rendering. Pre-compute values (e.g. scale, fade,
    transition) in `createSnapshot()` rather than in the submit phase.

## Creating a Submitter

The submitter has two responsibilities:

1. **`createSnapshot()`** - build the snapshot from the world object and camera state.
   The `x`, `y`, `z` parameters are already interpolated and camera-relative.
2. **`submit()`** - use the snapshot to emit render geometry

=== ":octicons-file-code-16: BeaconSubmitter"
    ```java
    package org.example.myaddon.object;

    import net.labymod.api.client.render.matrix.Stack;
    import net.labymod.api.client.render.state.world.CameraSnapshot;
    import net.labymod.api.client.world.object.submit.WorldObjectSubmitter;
    import net.labymod.api.laby3d.render.queue.SubmissionCollector;
    import org.jetbrains.annotations.NotNull;

    public final class BeaconSubmitter
        extends WorldObjectSubmitter<BeaconObject, BeaconSnapshot> {

        @Override
        @NotNull
        public BeaconSnapshot createSnapshot(
            @NotNull BeaconObject beacon,
            double x, double y, double z,
            int lightCoords,
            @NotNull CameraSnapshot camera
        ) {
            return new BeaconSnapshot(
                x, y, z,
                lightCoords,
                beacon.getColor(),
                camera.getYaw()
            );
        }

        @Override
        public void submit(
            @NotNull Stack stack,
            @NotNull SubmissionCollector collector,
            @NotNull BeaconSnapshot snapshot
        ) {
            stack.push();
            stack.translate(snapshot.x(), snapshot.y(), snapshot.z());

            // Billboard toward the camera
            stack.rotate(snapshot.cameraYaw(), 0F, 1F, 0F);

            // Submit render geometry using the collector, e.g.:
            // collector.submitIcon(stack, icon, displayMode, x, y, width, height, color);
            // collector.submitRectangle(stack, x, y, width, height, color, lightCoords);
            // collector.submitComponent(stack, component, x, y, ...);

            stack.pop();
        }
    }
    ```

## Registering Everything

Register your submitter and world objects in your addon's `enable()` method.

=== ":octicons-file-code-16: ExampleAddon"
    ```java
    package org.example.myaddon;

    import net.labymod.api.Laby;
    import net.labymod.api.addon.LabyAddon;
    import net.labymod.api.client.world.object.WorldObjectDispatcher;
    import net.labymod.api.client.world.object.WorldObjectRegistry;
    import net.labymod.api.util.math.vector.DoubleVector3;
    import org.example.myaddon.object.BeaconObject;
    import org.example.myaddon.object.BeaconSubmitter;

    @AddonMain
    public class ExampleAddon extends LabyAddon<ExampleConfiguration> {

        @Override
        protected void enable() {
            // Register the submitter for your world object type
            WorldObjectDispatcher dispatcher = Laby.references().worldObjectDispatcher();
            dispatcher.registerSubmitter(BeaconObject.class, new BeaconSubmitter());
        }

        // Call this whenever you want to place an object in the world.
        // The id should be unique per object instance.
        public void placeBeacon(double x, double y, double z, int color) {
            WorldObjectRegistry registry = Laby.references().worldObjectRegistry();
            registry.register(
                "my_beacon_" + x + "_" + y + "_" + z,
                new BeaconObject(new DoubleVector3(x, y, z), color)
            );
        }
    }
    ```

## Frustum Culling

Objects outside the camera frustum are automatically skipped. Control culling behavior with:

- **`CullVolume.point(position)`** - a single point (default). Good for small objects.
- **`CullVolume.box(minX, minY, minZ, maxX, maxY, maxZ)`** - an axis-aligned bounding box.
  Use this for larger objects to ensure they remain visible when partially on screen.
- **`canBeCulled()` returning `false`** - disables culling. The object is always rendered regardless
  of camera direction. Use sparingly.

!!! warning
    Make sure your cull volume fully contains your rendered geometry. If the volume is too small,
    the object will pop in and out as the camera moves.

!!! tip
    You can enable **World Object Cull Volumes** in the debug tools to visualize the cull volumes of all world objects. You can also enable **Frustum Debug** to freeze the frustum and inspect which objects are being culled.

## Lifecycle

1. You register a `WorldObject` into the `WorldObjectRegistry`
2. Each frame, the pipeline calls `shouldRemove()`. If `true`, `onRemove()` is called and the object is unregistered
3. For visible objects (passing frustum culling), the submitter creates a snapshot
4. The snapshot is submitted for rendering

Objects self-manage their removal via `shouldRemove()`. There is no external unregister API.
Set a flag on your object and return `true` from `shouldRemove()`.

## Dynamic Positions

For objects that follow an entity or move over time, override `position()` and
`previousPosition()` to enable smooth interpolation:

```java
@Override
@NotNull
public DoubleVector3 position() {
    // Return current position (updated each tick)
    return this.currentPosition;
}

@Override
@NotNull
public DoubleVector3 previousPosition() {
    // Return last tick's position for interpolation
    return this.lastTickPosition;
}
```

The pipeline automatically interpolates between `previousPosition()` and `position()`
using `partialTicks` before passing the camera-relative coordinates to your submitter's
`createSnapshot()`.
