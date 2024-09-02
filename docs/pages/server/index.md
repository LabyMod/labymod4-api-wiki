???+ danger "Important Note"

    You'll need Java Development Kit (JDK) 8 or higher to be able to use the LabyMod 4 Server API (the Velocity platform-specific implementation requires JDK 17 or higher)

## Adding the LabyMod Repository

=== ":octicons-file-code-16: Gradle (Kotlin DSL)"

    ```kotlin
    repositories {
        maven {
            name = "labymod"
            url = uri("https://dist.labymod.net/api/v1/maven/release/")
        }
    }
    ```

=== ":octicons-file-code-16: Gradle (Groovy)"

    ```groovy
    repositories {
        maven {
            name = "labymod"
            url = "https://dist.labymod.net/api/v1/maven/release/"
        }
    }
    ```

=== ":octicons-file-code-16: Maven"

    ```xml
    <repositories>
        <repository>
            <id>labymod</id>
            <url>https://dist.labymod.net/api/v1/maven/release/</url>
        </repository>
    </repositories>
    ```

## Adding the LabyMod 4 Server API as a Dependency

Depending on the actual artifact you want to use, you have to add the following dependency to your project. Listed below are the available artifacts and their use cases:

- `api` - The protocol itself without any LabyMod-specific code. Useful if you want to just use the protocol.
- `core` - The LabyMod implementation of the protocol, containing all packets and models to interact with the LabyMod client. Use this if you want to communicate with the LabyMod 4 Server API platform-independently.
- `server-bukkit` - The platform-specific implementation of the LabyMod Protocol for Servers running on Bukkit (Spigot, Paper, etc.).
- `server-bungeecord` - The platform-specific implementation of the LabyMod Protocol for Servers running on BungeeCord.
- `server-minestom` - The platform-specific implementation of the LabyMod Protocol for Servers running on Minestom.
- `server-velocity` - The platform-specific implementation of the LabyMod Protocol for Servers running on Velocity.
- `server-common` - Contains shared classes and utilities used across different server implementations to ensure consistent behavior and reduce code duplication. Use this if you want to create your own platform implementation.

???+ danger "Important Note"

    For the examples below, replace `ARTIFACT` and `VERSION` with the artifact and version you want to use. The latest version can be found here: <a href="https://github.com/LabyMod/labymod4-server-api/releases" target="_blank" style="display: inline-flex;-ms-transform: translateY(25%);transform: translateY(25%);">![GitHub Release](https://img.shields.io/github/v/release/LabyMod/labymod4-server-api?label=%20)</a>


=== ":octicons-file-code-16: Gradle (Kotlin DSL)"

    ```kotlin
    dependencies {
        compileOnly("net.labymod.serverapi:ARTIFACT:VERSION")
    }
    ```

=== ":octicons-file-code-16: Gradle (Groovy)"

    ```groovy
    dependencies {
        compileOnly "net.labymod.serverapi:ARTIFACT:VERSION"
    }
    ```

=== ":octicons-file-code-16: Maven"

    ```xml
    <dependencies>
      <dependency>
        <groupId>net.labymod.serverapi</groupId>
        <artifactId>ARTIFACT</artifactId>
        <version>VERSION</version>
      </dependency>
    </dependencies>
    ```

## Setting up Your Plugin

Each officially supported server platform has two types of implementations. 

1. You load the official jar file into your server's plugins folder and add it as a plugin dependency to your plugin.
2. You shade the dependency into your plugin and initialize it manually, effectively eliminating the need to have the 
Server API run as a separate plugin.

### Bukkit Plugin

#### Running the Server API as a Plugin

1. Add the `server-bukkit` dependency to your project's dependencies as described above.
2. Download the latest version of the `server-bukkit` jar file from the <a href="https://github.com/LabyMod/labymod4-server-api/releases" target="_blank">GitHub Releases</a>.
3. Place the jar file in your server's `plugins` folder.
4. Add the following line to your plugin's `plugin.yml`:
    ```yaml
    depend: [LabyModServerAPI]
    ```
5. You're now ready to use the LabyMod 4 Server API in your Bukkit plugin.

#### Shading the Server API into Your Plugin

1. Add the `server-bukkit` dependency to your project's dependencies as described above.
2. Configure shadow in your project's `build.gradle` or `pom.xml` to shade the `server-bukkit` dependency into your plugin.
3. Initialize the LabyMod 4 Server API in your plugin's `onEnable` method:
    ```java
    @Override
    public void onEnable() {
        LabyModProtocolService.initialize(this);
    }
    ```
4. You're now ready to use the LabyMod 4 Server API in your Bukkit plugin.

### BungeeCord Plugin

#### Running the Server API as a Plugin

1. Add the `server-bungeecord` dependency to your project's dependencies as described above.
2. Download the latest version of the `server-bungeecord` jar file from the <a href="https://github.com/LabyMod/labymod4-server-api/releases" target="_blank">GitHub Releases</a>.
3. Place the jar file in your server's `plugins` folder.
4. Add the following line to your plugin's `plugin.yml` or `bungee.yml`:
    ```yaml
    depend: [LabyModServerAPI]
    ```
5. You're now ready to use the LabyMod 4 Server API in your BungeeCord plugin.

#### Shading the Server API into Your Plugin

1. Add the `server-bungeecord` dependency to your project's dependencies as described above.
2. Configure shadow in your project's `build.gradle` or `pom.xml` to shade the `server-bungeecord` dependency into your plugin.
3. Initialize the LabyMod 4 Server API in your plugin's `onEnable` method:
    ```java
    @Override
    public void onEnable() {
        LabyModProtocolService.initialize(this);
    }
    ```
4. You're now ready to use the LabyMod 4 Server API in your BungeeCord plugin.

### Minestom Library

1. Add the `server-minestom` dependency to your project's dependencies as described above.
2. Initialize the LabyMod 4 Server API before you call `MinecraftServer#start`:
    ```java
    LabyModProtocolService.initialize();
    ```
3. You're now ready to use the LabyMod 4 Server API in your Minestom server.

### Velocity Plugin

#### Running the Server API as a Plugin

1. Add the `server-velocity` dependency to your project's dependencies as described above.
2. Download the latest version of the `server-velocity` jar file from the <a href="https://github.com/LabyMod/labymod4-server-api/releases" target="_blank">GitHub Releases</a>.
3. Place the jar file in your server's `plugins` folder.
4. Add the following code to the `Plugin` annotation above your plugin's main class:
    ```java
    dependencies = {
        @Dependency(id = "labymod-server-api")
    }
    ```
5. You're now ready to use the LabyMod 4 Server API in your BungeeCord plugin.

#### Shading the Server API into Your Plugin

1. Add the `server-velocity` dependency to your project's dependencies as described above.
2. Configure shadow in your project's `build.gradle` or `pom.xml` to shade the `server-velocity` dependency into your plugin.
3. Initialize the LabyMod 4 Server API in your plugin's `ProxyInitializeEvent` listener:
    ```java
    @Subscribe
    public void onProxyInitialization(ProxyInitializeEvent event) {
        LabyModProtocolService.initialize(this, this.server, this.logger);
    }
    ```
4. You're now ready to use the LabyMod 4 Server API in your Velocity plugin. 



