While our API is completely version-independent for you to use, you might still need to implement some version-dependent things yourself (such as highly niche things, just something we didn't implement). At the current moment, you might implement more yourself, as we're still implementing more and more things for you to use version independently.

There are two ways to implement version-dependent, different use cases require different ways to implement them.

The easiest method is to just create an interface or abstract class and implement it in your desired version(s). This will result in the ability, that you can control your version-dependent code from the core. 

The more complex way would be SpongePowered's Mixin. While Mixin itself is comparatively easy to use, it can be a bit confusing at the beginning, as all new things are.

???+ warning "Important Note"

    Please keep in mind that the examples on this page are version dependent. We are showing the examples for Minecraft 1.19.1, so depending on the date you're reading this, recreating the examples might not be possible, we'll try to keep them updated though and if we do, we update the version in this note.

## Access the Minecraft Code "the Normal Way"

This should only be used for things that you can get access to, without using Reflections, as using Reflections can have a high impact on the performance of the players that use your addon. 

The use case we will implement in the following example will show how to display messages in the player's chat. This is already implemented by us, but it is a relatively easy thing to show and understand.

The first thing we will do is create a new interface in our `core`- or `api` module called `ExampleChatExecutor` and declare a new method `void displayMessageInChat(String)`. Then head to the module of the version we want, now create a new class called `VersionedExampleChatExecutor` in our desired package (if there is no folder called `src` in the module, you'll need to create the following folder structure inside the module: `src/main/java/`). 

Now to the implementation. First, we implement the interface `ExampleChatExecutor` and now the most important part: we need to add the annotation `Implement` to the class and declare `ExampleChatExecutor.class` as argument. This will allow you to access the versioned implementation from the core module. Then we'll add the annotation `Singleton` to the class, as we don't need more than one object of this implementation. At this point, the only point that's missing is the actual implementation of Minecraft, we'll overwrite the `displayMessageInChat` method from our interface and create a new Component from our String with `Component.literal(message)`. Then we access the Chat GUI with `Minecraft.getInstance().gui.getChat()` and add our component with `addMessage(component)`. 

After implementing the `ExampleChatExecutor` interface, we go back to our `core` module and head into our `ExamplePingCommand`, that we got from using the addon template. Then we remove the line where we are displaying a gold-colored "Pong!" component and get the object of our interface via `LabyGuice.getInstance(ExampleChatExecutor.class)` (we need to get the instance of the interface because we have no access to the `VersionedExampleChatExecutor` class when not in this specific module). Now all we need to do is call the `displayMessageInChat` method from our interface and declare a String as an argument, we'll be using `"Pong!"` again.

After starting LabyMod 4, joining a server and executing "/pong", well see a colorless "Pong!". Now if we want that message colored, we need to replace `String` in our interface with `Component` and instead of using `Command.literal`, we get the `ComponentMapper` via `Laby.labyApi().minecraft().componentMapper()` and call `toMinecraftComponent(component)`. Now our component from the Adventure Component library was mapped to a Minecraft Component and calling `displayMessageInChat(Component.text("Pong!", NamedTextColor.GOLD))` in our Command works just like before. Just with our own implementation.

Those are the results from this example:

=== ":octicons-file-code-16: ExampleChatExecutor"
    ```java
    public interface ExampleChatExecutor {
    
      void displayMessageInChat(String message);
    
      void displayMessageInChat(Component adventureComponent);
    }
    ```

=== ":octicons-file-code-16: VersionedExampleChatExecutor"
    ```java
    @Singleton
    @Implement(ExampleChatExecutor.class)
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

=== ":octicons-file-code-16: ExamplePingCommand"
    ```java
    public class ExamplePingCommand extends Command {

      @Inject
      private ExamplePingCommand() {
        super("ping", "pong");
      }

      @Override
      public boolean execute(String prefix, String[] arguments) {
        if (prefix.equalsIgnoreCase("ping")) {
          this.displayMessage(Component.text("Ping!", NamedTextColor.AQUA));
          return false;
        }

        ExampleChatExecutor chatExecutor = LabyGuice.getInstance(ExampleChatExecutor.class);
        chatExecutor.displayMessageInChat(Component.text("Pong!", NamedTextColor.GOLD));
        return true;
      }
    }
    ```

## Access the Minecraft Code via Mixin

???+ error "Important Note"

    Please keep in mind that the moment your addon uses Mixins, it requires a restart when downloaded via the addon store.

todo: write

## Inheriting Version Dependend Code

todo: write