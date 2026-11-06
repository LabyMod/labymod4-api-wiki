## Quick start

One command creates a new addon from our template and prepares it for AI coding agents like Claude Code, Codex and
Gemini CLI.

=== "Windows (PowerShell)"

    ```powershell
    irm https://dev.labymod.net/new-addon.ps1 | iex
    ```

=== "macOS and Linux"

    ```sh
    curl -fsSL https://dev.labymod.net/new-addon.sh | sh
    ```

The script:

- checks for JDK 25, Node.js and Git and asks before it installs anything that is missing (with winget on Windows,
  Homebrew on macOS and apt, dnf or pacman on Linux)
- asks for your addon's name, namespace, author and main package
- downloads the <a href="https://github.com/LabyMod/addon-template" target="_blank">addon template</a> and renames it
  to your addon
- sets up the tools AI agents use to look up the LabyMod API and this wiki, check your addon against the publishing
  guidelines and test it in the running game

You can read both scripts before you run them: <a href="https://dev.labymod.net/new-addon.ps1" target="_blank">new-addon.ps1</a>,
<a href="https://dev.labymod.net/new-addon.sh" target="_blank">new-addon.sh</a>.

Start the game from the project folder with `./gradlew :game-runner:client_v<version>`, for example
`./gradlew :game-runner:client_v26.1.2`. To debug it, open the project in
<a href="https://www.jetbrains.com/idea/download/" target="_blank">IntelliJ IDEA</a>.

## Manual setup

First you'll need a Java IDE, as of now we only support
<a href="https://www.jetbrains.com/idea/download/" target="_blank">IntelliJ IDEA</a>. Then download <a href="https://adoptium.net/temurin/releases/?version=25" target="_blank">JDK (Java Development Kit) 25</a> if you haven't already.

Differences between the "Community" and "Ultimate" edition:

- **IntelliJ IDEA Community Edition** is the free to use version for everyone.
- **IntelliJ IDEA Ultimate** is the version where you need a valid subscription based license.

You can apply for a free educational license at Jetbrains <a href="https://www.jetbrains.com/community/education/" target="_blank">here</a>.<br>
Its also possible obtain an "Ultimate" edition license if you are part of the <a href="https://education.github.com" target="_blank">GitHub Global Campus</a> where you can apply <a href="https://education.github.com/pack/join" target="_blank">here</a>.

Now <a href="https://github.com/LabyMod/addon-template" target="_blank">download or clone our addon template</a> and open it in your preferred IDE.

todo: fill with basic information
