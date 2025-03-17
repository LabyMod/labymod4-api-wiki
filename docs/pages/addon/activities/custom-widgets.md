# Create Your Own Widget

You cannot only use the Widgets we created, but you can also create your own ones.
This small example will show you how to create your first Widget and add it to your Activity.
The result of our little example will be a widget that displays a player's head to the left and a player's name.
This Widget will be applied in a vertical list with multiple entries.

## Basics

First of all, every Widget is a subclass of `AbstractWidget`, you can also extend other widgets like
for example the `ButtonWidget` or the `VerticalListWidget` to get some basic functionality. The `AutoWidget` annotation
is necessary on every Widget.

### Generics

The generic type of the AbstractWidget (`AbstractWidget<...>`) defines the type of the children of this widget.
If you want your widget to have children of only a specific type, you can define it here, otherwise just use `Widget`.
In reality this is used for stuff like this:
```java
public class DropdownListWidget<T> extends VerticalListWidget<DropdownEntryWidget<T>> {}
```

### User interaction / Custom rendering

```java
@AutoWidget
public class ExampleWidget extends AbstractWidget<Widget> {

    @Override
    public void renderWidget(ScreenContext context) {
        if (this.isVisible()) {
            // optional: custom rendering
        }
        
        super.renderWidget(context); // Render children
    }

    @Override
    public boolean mouseClicked(MutableMouse mouse, MouseButton mouseButton) {
        // optional: handle mouse interactions
        return super.mouseClicked(mouse, mouseButton);
    }

    @Override
    public boolean keyPressed(Key key, InputType type) {
        // optional: handle key press
        return super.keyPressed(key, type);
    }
    
    /*
        There are more methods that you can override for user input like:
        - mouseDragged(...)
        - mouseScrolled(...)
        - mouseReleased(...)
        - keyReleased(...)
        - fileDropped(...) -> there may be limitations in older Minecraft versions, for file interactions you should always provide an optional file chooser (e.g. FileChooserWidget)
    */
}
```

### Children / Custom style

Just like Activities, Widgets can also have children and styles. In your custom widget, you can add children in the initialize() method just like
you can do it in the Activity.

=== ":octicons-file-code-16: UserListActivity"
```java
@AutoActivity
@Link("user-list-activity.lss")
public class UserListActivity extends SimpleActivity {

    @Override
    public void initialize(Parent parent) {
        super.initialize(parent);

        VerticalListWidget<UserWidget> users = new VerticalListWidget<>();
        users.addId("users");
        this.document().addChild(users);

        users.addChild(new UserWidget("LabyMod"));
        users.addChild(new UserWidget("LabyStudio"));
        users.addChild(new UserWidget("LabyMarco"));

        ButtonWidget addButton = ButtonWidget.text("Add User");
        addButton.setPressable(() -> {
            // addChildInitialized can be used to add children to a widget 
            // after the initialize() method has already been called
            users.addChildInitialized(new UserWidget("Test"));
            
            // Keep in mind that the VerticalListWidget users will get recreated when the Activity is being initialized again.
            // This means that for example when resizing the window all "Test" users will be removed again, you can
            // prevent this by saving the usernames in a separate list and adding to this list
        });
        addButton.addId("add-button");
        this.document().addChild(addButton);
    }
}
```

=== ":octicons-file-code-16: user-list-activity.lss"
```css
    .users {
        left: 50%;
        alignment-x: center;
        top: 30;
        
        width: fit-content;
        height: fit-content;
        
        User {
            height: fit-content;
        }
    }
    
    .add-button {
        left: 50%;
        alignment-x: center;
        top: 10;
        
        width: 50;
        height: 20;
    }
```

=== ":octicons-file-code-16: UserWidget"
```java
@AutoWidget
@Link("user-widget.lss")
public class UserWidget extends AbstractWidget<Widget> {
    
    private final String username;
    
    public UserWidget(String username) {
        this.username = username;
    }
    
    @Override
    public void initialize(Parent parent) {
        super.initialize(parent);

        IconWidget head = new IconWidget(Icon.head(this.username));
        head.addId("head");
        this.addChild(head);

        ComponentWidget username = ComponentWidget.text(this.username);
        username.addId("username");
        this.addChild(username);
    }
}
```

=== ":octicons-file-code-16: user-widget.lss"
```css
    .head {
        // align left
        left: 0;
        
        // center vertically
        top: 50%;
        alignment-y: center;
        
        width: 12;
        height: 12;
    }

    .username {
        // align next to the head
        left: 14;
        
        // center vertically
        top: 50%;
        alignment-y: center;
        
        // width/height is set automatically for a ComponentWidget
    }
```

=== ":octicons-file-media-24: Result"
    ![Custom-Widget-Result](/assets/files/screenshots/lss-custom-widget-example.png)

