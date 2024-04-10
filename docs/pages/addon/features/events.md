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