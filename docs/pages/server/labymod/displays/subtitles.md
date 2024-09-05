The `SubtitlePacket` is a client-bound packet that allows servers to display a subtitle to the player. The subtitle is
displayed below the player's name tag.

## The Subtitle Model

The `Subtitle` class provides several factory methods. If you're managing the Subtitles with the `LabyModPlayer` object,
you won't need to create the model yourself.

The following methods are available to update the values of an Economy Display:

- `#text(ServerAPIComponent)` - Updates the text of the subtitle. Default is `null`.
- `#size(double)` - Updates the size of the subtitle. Default is `1`.

## Managing via LabyModPlayer (Recommended)

The `LabyModPlayer` class provides a range of methods to manage the subtitles.

Additionally, if you use the methods below, subtitles are automatically sent to every other LabyMod player on the
server. LabyMod players connecting to the server will also be sent every subtitle that is currently active
automatically.

### Updating the Subtitle

Updating the subtitle allows you to change the text and size of the subtitle. If no subtitle was set before, a new
one will be created.

=== ":fontawesome-solid-pen-to-square: Update Text"

    ```java
    // Get the LabyModPlayer
    LabyModPlayer labyModPlayer = LabyModProtocolService.get().getPlayer(uniqueId);

    // Update the Subtitle text
    labyModPlayer.updateSubtitle(ServerAPIComponent.text("Example Subtitle"));
    ```

=== ":fontawesome-solid-pen-to-square: Update Text and Size"

    ```java
    // Get the LabyModPlayer
    LabyModPlayer labyModPlayer = LabyModProtocolService.get().getPlayer(uniqueId);

    // Update the Subtitle text and size
    labyModPlayer.updateSubtitle(ServerAPIComponent.text("Example Subtitle"), 0.5D);
    ```

### Reset the Subtitle

Resetting the subtitle will remove the subtitle from the player.

```java
// Get the LabyModPlayer
LabyModPlayer labyModPlayer = LabyModProtocolService.get().getPlayer(uniqueId);

// Reset the subtitle
labyModPlayer.resetSubtitle();
```

## Sending via the LabyModProtocol

While not recommended, it is also possible to send the subtitles directly via the `LabyModProtocol`.

???+ danger "Important Note"

    When sending subtitles directly via the `LabyModProtocol`, you will have to store all subtitles yourself and send them to every player manually.

```java
// Create or get a List of subtitles (array is also possible)
List<Subtitle> subtitles = new ArrayList<>();

// Add all subtitles you want to send to the player
subtitles.add(Subtitle.create(uniqueId, ServerAPIComponent.text("Example Subtitle")));

// Get the LabyModProtocol
LabyModProtocol labyModProtocol = LabyModProtocolService.get().labyModProtocol();

// Send the packet
labyModProtocol.sendPacket(uniqueId, new SubtitlePacket(subtitles));
```
