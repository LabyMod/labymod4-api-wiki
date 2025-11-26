As of version 1.21.3 Minecraft has introduced an immutable rendering state,
this means that rendering only happens based off of immutable objects instead of
taking e.g. the position of a player during the rendering of a frame. This greatly
improves thread safety, but one must know how to make proper use of it.

In this section we want to introduce you to how you can add your own custom data to
the LabyMod state of an Entity which you can then use during rendering.

## Snapshot extras

A LabyMod Snapshot consists of a Map with data called Extras. After its creation it
cannot be modified anymore, it is **immutable**.

Typically, an addon that uses the snapshot feature contains two types in its api module:

=== ":octicons-file-code-16: ExampleExtraKeys"
    ```java
    package org.example.myaddon.api.snapshot;
    
    import net.labymod.api.laby3d.renderer.snapshot.ExtraKey;
    
    public class ExampleExtraKeys {
    
        // The key must be something unique within your addon; it will automatically include your addon's namespace
        public static final ExtraKey<ExampleUserSnapshot> EXAMPLE_USER = ExtraKey.of("example_user", ExampleUserSnapshot.class);
        
        // ... add more keys as required
    }
    ```

=== ":octicons-file-code-16: ExampleUserSnapshot"
    ```java
    package org.example.myaddon.api.snapshot;
    
    import net.labymod.api.client.component.Component;
    import net.labymod.api.laby3d.renderer.snapshot.LabySnapshot;
    
    public interface ExampleUserSnapshot extends LabySnapshot {
        
        Component tag(); // Example
      
        // ... put in whatever custom data you want
    }
    ```

## Snapshot implementation

A typical implementation looks like this, but of course it may also be implemented for
any other Entity type other than Player.

By using `@AutoService` we don't need to manually register the these classes anywhere,
the Annotation Processor does the work for us.

=== ":octicons-file-code-16: ExampleUserSnapshotFactory"
    ```java
    package org.example.myaddon.snapshot;
    
    import org.example.myaddon.api.snapshot.ExampleExtraKeys;
    import org.example.myaddon.api.snapshot.ExampleUserSnapshot;
    import net.labymod.api.client.entity.player.Player;
    import net.labymod.api.laby3d.renderer.snapshot.Extras;
    import net.labymod.api.laby3d.renderer.snapshot.LabySnapshotFactory;
    import net.labymod.api.service.annotation.AutoService;
    
    @AutoService(LabySnapshotFactory.class)
    public class ExampleUserSnapshotFactory extends LabySnapshotFactory<Player, ExampleUserSnapshot> {
    
        public ExampleUserSnapshotFactory() {
            super(ExampleExtraKeys.EXAMPLE_USER);
        }
        
        @Override
        protected ExampleUserSnapshot create(Player player, Extras extras) {
            return new DefaultExampleUserSnapshot(player, extras);
        }
    }
    ```

=== ":octicons-file-code-16: DefaultExampleUserSnapshot"
    ```java
    package org.example.myaddon.snapshot;
    
    import org.example.myaddon.api.snapshot.ExampleUserSnapshot;
    import net.labymod.api.client.component.Component;
    import net.labymod.api.client.entity.player.Player;
    import net.labymod.api.laby3d.renderer.snapshot.AbstractLabySnapshot;
    import net.labymod.api.laby3d.renderer.snapshot.Extras;
    import java.util.UUID;
    
    public class DefaultExampleUserSnapshot extends AbstractLabySnapshot implements ExampleUserSnapshot {
    
        private final Component tag;
        
        public DefaultExampleUserSnapshot(Player player, Extras extras) {
            super(extras);
            
            // You can get any data from the Entity you're getting from the Factory:
            UUID uniqueId = player.getUniqueId();
            
            // ... Get any other data for the player as required (e.g. custom roles, tags, badges, ...)
            
            // Example:
            this.tag = Component.text("My Custom Tag for ").append(player.nameComponent());
        }
        
        @Override
        public Component tag() {
            return this.tag;
        }
    }
    ```

=== ":octicons-file-code-16: PlayerSnapshotProcessor"
    ```java
    package org.example.myaddon.snapshot;
    
    import org.example.myaddon.api.snapshot.ExampleExtraKeys;
    import net.labymod.api.client.entity.Entity;
    import net.labymod.api.client.entity.player.Player;
    import net.labymod.api.client.render.state.entity.EntitySnapshotProcessor;
    import net.labymod.api.client.render.state.entity.EntitySnapshotRegistry;
    import net.labymod.api.laby3d.renderer.snapshot.ExtrasWriter;
    import net.labymod.api.service.annotation.AutoService;
    
    @AutoService(EntitySnapshotProcessor.class)
    public class PlayerSnapshotProcessor extends EntitySnapshotProcessor<Player> {
    
        public PlayerSnapshotProcessor(EntitySnapshotRegistry registry) {
            super(registry);
        }
        
        @Override
        public boolean supports(Entity entity) {
            return entity instanceof Player;
        }
        
        @Override
        public void process(Player player, float partialTicks, ExtrasWriter entityWriter) {
            this.registry().captureSnapshot(entityWriter, ExampleExtraKeys.EXAMPLE_USER, player);
            // ... you can also add more extras here as required
        }
    }
    ```

## Use-cases

For an easy use-case check out the next section: [Entity Tags](entity-tags.md)
