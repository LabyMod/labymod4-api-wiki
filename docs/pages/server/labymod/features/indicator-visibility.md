The `UpdateLabyModUserIndicatorVisibilityPacket` is a client-bound packet that allows servers to hide the indicator of a player.

## Sending the Packet

The packet can either be sent via the `LabyModPlayer` object of the player, or directly via the `LabyModProtocol`.

### Via the LabyModPlayer (Recommended)

```java
// Get the LabyModPlayer
LabyModPlayer player = LabyModProtocolService.get().getPlayer(uniqueId);
        
// Update the Indicator Visibility
player.updateLabyModUserIndicatorVisibility(false);
```

### Via the LabyModProtocol

```java
// Get the LabyModProtocol
LabyModProtocol labyModProtocol = LabyModProtocolService.get().labyModProtocol();

// Send the packet
labyModProtocol.sendPacket(uniqueId, new UpdateLabyModUserIndicatorVisibilityPacket(false));
```