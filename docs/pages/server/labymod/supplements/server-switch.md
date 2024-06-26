The `ServerSwitchPromptPacket` is a client-bound packet that allows you to open a prompt for the player that
recommends switching to another server. The player can then confirm or cancel the server switch.

The client will then respond with a `ServerSwitchPromptResponsePacket` that contains the player's decision.

![Example Server Switch Prompt](/assets/files/serverapi/server-switch-prompt.png)

## Creating an Input Prompt

The packet uses the `ServerSwitchPrompt` model, which can be created with `ServerSwitchPrompt.create`.
The ServerSwitchPrompt model uses the Server API's own Component model.

```java
ServerSwitchPrompt serverSwitchPrompt = ServerSwitchPrompt.create(
    ServerAPIComponent.text("Example Server Switch Prompt")
        .color(ServerAPITextColor.GOLD)
        .decorate(ServerAPITextDecoration.BOLD),
    "hypixel.net"
);
```

## Sending the Packet

The packet can either be sent via the `LabyModPlayer` object of the player, or directly via the `LabyModProtocol`.

### Via LabyModPlayer (Recommended)

=== ":octicons-file-code-16: #openServerSwitchPrompt(ServerSwitchPrompt, Consumer<ServerSwitchPromptResponsePacket>)"

    ```java
    // Get the LabyModPlayer
    LabyModPlayer labyModPlayer = LabyModProtocolService.get().getPlayer(uniqueId);

    // Open the server switch prompt and handle the response
    labyModPlayer.openServerSwitchPrompt(serverSwitchPrompt, response -> {
        boolean accepted = response.wasAccepted(); // Whether the player accepted the server switch
        // Directly handle the response
    });
    ```

=== ":octicons-file-code-16: #openServerSwitchPrompt(ServerSwitchPrompt)"

    ```java
    // Get the LabyModPlayer
    LabyModPlayer labyModPlayer = LabyModProtocolService.get().getPlayer(uniqueId);

    // Open the server switch prompt
    labyModPlayer.openServerSwitchPrompt(serverSwitchPrompt);

    // To handle the response, you need to register a PacketHandler for the 
    // ServerSwitchPromptResponsePacket yourself!
    ```

### Via the LabyModProtocol

=== ":octicons-file-code-16: #sendPacket(UUID, Packet)"

    ```java
    // Get the LabyModProtocol
    LabyModProtocol labyModProtocol = LabyModProtocolService.get().labyModProtocol();

    // Send the packet
    labyModProtocol.sendPacket(uniqueId, new ServerSwitchPromptPacket(inputPrompt));

    // To handle the response, you need to register a PacketHandler for the 
    // ServerSwitchPromptResponsePacket yourself!
    ```

=== ":octicons-file-code-16: #sendPacket(UUID, IdentifiablePacket, Class, Predicate)"

    ```java
    // Get the LabyModProtocol
    LabyModProtocol labyModProtocol = LabyModProtocolService.get().labyModProtocol();

    // Send the packet and handle the response
    labyModProtocol.sendPacket(
        uniqueId,
        new ServerSwitchPromptPacket(inputPrompt),
        ServerSwitchPromptResponsePacket.class,
        response -> {
            boolean accepted = response.wasAccepted(); // Whether the player accepted the server switch
            // Handle the response packet
            return false; // Return false, as only one response is expected
        }
    );
    ```