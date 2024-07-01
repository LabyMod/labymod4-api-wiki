Integrations are an integral part of the LabyMod 4 Server API. They provide a way to extend the server API with
additional features and functionalities. Integrations can be used to interact with LabyMod addons seamlessly.

## Official Integrations

We provide official integrations for addons developed by LabyMod utilizing the Server API. Their source code is
available on [GitHub](https://github.com/LabyMod/labymod4-server-api-integrations).

## Create an Integration

Integrations are created on the abstract layer of the Server API to support both server and client-side with the same
artifact. <br/>

### Create the Class

Create a class that implements the interface `LabyModProtocolIntegration`.
The interface provides two methods, `initialize(AbstractLabyModProtocolService)` and
`createIntegrationPlayer(AbstractLabyModPlayer<?>)`. `initialize` is called when the integration is loaded and
implementing this is required. `createIntegrationPlayer` is called when a LabyMod player connects to the server and
implementing it is optional.

```java
import net.labymod.serverapi.core.AbstractLabyModProtocolService;
import net.labymod.serverapi.core.integration.LabyModProtocolIntegration;

public class ExampleIntegration implements LabyModProtocolIntegration {

  private AbstractLabyModProtocolService protocolService;

  @Override
  public void initialize(AbstractLabyModProtocolService protocolService) {
    // Check if the field is already set, if so throw an exception. This is a good practice to
    // prevent the integration from being initialized multiple times.
    if (this.protocolService != null) {
      throw new IllegalStateException("VoiceChatIntegration is already initialized");
    }

    // Store the protocol service for later use
    this.protocolService = protocolService;
  }
}
```

### Registering the Service

While not required if you are using the Integration by calling `LabyModProtocolService#getOrRegisterIntegration` (
because the integration would be registered if not already), it is recommended to register the Integration as a service
to automate the registering this process.

#### Registering via AutoService

To register the integration via AutoService, you first need to add the dependency to your project.

=== ":octicons-file-code-16: Gradle (Kotlin DSL)"

    ```kotlin
    dependencies {
        compileOnly("com.google.auto.service:auto-service:1.1.1")
        annotationProcessor("com.google.auto.service:auto-service:1.1.1")
    }
    ```

=== ":octicons-file-code-16: Gradle (Groovy)"

    ```groovy
    dependencies {
        compileOnly "com.google.auto.service:auto-service:1.1.1" 
        annotationProcessor "com.google.auto.service:auto-service:1.1.1" 
    }
    ```

=== ":octicons-file-code-16: Maven"

    ```xml
    <dependencies>
        <dependency>
            <groupId>com.google.auto.service</groupId>
            <artifactId>auto-service</artifactId>
            <version>1.1.1</version>
            <optional>true</optional>
        </dependency>
    </dependencies>
    ```

After adding the dependency, you can annotate your integration class with `@AutoService(LabyModProtocolIntegration.class)`.

#### Registering Manually

To register the integration manually, create the directory `META-INF/services` in your resources folder and create a
file named `net.labymod.serverapi.core.integration.LabyModProtocolIntegration` with the fully qualified name (package +
class name) of your integration class.

### Creating a Protocol

To create a custom protocol, you can create a new instance of `AddonProtocol` in the `initialize` method of your integration. <br/>
Take a look at [Create a Custom Protocol](/pages/server/protocols/#create-a-custom-protocol) or the [official VoiceChat integration on GitHub](https://github.com/LabyMod/labymod4-server-api-integrations/blob/master/voicechat/src/main/java/net/labymod/serverapi/integration/voicechat/VoiceChatIntegration.java) for an example.
