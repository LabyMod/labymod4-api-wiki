The `TabListBannerPacket` is a client-bound packet that allows servers to add a custom banner above the player list.

???+ warning "Important Note"

    The aspect ratio of the image must be `5:1` and the recommended resolution is `1280x256` pixels.

![TabList Banner](/assets/files/serverapi/tablist-banner.png)

## Sending the Packet

The packet can either be sent via the `LabyModPlayer` object of the player, or directly via the `LabyModProtocol`.

The value can either be a URL to the image or `null` to unset the banner.

### Via LabyModPlayer 

```java
// Get the LabyModPlayer
LabyModPlayer labyModPlayer = LabyModProtocolService.get().getPlayer(uniqueId);

// Send the tab list banner
labyModPlayer.sendTabListBanner("https://example.com/banner.png");
```

### Via the LabyModProtocol

```java
// Get the LabyModProtocol
LabyModProtocol labyModProtocol = LabyModProtocolService.get().labyModProtocol();

// Send the packet
labyModProtocol.sendPacket(uniqueId, new TabListBannerPacket("https://example.com/banner.png"));
```
