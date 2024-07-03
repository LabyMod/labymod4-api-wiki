The `VoiceChatMutePacket` is a client-bound packet provided by the VoiceChat integration, that allows servers to mute any player in the voice chat on their server.

## Creating the Mute Model

The packet uses the `VoiceChatMute` model, which can be created with `VoiceChatMute.create`.

```java
// Create the mute model
// For a permanent mute, remove the timestamp parameter
VoiceChatMute voiceChatMute = VoiceChatMute.create(
    uniqueId, // The UUID of the player to mute
    "Example Mute Reason", // The reason for the mute. Can be null
    System.currentTimeMillis() + 60000 // The timestamp until the mute expires.
);
```

## Sending the Packet

The packet can either be sent via the `VoiceChatPlayer` or the `AddonProtocol` of the `VoiceChatIntegration`

If you are using the `VoiceChatPlayer` to mute a player, the mute will automatically be sent to every LabyMod player on 
the server. LabyMod players connecting to the server will also be sent every mute that is currently active automatically.

### Via VoiceChatPlayer (Recommended)

```java
// Get the LabyModPlayer
LabyModPlayer labyModPlayer = LabyModProtocolService.get().getPlayer(uniqueId);

// Get the VoiceChatPlayer
VoiceChatPlayer voiceChatPlayer = labyModPlayer.getIntegrationPlayer(VoiceChatPlayer.class);

// Mute the player
voiceChatPlayer.mute(voiceChatMute);
```

### Via the AddonProtocol

While not recommended, it is also possible to send the mutes directly via the `AddonProtocol` of the `VoiceChatIntegration`.

???+ danger "Important Note"

    When sending mutes directly via the `AddonProtocol` of the `VoiceChatIntegration`, you will have to store all mutes yourself and send them to every player manually.

```java
// Create or get a List of mutes (array is also possible)
List<VoiceChatMute> mutes = new ArrayList<>();

// Add all mutes that you want to send to the player
mutes.add(voiceChatMute);

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
addonProtocol.sendPacket(uniqueId, new VoiceChatMutePacket(mutes));
```

### Via the LabyMod Player

While not recommended, it is also possible to send the packet directly via the `LabyModPlayer`. This will basically skip the "protocol-getting" process, as it will search for the protocol automatically. 

???+ danger "Important Note"

    When sending mutes directly via the `LabyModPlayer`, you will have to store all mutes yourself and send them to every player manually.

```java
// Create or get a List of mutes (array is also possible)
List<VoiceChatMute> mutes = new ArrayList<>();

// Add all mutes that you want to send to the player
mutes.add(voiceChatMute);

// Get the LabyModPlayer
LabyModPlayer labyModPlayer = LabyModProtocolService.get().getPlayer(uniqueId);

// Send the packet
labyModPlayer.sendPacket(new VoiceChatMutePacket(mutes));
```