The `VersionLoginPacket` is a server-bound packet that is sent to the server directly after connecting to it. It
contains the player's Laby Client version and serves as the first communication between the Laby Client and the server.

## Receiving the Packet

There is generally no need to manually handle this packet, as the Laby Client Server API creates the `LabyModPlayer` object
upon receiving this packet. The Laby Client version is then stored in the player's `LabyModPlayer` and can be accessed via
`LabyModPlayer#getLabyModVersion()`.

If you want to handle it anyway, you can register a `PacketHandler` for the `VersionLoginPacket`. The process is explained [here](../../protocols.md#registering-handlers).  