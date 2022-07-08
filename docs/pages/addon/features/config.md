# Creating a Configuration

From using our predefined setting widgets, over creating your own to a few things that didn't fit in with the rest. On this page we will show you everything there is to know about our configuration system.

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
Compatible Types: `String` <br>
Description: 

### Key Bind Widget

Annotation: `KeyBindSetting` <br>
Arguments: none <br>
Compatible Types: `Key` <br>
Description: 

### Multi Key Bind Widget

Annotation: `MultiKeyBindSetting` <br>
Arguments: none <br>
Compatible Types: `Key[]` <br>
Description: 

### Color Picker Widget

Annotation: `ColorPickerSetting` <br>
Arguments: (`alpha` - whether the user should be able to change the transparency - default is false) <br>
Compatible Types: `int`, `Color` <br>
Description: 

### Dropdown Widget

Annotation: `DropdownSetting` <br>
Arguments: none <br>
Compatible Types: any <br>
Description: 

### Button Widget

Annotation: `ButtonSetting` <br>
Arguments: (`text` - a String that will be displayed - default is ""), (`translation` - the key to a translation within your localization files, default is "") <br>
Compatible Types: any method <br>
Description: 

### Addon Activity Widget

Annotation: `AddonActivityWidget` <br>
Arguments: (`text` - a String that will be displayed - default is ""), (`translation` - the key to a translation within your localization files, default is "") <br>
Compatible Types: any method that returns an <a href="#FINAL_LINK_HERE">Activity</a> <br>
Description: 


## Create Custom Setting Widgets

## Other Noteworthy Behaviour