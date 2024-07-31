# Create Hud Widgets

A Hud Widget is a block of content, which can be enabled within our "Widget Editor". Users can customize and move Widgets by drag&drop.
Our Hud Widget System allows you to create own Widgets for your addon.

### Create own Hud Widget Category

You're able to create own Widget categories so you can create an own category for the Widgets your addon provides.
Just create a HudWidgetCategory and register it in your Addon enable method.

```java
@AddonMain
public class ExampleAddon extends LabyAddon<ExampleConfiguration> {

  private HudWidgetCategory widgetCategory;

  @Override
  protected void enable() {
    labyAPI().hudWidgetRegistry().categoryRegistry().register(this.widgetCategory = new HudWidgetCategory("example_category"));
  }

{
```

# Registering HudWidgets

You can register a created Hud Widget in your Addon enable method.

```java
@AddonMain
public class ExampleAddon extends LabyAddon<ExampleConfiguration> {

  @Override
  protected void enable() {
    labyAPI().hudWidgetRegistry().register(new ExampleHudWidget(this));
  }

{
```

# Different HudWidget Types

LabyMod provides different Widget types that help you to easily create HudWidgets.

+ TextHudWidget - a simple text widget that supports multiple lines
+ ItemHudWidget - an item widget with that you can display an image with a text next to it
+ SimpleHudWidget - a widget that render custom icons/text etc. - an example can be found in the <a href="https://github.com/labymod-addons/teamspeak/blob/master/core/src/main/java/net/labymod/addons/teamspeak/core/hud/TeamSpeakHudWidget.java">Teamspeak LabyMod Addon</a>

  
# Example TextHudWidget

```java
public class ExampleHudWidget extends TextHudWidget<TextHudWidgetConfig> {

  private TextLine textLine;

  public ExampleHudWidget(ExampleAddon addon) {
    super("example_id");
    // Bind the Widget to our created category in our main class
    this.bindCategory(addon.widgetCategory());

    // Optional - set an icon for the Widget Editor in the Constructor; you can also annotate the icon via a SpriteSlot at the top of the class
    this.setIcon(ResourceLocation.create("minecraft", "textures/item/name_tag.png"));
  }

  @Override
  public void load(TextHudWidgetConfig config) {
    super.load(config);
    this.textLine = createLine("Own Username", "");
  }

  @Override
  public void onTick(boolean isEditorContext) {

    String value = null;
    if(Laby.labyAPI().serverController().isConnected()) {
      value = Laby.labyAPI().getName();
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

# Hud Widget Configurations

You can also create Configurations for your Hud Widgets, in our example we are using a configuration for the TextHudWidget.
You can easily create configurations by creating a class that inherit the `TextHudWidgetConfig` class.
You can use the same Setting Elements that you are using to create the configuration of your addon, take a look <a href="/pages/addon/features/config/#using-predefined-setting-widgets">here</a>.

```java

public class ExampleHudWidget extends TextHudWidget<ExampleHudWidgetConfig> {

  private TextLine textLine;

  public ExampleHudWidget(ExampleAddon addon) {
    super("example_id", ExampleHudWidgetConfig.class);
    this.bindCategory(addon.widgetCategory());
  }

  @Override
  public void load(ExampleHudWidgetConfig config) {
    super.load(config);
    this.textLine = createLine("Own UUID", "");
  }

  @Override
  public void onTick(boolean isEditorContext) {

    String value = null;
    if(Laby.labyAPI().serverController().isConnected()) {
      value = Laby.labyAPI().getUniqueId().toString();
      // Access our created Setting
      if(!this.getConfig().showDashes().get()) {
        value = value.replace("-", "");
      }
    }

    this.textLine.updateAndFlush(value);
    this.textLine.setState(value != null ? State.VISIBLE : State.HIDDEN);
  }

  public static class ExampleHudWidgetConfig extends TextHudWidgetConfig {

    @SwitchSetting
    private final ConfigProperty<Boolean> showDashes = new ConfigProperty<>(true);

    public ConfigProperty<Boolean> showDashes() {
      return showDashes;
    }

  }

}
```
