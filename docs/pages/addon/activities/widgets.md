Widgets are a useful and easy way to customize your activities and they are the backbone of every themeable activity.

## Use Widgets in Activities

In this part we will show you how to use and integrate Widgets in your Activity. Looking back at our bare Activity example, we rendered the text `"I am a bare rendered example text"`, so we'll be using a ComponentWidget just this time with the text `"I am an example text rendered with a ComponentWidget"`. We're building onto the code from the previous example so if you haven't already gone through it, we recommend taking a look at it <a href="/pages/addon/activities/activity/">here</a>.

???+ warning "Important Note"

    Please keep in mind that we're explaining the Activity System in multiple steps. In this part of the page page, we will explain how to create Activities with Widets but without LSS. This is for example purposes only, we highly recommend using Widgets and LSS in your Activities, as the system is not optimized for Widgets without LSS. It is possible but don't expect that your code will work forever, there is a high chance that the methods you use will be deprecated at any time.

Looking back at the bare Activity example, we remove the `render` method overwrite, as we don't need that anymore because the ComponentWidget will render the text for us. Now we overwrite the `initialize` method. Keep in mind that the super call has to be at the head of the method body. The method will be called any time the window is resized, the activity is manually reloaded or when the Activity was opened.

Then we create a new ComponentWidget. In this case, we will simply create a non-translatable ComponentWidget by calling `ComponentWidget.text` and declare our text as the first parameter and because we want our text to be colored, we'll set the color color of our choice as the second parameter, in this case, Gold. The call should look like this in the end: `ComponentWidget.text("I am an example text rendered with a ComponentWidget", NamedTextColor.GOLD)`. Now we just declare it as a field and call `this.document().addChild(this.componentWidget)` as this will add the ComponentWidget to our Activity.

Theoretically we could start the client and our text would be rendered. But we haven't set the position yet. As we'll only take a look at LSS in the next part, we need to set the position with our Java code. To do this we need to overwrite the protected void `postStyleSheetLoad` and again, keep the super call as it notifies all child widgets that the style sheets have been loaded. We don't use those yet but we leave the call in anyways. This method is called when all style sheets have been loaded and applied, just as the name suggests.

Now we get the bounds of our activity with `this.bounds()` and the bounds of our ComponentWidget via `this.componentWidget.bounds()` and set the position of said widget with `widgetBounds.setPosition(activityBounds.getCenterX(), activityBounds.getCenterY()`. As we want the ComponentWidget to be centered we need also to add `this.componentWidget.alignmentX().set(WidgetAlignment.CENTER)` and `this.componentWidget.alignmentY().set(WidgetAlignment.CENTER)` this centers the Widget horizontally and vertically. 

### Widget Activity Result

Like with the bare Activity, this is what the code we described above would look like:

=== ":octicons-file-code-16: ExampleBareActivity"
    ```java
    @AutoActivity
    public class ExampleWidgetActivity extends SimpleActivity {
    
      private ComponentWidget componentWidget;
    
      @Override
      public void initialize(Parent parent) {
        super.initialize(parent);
    
        this.componentWidget = ComponentWidget.text(
            "I am an example text rendered with a ComponentWidget",
            NamedTextColor.GOLD
        );
        this.document().addChild(this.componentWidget);
      }
    
      @Override
      protected void postStyleSheetLoad() {
        super.postStyleSheetLoad();
    
        Bounds activityBounds = this.bounds();
        Bounds widgetBounds = this.componentWidget.bounds();
        widgetBounds.setPosition(
            activityBounds.getCenterX(),
            activityBounds.getCenterY()
        );
    
        this.componentWidget.alignmentX().set(WidgetAlignment.CENTER);
        this.componentWidget.alignmentY().set(WidgetAlignment.CENTER);
      }
    
      @Override
      public <T extends LabyScreen> @Nullable T renew() {
        return (T) new ExampleWidgetActivity();
      }
    }
    ```

=== ":octicons-file-media-24: Result"
    ![Config-Result](/assets/files/screenshots/widget-activity-example.png)

## Create Your Own Widget

You not only can use the Widgets we created, but you can also create your very own ones. 
In this small example, we will show you how to create your first Widget and how to add it to your Activity. 
The result of our little example will be a widget that displays a player's head to the left and a player's name. 
This widget will be applied in a vertical list with multiple entries.

???+ warning "Important Note"

    This example will also be without the use of LSS. You can find the same Widget just with LSS on the next page about LSS.

We start by creating a new class and inheriting `SimpleWidget`. `SimpleWidget` only does one thing, it inherits from `AbstractWidget` with the type `Widget`. The type on the `AbstractWidget` declares what type the children have to be. In this case, it's `Widget` and therefore you can add any widget you want as a child. But if you only want ComponentWidgets as children, you can inherit `AbstractWidget` and set the type parameter to `ComponentWidget`. This will only allow the children to be or inherit `ComponentWidget`.

We'll continue by creating a constructor with a String as the parameter. This String will represent the name of the player. 
Now we overwrite the `initialize` method and declare a new `HorizontalListWidget` as a local variable. The `HorizontalListWidget` does what it's named after, it's a list that displays the entries horizontally. The counterpart is the `VerticalListWidget`, but we'll use that one later.
The `HorizontalListWidget` allows us to list our widgets horizontally while setting the position of the children automatically. We could also inherit the `HorizontalListWidget` directly but let's assume there is a reason we're not.

Now we create a new `IconWidget`...

todo: write

## All Widgets

todo: list all widgets