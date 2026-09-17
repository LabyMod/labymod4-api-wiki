The Laby Launcher records the game in the background and can save the last moments as a clip. LabyMod asks for such a clip on its own when something clip-worthy happens, a clutch for example. With the `ClipService` your addon can do the same: ask for a clip right after a moment your addon knows about, and keep those clips together in a folder of their own.

???+ note "Note"
    The clip API is available since LabyMod 4.6.22. Clips only work when the game was started from a Laby Launcher that has clips turned on, and when the user has the **Clip Events** setting enabled. Your addon never has to check for the launcher itself, `isAvailable()` answers all of it at once.

## Getting the Service

The service is a reference, you get it the same way as any other:

```java
ClipService clips = Laby.references().clipService();
```

## Requesting a Clip

The launcher always holds the last moments of gameplay. A request tells it to keep what led up to **now**, so ask right **after** the moment, not before it.

Every clip has a type. Use a `ResourceLocation` in the namespace of your addon, so your events can never be mixed up with the ones of LabyMod or of another addon.

=== ":octicons-file-code-16: ExampleListener"
    ```java
    public class ExampleListener {

      private static final ResourceLocation ACE = ResourceLocation.create("example", "ace");

      private final ClipService clips = Laby.references().clipService();

      public void onAce(int kills) {
        if (!this.clips.isAvailable()) {
          return;
        }

        // type, free detail on the event, a number that belongs to it
        this.clips.requestClip(ACE, kills + " kills", kills);
      }
    }
    ```

| Parameter | Description |
|-----------|-------------|
| `type` | What happened, for example `example:ace`. The launcher tags the clip with the path of the type, this clip is found under `ace` |
| `context` | Free detail on the event, may be empty |
| `value` | A number that belongs to the event, a distance or a count, or `0` |
| `folder` | The folder the clip is saved into, or `null` for none. See [Folders](#folders) |

`requestClip` returns `true` if the request was sent. It returns `false` if clips are not available, or if the cooldown of the user has not passed yet.

???+ warning "Important Note"
    The user sets a cooldown between two clips in the **Clip Events** settings, and it counts for every source together. A clutch clipped by LabyMod and an event of your addon in the same moment are still one clip. Do not try to work around it, and do not request clips for things that happen all the time.

If you need neither detail nor a folder, the short form is enough:

```java
clips.requestClip(ResourceLocation.create("example", "ace"));
```

## Folders

Clips can be saved into a folder of the launcher, so the clips of your addon are not lost between everything else the user records.

You ask the launcher for a folder by its name. If there is no folder of that name yet, the launcher creates it. If there is one already, you get that one back, there is only ever **one folder per name**, without regard to case. Asking again is harmless.

The answer is a `ClipFolder`. Its id is what the launcher knows the folder by, and from then on you use that folder object for your clips instead of the name.

=== ":octicons-file-code-16: ExampleAddon"
    ```java
    @AddonMain
    public class ExampleAddon extends LabyAddon<ExampleConfiguration> {

      private static final ResourceLocation ACE = ResourceLocation.create("example", "ace");

      private ClipFolder folder;

      @Subscribe
      public void onServerJoin(ServerJoinEvent event) {
        ClipService clips = Laby.references().clipService();
        if (!clips.isAvailable()) {
          return;
        }

        clips.createFolder("Example Addon", ClipFolderIcon.block(Block.DIAMOND, Background.SKY))
            .thenAccept(folder -> this.folder = folder);
      }

      public void onAce(int kills) {
        // a folder of null saves the clip into no folder
        Laby.references().clipService().requestClip(ACE, kills + " kills", kills, this.folder);
      }
    }
    ```

`createFolder` does not block the game, it returns a `CompletableFuture<ClipFolder>`.

| The future... | When |
|---------------|------|
| completes with the folder | The launcher created the folder, or found the one of that name |
| fails with an `IllegalStateException` | Clips are not available, or the launcher refused the folder |
| fails with a `TimeoutException` | The launcher did not answer within 5 seconds. A launcher that is too old never answers |
| fails with an `IllegalArgumentException` | The name is empty |

???+ warning "Important Note"
    The future completes on the thread that reads from the launcher, **not** on the game thread. Storing the folder in a field is fine. If you want to touch the game from there, hand the work over to the game thread first.

The name of a folder is cut to 60 characters. A folder that already exists keeps its icon unless you pass one, passing `null` never removes an icon.

The user can rename or delete folders in the launcher at any time. The id survives a rename, so you can store it in your configuration and build the folder again in a later session:

```java
ClipFolder folder = new ClipFolder(storedId, "Example Addon");
```

If the user deleted the folder in the meantime, the clip is still saved, just into no folder. Your addon cannot rename or delete folders.

## Folder Icons

A folder icon is one of the blocks the launcher draws itself, alone or on a colored background, or an image of your own. Without an icon the folder shows the default folder symbol.

```java
// a block
ClipFolderIcon.block(Block.GRASS);

// a block on a colored background
ClipFolderIcon.block(Block.GRASS, Background.SKY);

// your own image: the bytes of a png file, at most 128 KiB. it is shown small, 64 by 64 pixels is plenty
ClipFolderIcon.image(pngBytes);
```

### Blocks

`ClipFolderIcon.Block` lists every block the launcher can draw.

### Backgrounds

`ClipFolderIcon.Background` lists the gradients a block can sit on.

## Related API

Two additions were made for the clutch detection, both can be useful on their own:

| API | Description |
|-----|-------------|
| `Entity#getFallDistance()` | The distance an entity has fallen since it last stood on something, in blocks. It is the counter of the game itself, which sets it back to zero on the ground, in water, in a web, on a climbable and while riding |
| `ClientPlayerMountEvent` | Fired the moment the client player starts to ride an entity. A ride that is over again before the next tick is still reported, which watching `Entity#getVehicle()` once a tick cannot promise |
