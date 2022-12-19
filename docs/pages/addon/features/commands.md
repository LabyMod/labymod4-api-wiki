
# Create Commands

At First Create your new Command Class and extend it the `Command`

### The super Method
The first String in the super Method is the prefix, see it as the Name of your command, the Stringlist
after it are aliases, these are optional

### The execute Method
Your Command Method. If you return `true`, the Command will be consumed by LabyMod and won't be send
to the Server. If you return `false`, the Command will be cancelled and sent to the Server

=== ":octicons-file-code-16: ExampleCommand"
```java
public class ExampleCommand extends Command {

    private final ExampleAddon exampleAddon;

    @Inject
    private ExampleCommand(ExampleAddon exampleAddon) {
        super("exampleAddon+notify", "+notify");
        this.exampleAddon = exampleAddon;
    }

    @Override
    public boolean execute(String prefix, String[] arguments) {
        if (prefix.equalsIgnoreCase("+notify")) {
            this.displayMessage(Component.text("You used an Alias!", NamedTextColor.AQUA));
            return false;
        }

        String title;
        String text;

        if (arguments.length == 0) {
            title = "Title";
            text = "Text";
        } else {
            title = arguments[0];
            text = arguments[1];
        }
        exampleAddon.labyAPI().notificationController().push(Notification.builder()
                .title(Component.text(title))
                .text(Component.text(text))
                .build());
        return true;
    }
}
```

### execute Command
To execute your Command type `/exampleAddon+notify` or `/+notify` 

### register Command
Go into your `LabyAddon` Class and register the Command in `enable()` with
```java
this.registerCommand(ExampleCommand.class);
```