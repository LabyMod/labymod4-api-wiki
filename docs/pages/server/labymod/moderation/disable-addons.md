The `AddonDisablePacket` is a client-bound packet that forcefully disables the specified addons for the player.
Reverting the forced disabled state is also possible via the same packet.

???+ warning
    While this should work with all addons that can also be disabled by the user, this cannot be guaranteed. Especially for addons that are not in the addon store.

## Disabling Addons

???+ danger "Note"
    Some addons also provide special permissions to disable certain features. For user experience sake, please consider disabling these permissions instead of the whole addon (f.e. [BetterPerspective](/pages/server/addons/betterperspective/)).

### Via LabyModPlayer (Recommended)

```java
// Create or get a List of addons to disable
List<String> addonsToDisable = new ArrayList<>();

// Add the namespace of all addons that you want to disable
addonsToDisable.add("voicechat");
addonsToDisable.add("clearwater");

// Get the LabyModPlayer
LabyModPlayer labyModPlayer = LabyModProtocolService.get().getPlayer(uniqueId);

// Send the addons to disable
labyModPlayer.disableAddons(addons);
```

### Via the LabyModProtocol

```java
// Create or get a List of addons to disable (array is also possible)
List<String> addonsToDisable = new ArrayList<>();

// Add the namespace of all addons that you want to disable
addonsToDisable.add("voicechat");
addonsToDisable.add("clearwater");

// Get the LabyModProtocol
LabyModProtocol labyModProtocol = LabyModProtocolService.get().labyModProtocol();

// Send the packet
labyModProtocol.sendPacket(uniqueId, AddonDisablePacket.disable(addonsToDisable));
```

## Reverting the Disable State

### Via LabyModPlayer (Recommended)

When disabling addons [via LabyModPlayer](#via-labymodplayer-recommended), all disabled addons are stored in the player's object. This allows you to either revert the disable state for all disabled addons or only for specific ones.

=== ":octicons-file-code-16: All Disabled Addons"

    ```java
    // Get the LabyModPlayer
    LabyModPlayer labyModPlayer = LabyModProtocolService.get().getPlayer(uniqueId);
    
    // Revert the disabled state of all disabled addons
    labyModPlayer.revertDisabledAddons();
    ```

=== ":octicons-file-code-16: Specific Addons"

    ```java
    // Create or get a List of addons to enable
    List<String> addonsToRevert = new ArrayList<>();
    
    // Add the namespace of all addons that you want to enable
    addonsToRevert.add("voicechat");
    
    // Get the LabyModPlayer
    LabyModPlayer labyModPlayer = LabyModProtocolService.get().getPlayer(uniqueId);
    
    // Send the addons to revert
    labyModPlayer.revertDisabledAddons(addonsToRevert);
    ```

### Via the LabyModProtocol

```java
// Create or get a List of addons to enable (array is also possible)
List<String> addonsToRevert = new ArrayList<>();

// Add the namespace of all addons that you want to enable
addonsToRevert.add("voicechat");

// Get the LabyModProtocol
LabyModProtocol labyModProtocol = LabyModProtocolService.get().labyModProtocol();

// Send the packet
labyModProtocol.sendPacket(uniqueId, AddonDisablePacket.revert(addonsToRevert));
```