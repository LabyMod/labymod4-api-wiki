When using an official platform-implementation of the LabyMod Server API, you can listen to the following events that
are fired by the API:

## LabyModPlayerJoinEvent

The `LabyModPlayerJoinEvent` is fired after a player has sent
the [VersionLoginPacket](/pages/server/labymod/moderation/labymod-version/) to the server.

???+ danger "Important Note"

    The `LabyModPlayer` object of the player is not available before this event is fired. It is fired **after** the join event of the respective server platform (f.e. `PlayerJoinEvent` on Bukkit).

The following methods are available in this event:

- `#labyModPlayer()` - Returns the `LabyModPlayer` object of the player.
- `#protocolService()` - Returns the `LabyModProtocolService` instance.

## LabyModPacketSentEvent

The `LabyModPacketSentEvent` is fired **after** a packet has been sent to a player.

The following methods are available in this event:

- `#packet()` - Returns the packet that has been sent.
- `#protocolService()` - Returns the `LabyModProtocolService` instance.
- `#protocol()` - The protocol that the packet has been sent with.
- `#getReceiver()` - Returns the unique id player that the packet has been sent to.
- `#getLabyModPlayer()` - Returns the `LabyModPlayer` object of the player that the packet has been sent to. **Can
  be `null` if it's not a LabyMod player.**

## LabyModPacketReceiveEvent

The `LabyModPacketReceiveEvent` is fired **after** a packet has been received from a player (and after all registered
packet handlers have handled the packet).

The following methods are available in this event:

- `#packet()` - Returns the packet that was sent by the player.
- `#protocolService()` - Returns the `LabyModProtocolService` instance.
- `#protocol()` - The protocol that the packet was received on.
- `#getSender()` - Returns the unique id player that has sent the packet.
- `#getLabyModPlayer()` - Returns the `LabyModPlayer` object of the player that has sent the packet. **Can be `null` if
  it's not a LabyMod player.**
