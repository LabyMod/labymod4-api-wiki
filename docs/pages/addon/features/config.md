# Creating a Configuration

From using our predefined setting widgets, over creating your own to a few things that didn't fit in with the rest. On this page, we will show you everything there is to know about our configuration system.

## Using Predefined Setting Widgets

The following content lists all of our Setting Widgets, that will be served by using the Addon API, with possible arguments (optional arguments are surrounded by brackets), compatible types and a short description, that you can create via an annotation:

### Switch Widget

Annotation: `SwitchSetting` <br>
Arguments: none <br>
Compatible Type: `boolean` <br>
Description: 

### Slider Widget

Annotation: `SliderSetting` <br>
Arguments: `min` - smallest value possible, `max` - biggest value possible, (`steps` - the amount of how much the value will increase/decrease on each move - default is 1) <br>
Compatible Types: `int`, `float`, `double`, `short`, `byte`, `long` <br>
Description: 

### Text Field Widget

Annotation: `TextFieldSetting` <br>
Arguments: (`maxLength` - the maximal length of the string entered) <br>
Compatible Type: `String` <br>
Description: 

### Key Bind Widget

Annotation: `KeyBindSetting` <br>
Arguments: none <br>
Compatible Type: `Key` <br>
Description: 

### Multi Key Bind Widget

Annotation: `MultiKeyBindSetting` <br>
Arguments: none <br>
Compatible Type: `Key[]` <br>
Description: 

### Color Picker Widget

Annotation: `ColorPickerSetting` <br>
Arguments: (`alpha` - whether the user should be able to change the transparency - default is false) <br>
Compatible Type: `int` <br>
Description: 

### Dropdown Widget

Annotation: `DropdownSetting` <br>
Arguments: none <br>
Compatible Types: any enum <br>
Description: 

### Button Widget

Annotation: `ButtonSetting` <br>
Arguments: (`text` - a String that will be displayed - default is ""), (`translation` - the key to a translation within your localization files, default is "") <br>
Compatible Types: any public method <br>
Description: 

### Addon Activity Widget

Annotation: `AddonActivityWidget` <br>
Arguments: (`text` - a String that will be displayed - default is ""), (`translation` - the key to a translation within your localization files, default is "") <br>
Compatible Types: any public method that returns an <a href="#FINAL_LINK_HERE">Activity</a> <br>
Description: 

## Further Customize the Settings

In addition to using predefined widgets for your settings, you also have a few other options to customize them. <br>
The following points are not very precisely explained but you can see everything from the following subsections and most of the subsections before in
<a href="#example-of-the-previous-sections">this section</a>.

### Create Sections

You can create sections in your settings, you just have to add the annotation `@SettingSection` above the first field that you want to have in said section. Now all you have to do is set the identifier as the annotation's parameter and add it to your internationalization file. 

### Create Sub Settings

If you want more structure in your settings but don't want to use Sections, you can create sub-settings that can be accessed via a button. Just create a new class, and let it inherit from `Config`. Add a field with the same type and create a new instance of said class.

If you want to display more than just the advanced-button (the button that lets you access the sub-settings), add the `@ParentSetting` annotation to the field of the most desirable setting.

### Use Icons for Settings

In order to display icons in front of your settings, you'll need to declare a sprite texture with the `@SpriteTexture` annotation. Set the name of your file as the value of the annotation (the base path is `assets/NAMESPACE/themes/THEME/textures/sprite`, while the namespace is the namespace you set in your `build.gradle.kts` and the theme to the current theme. If you want your icons to be visible in all themes, put the texture in the vanilla theme). More on sprite textures <a href="#FINAL_LINK_HERE">here</a>. 

## Example of the Previous Sections

These are some example files showing a few of the functions mentioned before.

=== ":octicons-file-code-16: ExampleConfiguration"
    ``` java
    @ConfigName("settings")
    @SpriteTexture("example_sprite.png")
    public class ExampleConfiguration extends Config {
    
      @SpriteSlot(x = 1, y = 1)
      @SwitchSetting
      private boolean enabled = true;

      @SettingSection("print")
      @SpriteSlot(x = 6)
      @TextFieldSetting
      private String text = "Hi!";

      @SettingSection("miscellaneous")
      @SpriteSlot(x = 1, y = 3)
      private ExampleSubSettings subSettings = new ExampleSubSettings();

      @SpriteSlot(y = 3)
      @DropdownSetting
      private ExampleEnum type = ExampleEnum.SCALENE_TRIANGLE;

      @MethodOrder(after = "text")
      @SpriteSlot(x = 2, y = 6)
      @ButtonSetting(text = "Print!")
      public void print(Setting setting) {
        LabyGuice.getInstance(ExampleAddon.class).logger()
            .info(setting.getId() + " was clicked! " + this.text);
      }
    }
    ```

=== ":octicons-file-code-16: ExampleSubSetting"
    ``` java
    public class ExampleSubSettings extends Config {

      @ParentSwitch
      @SpriteSlot(x = 7)
      @SwitchSetting
      private boolean enabled = false;

      @SpriteSlot(x = 1, y = 6)
      @ColorPickerSetting
      private int labyModColor = new Color(10, 85, 165).getRGB();

      @SpriteSlot(x = 2)
      @KeyBindSetting
      private Key keyBind = Key.F;
    }
    ```

=== ":octicons-file-code-16: ExampleEnum"
    ``` java
    public enum ExampleEnum {
        HEART, CIRCLE, RECTANGLE, TRIANGLE, SCALENE_TRIANGLE;
    }
    ```

=== ":octicons-file-code-16: en_us.json"
    ``` json
    {
      "settings": {
        "example": {
          "name": "ExampleAddon",
          "enabled": {
            "name": "Enabled"
          },
          "text": {
            "name": "Text to be Printed"
          },
          "print": {
            "name": "Click Me to Print the Text"
          },
          "subSettings": {
            "name": "Miscellaneous Sub Settings",
            "labyModColor": {
              "name": "The LabyMod Color"
            },
            "keyBind": {
              "name": "Key Bind"
            }
          },
          "type": {
            "name": "Display Type",
            "heart": "Heart",
            "circle": "Circle",
            "rectangle": "Rectangle",
            "triangle": "Triangle",
            "scaleneTriangle": "Weird Shape"
          },
          "header": {
            "miscellaneous": {
              "name": "Miscellaneous"
            },
            "print": {
              "name": "Print!"
            }
          }
        }
      }
    }
    ```

=== ":octicons-file-media-24: Result"
    ![Config-Result](/assets/files/screenshots/config-example.gif)

## Create Custom Setting Widgets