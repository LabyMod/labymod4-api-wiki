The `AddonRecommendationPacket` is a client-bound packet that opens a popup for the player with addons that are recommended or even required. The client will then respond with an `AddonRecommendationResponsePacket` that contains the player's response.

If sending required addons, you need to handle the response and check if the player has installed all required addons. LabyMod itself does not enforce the installation of required addons.

???+ danger "Note"
    The `AddonRecommendationResponsePacket` is sent <strong>twice</strong> by the client. Once before opening the popup and once the player has closed the popup. The `#isInitial` method can be used to check which response is being sent.

## Creating an Addon Recommendation

The packet uses the `RecommendedAddon` model, which can be created with `RecommendedAddon.of`.

```java
// Create the recommended adddon and provide the namespace
RecommendedAddon recommendedAddon = RecommendedAddon.of("example");

// If the addon is required, execute the following line
recommendedAddon.require();
```

## Sending the Packet

The packet can either be sent via the `LabyModPlayer` object of the player, or directly via the `LabyModProtocol`.

If you're not sending the packet with an integrated handler, you need to register a handler for the `AddonRecommendationResponsePacket` yourself. The process is explained [here](/pages/server/protocols/#registering-handlers).

### Via LabyModPlayer (Recommended)

=== ":octicons-file-code-16: #sendAddonRecommendations(List<RecommendedAddon>, Consumer<AddonRecommendationResponsePacket>)"

    ```java
    // Create or get a List of recommended addons 
    List<RecommendedAddon> recommendations = new ArrayList<>();
    
    // Add all recommended addons you want to send to the player
    recommendations.add(recommendedAddon);

    // Get the LabyModPlayer
    LabyModPlayer labyModPlayer = LabyModProtocolService.get().getPlayer(uniqueId);

    // Send the recommended addons and handle the response
    labyModPlayer.sendAddonRecommendations(recommendations, response -> {
        boolean initial = response.isInitial(); // Whether the response is the initial response
        boolean allInstalled = response.isAllInstalled(); // Whether all recommended addons are installed
        // Directly handle the response
    });
    ```

=== ":octicons-file-code-16: #sendAddonRecommendations(List<RecommendedAddon>)"

    ```java
    // Create or get a List of recommended addons 
    List<RecommendedAddon> recommendations = new ArrayList<>();
    
    // Add all recommended addons you want to send to the player
    recommendations.add(recommendedAddon);

    // Get the LabyModPlayer
    LabyModPlayer labyModPlayer = LabyModProtocolService.get().getPlayer(uniqueId);

    // Send the recommended addons
    labyModPlayer.sendAddonRecommendations(serverSwitchPrompt);

    // To handle the response, you need to register a PacketHandler for the 
    // AddonRecommendationResponsePacket yourself!
    ```

### Via the LabyModProtocol

=== ":octicons-file-code-16: #sendPacket(UUID, Packet)"

    ```java
    // Create or get a List of recommended addons (array is also possible)
    List<RecommendedAddon> recommendations = new ArrayList<>();
    
    // Add all recommended addons you want to send to the player
    recommendations.add(recommendedAddon);

    // Get the LabyModProtocol
    LabyModProtocol labyModProtocol = LabyModProtocolService.get().labyModProtocol();

    // Send the packet
    labyModProtocol.sendPacket(uniqueId, new AddonRecommendationPacket(recommendations));

    // To handle the response, you need to register a PacketHandler for the 
    // AddonRecommendationResponsePacket yourself!
    ```

=== ":octicons-file-code-16: #sendPacket(UUID, IdentifiablePacket, Class, Predicate)"

    ```java
    // Create or get a List of recommended addons (array is also possible)
    List<RecommendedAddon> recommendations = new ArrayList<>();
    
    // Add all recommended addons you want to send to the player
    recommendations.add(recommendedAddon);

    // Get the LabyModProtocol
    LabyModProtocol labyModProtocol = LabyModProtocolService.get().labyModProtocol();

    // Send the packet and handle the response
    labyModProtocol.sendPacket(
        uniqueId,
        new AddonRecommendationPacket(recommendations),
        AddonRecommendationResponsePacket.class,
        response -> {
            boolean initial = response.isInitial(); // Whether the response is the initial response
            boolean allInstalled = response.isAllInstalled(); // Whether all recommended addons are installed
            // Handle the response packet

            return initial; // return #isInitial, as another response is expected if it is the initial response
        }
    );
    ```