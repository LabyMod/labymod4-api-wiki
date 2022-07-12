# Your first LabyMod 4 Addon

Basically all you need to do to start your addon is done. You should be able to start your addon right after you imported the Gradle project, but are a few things left that you shouldn't forget.

To name a few of them:

+ **Basic Information**: not only those who will test your addon would benefit from providing some information, we do too. Some information is crucial in order to guarantee a seamless experience
+ **Understanding the Example**: you could start right away with coding stuff for your addon but we've written an example addon to show you the basics of how LabyMod 4 addons work.
+ 

## Provide information about your addon
Head inside the `build.gradle.kts` and scroll to the bottom. <br>
Search for the `addon` segment and edit the following points:

+ `namespace`: this attribute has to be unique in order for everything to work without complications. If you want to publish your addon, we will check if this namespace is already taken by any other published addon, so nothing to worry about 
+ `displayName`: the display name users will see when they view their installed addons
+ `author`: the name of your organization or you
+ `description`: a description that fits your addon

After you changed these attributes, reload the Gradle project and you're good to go.


## Understanding the Basics
Head to `core\src\main\java` in your root project folder. You'll find some examples there, starting with the main addon class: `ExampleAddon`.

### The Main Class

The most important thing about the main addon class is the `AddonListener` annotation. This annotation allows us to automatically generate the `addon.json`, basically the identifier of your addon. That means without this file, your addon won't be recognized and thus won't start.

Now there are two ways to use this main class:

+ With a Superclass that handles the important stuff for you (this is what we used in the example)
+ Without anything in the background. Just a bare class, you have to handle almost everything yourself (logic-wise)

#### The Main with the Superclass

We've written a Superclass for an easier and more convenient way to develop addons. By inheriting the class `LabyAddon` everything is just a lot easier. All you have to do is specify your configuration class (in our example the class `ExampleConfiguration`, but more about that later), in 3 different places (the parts you need to replace are written in CAPS):
 
 1. after declaring your main class by appending `extends LabyAddon<CONFIGURATION>`. After doing that your IDE should either mark the other two places as errors or replace them automatically, but we'll show you anyhow
 2. in the head of the getter `configurationClass` by changing it to `Class<CONFIGURATION>`
 3. in the body of the same getter `configuraionClass` by changing the returned value to `CONFIGURATION.class`


Looking at the method `enable`, you'll see we used a method called `registerSettingCategory``. This registers a new category in the LabyMod Settings that allows users to enable/disable or configure other things regarding your addon.

Registering commands and listeners can be done by calling `registerListener` and `registerCommand` and providing the class (which will then be injected by us with the help of Guice, more on that 
<a href="#FINAL_LINK_HERE">here</a>) or by providing the already initialized object.

Now the final method we called here is `this.logger()`, which a logger to print information to the console/log. This is nicer than `System.out.println()` because it is integrated with the Minecraft log. You can print information with `.info()`, warnings with `.warn()` or errors with `.error()`.

#### The Main without the Superclass

As already mentioned you can inherit the class `LabyAddon`, but you can also do it without it. 


this stays empty for now, would take too long to describe it and we have an easier way.

### The Configuration

Now navigate to the class `ExampleConfiguration`. You'll see that this class inherits `Config`. This is necessary for all configurations that you want to show in the LabyMod Settings.

Looking at the class body you will find a field called `enabled` with the `SwitchSetting` annotation. 
The annotation declares the widget that you'll find in your settings. In this case, the widget is a SwitchSettingWidget, which toggles a boolean between on and off.

You can find more about configurations <a href="/pages/addon/features/config/#using-predefined-setting-widgets">here</a>.

### The Listener

Looking into the package `org.example.core.listener` you'll find the class ExampleGameTickListener, it does what it says. It listens to the GameTickListener event. A complete guide to our events can be found 
<a href="#FINAL_LINK_HERE">here</a>.

First we declared a field with our addon main class as type. Then we created a constructor with our main class instance as a parameter and added the `@Inject` annotation in order for <a href="#FINAL_LINK_HERE">Guice</a> to be able to find the constructor. 

Basically what this class does is, as already mentioned, listen to the GameTickEvent, which is called twice every tick (first one with phase PRE & the second one with phase POST). In this case, we're only listening to the PRE phase, because we only want the rest called once.
Inside of the event, we are accessing the field with our addon main instance. With this instance, we are gaining access to the logger we mentioned a few sections above and printing if the addon is enabled or disabled.

### The Command

With the LabyMod 4 API you have the option to add your own commands with a simple-to-use command system. More on how to create own commands <a href="#FINAL_LINK_HERE">here</a>.

What we do in this class is as simple and basic as the command system in general. We are inheriting the class `Command`, creating the constructor of our class and calling the constructor of the superclass with the main prefix of the command (in our case `ping`) and the aliases (in this case just `pong`).

Now to the `execute` method. It is called when, as the name says, the command is executed and we can handle it.


FINISH AFTER COMMAND SYSTEM IS FINISHED

 