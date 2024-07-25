The BetterPerspective integration provides the unlock camera permission.

## Adding the Dependency

The BetterPerspective integration is shipped with all official [server platform integration artifacts](/pages/server/#adding-the-labymod-4-server-api-as-a-dependency). If you are using the `core` artifact, you can add the following dependency to your project:

???+ danger "Important Note"

    For the examples below, `VERSION` with the version you want to use. The latest version can be found here: <a href="https://github.com/LabyMod/labymod4-server-api-integrations/releases" target="_blank" style="display: inline-flex;-ms-transform: translateY(25%);transform: translateY(25%);">![GitHub Release](https://img.shields.io/github/v/release/LabyMod/labymod4-server-api-integrations?label=%20)</a>

=== ":octicons-file-code-16: Gradle (Kotlin DSL)"

    ```kotlin
    dependencies {
        compileOnly("net.labymod.serverapi.integration:betterperspective:VERSION")
    }
    ```

=== ":octicons-file-code-16: Gradle (Groovy)"

    ```groovy
    dependencies {
        compileOnly "net.labymod.serverapi.integration:betterperspective:VERSION"
    }
    ```

=== ":octicons-file-code-16: Maven"

    ```xml
    <dependencies>
      <dependency>
        <groupId>net.labymod.serverapi.integration</groupId>
        <artifactId>betterperspective</artifactId>
        <version>VERSION</version>
      </dependency>
    </dependencies>
    ```

## Unlock Camera Permission

While not necessary to use, the integration provides a constant for the unlock camera permission methods to toggle the permission easily.

???+ tip "Note"

    The Unlock Camera permission is enabled by default.

### Via BetterPerspectivePlayer

=== ":octicons-file-code-16: Disable Unlock Camera"

    ```java
    // Get the LabyModPlayer
    LabyModPlayer labyModPlayer = LabyModProtocolService.get().getPlayer(uniqueId);
    
    // Get the BetterPerspectivePlayer
    BetterPerspectivePlayer betterPerspectivePlayer = labyModPlayer.getIntegrationPlayer(
        BetterPerspectivePlayer.class
    );
    
    // Disable the permission
    betterPerspectivePlayer.denyUnlockCamera();
    ```

=== ":octicons-file-code-16: Enable Unlock Camera"

    ```java
    // Get the LabyModPlayer
    LabyModPlayer labyModPlayer = LabyModProtocolService.get().getPlayer(uniqueId);
    
    // Get the BetterPerspectivePlayer
    BetterPerspectivePlayer betterPerspectivePlayer = labyModPlayer.getIntegrationPlayer(
        BetterPerspectivePlayer.class
    );
    
    // Enable the permission
    betterPerspectivePlayer.allowUnlockCamera();
    ```

### Via the LabyModProtocol

=== ":octicons-file-code-16: Disable Unlock Camera"

    ```java
    // Get the LabyModProtocol
    LabyModProtocol labyModProtocol = LabyModProtocolService.get().labyModProtocol();
    
    // Send the packet
    labyModProtocol.sendPacket(uniqueId, new PermissionPacket(
        BetterPerspectiveIntegration.UNLOCK_CAMERA_PERMISSION.deny()
    ));
    ```

=== ":octicons-file-code-16: Enable Unlock Camera"

    ```java
    // Get the LabyModProtocol
    LabyModProtocol labyModProtocol = LabyModProtocolService.get().labyModProtocol();
    
    // Send the packet
    labyModProtocol.sendPacket(uniqueId, new PermissionPacket(
        BetterPerspectiveIntegration.UNLOCK_CAMERA_PERMISSION.allow()
    ));
    ```

