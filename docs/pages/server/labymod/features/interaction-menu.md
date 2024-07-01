The `InteractionMenuPacket` is a client-bound packet that allows servers to add custom interaction menu entries.

![Example Interaction Menu Entry](/assets/files/serverapi/interaction-menu.png)

## Creating an Interaction Menu Entry

The packet uses the `InteractionMenuEntry` model, which can be created with `InteractionMenuEntry.create`.
The InteractionMenuEntry model uses the Server API's own Component model.

### Actions
There are four different types of actions an interaction menu entry can perform:

- `InteractionMenuType.RUN_COMMAND` - Executes the value as command.
- `InteractionMenuType.CLIPBOARD` - Copies the value to the clipboard.
- `InteractionMenuType.SUGGEST_COMMAND` - Opens the chat and suggests the value.
- `InteractionMenuType.OPEN_BROWSER` - Opens the web browser with the value as URL.

### Value Placeholders
The value can contain the following placeholders (addons may add custom placeholders):

- `{name}` - Will be replaced with the player's name.
- `{uuid}` - Will be replaced with the player's unique id.

### Example
```java
InteractionMenuEntry exampleEntry = InteractionMenuEntry.create(
    ServerAPIComponent.text("Example Entry").color(ServerAPITextColor.YELLOW),
    InteractionMenuEntry.InteractionMenuType.RUN_COMMAND,
    "/example"
);
```

## Sending the Packet

The packet can either be sent via the `LabyModPlayer` object of the player, or directly via the `LabyModProtocol`.

### Via LabyModPlayer

```java
// Create a List of entries (array is also possible)
List<InteractionMenuEntry> entries = new ArrayList<>();

// Add all entries that you want to display
entries.add(exampleEntry);

// Get the LabyModPlayer
LabyModPlayer labyModPlayer = LabyModProtocolService.get().getPlayer(uniqueId);

// Send the entries
labyModPlayer.sendInteractionMenuEntries(entries);
```

### Via the LabyModProtocol

```java
// Create a List of entries (array is also possible)
List<InteractionMenuEntry> entries = new ArrayList<>();

// Add all entries that you want to display
entries.add(exampleEntry);

// Get the LabyModProtocol
LabyModProtocol labyModProtocol = LabyModProtocolService.get().labyModProtocol();

// Send the packet
labyModProtocol.sendPacket(uniqueId, new InteractionMenuPacket(entries));
```
