# Create Hud Widgets

A Hud Widget is a block of content, which can be enabled within our "Widget Editor". Users can customize and move Widgets by drag&drop.
Our Hud Widget System allows you to create own Widgets for your addon

### Create own Hud Widget Category

You're able to create own Widget categories so you can create an own category for the Widgets your addon provides.
Just create a HudWidgetCategory and register it in your Addon enable method.

```java
@AddonMain
public class ExampleAddon extends LabyAddon<ExampleConfiguration> {

  private final HudWidgetCategory widgetCategory;

  @Override
  protected void enable() {
    labyAPI().hudWidgetRegistry().categoryRegistry().register(this.widgetCategory = new HudWidgetCategory("moneymaker"));
  }

{
```

# Different HudWidget Types

LabyMod provides different Widget types that help you to easily create HudWidgets.

+ TextHudWidget - a simple text widget that supports multiple lines
+ ItemHudWidget - an item widget with that you can display an image with a text next to it

  
# Example TextHudWidget

```java

public class ExampleHudWidgets extends TextHudWidget<TextHudWidgetConfig> {

  private ExampleAddon addon;
  private TextLine textLine;

  public WorkerPriceWidget(ExampleAddon addon) {
    super("example_id");
    this.addon = addon;
    // Bind the Widget to our created category in our main class
    this.bindCategory(addon.widgetCategory());

    // Optional - set an icon for the Widget Editor in the Constructor; you can also annotate the icon via a SpriteSlot at the top of the class
    this.setIcon(ResourceLocation.create("minecraft", "textures/item/name_tag.png"));
  }

  @Override
  public void load(TextHudWidgetConfig config) {
    super.load(config);
    this.textLine = createLine("Own Username", "0");
  }

  @Override
  public void onTick(boolean isEditorContext) {

    String value = null;
    if(this.addon.labyAPI().serverController().isConnected()) {
      value = this.addon.labyAPI().getName();
    }
    
    // Update the text line an flush it
    this.textLine.updateAndFlush(value);

    // Set the state of the text line
    // DISABLED - text line is fully disabled also not available in the Widget Editor
    // HIDDEN - text line is hidden ingame, but is displayed in the Widget Editor
    // VISIBLE - text line is visible ingame
    this.textLine.setState(value != null ? State.VISIBLE : State.HIDDEN);
  }

}

```
