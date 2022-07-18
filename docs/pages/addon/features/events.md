# Use and Create Events

With LabyMod 4 we not only deliver more Events, but they are very similar to use like the events of Minecraft server software like Bukkit and BungeeCord.

## The Most Important Events

We deliver a variety of events, but the following are the ones with the most common use cases:

### Addon Enable Event

The `AddonEnableEvent` is fired right after we detected your addon. This Event is only fired in your addon, you cannot use it to detect other addons.

### Addon Post Enable Event

The exact moment when the `AddonPostEnableEvent` is fired depends on the current state of LabyMod. If your addon is loaded directly after the game start (for example while in the addon develop environment or when the addon has been installed before), the event will be fired as soon as LabyMod itself has been fully initialized. But if your addon is enabled while LabyMod is already initialized (when a user downloads your addon via the addon store), the event will be fired right after we enabled it.
 
### Addon Unload Event

The class exists, but the event won't be fired yet. Can be used to save custom configurations or close open connections to prevent a timeout.

### Chat Message Send Event

The `ChatMessageSendEvent` is fired when sending a chat message to the server. Can be used to manipulate outgoing messages but also can be canceled. 

### Chat Receive Event

The `ChatReceiveEvent` is fired when a message is registered to be shown in chat. Can be used to manipulate incoming messages. The event can be canceled.

### Game Tick Event

The `GameTickEvent` is fired twice every tick. Once with the phase `PRE` and once with the phase `POST`. The phase represents the current state of a tick. If it has the phase `PRE`, it is fired before Minecraft registers the tick to all its different handlers, if it's the `POST` phase, it is fired after Minecraft itself handled the tick. A tick represents 50 milliseconds (20 ticks per second).

### Network Disconnect Event

The `NetworkDisconnectEvent` will be fired if the user connection to a server closes (so either if the user disconnects or gets kicked).

### Network Login Event

The `NetworkLoginEvent` will be fired as soon as the user connects to a server. Contains the ServerData.

### Network Server Switch Event

The `NetworkServerSwitchEvent` is fired when the user is already connected to a server but switches a sub-server (for example when connected to a proxy and switching from the hub to survival games).

## Every Other Event

coming soon

## Create Your Very Own Events

coming soon
