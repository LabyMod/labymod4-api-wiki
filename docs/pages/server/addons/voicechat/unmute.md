The `VoiceChatUnmutePacket` is a client-bound packet provided by the VoiceChat integration, that allows servers to remove the server-bound mute from a player in the voice chat.

## Sending the Packet

The packet can either be sent via the `VoiceChatPlayer` or the `AddonProtocol` of the `VoiceChatIntegration`

If you are using the `VoiceChatPlayer` to unmute a player, the unmute will automatically be sent to every LabyMod player on
the server. 

### Via VoiceChatPlayer (Recommended)

```java
// Get the LabyModPlayer
LabyModPlayer labyModPlayer = LabyModProtocolService.get().getPlayer(uniqueId);

// Get the VoiceChatPlayer
VoiceChatPlayer voiceChatPlayer = labyModPlayer.getIntegrationPlayer(VoiceChatPlayer.class);

// Unmute the player
voiceChatPlayer.unmute();
```

### Via the AddonProtocol

While not recommended, it is also possible to send the unmutes directly via the `AddonProtocol` of the `VoiceChatIntegration`.

???+ danger "Important Note"

    When sending (un)mutes directly via the `AddonProtocol` of the `VoiceChatIntegration`, you will have to store all mutes yourself and send them to every player manually.

```java
// Get the VoiceChatIntegration
// #getOrRegisterIntegration is a fail-safe method to get the integration, even 
// if the integration has not been registered.  Alternatively, you can use 
// #getIntegration, which will return null if the integration has not been registered.
VoiceChatIntegration voiceChatIntegration = LabyModProtocolService.get().getOrRegisterIntegration(
    VoiceChatIntegration.class,
    VoiceChatIntegration::new
);

// Get the AddonProtocol
AddonProtocol addonProtocol = voiceChatIntegration.voiceChatProtocol();

// Send the packet
addonProtocol.sendPacket(uniqueId, new VoiceChatUnmutePacket(uniqueId));
```

### Via the LabyMod Player

While not recommended, it is also possible to send the packet directly via the `LabyModPlayer`. This will basically skip the "protocol-getting" process, as it will search for the protocol automatically.

???+ danger "Important Note"

    When sending (un)mutes directly via the `LabyModPlayer`, you will have to store all mutes yourself and send them to every player manually.

```java
// Get the LabyModPlayer
LabyModPlayer labyModPlayer = LabyModProtocolService.get().getPlayer(uniqueId);

// Send the packet
labyModPlayer.sendPacket(new VoiceChatUnmutePacket(uniqueId));
```
