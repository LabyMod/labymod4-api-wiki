The `PlayingGameModePacket` is a client-bound packet that sends the current game mode to the player's LabyMod Chat friends.

![Example Playing Game Mode](/assets/files/serverapi/game-mode.png)

## Sending the Packet

The packet can either be sent via the `LabyModPlayer` object of the player, or directly via the `LabyModProtocol`.

The value can be a string that represents the current game mode, or `null` to unset the current game mode.

### Via LabyModPlayer

```java
// Get the LabyModPlayer
LabyModPlayer labyModPlayer = LabyModProtocolService.get().getPlayer(uniqueId);

// Send the game mode
labyModPlayer.sendPlayingGameMode("Example Game Mode");
```

### Via the LabyModProtocol

```java
// Get the LabyModProtocol
LabyModProtocol labyModProtocol = LabyModProtocolService.get().labyModProtocol();

// Send the packet
labyModProtocol.sendPacket(
    uniqueId, 
    new PlayingGameModePacket("Example Game Mode")
);
```
