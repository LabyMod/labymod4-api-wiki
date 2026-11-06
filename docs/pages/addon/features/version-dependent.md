While our API is entirely version-independent for you to use, you might still need to implement some version-dependent
things yourself (such as niche things, just something we didn't implement). At the current moment, you might need to
implement more yourself, as we're still implementing more and more stuff for you to use version independently.

There are two ways to implement version-dependent; different use cases require different ways to implement them.

The easiest method is to create an interface or abstract class and implement it in your desired version(s). This will
result in the ability that you can control your version-dependent code from the core.

The more complex way would be SpongePowered's Mixin. While Mixin is comparatively easy to use, it can be a bit confusing
at the beginning, as all new things are.

???+ tip "Write It Once"

    Both ways work in the shared source set too. Instead of one copy per version, you write the code once for all
    versions from 1.16.5 on. See [Share Code Across Versions](shared-version-code.md). This feature is
    experimental.

???+ warning "Important Note"

    Please keep in mind that the examples on this page are version dependent. We are showing the examples for Minecraft 1.21.5, so depending on the date you're reading this, recreating the examples might not be possible, we'll try to keep them updated, though, and if we do, we update the version in this note.

## Access the Minecraft Code "the Normal Way"
You should only use this method for things you can access without using Reflections, as using Reflections can have a
high impact on the performance of the players that use your addon.

The use case we will implement in the following example will show how to display messages in the player's chat. We have
already implemented this, but it is relatively easy to show and understand.

First, create a new interface (an abstract class would also work) in the `core` or `api` module and name it `ExampleChatExecutor`. Annotate it with `@Referenceable`, and define a method:

```java
void displayMessageInChat(String message);
```

Next, navigate to the `game-runner` module. Locate the version you want to implement this functionality for, and create a new class named `VersionedExampleChatExecutor` in the appropriate package.

Now to the implementation. First, we implement the interface `ExampleChatExecutor`, and now the most important part: we
need to add the annotation `Implement` to the class and declare `ExampleChatExecutor.class` as the argument. This will
allow you to access the versioned implementation from the core module. Then we'll add the annotation `Singleton` to the
class, as we don't need more than one object of this implementation. At this point, the only missing point is the actual
implementation of Minecraft; we'll overwrite the `displayMessageInChat` method from our interface and create a new
Component from our String with `Component.literal(message)`. Then we access the Chat GUI
with `Minecraft.getInstance().gui.getChat()` and add our component with `addMessage(component)`.

To access our `VersionedExampleChatExecutor` from the core module, we need to add a private instance of the `ExampleChatExecutor` with a getter to our `ExampleAddon` class. Then we assign the instance in our `ExampleAddon#enable` method using `((DefaultReferenceStorage) this.referenceStorageAccessor).exampleChatExecutor()`. If the function does not exist, we need to run a gradle build to add the class to our reference storage. We can now access the instance from the core module with `ExampleAddon#chatExecutor()`. Now we can require an `ExampleAddon` instance as a parameter in our `ExamplePingCommand` and pass `this` to the constructor of the command in the `ExampleAddon#enable`. Then we can access the `VersionedExampleChatExecutor` instance from the command and call the `displayMessageInChat` method with `"Pong!"` as an argument.

After starting the Laby Client, joining a server, and executing "/pong", we'll see a colorless "Pong!". Now, if we want that
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

      void displayMessageInChat(Component labyComponent);
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
      public void displayMessageInChat(net.labymod.api.client.component.Component labyComponent) {
        ComponentMapper componentMapper = Laby.labyAPI().minecraft().componentMapper();
        Component component = (Component) componentMapper.toMinecraftComponent(labyComponent);
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
        # Make sure to build your addon first (after creating the interface and it's implementations) and to import your own generated ReferenceStorage class
        this.chatExecutor = ((ReferenceStorage) this.referenceStorageAccessor()).exampleChatExecutor();

        this.registerCommand(new ExamplePingCommand(this));
      }

      @Override
      protected Class<? extends ExampleConfiguration> configurationClass() {
        return ExampleConfiguration.class;
      }

      public ExampleChatExecutor chatExecutor() {
        return this.chatExecutor;
      }
    ```

=== ":octicons-file-code-16: ExamplePingCommand"
    ```java
    public class ExamplePingCommand extends Command {

      private final ExampleChatExecutor chatExecutor;

      public ExamplePingCommand(ExampleAddon addon) {
        super("ping", "pong");
        this.chatExecutor = addon.chatExecutor();
      }

      @Override
      public boolean execute(String prefix, String[] arguments) {
        if (prefix.equalsIgnoreCase("ping")) {
          this.displayMessage(Component.text("Ping!", NamedTextColor.AQUA));
          return false;
        }

        this.chatExecutor.displayMessageInChat(Component.text("Pong!", NamedTextColor.GOLD));
        return true;
      }
    }
    ```

## Access the Minecraft Code via Mixin

!!! warning "Important Note"
    The moment your addon uses Mixins, it requires a full game restart when downloaded via the addon store.

!!! danger
    For mixins to work outside of the development environment, your `rootProject.name` in `settings.gradle.kts` must exactly match your addon namespace.

Mixins allow you to modify Minecraft code directly. Similar to reference storage, they are version-dependent, which means you must implement them separately for each Minecraft version you want to support.

When creating a mixin, the **location** is critical. Navigate to the `game-runner` module of your addon and create a package named `mixins` inside the automatically generated versioned package. Your structure should look something like this:

```
org/example/{version}/mixins
```

You may create mixins in this package or in subpackages. You do **not** need to register them manually in a configuration file - Laby Client will automatically detect and apply them. The Laby Client also supports [MixinExtras](https://github.com/LlamaLad7/MixinExtras) annotations, which can simplify common injection patterns.

For further reading:

* [SpongePowered Mixin Documentation](https://github.com/SpongePowered/Mixin/wiki)
* [MixinExtras Wiki](https://github.com/LlamaLad7/MixinExtras/wiki)

This section does not attempt to explain all of Mixin in detail - it focuses only on how to correctly load and use them with the Laby Client.

### Example: Logging Every Tick

=== ":octicons-file-code-16: org.example.v1_21_5.mixins.MixinMinecraft"
    ```java
    @Mixin(Minecraft.class)
    public class MixinMinecraft {

      @Unique
      private int example$tickCount = 0;

      @Inject(method = "tick", at = @At("HEAD"))
      private void onTick(CallbackInfo ci) {
          System.out.println("[Mixin] Tick log " + this.example$tickCount++);
      }
    }
    ```