# Create Commands

with Labymod 4, you can create custom Clientside Commands which are easy to use and easy to made, 
this page will show you how

### The super Method
the first String in the super Method is the prefix, see it as the Name of your command, the Stringlist
after it are aliases, these are optional

### The execute Method
your Command method. If you return `true`, the command will be consumed by Labymod and won't be send
to the Server. If you return `false`, the command will be cancelled and sent to the Server.

To execute your Command you need to register it in your main class with
`this.registerCommand(ExampleCommand.class);`then type `/notify` or `/alias`

=== ":octicons-file-code-16: ExampleCommand"
```java
public class ExampleCommand extends Command {

    private final NotificationController notificationController;

    @Inject
    private ExampleCommand(NotificationController notificationController) {
        super("notify", "alias");
        this.notificationController = notificationController;
    }

    @Override
    public boolean execute(String prefix, String[] arguments) {
        if (prefix.equalsIgnoreCase("alias")) {
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
        notificationController.push(Notification.builder()
                .title(Component.text(title))
                .text(Component.text(text))
                .build());
        return true;
    }
}
```