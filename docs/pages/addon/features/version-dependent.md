While our API is entirely version-independent for you to use, you might still need to implement some version-dependent
things yourself (such as niche things, just something we didn't implement). At the current moment, you might need to
implement more yourself, as we're still implementing more and more stuff for you to use version independently.

There are two ways to implement version-dependent; different use cases require different ways to implement them.

The easiest method is to create an interface or abstract class and implement it in your desired version(s). This will
result in the ability that you can control your version-dependent code from the core.

The more complex way would be SpongePowered's Mixin. While Mixin is comparatively easy to use, it can be a bit confusing
at the beginning, as all new things are.

???+ warning "Important Note"

    Please keep in mind that the examples on this page are version dependent. We are showing the examples for Minecraft 1.19.1, so depending on the date you're reading this, recreating the examples might not be possible, we'll try to keep them updated, though, and if we do, we update the version in this note.

## Access the Minecraft Code "the Normal Way"
You should only use this method for things you can access without using Reflections, as using Reflections can have a
high impact on the performance of the players that use your addon.

The use case we will implement in the following example will show how to display messages in the player's chat. We have
already implemented this, but it is relatively easy to show and understand.

We will first create a new interface in our `core`- or `api` module called `ExampleChatExecutor`, annotate it with the `@Referenceable` annotation and declare a new
method `void displayMessageInChat(String)`. Now we head to the module of the version we want and create a new class
called `VersionedExampleChatExecutor` in our desired package. If there is no folder called `src` in the module, you'll
need to create the following folder structure inside the module: `src/main/java/`.

Now to the implementation. First, we implement the interface `ExampleChatExecutor`, and now the most important part: we
need to add the annotation `Implement` to the class and declare `ExampleChatExecutor.class` as the argument. This will
allow you to access the versioned implementation from the core module. Then we'll add the annotation `Singleton` to the
class, as we don't need more than one object of this implementation. At this point, the only missing point is the actual
implementation of Minecraft; we'll overwrite the `displayMessageInChat` method from our interface and create a new
Component from our String with `Component.literal(message)`. Then we access the Chat GUI
with `Minecraft.getInstance().gui.getChat()` and add our component with `addMessage(component)`.

To access our `VersionedExampleChatExecutor` from the core module, we need to add a private instance of the `ExampleChatExecutor` with a getter to our `ExampleAddon` class. Then we assign the instance in our `ExampleAddon#enable` method using `((DefaultReferenceStorage) this.referenceStorageAccessor).exampleChatExecutor()`. If the function does not exist, we need to run a gradle build to add the class to our reference storage. We can now access the instance from the core module with `ExampleAddon#chatExecutor()`. Now we can require an `ExampleAddon` instance as a parameter in our `ExamplePingCommand` and pass `this` to the constructor of the command in the `ExampleAddon#enable`. Then we can access the `VersionedExampleChatExecutor` instance from the command and call the `displayMessageInChat` method with `"Pong!"` as an argument.

After starting LabyMod 4, joining a server, and executing "/pong", we'll see a colorless "Pong!". Now, if we want that
message colored, we need to replace `String` in our interface with `Component`. Instead of using `Command.literal`, we
get the `ComponentMapper` via `Laby.labyApi().minecraft().componentMapper()` and call `toMinecraftComponent(component)`.
Now our component from the Adventure Component library was mapped to a Minecraft Component, and
calling `displayMessageInChat(Component.text("Pong!", NamedTextColor.GOLD))` in our Command works like before. Just with
our own implementation.

Those are the results from this example:

=== ":octicons-file-code-16: ExampleChatExecutor"
    ```java
    @Referenceable
    public interface ExampleChatExecutor {
    
      void displayMessageInChat(String message);
    
      void displayMessageInChat(Component adventureComponent);
    }
    ```

=== ":octicons-file-code-16: VersionedExampleChatExecutor"
    ```java
    @Singleton
    @Implements(ExampleChatExecutor.class)
    public class VersionedExampleChatExecutor implements ExampleChatExecutor {
    
      @Override
      public void displayMessageInChat(String message) {
        Component component = Component.literal(message);
        this.addMessageToChat(component);
      }
    
      @Override
      public void displayMessageInChat(net.kyori.adventure.text.Component adventureComponent) {
        ComponentMapper componentMapper = Laby.labyAPI().minecraft().componentMapper();
        Component component = (Component) componentMapper.toMinecraftComponent(adventureComponent);
        Minecraft.getInstance().gui.getChat().addMessage(component);
      }
    
      private void addMessageToChat(Component component) {
        Minecraft.getInstance().gui.getChat().addMessage(component);
      }
    }
    ```

=== ":octicons-file-code-16: ExampleAddon"
    ```java
    public class ExampleAddon extends LabyAddon<ExampleConfiguration> {
    
      private ExampleChatExecutor chatExecutor;

      @Override
      protected void enable() {
        chatExecutor = ((DefaultReferenceStorage) this.referenceStorageAccessor()).exampleChatExecutor();

        this.registerCommand(new ExamplePingCommand(this));
      }

      @Override
      protected Class<? extends ExampleConfiguration> configurationClass() {
        return ExampleConfiguration.class;
      }

      public ExampleChatExecutor chatExecutor() {
        return chatExecutor;
      }
    ```

=== ":octicons-file-code-16: ExamplePingCommand"
    ```java
    public class ExamplePingCommand extends Command {
    
      private final ExampleChatExecutor chatExecutor;

      public ExamplePingCommand(ExampleAddon addon) {
        super("ping", "pong");
        chatExecutor = addon.chatExecutor();
      }
    
      @Override
      public boolean execute(String prefix, String[] arguments) {
        if (prefix.equalsIgnoreCase("ping")) {
          this.displayMessage(Component.text("Ping!", NamedTextColor.AQUA));
          return false;
        }
    
        chatExecutor.displayMessageInChat(Component.text("Pong!", NamedTextColor.GOLD));
        return true;
      }
    }
    ```

## Access the Minecraft Code via Mixin

???+ error "Important Note"

    Please keep in mind that the moment your addon uses Mixins, it requires a restart when downloaded via the addon store.

todo: write

## Inheriting Version Dependent Code

todo: write
