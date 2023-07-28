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

## Every Other Event

todo: write

## Create Your Very Own Events

todo: write