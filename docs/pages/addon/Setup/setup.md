# Setting up the Project

## Provide information about your addon
After you have imported the Gradle project, head inside the `build.gradle.kts` and scroll to the bottom. <br>
Search for the `addon` segment and edit the following points:

+ `namespace`: this attribute has to be unique in order for everything to work without complications. If you want to publish your addon, we will check if this namespace is already taken by any other published addon, so nothing to worry about 
+ `displayName`: the display name users will see when they view their installed addons
+ `author`: the name of your organization or you

After you changed there attributes, reload the Gradle project and you're good to go.

##



