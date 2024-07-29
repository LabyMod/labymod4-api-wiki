???+ warning "Only available on Snapshot"
    This feature was added in LabyMod 4.2.33 (currently only available on the snapshot release channel).

There are multiple packets related to the installed addons of your players. But all rely on the client-bound packet
`InstalledAddonsRequestPacket`.
The workflow is as follows:

1. You send the `InstalledAddonsRequestPacket` to the player containing the addons that you want to request.
2. The client responds with the `InstalledAddonsResponsePacket` containing all requested addons that are installed.
3. If the enabled state of a requested addon changes (or it was installed), the client will send the
   `AddonStateChangedPacket` to the server.

## Get Installed Addons

`LabyModPlayer#installedAddons` gets an object of the class `InstalledAddonsResponse`, this object is created with the `LabyModPlayer` BUT does not contain any addons until you request them. You can check this by calling `#hasResponse` on the object.

This object is also used as response when using the `LabyModPlayer#requestInstalledAddons` method (with callback).

???+ danger "Important Note"
    Installed addons are not sent to the server by default. You need to request them first, see [Requesting Installed Addons](#requesting-installed-addons).

The `InstalledAddonsResponse` class contains the following methods:

- `#hasResponse` - Whether the client has responded with the installed addons.
- `#hasRequested` - Whether the installed addons were requested
- `#getRequested` - Gets the requested addons. If `#hasRequested` is true and the list is empty, all addons were requested.
- `#isInstalled` - Whether the addon is installed
- `#isEnabled` - Whether the addon is enabled
- `#isDisabled` - Whether the addon is disabled
- `#isLocal` - Returns `true` if the addon is installed locally (`false` if it's from the addon store)
- `#getVersion` - Gets the version of the addon

## Requesting Installed Addons

As mentioned above **ALL** packets related to installed addons **RELY** on this packet and it's contents. The client **DOES NOT** send the installed addons to the server automatically.

???+ danger "Important Note"
      Requesting **all** installed addons is not recommended as it can lead to unnecessary traffic and processing. Only request the addons that you really need to know about.

### Via LabyModPlayer (Recommended)

The `LabyModPlayer` object provides the `#installedAddons` method to get the installed addons of the player at any time. Check `InstalledAddonsResponse#hasResponse` before handling it though, to ensure that the data is valid.

???+ warning "Note"
    Using the `LabyModPlayer` for this process is recommended as it keeps track of the installed and enabled addons for you. If you're not using the `LabyModPlayer`, you need to keep track of the installed (and enabled/disabled) addons yourself by [handling the server-bound packets](/pages/server/protocols/#registering-handlers).

=== ":octicons-file-code-16: Specific Addons"

    ```java
    // Create or get a List of addons to request
    List<String> addonsToRequest = new ArrayList<>();
    
    // Add the namespace of all addons that you want to request
    // Keeping the List empty requests all addons (not recommended)
    addonsToRequest.add("voicechat");

    // Get the LabyModPlayer
    LabyModPlayer labyModPlayer = LabyModProtocolService.get().getPlayer(uniqueId);
    
    // Request the installed addons and optionally handle the response
    labyModPlayer.requestInstalledAddons(addonsToRequest, response -> {
        if (response.isEnabled("voicechat")) {
            // VoiceChat is enabled
        } else if (response.isDisabled("voicechat")) {
            // VoiceChat is disabled
        } else {
            // VoiceChat is not installed
        }
    });
    ```

=== ":octicons-file-code-16: All Addons (Not Recommended)"

    ```java
    // Get the LabyModPlayer
    LabyModPlayer labyModPlayer = LabyModProtocolService.get().getPlayer(uniqueId);
    
    // Request all installed addons and optionally handle the response
    labyModPlayer.requestInstalledAddons(response -> {
        List<InstalledAddon> installedAddons = response.getInstalledAddons();
        // Handle the response
    });
    ```

### Via the LabyModProtocol

=== ":octicons-file-code-16: #sendPacket(UUID, Packet)"

    ```java
    // Create or get a List of addons to request (array is also possible)
    List<String> addonsToRequest = new ArrayList<>();
    
    // Add the namespace of all addons that you want to request
    // Keeping the List empty requests all addons (not recommended)
    addonsToRequest.add("voicechat");

    // Get the LabyModProtocol
    LabyModProtocol labyModProtocol = LabyModProtocolService.get().labyModProtocol();

    // Send the packet
    labyModProtocol.sendPacket(uniqueId, new InstalledAddonsRequestPacket(addonsToRequest));

    // To handle the response, you need to register a PacketHandler for the 
    // InstalledAddonsResponsePacket yourself!
    ```

=== ":octicons-file-code-16: #sendPacket(UUID, IdentifiablePacket, Class, Predicate)"

    ```java
    // Create or get a List of addons to request (array is also possible)
    List<String> addonsToRequest = new ArrayList<>();
    
    // Add the namespace of all addons that you want to request
    // Keeping the List empty requests all addons (not recommended)
    addonsToRequest.add("voicechat");

    // Get the LabyModProtocol
    LabyModProtocol labyModProtocol = LabyModProtocolService.get().labyModProtocol();

    // Send the packet and handle the response
    labyModProtocol.sendPacket(
        uniqueId,
        new InstalledAddonsRequestPacket(recommendations),
        InstalledAddonsResponsePacket.class,
        response -> {
            List<InstalledAddon> installedAddons = response.getInstalledAddons();
            // Handle the response

            return false; // return false because no other response is expected
        }
    );
    ```
