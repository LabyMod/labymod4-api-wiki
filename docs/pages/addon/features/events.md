With LabyMod 4 we not only deliver more Events, but they are also very similar to use, like the events of Minecraft server software like Bukkit and BungeeCord.

## The Most Important Events

We deliver a variety of events, but the following are the ones with the most common use cases:

### Addon Enable Event

The `AddonEnableEvent` is fired right after we detected your addon. This Event is only fired in your addon; you cannot use it to detect other addons. The event contains the Installed Addon Info, the reference storage of your addon and the main instance your addon was initialized with.

### Addon Post Enable Event

The exact moment when the `AddonPostEnableEvent` is fired depends on the current state of LabyMod. Suppose your addon is loaded directly after the game start (for example while in the addon develop environment or when the addon has been installed before). In that case, the Event will be fired as soon as LabyMod itself has been fully initialized. But if your addon is enabled while LabyMod is already initialized (when a user downloads your addon via the addon store), the Event will be fired right after we enabled it.
 
### Global Addon Post Enable Event

The `GlobalAddonPostEnableEvent` is called if an addon has been enabled. Same as `AddonPostEnableEvent`, the moment the event is fired depends on the current state of LabyMod. Can be used to detect if another addon has been enabled.

### Addon Unload Event

The class exists, but the Event won't be fired yet. It can be used to save custom configurations or close open connections to prevent a timeout.

### Chat Message Send Event

The `ChatMessageSendEvent` is fired when sending a chat message to the server. It can be used to manipulate outgoing messages but also can be canceled. 

### Chat Receive Event

The `ChatReceiveEvent` is fired when a message is registered to be shown in chat. It can be used to manipulate incoming messages. The Event is cancellable.

### Game Tick Event

The `GameTickEvent` is fired twice every tick. Once with the phase `PRE` and once with the phase `POST`. The phase represents the current state of a tick. If it has the phase `PRE`, it is fired before Minecraft registers the tick to all its different handlers; if it's the `POST` phase, it is fired after Minecraft itself handled the tick. A tick represents 50 milliseconds (20 ticks per second).

### Json Config Loader Initialize Event

The `JsonConfigLoaderInitializeEvent` is fired when the configuration loader is initialized. This Event is used to create your own type adapters for your configuration.

### Server Disconnect Event

The `ServerDisconnectEvent` will be fired if the connection to a server closes (so either if the user disconnects or gets kicked).

### Server Join Event

The `ServerJoinEvent` will be fired as soon as the user connects to a server. Contains the ServerData.

### Sub Server Switch Event

The `SubServerSwitchEvent` is fired when the user is already connected to a server but switches to a sub-server (for example, when connected to a proxy and switching from the hub to survival games).

### Server Switch Event

The `ServerSwitchEvent` will be fired when the user is on a server and then joins another server from the server list without disconnecting.

### Setting Initialize Event

The `SettingInitializeEvent` is fired when an in-game setting was initialized; is used to modify setting Widgets at a later point (adding custom entries to a Dropdown for example). 
**The listener has to be registered before the setting category is added!**

## List of (nearly) all Events
???+ information "Note"

    LabyMod 4 is constantly being developed and new events are added on a regular basis. This list is therefore not guaranteed to be complete.

| Event Name | Description |
|------------|-------------|
| **Addon Lifecycle Events** |
| `AddonEnableEvent` | Fired right after an addon is detected |
| `AddonPostEnableEvent` | Fired after LabyMod is fully initialized or right after an addon is enabled |
| `GlobalAddonEnableEvent` | Fired when any addon is enabled |
| `GlobalAddonPostEnableEvent` | Fired after any addon is fully enabled |
| **Block Entity Events** |
| `BlockEntityPreLoadEvent` | Fired before a block entity is loaded |
| `BlockEntityUpdateEvent` | Fired when a block entity is updated |
| `SignBlockEntityPostLoadEvent` | Fired after a sign block entity is loaded |
| **Chat Events** |
| `ActionBarReceiveEvent` | Fired when an action bar message is received |
| `ChatClearEvent` | Fired when the chat is cleared |
| `ChatMessageAddEvent` | Fired when a message is added to the chat |
| `ChatMessageGuessSenderEvent` | Fired when the sender of a chat message is being guessed |
| `ChatMessageSendEvent` | Fired when sending a chat message to the server. Allows modifying the message content, checking if it's a command, controlling whether it appears in chat history, or cancelling it entirely |
| `ChatMessageUpdateEvent` | Fired when a chat message is updated |
| `ChatReceiveEvent` | Fired when a message is received in chat. Allows accessing and modifying the message content or cancelling the message entirely |
| `ChatScreenUpdateEvent` | Fired when the chat screen is updated |
| `AdvancedChatReloadEvent` | Fired when advanced chat is reloaded |
| `AdvancedChatTabMessageEvent` | Fired when a message is added to an advanced chat tab |
| **Component Events** |
| `ComponentDeserializeEvent` | Fired when a component is deserialized |
| `ComponentSerializeEvent` | Fired when a component is serialized |
| `ComponentFlattenerConstructEvent` | Fired when a component flattener is constructed |
| **Player Events** |
| `ClientHotbarSlotChangeEvent` | Fired when the player changes their hotbar slot |
| `ClientPlayerAbilitiesUpdateEvent` | Fired when player abilities are updated |
| `ClientPlayerInteractEvent` | Fired when the player interacts with the world |
| `DamageBlockedEvent` | Fired when damage to a player is blocked |
| `FieldOfViewModifierEvent` | Fired when the field of view is modified |
| `CameraLockEvent` | Fired when the camera is locked |
| `CameraUnlockEvent` | Fired when the camera is unlocked |
| `InventorySetSlotEvent` | Fired when an inventory slot is set |
| **GUI Events** |
| `HudWidgetEvent` | Fired for HUD widget-related actions |
| `ActivityInitializeEvent` | Fired when an activity is initialized |
| `ActivityOpenEvent` | Fired when an activity is opened |
| `FileDroppedEvent` | Fired when a file is dropped onto the game window |
| `IngameMenuInitializeEvent` | Fired when the in-game menu is initialized |
| `ScreenDisplayEvent` | Fired when a screen is displayed |
| `ScreenOpenEvent` | Fired when a screen is opened |
| `ScreenResizeEvent` | Fired when the screen is resized |
| `ScreenUpdateVanillaWidgetEvent` | Fired when a vanilla widget is updated |
| `VanillaWidgetReplacementEvent` | Fired when a vanilla widget is replaced |
| `VersionedScreenInitEvent` | Fired when a versioned screen is initialized |
| `PlayerListUpdateEvent` | Fired when the player list is updated |
| `ServerBannerEvent` | Fired when a server banner is displayed |
| `ThemeChangeEvent` | Fired when the theme is changed |
| `ThemeLoadEvent` | Fired when a theme is loaded |
| `ThemeRegisterEvent` | Fired when a theme is registered |
| `ThemeUnregisterEvent` | Fired when a theme is unregistered |
| `ThemeUpdateEvent` | Fired when a theme is updated |
| `TitleScreenLogoInitializeEvent` | Fired when the title screen logo is initialized |
| `TitleScreenOpenedEvent` | Fired when the main menu is fully opened, after the open sequence is finished and all parts of the menu are initialized. Can detect if this is the first time the title screen is opened during the application's lifecycle |
| `TitleScreenRenderEvent` | Fired when the title screen is rendered |
| `TitleScreenSplashTextEvent` | Fired when the title screen splash text is displayed |
| `WindowResizeEvent` | Fired when the game window is resized |
| `WindowShowEvent` | Fired when the game window is shown |
| **Input Events** |
| `CharacterTypedEvent` | Fired when a character is typed |
| `KeyEvent` | Fired when a keyboard key is pressed or released. Provides information about which key was affected and the action (press, release, repeat). Can be cancelled to prevent the key input from being processed |
| `RegisterKeybindingEvent` | Fired when a keybinding is registered |
| **Lifecycle Events** |
| `GameFpsLimitEvent` | Fired when the FPS limit is changed |
| `GameShutdownEvent` | Fired when the game is shutting down |
| `GameTickEvent` | Fired twice every game tick (PRE and POST phases). Useful for performing periodic tasks or animations that need to be synchronized with the game's update cycle |
| **Miscellaneous Events** |
| `CaptureScreenshotEvent` | Fired when a screenshot is captured |
| `VanillaOptionsSaveEvent` | Fired when vanilla options are saved |
| `WriteScreenshotEvent` | Fired when a screenshot is written to disk |
| **Network Events** |
| `PlayerInfoAddEvent` | Fired when player info is added |
| `PlayerInfoRemoveEvent` | Fired when player info is removed |
| `NetworkDisconnectEvent` | Fired when disconnecting from a network (deprecated) |
| `NetworkServerSwitchEvent` | Fired when switching servers within a network |
| `NetworkSwitchEvent` | Fired when switching networks |
| `ServerDisconnectEvent` | Fired when the connection to a server closes (disconnect, kick, or network interruption). Provides access to server data for cleanup operations |
| `ServerJoinEvent` | Fired when the client is ready to send packets to the server/network after joining |
| `ServerSwitchEvent` | Fired when switching between different server networks without fully disconnecting. Provides access to both old and new server data |
| `SubServerSwitchEvent` | Fired when switching between sub-servers within the same network (e.g., moving between game modes on a BungeeCord/Velocity network) |
| **Render Events** |
| `ConfigureMojangShaderEvent` | Fired when Mojang shaders are configured |
| `PlayerNameTagRenderEvent` | Fired when a player name tag is rendered |
| `RenderEvent` | Fired during rendering |
| `RenderTypeAttachmentEvent` | Fired when a render type is attached |
| `CameraRotationEvent` | Fired when the camera rotates |
| `EntityRenderEvent` | Fired when an entity is rendered |
| `EntityRenderPassEvent` | Fired during an entity render pass |
| `PlayerItemRenderContextEvent` | Fired when rendering a player's item |
| `HumanoidModelAnimateEvent` | Fired when a humanoid model is animated |
| `HudWidgetDropzoneElementShiftEvent` | Fired when a HUD widget dropzone element is shifted |
| `PostProcessingScreenEvent` | Fired during post-processing of the screen |
| `ShadowRenderPassContextEvent` | Fired during shadow rendering |
| `RenderBlockSelectionBoxEvent` | Fired when rendering the block selection box |
| `RenderWorldEvent` | Fired when the world is rendered |
| **Resource Events** |
| `ReleaseTextureEvent` | Fired when a texture is released |
| `IncompatibleResourcePacksEvent` | Fired when incompatible resource packs are detected |
| `ResourceReloadEvent` | Fired when resources are reloaded |
| `RegisterResourceTransformerEvent` | Fired when a resource transformer is registered |
| **Scoreboard Events** |
| `ScoreboardObjectiveUpdateEvent` | Fired when a scoreboard objective is updated |
| `ScoreboardScoreUpdateEvent` | Fired when a scoreboard score is updated |
| `ScoreboardTeamUpdateEvent` | Fired when a scoreboard team is updated |
| **Session Events** |
| `SessionUpdateEvent` | Fired when the session is updated |
| **World Events** |
| `DimensionChangeEvent` | Fired when the dimension changes |
| `EntityDestructEvent` | Fired when an entity is destroyed |
| `EntitySpawnEvent` | Fired when an entity spawns |
| `ItemStackTooltipEvent` | Fired when an item stack tooltip is displayed |
| `WorldLeaveEvent` | Fired when leaving a world |
| `BlockUpdateEvent` | Fired when a block is updated |
| `ChunkEvent` | Fired for chunk-related actions |
| `LightUpdateEvent` | Fired when lighting is updated |
| **LabyMod Events** |
| `LabyModRefreshEvent` | Fired when LabyMod is refreshed |
| `ServiceLoadEvent` | Fired when a service is loaded |
| `SubscribeMethodRegisterEvent` | Fired when a subscribe method is registered |
| `ConfigurationLoadEvent` | Fired when a configuration is loaded |
| `ConfigurationSaveEvent` | Fired when a configuration is saved |
| `ConfigurationVersionUpdateEvent` | Fired when a configuration version is updated |
| `SettingInitializeEvent` | Fired when a setting is initialized |
| `SettingResetEvent` | Fired when a setting is reset |
| `SettingWidgetInitializeEvent` | Fired when a setting widget is initialized |
| `ImGuiInitializeEvent` | Fired when ImGui is initialized |
| `LabyConnectChatMessageDeleteEvent` | Fired when a LabyConnect chat message is deleted |
| `LabyConnectEvent` | Fired for LabyConnect-related actions |
| `LabyConnectChatDropdownInitializeEvent` | Fired when a LabyConnect chat dropdown is initialized |
| `LabyConnectChatInitializeEvent` | Fired when LabyConnect chat is initialized |

## Create Your Very Own Events

### Create a Basic Event

If you cannot find a suitable event for your needs, you can simply create your own event. You can create a basic event by creating a new class and implementing the `Event` interface.

Events are particularly useful when working with version-dependent code. For example, if you want to play a sound every time a player receives an advancement, you can use a custom event so you don't have to implement the logic for each version.

### Fire a Custom Event

To fire/call a custom event, you only need to execute the `Laby.fireEvent` method, which returns the executed event.

### Code Example of the Previous Section

We first create a new class in our `core`- or `api` module called `AdvancementReceiveEvent` and implement the `Event` interface from the `net.labymod.api.event` package.
For this example, we only need a simple class that does not contain any fields. However, you can also add fields that can be changed in your event listener.

=== ":octicons-file-code-16: AdvancementReceiveEvent"
    ``` java
    import net.labymod.api.event.Event;

    public class AdvancementReceiveEvent implements Event {

      public AdvancementReceiveEvent() {
      }

    }
    ```
Now we need to fire the event so that all registered listeners can be notified. We will do this by hooking into the Minecraft code for each version and calling `Laby.fireEvent(new AdvancementReceiveEvent())` every time the player receives a new advancement.

You can find more information about how to hook into Minecraft methods <a href="/pages/addon/features/version-dependent/#access-the-minecraft-code-via-mixin">here</a>.

The last thing to do is to create our listener class called `AdvancementReceivedListener` which will listen for our `AdvancementReceiveEvent` and play a sound for the client every time the event is fired.
The `AdvancementReceivedListener` needs a method annotated with `@Subscribe` and our `AdvancementReceiveEvent` class as parameters. In this method, we can simply call `Laby.labyAPI().minecraft().sounds().playButtonPress()` to play a sound for the client every time our event is fired.

=== ":octicons-file-code-16: AdvancementReceivedListener"
    ``` java
    import net.labymod.api.Laby;
    import net.labymod.api.event.Subscribe;

    public class AdvancementReceivedListener {

      @Subscribe
      public void onAdvancementReceived(AdvancementReceivedEvent event) {
        Laby.labyAPI().minecraft().sounds().playButtonPress();
      }

    }
    ```
Finally, we need to register our `AdvancementReceivedListener` class in the `enable()` method of our main addon class by calling `registerListener(new AdvancementReceivedListener())`.
