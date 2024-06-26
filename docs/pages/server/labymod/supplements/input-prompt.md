The `InputPromptPacket` is a client-bound packet that opens a prompt for the player with a text field.

The client will then respond with a `InputPromptResponsePacket` that contains the player's input.

![Example Input Prompt](/assets/files/serverapi/input-prompt.png)

## Creating an Input Prompt

The packet uses the `InputPrompt` model, which can be created with either `InputPrompt.builder` or `InputPrompt.create`.
The InputPrompt model uses the Server API's own Component model.

=== ":octicons-file-code-16: InputPrompt.builder"

    ```java
    InputPrompt inputPrompt = InputPrompt.builder()
        .title(ServerAPIComponent.text("Example Input Switch Prompt")
            .color(ServerAPITextColor.AQUA)
            .decorate(ServerAPITextDecoration.BOLD))
        .placeholder(ServerAPIComponent.text("Example placeholder"))
        .defaultValue("value")
        .maxLength(12)
        .build();
    ```

=== ":octicons-file-code-16: InputPrompt.create"

    ```java
    InputPrompt inputPrompt = InputPrompt.create(
        ServerAPIComponent.text("Example Input Switch Prompt")
            .color(ServerAPITextColor.AQUA)
            .decorate(ServerAPITextDecoration.BOLD),
        ServerAPIComponent.text("Example placeholder"),
        "value",
        12
    );
    ```

## Sending the Packet

The packet can either be sent via the `LabyModPlayer` object of the player, or directly via the `LabyModProtocol`.

### Via LabyModPlayer (Recommended)

=== ":octicons-file-code-16: #openInputPrompt(InputPrompt, Consumer<String>)"

    ```java
    // Get the LabyModPlayer
    LabyModPlayer labyModPlayer = LabyModProtocolService.get().getPlayer(uniqueId);

    // Open the input prompt and handle the response
    labyModPlayer.openInputPrompt(inputPrompt, input -> {
        // Directly handle the input
    });
    ```

=== ":octicons-file-code-16: #openInputPrompt(InputPrompt)"

    ```java
    // Get the LabyModPlayer
    LabyModPlayer labyModPlayer = LabyModProtocolService.get().getPlayer(uniqueId);

    // Open the input prompt
    labyModPlayer.openInputPrompt(inputPrompt);

    // To handle the response, you need to register a PacketHandler for the 
    // InputPromptResponsePacket yourself!
    ```

### Via the LabyModProtocol

=== ":octicons-file-code-16: #sendPacket(UUID, Packet)"

    ```java
    // Get the LabyModProtocol
    LabyModProtocol labyModProtocol = LabyModProtocolService.get().labyModProtocol();

    // Send the packet
    labyModProtocol.sendPacket(uniqueId, new InputPromptPacket(inputPrompt));

    // To handle the response, you need to register a PacketHandler for the 
    // InputPromptResponsePacket yourself!
    ```

=== ":octicons-file-code-16: #sendPacket(UUID, IdentifiablePacket, Class, Predicate)"

    ```java
    // Get the LabyModProtocol
    LabyModProtocol labyModProtocol = LabyModProtocolService.get().labyModProtocol();

    // Send the packet and handle the response
    labyModProtocol.sendPacket(
        uniqueId,
        new InputPromptPacket(inputPrompt),
        InputPromptResponsePacket.class,
        response -> {
            // Handle the response packet
            return false; // Return false, as only one response is expected
        }
    );
    ```