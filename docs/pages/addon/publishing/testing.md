While developing, you usually start your addon via the development run in your IDE. But before publishing (or sharing your addon with testers), you should always verify that it also works in the production environment - the LabyMod 4 client normal users are playing with.

## Build the Release Jar

The development jar is not suited for the production client. To create a production-ready jar, run the following Gradle tasks in your project root (this is also what the GitHub Actions workflow of our <a href="https://github.com/LabyMod/addon-template" target="_blank">addon template</a> does):

```
./gradlew build
./gradlew createReleaseJar
```

The task `createReleaseJar` bundles your addon (including all version-dependent implementations) into a single jar. You'll find it in `build/libs/` with the suffix `-release.jar` (for example `example-1.0.0-release.jar`).

???+ warning "Use the Release Jar"

    Only the jar ending with `-release.jar` will work in the production client. The other jars in `build/libs/` are intermediate build results.

## Install the Addon in the Production Client

Place the release jar in the `addons` folder of your LabyMod 4 installation. By default, you'll find it at:

+ **Windows**: `%APPDATA%\.minecraft\labymod-neo\addons`
+ **Linux**: `~/.minecraft/labymod-neo/addons`
+ **macOS**: `~/Library/Application Support/minecraft/labymod-neo/addons`

Now start LabyMod 4 via the <a href="https://www.labymod.net/en/download" target="_blank">Launcher</a>. Your addon will be loaded like any addon installed via the addon store and shows up in the addon list in the LabyMod settings.

To test a new build, replace the jar in the `addons` folder and restart the client.

## Share Builds with Testers

The GitHub Actions workflow of the addon template automatically builds the release jar on every push and uploads it as an artifact. Testers can download the artifact from the `Actions` tab of your repository (a GitHub account is required) and install it the same way as described above - no local development environment needed.
