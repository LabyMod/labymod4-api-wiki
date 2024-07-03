The VoiceChat integration provides a way to manage the voice chat server-side.

## Adding the Dependency

The VoiceChat integration is shipped with all official [server platform integration artifacts](/pages/server/#adding-the-labymod-4-server-api-as-a-dependency). If you are using the `core` artifact, you can add the following dependency to your project:

???+ danger "Important Note"

    For the examples below, `VERSION` with the version you want to use. The latest version can be found here: <a href="https://github.com/LabyMod/labymod4-server-api-integrations/releases" target="_blank" style="display: inline-flex;-ms-transform: translateY(25%);transform: translateY(25%);">![GitHub Release](https://img.shields.io/github/v/release/LabyMod/labymod4-server-api-integrations?label=%20)</a>

=== ":octicons-file-code-16: Gradle (Kotlin DSL)"

    ```kotlin
    dependencies {
        compileOnly("net.labymod.serverapi.integration:voicechat:VERSION")
    }
    ```

=== ":octicons-file-code-16: Gradle (Groovy)"

    ```groovy
    dependencies {
        compileOnly "net.labymod.serverapi.integration:voicechat:VERSION"
    }
    ```

=== ":octicons-file-code-16: Maven"

    ```xml
    <dependencies>
      <dependency>
        <groupId>net.labymod.serverapi.integration</groupId>
        <artifactId>voicechat</artifactId>
        <version>VERSION</version>
      </dependency>
    </dependencies>
    ```

