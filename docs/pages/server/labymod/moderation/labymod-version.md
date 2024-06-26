The `VersionLoginPacket` is a server-bound packet that is sent to the server directly after connecting to it. It
contains the player's LabyMod version and serves as the first communication between LabyMod and the server.

## Receiving the Packet

There is generally no need to manually handle this packet, as the LabyMod Server API creates the `LabyModPlayer` object
upon receiving this packet. The LabyMod version is then stored in the player's `LabyModPlayer` and can be accessed via
`LabyModPlayer#getLabyModVersion()`.

If you want to handle it anyway, you can register a `PacketHandler` for the `VersionLoginPacket`.