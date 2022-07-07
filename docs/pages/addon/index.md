# Introduction

With LabyMod 4 we've improved the way to develop addons. You now have one project per addon, this allows you to write version independent code besides version dependent code without needing to copy & paste the version independent code for every version.

In addition to that you now can publish your addon for all LabyMod Users to download without having to wait for us to review the addon. Only catch: users have to specifically search for your addon in our addon store and if they want to download it, they get served a warning. But you can also request a review so every LabyMod User can see your addon and download it without any warnings.

Here are some of the changes with our new Addon API:

* With our brand new Activity System you can easily create custom screens without needing to know how to use OpenGL
* More events for almost every occasion that behave like server-side events
* Improved way to create and use configurations
* Easy internationalization
* Mixin for bytecode manipulation in every version
* Easier setup and debugging of the addon

<br>
As of now you'll have to manually update your `build.gradle.kts` when we update your Gradle plugin or support a new Minecraft version. If you want to stay up to date at any time or if you have any questions regarting our Addon API please feel free to 
<a href="https://labymod.net/dc/dev" target="_blank">join our development Discord</a>.