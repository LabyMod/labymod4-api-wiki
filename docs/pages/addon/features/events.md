With LabyMod 4 we not only deliver more Events, but they are also very similar to use, like the events of Minecraft server software like Bukkit and BungeeCord.

## The Most Important Events

We deliver a variety of events, but the following are the ones with the most common use cases:

### Addon Enable Event

The `AddonEnableEvent` is fired right after we detected your addon. This event is only fired in your addon; you cannot use it to detect other addons. The event contains the Installed Addon Info, the reference storage of your addon and the main instance your addon was initialized with.

### Addon Post Enable Event

The exact moment when the `AddonPostEnableEvent` is fired depends on the current state of LabyMod. Suppose your addon is loaded directly after the game start (for example while in the addon develop environment or when the addon has been installed before). In that case, the event will be fired as soon as LabyMod itself has been fully initialized. But if your addon is enabled while LabyMod is already initialized (when a user downloads your addon via the addon store), the event will be fired right after we enabled it.

### Global Addon Post Enable Event

The `GlobalAddonPostEnableEvent` is called if an addon has been enabled. Same as `AddonPostEnableEvent`, the moment the event is fired depends on the current state of LabyMod. Can be used to detect if another addon has been enabled.

### Chat Message Send Event

The `ChatMessageSendEvent` is fired when sending a chat message to the server. It can be used to manipulate outgoing messages but also can be canceled.

### Chat Receive Event

The `ChatReceiveEvent` is fired when a message is registered to be shown in chat. It can be used to manipulate incoming messages. The event is cancellable.

### Game Tick Event

The `GameTickEvent` is fired twice every tick. Once with the phase `PRE` and once with the phase `POST`. The phase represents the current state of a tick. If it has the phase `PRE`, it is fired before Minecraft registers the tick to all its different handlers; if it's the `POST` phase, it is fired after Minecraft itself handled the tick. A tick represents 50 milliseconds (20 ticks per second).

### JSON Config Loader Initialize Event

The `JsonConfigLoaderInitializeEvent` is fired when the configuration loader is initialized. This event is used to create your own type adapters for your configuration.

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
| **Addon Lifecycle Events** | |
| `AddonEnableEvent` | Fired right after an addon is detected. Only fired in the respective addon's scope |
| `AddonPostEnableEvent` | Fired after LabyMod is fully initialized or right after an addon is enabled at runtime |
| `AddonUnloadEvent` | ~~Deprecated: Not fired anymore, addons cannot be unloaded at runtime~~ |
| `GlobalAddonEnableEvent` | Fired when any addon is enabled. Can be used to detect other addons |
| `GlobalAddonPostEnableEvent` | Fired after any addon is fully enabled |
| **Block Entity Events** | |
| `BlockEntityPreLoadEvent` | Fired before a block entity is loaded |
| `BlockEntityUpdateEvent` | Fired when a block entity's data is updated |
| `SignBlockEntityPostLoadEvent` | Fired after a sign block entity has been loaded |
| **Chat Events** | |
| `ActionBarReceiveEvent` | Fired when an action bar message is received from the server |
| `AdvancedChatReceiveEvent` | Fired when the advanced chat system receives a message |
| `AdvancedChatReloadEvent` | Fired when the advanced chat configuration is reloaded |
| `AdvancedChatTabMessageEvent` | Fired when a message is routed to an advanced chat tab |
| `ChatClearEvent` | Fired when the chat history is cleared |
| `ChatMessageAddEvent` | Fired when a message is added to the chat history |
| `ChatMessageGuessSenderEvent` | Fired when LabyMod attempts to determine the sender of a chat message |
| `ChatMessageSendEvent` | Fired when sending a chat message to the server. Allows modifying the message content, checking if it's a command, controlling whether it appears in chat history, or cancelling it entirely |
| `ChatMessageUpdateEvent` | Fired when an existing chat message is updated (e.g. message editing) |
| `ChatReceiveEvent` | Fired when a message is received from the server. Allows accessing and modifying the message content or cancelling the message entirely |
| `ChatScreenUpdateEvent` | Fired when the chat screen UI is updated |
| `ChatTabMessageEvent` | Fired when a message is processed for chat tab filtering |
| **Component Events** | |
| `ComponentDeserializeEvent` | Fired when a text component is deserialized from JSON |
| `ComponentSerializeEvent` | Fired when a text component is serialized to JSON |
| `ComponentFlattenerConstructEvent` | Fired when the component flattener is constructed. Used to customize component text extraction |
| **Player Events** | |
| `ClientHotbarSlotChangeEvent` | Fired when the player changes their selected hotbar slot |
| `ClientPlayerAbilitiesUpdateEvent` | Fired when the player's abilities are updated (e.g. flying, creative mode) |
| `ClientPlayerInteractEvent` | Fired when the player interacts with the world (attack, use item, pick block) |
| `ClientPlayerTurnEvent` | Fired when the player's rotation changes |
| `ClientPlayerUseItemOnBlockEvent` | Fired when the player uses an item on a block |
| `FieldOfViewEvent` | Fired when the field of view is calculated |
| `FieldOfViewModifierEvent` | Fired when a modifier is applied to the field of view (e.g. sprinting, potion effects) |
| `FieldOfViewTickEvent` | Fired each tick when the field of view is recalculated |
| `CameraLockEvent` | Fired when the camera is locked to a specific position |
| `CameraUnlockEvent` | Fired when the camera lock is released |
| `InventorySetSlotEvent` | Fired when an inventory slot is updated by the server |
| **HUD Widget Events** | |
| `HudWidgetCreatedEvent` | Fired when a new HUD widget instance is created |
| `HudWidgetDestroyedEvent` | Fired when a HUD widget instance is destroyed |
| `HudWidgetEvent` | Base event for HUD widget-related actions |
| `HudWidgetMovedEvent` | Fired when a HUD widget is repositioned |
| `HudWidgetRegisterEvent` | Fired when a HUD widget type is registered |
| `HudWidgetUpdateRequestEvent` | Fired when a HUD widget update is requested |
| **Screen/GUI Events** | |
| `ActivityInitializeEvent` | Fired when a LabyMod activity is initialized |
| `ActivityOpenEvent` | Fired when a LabyMod activity is opened |
| `FileDroppedEvent` | Fired when a file is dragged and dropped onto the game window |
| `IngameMenuInitializeEvent` | Fired when the in-game pause menu is initialized. Can be used to add custom buttons |
| `ScreenDisplayEvent` | Fired when a screen is about to be displayed |
| `ScreenOpenEvent` | Fired when a screen is opened |
| `ScreenResizeEvent` | Fired when the screen dimensions change |
| `ScreenUpdateVanillaWidgetEvent` | Fired when a vanilla Minecraft widget is updated on a screen |
| `VanillaWidgetReplacementEvent` | Fired when a vanilla Minecraft widget is being replaced by a LabyMod widget |
| `VersionedScreenInitEvent` | Fired when a version-specific screen is initialized |
| **Player List Events** | |
| `PlayerListUpdateEvent` | Fired when the tab player list is updated |
| `PlayerListUserUpdateEvent` | Fired when a specific player's entry in the player list is updated |
| `ServerBannerEvent` | Fired when a server banner is rendered in the player list |
| **Theme Events** | |
| `ThemeChangeEvent` | Fired when the active theme is switched |
| `ThemeLoadEvent` | Fired when a theme is loaded from disk |
| `ThemeRegisterEvent` | Fired when a new theme is registered |
| `ThemeUnregisterEvent` | Fired when a theme is unregistered |
| `ThemeUpdateEvent` | Fired when a theme's properties are updated |
| **Title Screen Events** | |
| `TitleScreenLogoInitializeEvent` | Fired when the title screen logo is initialized |
| `TitleScreenOpenedEvent` | Fired when the main menu is fully opened and all parts are initialized. Can detect if this is the first time the title screen is opened during the application lifecycle |
| `TitleScreenRenderEvent` | Fired during title screen rendering |
| `TitleScreenSplashTextEvent` | Fired when the title screen splash text is generated |
| **Window Events** | |
| `WindowResizeEvent` | Fired when the game window is resized |
| `WindowShowEvent` | Fired when the game window becomes visible |
| **Input Events** | |
| `CharacterTypedEvent` | Fired when a character is typed via the keyboard |
| `KeyEvent` | Fired when a keyboard key is pressed, released, or held. Provides key code and action type. Can be cancelled to prevent input processing |
| `MouseButtonEvent` | Fired when a mouse button is pressed or released |
| `MouseDragEvent` | Fired during a mouse drag operation |
| `MouseEvent` | Base event for mouse-related input |
| `MouseScrollEvent` | Fired when the mouse scroll wheel is used |
| `RegisterKeybindingEvent` | Fired when a keybinding is registered in the input system |
| **Lifecycle Events** | |
| `GameFpsLimitEvent` | Fired when the FPS limit is applied |
| `GameShutdownEvent` | Fired when the game is shutting down. Use for cleanup operations |
| `GameTickEvent` | Fired twice every game tick (PRE and POST phases). PRE fires before Minecraft processes the tick, POST fires after. A tick is 50ms (20 ticks per second) |
| `ShutdownEvent` | Fired during the shutdown sequence |
| **Miscellaneous Events** | |
| `CaptureScreenshotEvent` | Fired when a screenshot is captured |
| `ScreenshotNotificationEvent` | Fired when a screenshot notification is displayed to the player |
| `VanillaOptionsSaveEvent` | Fired when vanilla Minecraft options are saved |
| `WriteScreenshotEvent` | Fired when a screenshot is written to disk |
| **Network Events** | |
| `IntegratedServerStoppingEvent` | Fired when a singleplayer/LAN world is stopping |
| `NetworkDisconnectEvent` | ~~Deprecated: Use `ServerDisconnectEvent` instead~~ |
| `NetworkLoginEvent` | Fired during the network login phase |
| `NetworkPayloadEvent` | Fired when a custom network payload (plugin message) is received |
| `NetworkServerSwitchEvent` | Fired when switching servers within a network |
| `NetworkSwitchEvent` | Fired when switching between network types |
| `PlayerInfoAddEvent` | Fired when a player is added to the player info list |
| `PlayerInfoRemoveEvent` | Fired when a player is removed from the player info list |
| `PlayerInfoUpdateEvent` | Fired when a player's info is updated (skin, display name, latency, etc.) |
| `ServerDisconnectEvent` | Fired when the connection to a server closes (disconnect, kick, or network interruption). Provides access to server data for cleanup operations |
| `ServerJoinEvent` | Fired when the client is ready to send packets to the server after joining. Contains the ServerData |
| `ServerKickEvent` | Fired when the player is kicked from a server. Provides access to the kick reason |
| `ServerLobbyEvent` | Fired when the player enters or leaves a server lobby |
| `ServerLoginEvent` | Fired during the server login process |
| `ServerSwitchEvent` | Fired when switching between different server networks without fully disconnecting. Provides access to both old and new server data |
| `SubServerSwitchEvent` | Fired when switching between sub-servers within the same network (e.g., moving between game modes on a BungeeCord/Velocity proxy) |
| **Render Events** | |
| `CameraOverlayRenderEvent` | Fired when a camera overlay texture is rendered (pumpkin blur, powder snow outline). Can be cancelled or have its opacity modified in the `PRE` phase |
| `CameraRotationEvent` | Fired when the camera rotation is calculated |
| `CameraSetupEvent` | Fired during camera setup before rendering |
| `EntityRenderEvent` | Fired when an entity is being rendered |
| `EntityRenderPassEvent` | Fired during an entity render pass |
| `EntityRenderStateCreationEvent` | Fired when an entity's render state is created |
| `GameRenderEvent` | Fired during the main game render loop |
| `HumanoidModelAnimateEvent` | Fired when a humanoid model's animation is calculated |
| `HumanoidModelPoseAnimationEvent` | Fired when a humanoid model's pose animation is applied |
| `HudWidgetDropzoneElementShiftEvent` | Fired when a HUD widget dropzone element position is shifted |
| `IngameOverlayElementRenderEvent` | Fired when an individual in-game overlay element is rendered (hotbar, health, etc.) |
| `IngameOverlayRenderEvent` | Fired during in-game overlay rendering |
| `ItemInHandLayerRenderEvent` | Fired when the item-in-hand render layer is processed |
| `PlayerCapeRenderEvent` | Fired when a player's cape is rendered |
| `PlayerItemRenderContextEvent` | Fired when a player's held item render context is set up |
| `PlayerModelRenderEvent` | Fired when a player model is rendered |
| `PlayerModelRenderHandEvent` | Fired when a player model's hand is rendered |
| `PlayerNameTagRenderEvent` | Fired when a player's name tag is rendered above their head |
| `NameTagBackgroundRenderEvent` | Fired when the background of a name tag is rendered |
| `PostProcessingScreenEvent` | Fired during post-processing effects on the screen |
| `RenderBlockSelectionBoxEvent` | Fired when the block selection highlight box is rendered |
| `RenderEvent` | Base event fired during the render cycle |
| `RenderFirstPersonItemInHandEvent` | Fired when the first-person hand/item model is rendered |
| `RenderHandEvent` | Fired when the player's hand is rendered |
| `RenderTypeAttachmentEvent` | Fired when a render type attachment is processed |
| `RenderWorldEvent` | Fired during world rendering |
| `ScreenRenderEvent` | Fired during screen/GUI rendering |
| `ShaderPipelineContextEvent` | Fired when the shader pipeline context is set up (includes shadow render pass) |
| `StringRenderEvent` | Fired when a text string is rendered |
| `StringWidthEvent` | Fired when the width of a text string is calculated |
| `UpdateLightmapTextureEvent` | Fired when the lightmap texture is updated |
| **Resource Events** | |
| `IncompatibleResourcePacksEvent` | Fired when incompatible resource packs are detected |
| `RegisterResourceTransformerEvent` | Fired when a resource transformer is registered |
| `ReleaseTextureEvent` | Fired when a texture resource is released from memory |
| `ResourceReloadEvent` | Fired when game resources are reloaded |
| **Scoreboard Events** | |
| `ScoreboardObjectiveUpdateEvent` | Fired when a scoreboard objective is added, updated, or removed |
| `ScoreboardScoreUpdateEvent` | Fired when a scoreboard score value changes |
| `ScoreboardTeamEntryAddEvent` | Fired when an entry is added to a scoreboard team |
| `ScoreboardTeamEntryRemoveEvent` | Fired when an entry is removed from a scoreboard team |
| `ScoreboardTeamUpdateEvent` | Fired when a scoreboard team's properties are updated |
| **Session Events** | |
| `SessionUpdateEvent` | Fired when the player's session data is updated (e.g. account switch) |
| **World Events** | |
| `BlockUpdateEvent` | Fired when a block in the world is updated |
| `ChunkEvent` | Fired for chunk load/unload operations |
| `DimensionChangeEvent` | Fired when the player changes dimensions (e.g. Overworld to Nether) |
| `EntityDestructEvent` | Fired when an entity is removed from the world |
| `EntitySpawnEvent` | Fired when an entity spawns in the world |
| `ItemStackTooltipEvent` | Fired when an item stack tooltip is generated. Can be used to add or modify tooltip lines |
| `LightUpdateEvent` | Fired when lighting is recalculated for a chunk section |
| `PrepareWorldSnapshotEvent` | Fired when a world snapshot is being prepared |
| `SubmitWorldSnapshotEvent` | Fired when a world snapshot is submitted |
| `WorldEnterEvent` | Fired when the player enters a world |
| `WorldLeaveEvent` | Fired when the player leaves a world |
| `WorldLoadEvent` | Fired when a world is loaded |
| **Server API Events** | |
| `EconomyUpdateEvent` | Fired when economy data is updated via the LabyMod Server API |
| `PermissionStateChangeEvent` | Fired when a permission state changes via the LabyMod Server API |
| `ServerFeatureUpdateEvent` | Fired when the server enables or disables features via the LabyMod Protocol. Can be fired at any point during the session |
| **Configuration Events** | |
| `ConfigurationLoadEvent` | Fired when a configuration file is loaded |
| `ConfigurationSaveEvent` | Fired when a configuration file is saved |
| `ConfigurationVersionUpdateEvent` | Fired when a configuration is migrated to a newer version |
| `JsonConfigLoaderInitializeEvent` | Fired when the JSON config loader is initialized. Used to register custom type adapters |
| `SettingCreateEvent` | Fired when a new setting is created |
| `SettingInitializeEvent` | Fired when a setting is initialized. Used to modify setting widgets (e.g. adding custom dropdown entries). **The listener has to be registered before the setting category is added!** |
| `SettingResetEvent` | Fired when a setting is reset to its default value |
| `SettingUpdateEvent` | ~~Deprecated: Currently broken~~ |
| `SettingWidgetInitializeEvent` | Fired when a setting's UI widget is initialized |
| **LabyMod Core Events** | |
| `LabyModRefreshEvent` | Fired when LabyMod refreshes its state |
| `ServiceLoadEvent` | Fired when a LabyMod service is loaded |
| `SubscribeMethodRegisterEvent` | Fired when an event subscriber method is registered |
| `ImGuiInitializeEvent` | Fired when the ImGui debug overlay is initialized |
| **Discord RPC Events** | |
| `DiscordActivityServerUpdateEvent` | Fired when the Discord Rich Presence server information is updated |
| `DiscordActivityUpdateEvent` | Fired when the Discord Rich Presence activity is updated |
| **Notification Events** | |
| `PopNotificationEvent` | Fired when a notification is removed from the notification stack |
| `PushNotificationEvent` | Fired when a notification is pushed to the player |
| `UpdateNotificationEvent` | Fired when an existing notification is updated |
| **User Events** | |
| `UserDiscoverEvent` | Fired when a LabyMod user is discovered in the session |
| `UserFamiliarEvent` | Fired when a familiar LabyMod user is encountered |
| `UserUpdateDataEvent` | Fired when a LabyMod user's cosmetic or profile data is updated |
| **LabyConnect Events** | |
| `LabyConnectEvent` | Base event for LabyConnect-related actions |
| `LabyConnectStateUpdateEvent` | Fired when the LabyConnect connection state changes |
| `LabyConnectBroadcastEvent` | Fired when a broadcast is received via LabyConnect |
| `LabyConnectDisconnectEvent` | Fired when disconnected from LabyConnect |
| `LabyConnectPlayEmoteEvent` | Fired when an emote is played via LabyConnect |
| `LabyConnectSprayEvent` | Fired when a spray is used via LabyConnect |
| `LabyConnectTokenEvent` | Fired when a LabyConnect token is received |
| `LabyConnectUpdateSettingEvent` | Fired when a LabyConnect setting is updated |
| `LabyConnectChatDropdownInitializeEvent` | Fired when a LabyConnect chat dropdown menu is initialized |
| `LabyConnectChatEvent` | Base event for LabyConnect chat actions |
| `LabyConnectChatInitializeEvent` | Fired when the LabyConnect chat is initialized |
| `LabyConnectChatMessageDeleteEvent` | Fired when a LabyConnect chat message is deleted |
| `LabyConnectChatMessageEvent` | Fired when a LabyConnect chat message is received |
| `LabyConnectChatMessageReadEvent` | Fired when a LabyConnect chat message is marked as read |
| `LabyConnectFriendAddEvent` | Fired when a friend is added via LabyConnect |
| `LabyConnectFriendRemoveEvent` | Fired when a friend is removed via LabyConnect |
| `LabyConnectFriendNoteUpdateEvent` | Fired when a friend's note is updated |
| `LabyConnectFriendPinUpdateEvent` | Fired when a friend is pinned or unpinned |
| `LabyConnectFriendServerEvent` | Fired when a friend's server information changes |
| `LabyConnectFriendStatusEvent` | Fired when a friend's online status changes |
| `LabyConnectIncomingFriendRequestAddEvent` | Fired when an incoming friend request is received |
| `LabyConnectIncomingFriendRequestRemoveEvent` | Fired when an incoming friend request is removed |
| `LabyConnectOutgoingFriendRequestAddEvent` | Fired when an outgoing friend request is sent |
| `LabyConnectOutgoingFriendRequestRemoveEvent` | Fired when an outgoing friend request is removed |
| **Mod Loader Events** | |
| `ModLoadEvent` | Fired when a mod is loaded by the mod loader |
| `ModLoaderDiscoveryEvent` | Fired when the mod loader discovers available mods |
| `ModLoaderInitializeEvent` | Fired when the mod loader is initialized |
| **Laby3D Render Events** | |
| `RenderDeviceInitializedEvent` | Fired when the Laby3D render device is initialized |
| `RenderStateLinkerSetupEvent` | Fired when the Laby3D render state linker is set up |
| `UniformBlockRegistrationEvent` | Fired when a Laby3D uniform block is registered |
| `SubmissionRendererRegistrationEvent` | Fired when a Laby3D submission renderer is registered |

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

You can find more information about how to hook into Minecraft methods [here](version-dependent.md#access-the-minecraft-code-via-mixin).

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
