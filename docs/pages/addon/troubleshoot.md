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
