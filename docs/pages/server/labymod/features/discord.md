The `DiscordRPCPacket` is a client-bound packet that allows servers to customize the Discord Rich Presence of their players.

## Creating a Discord Rich Presence

### With Game Mode 

Create the model with `DiscordRichPresence.create` to create a Discord Rich Presence with the current game mode.
```java
DiscordRPC discordRPC = DiscordRPC.create("Example Game Mode");
```

### With Game Mode and Start Time

Create the model with `DiscordRichPresence.createWithStart` to create a Discord Rich Presence with the current game mode and the start time.
```java
DiscordRPC discordRPC = DiscordRPC.createWithStart("Example Game Mode", System.currentTimeMillis());
```

### With Game Mode and End Time

Create the model with `DiscordRichPresence.createWithEnd` to create a Discord Rich Presence with the current game mode and the end time.
```java
DiscordRPC discordRPC = DiscordRPC.createWithEnd("Example Game Mode", System.currentTimeMillis());
```

### Reset to Default

Create the model with `DiscordRichPresence.reset` to reset the Discord Rich Presence to the default state.
```java
DiscordRPC discordRPC = DiscordRPC.createReset();
```

## Sending the Packet

The packet can either be sent via the `LabyModPlayer` object of the player, or directly via the `LabyModProtocol`.

### Via LabyModPlayer

```java
// Get the LabyModPlayer
LabyModPlayer labyModPlayer = LabyModProtocolService.get().getPlayer(uniqueId);

// Send the discord rpc model
labyModPlayer.sendDiscordRPC(discordRPC);
```

### Via the LabyModProtocol

```java
// Get the LabyModProtocol
LabyModProtocol labyModProtocol = LabyModProtocolService.get().labyModProtocol();

// Send the packet
labyModProtocol.sendPacket(uniqueId, new DiscordRPCPacket(discordRPC));
```