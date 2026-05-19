Common mistakes and errors with possible solutions are explained on this page.

If you have an issue that is described here, please read carefully. 
If the approach to resolving your issue doesn't work feel free to ask for help on our <a href="https://labymod.net/dc/dev" target="_blank">development Discord</a>.

If you need help from others, please always keep in mind that they're human and don't always answer right away and think about what is written on <a href="https://nohello.net" target="_blank">NoHello.net</a>.

## My LSS StyleSheet Doesn't load

If it can happen that the LSS StyleSheet doesn't load, this is most commonly caused by a forgotten or misplaced semicolon (`;`) or curly bracket (`{`, `}`); the affected line should be printed to your log.
Try to search for those two cases. If you cannot find anything, feel free to ask for help on our <a href="https://labymod.net/dc/dev" target="_blank">development Discord</a> and <b>provide your LSS StyleSheet</b>.

## Unable to start Development runs in IntelliJ IDEA

If your development runs fail to start in IntelliJ IDEA, it may be due to a common bug. Follow these steps to resolve the issue:

1. **Close IntelliJ IDEA**: Ensure that the IDE is completely closed.
2. **Delete the `.idea` Folder**: Navigate to your project directory and remove the `.idea` folder. This folder contains project-specific settings.
3. **Restart IntelliJ IDEA**: After deleting the `.idea` folder, reopen IntelliJ IDEA.

Following these steps should resolve the issue and allow your development runs to start successfully again.

## Unable to reach our services / Gradle cannot resolve dependencies

If one of our services is temporarily down or you cannot reach our endpoints for any other reason (e.g. no internet connection, firewall, DNS issues), you can enable Gradle's **offline mode** to keep working with the dependencies and files that are already cached locally from a previous run.

<b>Important:</b> Offline mode only works correctly if you have already successfully run the project at least once before, so that all required dependencies are present in your local Gradle cache. If files are missing, the build will fail because Gradle is not allowed to download anything while offline.

### Enable offline mode in IntelliJ IDEA

1. Open the **Gradle** tool window (usually on the right sidebar, or via `View` → `Tool Windows` → `Gradle`).
2. In the toolbar of the Gradle tool window, click the **Toggle Offline Mode** button (the icon showing a cloud with a slash through it).
3. Re-run your Gradle task.

### Enable offline mode via the command line

When invoking Gradle directly, append the `--offline` flag to your command, for example:

```
./gradlew build --offline
```

Once our services are reachable again, disable offline mode to make sure you receive the latest updates.
