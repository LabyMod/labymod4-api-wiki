Protocols are collections of packets that are used to communicate between the client and the server. <br/>
Addons can create custom protocols to send and receive custom packets. <br/>
The LabyMod 4 Server API provides the LabyMod Protocol that is used to communicate with the LabyMod client.

## The LabyMod Protocol

The LabyMod Protocol is the default protocol, it contains all official features that servers can use to customize the
experience of LabyMod players.

A collection of all available features can be found [here](/pages/server/labymod/overview).

### Registering Handlers

To register a packet handler in the LabyMod Protocol, you first need to create a new class implementing the
`PacketHandler` interface. We'll use the [VersionLoginPacket](/pages/server/labymod/moderation/labymod-version/) in the
following example.

```java
import net.labymod.serverapi.api.packet.PacketHandler;
import net.labymod.serverapi.core.packet.serverbound.login.VersionLoginPacket;
import org.jetbrains.annotations.NotNull;

import java.util.UUID;

public class VersionLoginPacketHandler implements PacketHandler<VersionLoginPacket> {

  /**
   * Handles the VersionLoginPacket
   * 
   * @param sender the unique id of the sender of the packet
   * @param packet the packet that was sent
   */
  @Override
  public void handle(@NotNull UUID sender, @NotNull VersionLoginPacket packet) {
    // Perform logic to handle the packet
  }
}
```

After creating the handler, you can register it in the LabyMod Protocol.

```java
// Get the LabyModProtocol
LabyModProtocol labyModProtocol = LabyModProtocolService.get().labyModProtocol();

// Register the handler
labyModProtocol.registerHandler(
    VersionLoginPacket.class, // The packet class
    new VersionLoginPacketHandler() // Object of the handler (can also be a lambda)
);
```

## Create a Custom Protocol

To create a custom protocol, you can create a new instance of `AddonProtocol` by calling the constructor
with the protocol service and namespace as parameters. Then register the protocol in the ProtocolRegistry.

```java
// Get the Protocol Service
LabyModProtocolService protocolService = LabyModProtocolService.get();

// Create a new AddonProtocol
AddonProtocol protocol = new AddonProtocol(protocolService, "example");

// Register the protocol
protocolService.registry().registerProtocol(protocol);
```

### Register a Packet

To register a packet, you first need to [create a Packet](/pages/server/packets/). After doing that, you can just
register the packet in the protocol.

=== ":octicons-code-16: With Handler"

    ```java
    // Register the Packet with handler
    protocol.registerPacket(
        0, // the id of the packet. Must be unique in the protocol on both sides
        ExamplePacket.class, // the class of the packet
        Direction.CLIENTBOUND, // the direction of the packet. Can also be SERVERBOUND or BOTH
        new ExamplePacketHandler() // the handler of the packet
    );
    ```

=== ":octicons-code-16: Without Handler"

    ```java
    // Register the Packet without handler. Handler can be registered later.
    // See above for registering a handler separately
    protocol.registerPacket(
        0, // the id of the packet. Must be unique in the protocol on both sides
        ExamplePacket.class, // the class of the packet
        Direction.CLIENTBOUND // the direction of the packet. Can also be SERVERBOUND or BOTH
    );
    ```

