Markers are a feature of LabyMod that allows players to place markers on the screen. These markers can be used to highlight certain areas or entities in the game. 

## Set Maker Send Type

The send type is sent via the `MarkerPacket`. By default, Markers are only sent to LabyMod friends of the player. You can change this behaviour so that markers are sent to the server via the Server API, you then can handle the Marker and possibly forward them to other players.

The packet can either be sent via the `LabyModPlayer` object of the player, or directly via the `LabyModProtocol`.

### Via LabyModPlayer

```java
// Get the LabyModPlayer
LabyModPlayer labyModPlayer = LabyModProtocolService.get().getPlayer(uniqueId);

// Set the marker send type.
// Using MarkerSendType.LABY_CONNECT will restore the default behaviour.
labyModPlayer.sendMarkerSendType(MarkerSendType.SERVER);
```

### Via the LabyModProtocol

```java
// Get the LabyModProtocol
LabyModProtocol labyModProtocol = LabyModProtocolService.get().labyModProtocol();

// Send the packet.
// Using MarkerSendType.LABY_CONNECT will restore the default behaviour.
labyModProtocol.sendPacket(uniqueId, new MarkerPacket(MarkerSendType.SERVER));
```

## Send Markers to the Player

Markers can be sent to the Player via the `AddMarkerPacket`.

```java
// Get the LabyModProtocol
LabyModProtocol labyModProtocol = LabyModProtocolService.get().labyModProtocol();

// Send the packet
labyModProtocol.sendPacket(uniqueId, new AddMarkerPacket(
    uniqueId, // The sender of the marker
    0, // The x coordinate of the marker
    0, // The y coordinate of the marker
    0, // The z coordinate of the marker
    true, // Whether the marker should be large or not
    null // The target of the marker, can be null
));
```

## Receiving Markers

To receive markers sent by players, you first need to set the marker send type to `SERVER` as described above. Then you can create a `PacketHandler` for the `ClientAddMarkerPacket` to receive the markers. Registering a `PacketHandler` is described [here](/pages/server/protocols/#registering-handlers).

To keep the example platform-independent, we removed the import for `LabyModProtocolService`. Make sure to import the class in your implementation.

```java
import net.labymod.serverapi.api.packet.PacketHandler;
import net.labymod.serverapi.core.LabyModProtocol;
import net.labymod.serverapi.core.packet.clientbound.game.feature.marker.AddMarkerPacket;
import net.labymod.serverapi.core.packet.serverbound.game.feature.marker.ClientAddMarkerPacket;
import org.jetbrains.annotations.NotNull;

import java.util.UUID;

public class ClientAddMarkerPacketHandler implements PacketHandler<ClientAddMarkerPacket> {

  private final LabyModProtocolService protocolService;

  public ClientAddMarkerPacketHandler(LabyModProtocolService protocolService) {
    this.protocolService = protocolService;
  }

  @Override
  public void handle(@NotNull UUID sender, @NotNull ClientAddMarkerPacket packet) {
    // Map the ClientAddMarkerPacket to a AddMarkerPacket
    AddMarkerPacket addMarkerPacket = packet.toAddMarkerPacket(sender);

    // Get the LabyModProtocol
    LabyModProtocol labyModProtocol = this.protocolService.labyModProtocol();

    // Loop through all players and send the packet
    this.protocolService.forEachPlayer(player -> labyModProtocol.sendPacket(
        player.getUniqueId(), addMarkerPacket
    ));
  }
}
```