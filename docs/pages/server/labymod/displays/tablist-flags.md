The `TabListFlagPacket` is a client-bound packet that allows servers to display a flag in the tab list next to the player's name.

## Managing via LabyModPlayer (Recommended)

The `LabyModPlayer` class provides a method to manage the tab list flags.

Additionally, if you use the method below, flags are automatically sent to every LabyMod player on the
server. LabyMod players connecting to the server will also be sent every flag that is currently active
automatically.

```java
// Get the LabyModPlayer
LabyModPlayer labyModPlayer = LabyModProtocolService.get().getPlayer(uniqueId);

// Set the country code of the flag
labyModPlayer.setTabListFlag(TabListFlagCountryCode.DE);
```

## Sending via the LabyModProtocol

While not recommended, it is also possible to send the flags directly via the `LabyModProtocol`.

???+ danger "Important Note"

    When sending flags directly via the `LabyModProtocol`, you will have to store all flags yourself and send them to every player manually.

```java
// Create or get a List of flags (array is also possible)
List<TabListFlag> flags = new ArrayList<>();

// Add all flags you want to send to the player
flags.add(TabListFlag.create(uniqueId, TabListFlagCountryCode.DE));

// Get the LabyModProtocol
LabyModProtocol labyModProtocol = LabyModProtocolService.get().labyModProtocol();

// Send the packet
labyModProtocol.sendPacket(uniqueId, new TabListFlagPacket(flags));
```
