With LabyMod 4 we've improved the way to develop addons. 
You now have one project per addon; this allows you to write version-independent code in the same project as version-dependent code without needing to copy & paste the version-independent code for every version.

Here are some of the changes with our new Addon API:

* With our brand new Activity System, you can easily create and theme custom screens without needing to know how to use OpenGL
* More events for almost every occasion that behave like server-side events
* Improved way to create and use configurations
* Easy internationalization
* Mixin for bytecode manipulation in every version
* Easier setup and debugging of the addon

<br>
As of now, you'll have to manually update your `build.gradle.kts` when we update our Gradle plugin or support a new Minecraft version.
 If you want to stay up to date at any time or if you have any questions regarding our Addon API, please feel free to 
<a href="https://labymod.net/dc/dev" target="_blank">join our development Discord</a>.

Have you found something missing from this wiki that you think is important, or are you unhappy with something? 
Please fork our wiki repository, add/improve it and create a pull request 
<a href="https://github.com/LabyMod/labymod4-api-wiki" target="_blank">here</a>.