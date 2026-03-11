The `UpdateFeaturePacket` is a client-bound packet that allows servers to enable or disable LabyMod features for a player. Multiple features can be toggled in a single packet.

???+ note "Note"
    The list of available features is not fixed. New features can be added at any time by LabyMod or by addons that register custom features. Use `Feature.of("identifier")` to reference any feature by its identifier.

## Available Features

| Feature | Identifier | Description |
|---------|-----------|-------------|
| Fancy Font | `fancy_font` | Enables or disables the LabyMod fancy font |

## Enabling a Feature

```java
// Get the LabyModProtocol
LabyModProtocol labyModProtocol = LabyModProtocolService.get().labyModProtocol();

// Enable fancy font
labyModProtocol.sendPacket(uniqueId, new UpdateFeaturePacket(Feature.FANCY_FONT.enable()));
```

## Disabling a Feature

```java
// Get the LabyModProtocol
LabyModProtocol labyModProtocol = LabyModProtocolService.get().labyModProtocol();

// Disable fancy font
labyModProtocol.sendPacket(uniqueId, new UpdateFeaturePacket(Feature.FANCY_FONT.disable()));
```

## Toggling Multiple Features at Once

```java
// Get the LabyModProtocol
LabyModProtocol labyModProtocol = LabyModProtocolService.get().labyModProtocol();

// Toggle multiple features in a single packet
labyModProtocol.sendPacket(uniqueId, new UpdateFeaturePacket(
    Feature.FANCY_FONT.enable(),
    Feature.of("custom_feature").disable()
));
```
