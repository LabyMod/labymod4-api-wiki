The `VoiceChatOpenChannelsPacket` is a client-bound packet provided by the VoiceChat integration, that allows servers to open the voice channels popup.

## Sending the Packet

The packet can either be sent via the `VoiceChatPlayer` or the `AddonProtocol` of the `VoiceChatIntegration`

### Via VoiceChatPlayer

```java
// Get the LabyModPlayer
LabyModPlayer labyModPlayer = LabyModProtocolService.get().getPlayer(uniqueId);

// Get the VoiceChatPlayer
VoiceChatPlayer voiceChatPlayer = labyModPlayer.getIntegrationPlayer(VoiceChatPlayer.class);

// Open the VoiceChat Channels Widget
voiceChatPlayer.openVoiceChatChannels();
```

### Via the AddonProtocol

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
addonProtocol.sendPacket(uniqueId, new VoiceChatOpenChannelsPacket());
```

### Via the LabyMod Player

While not recommended, it is also possible to send the packet directly via the `LabyModPlayer`. This will basically skip the "protocol-getting" process, as it will search for the protocol automatically. <br/>

```java
// Get the LabyModPlayer
LabyModPlayer labyModPlayer = LabyModProtocolService.get().getPlayer(uniqueId);

// Send the packet
labyModPlayer.sendPacket(new VoiceChatOpenChannelsPacket());
```
