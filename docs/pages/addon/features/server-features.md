Servers can enable or disable specific features for connected LabyMod players. As an addon developer, you can listen for these feature updates and query the current state at any time.

## Available Features

| Feature | Identifier | Description |
|---------|-----------|-------------|
| Fancy Font | `fancy_font` | Controls whether the LabyMod fancy font is allowed |

???+ note "Note"
    The list of available features is not fixed. New features can be added at any time. Use `Feature.of("identifier")` to reference any feature by its string identifier.

## Listening for Feature Updates

When a server toggles a feature, LabyMod fires a `ServerFeatureUpdateEvent`. This event can be fired at any point during the session, not just on login. It only contains the features that changed, not the full set of active features.

=== ":octicons-file-code-16: FeatureListener"
    ``` java
    import net.labymod.api.event.Subscribe;
    import net.labymod.api.event.labymod.serverapi.ServerFeatureUpdateEvent;
    import net.labymod.serverapi.core.model.feature.Feature;
    import net.labymod.serverapi.core.model.feature.Feature.StatedFeature;

    public class FeatureListener {

      @Subscribe
      public void onServerFeatureUpdate(ServerFeatureUpdateEvent event) {
        StatedFeature fancyFont = event.get(Feature.FANCY_FONT);
        if (fancyFont == null) {
          return;
        }

        if (fancyFont.isEnabled()) {
          // The server enabled fancy font
        } else {
          // The server disabled fancy font
        }
      }

    }
    ```

Don't forget to register your listener in the `enable()` method of your addon class by calling `registerListener(new FeatureListener())`.

## Querying the Current Feature State

To check the current state of a feature outside of an event listener, use the `ServerFeatureService`. This gives you access to all features that the server has sent so far.

=== ":octicons-file-code-16: ServerFeatureService"
    ``` java
    import net.labymod.api.Laby;
    import net.labymod.api.user.serverfeature.ServerFeature;
    import net.labymod.api.user.serverfeature.ServerFeatureService;
    import net.labymod.serverapi.core.model.feature.Feature;

    ServerFeatureService service = Laby.references().serverFeatureService();
    ServerFeature serverFeature = service.serverFeature();

    // Check if a feature is enabled, returns the default if the server hasn't sent it
    boolean fancyFontEnabled = serverFeature.isFeatureEnabled(Feature.FANCY_FONT, false);
    ```

## Custom Features

Addons can react to custom feature identifiers. If a server sends an `UpdateFeaturePacket` with a custom identifier, the `ServerFeatureUpdateEvent` will contain it like any built-in feature.

=== ":octicons-file-code-16: Custom Feature"
    ``` java
    import net.labymod.serverapi.core.model.feature.Feature;
    import net.labymod.serverapi.core.model.feature.Feature.StatedFeature;

    // Reference a custom feature by its identifier
    Feature myFeature = Feature.of("my_addon_feature");

    // Use it in an event listener or query it via ServerFeatureService
    StatedFeature stated = event.get(myFeature);
    ```

???+ info "Server-Side Implementation"
    The server needs to send the `UpdateFeaturePacket` with your custom identifier for this to work. See the [Server API Feature Toggles](../../server/labymod/features/feature-toggles.md) documentation for the server-side implementation.
