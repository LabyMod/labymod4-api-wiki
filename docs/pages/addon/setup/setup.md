All you need to do to start your Addon is done. You should be able to start your Addon with the Laby Client right after you've imported the Gradle project, but there are a few things left that you shouldn't forget.

To name a few of them:

+ **Basic Information**: not only those who will test your Addon would benefit from providing some information, but we do too. Some information is crucial to guarantee a seamless experience
+ **Understanding the Example**: you could start with coding stuff for your Addon, but we've written an example addon to show you the basics of how Laby Client addons work.

## Provide information about your Addon
Head inside the `build.gradle.kts` and search for the block called `labyMod`. <br>
Inside this block is an assignment to the field `defaultPackageName`, change the assigned value to the main package you're using in all modules (for example `net.labymod.addons.voicechat`). This allows us to generate important files to the right package. <br>
Now search for the `addonInfo` segment and edit the following fields:

+ `namespace`: this attribute has to be unique for everything to work without complications. If you want to publish your Addon, we will check if this namespace is already taken by any other published addon, so nothing to worry about 
+ `displayName`: the display name users will see when they view their installed addons
+ `author`: the name of your organization or you
+ `description`: a description that fits your Addon
+ `minecraftVersion`: the <a href="/pages/addon/publishing/publish/#version-compatibility" target="_blank">version compatibility</a> of the addon

After you have changed these attributes, reload the Gradle project, and you're good to go.


## Understanding the Basics
Head to `core/src/main/java` in your root project folder. You'll find some examples, starting with the main addon class: `ExampleAddon`.

### The Main Class

The most important thing about the main addon class is the `AddonMain` annotation. This annotation allows us to automatically generate the `addon.json`, basically the identifier of your Addon. That means without this file, Laby Client can't recognize your Addon, and thus it won't start.

Now there are two ways to use this main class:

+ With a Superclass that handles the necessary stuff for you (this is what we used in the example)
+ Without anything in the background. Just a bare class, you have to handle almost everything yourself (logic-wise)

#### The Main with the Superclass

We've written a Superclass for an easier and more convenient way to develop addons. By inheriting the class `LabyAddon`, everything is more straightforward. All you have to do is specify your configuration class (in our example, the class `ExampleConfiguration`, but more about that later) in 3 different places (the parts you need to replace are written in CAPS):
 
 1. after declaring your main class by appending `extends LabyAddon<CONFIGURATION>`. After doing that, your IDE should either mark the other two places as errors or replace them automatically, but we'll show you anyhow
 2. in the head of the getter `configurationClass` by changing it to `Class<CONFIGURATION>`
 3. in the body of the same getter `configuraionClass` by changing the returned value to `CONFIGURATION.class`


Looking at the method `enable`, you'll see we used a method called `registerSettingCategory`. This method registers a new category in the Laby Client settings, allowing users to enable/disable or configure other things regarding your Addon.

Registering commands and listeners can be done by calling `registerListener` and `registerCommand` and providing the already initialized object.

Now the final method we called here is `this.logger()`, a logger to print information to the console/log. This is nicer than `System.out.println()` because it is integrated with the Minecraft log. You can print information with `.info()`, warnings with `.warn()` or errors with `.error()`.

#### The Main without the Superclass

As already mentioned, you can inherit the class `LabyAddon`, but you can also do it without it. 

???+ warning "Important Note"

    While this is possible, we highly recommend creating Addons with our LabyAddon class as it implements some things that make creating addons easier, especially for beginners. 

This section stays empty for now, it would take too long to describe it, and we have an easier way.

### The Configuration

Now navigate to the class `ExampleConfiguration`. You'll see that this class inherits `AddonConfig`. This is necessary for the main configuration, as it requires you to inherit the `enabled` ConfigProperty.

Looking at the class body, you will find a field called `enabled` with the `SwitchSetting` annotation. 
The annotation declares the Widget that you'll find in your settings. In this case, the Widget is a SwitchSettingWidget, which toggles a boolean between on and off.

You can find more about configurations [here](../features/config.md).

### The Listener

Looking into the package `org.example.core.listener`, you'll find the class ExampleGameTickListener; it does what it says. It listens to the GameTickListener event. You can find a complete guide to our events [here](../features/events.md).

First, we declared a field with our addon main class as type. Then we created a constructor with our main class instance as a parameter.

Basically, what this class does is, as already mentioned, listen to the GameTickEvent, which is called twice every tick (first one with phase PRE & the second one with phase POST). In this case, we only listen to the PRE phase because we only want the rest called once.
Inside the event, we access the field with our addon main instance; with this instance, we are gaining access to the logger we mentioned a few sections above and printing if the Addon is enabled or disabled.

### The Command

With the Laby Client API, you can add your own commands with a simple-to-use command system. More on how to create own commands [here](../features/commands.md).

What we do in this class is as simple and basic as the command system in general. We are inheriting the class `Command`, creating the constructor of our class, and calling the constructor of the superclass with the main prefix of the command (in our case, `ping`) and the aliases (in this case, just `pong`).

Now to the `execute` method. It is called when, as the name says, the command is executed, and we can handle it.

FINISH AFTER THE COMMAND SYSTEM IS FINISHED

### The Internationalization File

Go to the module called `core` and then navigate down to `src/main/resources/assets/example/i18n/` (the `example` folder has to be named after the namespace you set in your `build.gradle.kts`) and you should see a file with the name `en_us.json`. This is the default file for internationalization, as English is the default language. To dive deeper in the internationalization of the Laby Client go to [this article](../features/internationalization.md).

First, we created a new JSON Object called `example`, this has to reflect the namespace that you set in your `build.gradle.kts`; after that, we created another JSON Object called `settings`, which implies that the following lines are for the settings. Now we created another JSON Object with the key `enabled`, as this is the name of the field in our configuration; you will find another String with the key `name`. This is the name of the Setting Widget `enabled`.