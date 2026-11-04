The `PermissionPacket` is a client-bound packet that allows servers to deactivate and/or activate certain features for
their Laby Client players.

## What permissions are available?

All permissions available in Laby Client itself can be found as constants in the `Permission` class, integrations may also
create their own permissions. <br/>
Creating custom permissions is possible via `Permission.of(String)`.

## Sending the Packet

The packet can either be sent via the `LabyModPlayer` object of the player, or directly via the `LabyModProtocol`.

The packet requires the type `StatedPermission` which can be obtained by calling either `Permission#allow` or
`Permission#deny`. So for example `Permission.CHAT_AUTOTEXT.deny()` would disable the chat autotext feature.

### Via LabyModPlayer

```java
// Create a List of permissions (array is also possible)
List<Permission.StatedPermission> permissions = new ArrayList<>();

// Add all permissions you want to allow and/or deny
permissions.add(Permission.CHAT_AUTOTEXT.deny());

// Get the LabyModPlayer
LabyModPlayer labyModPlayer = LabyModProtocolService.get().getPlayer(uniqueId);

// Send the permissions
labyModPlayer.sendPermissions(permissions);
```

### Via the LabyModProtocol

```java
// Create a List of permissions (array is also possible)
List<Permission.StatedPermission> permissions = new ArrayList<>();

// Add all permissions you want to allow and/or deny
permissions.add(Permission.CHAT_AUTOTEXT.deny());

// Get the LabyModProtocol
LabyModProtocol labyModProtocol = LabyModProtocolService.get().labyModProtocol();

// Send the packet
labyModProtocol.sendPacket(uniqueId, new PermissionPacket(permissions));
```

## Disabling Features

Besides the permissions above, a server can turn off a feature of the Laby Client by its id. Deny the permission
`feature_<id>`, for example `feature_fullbright`. Allow it again to give the feature back.

```java
labyModPlayer.sendPermissions(Permission.of("feature_fullbright").deny());
```

The player's own setting stays as it is. The feature counts as off until the server allows it again or the player
leaves, and its settings show that the server disabled it.

- Features are allowed by default. You only need to send the ones you want to deny.
- A denial lasts until the player leaves the server. Unlike the permissions above, it survives subserver switches, so
  you send it once.
- Some features have parts with their own switch, like the cinema bars of Zoom. Deny `feature_<partId>`, e.g.
  `feature_cinema_bars`, to turn off only that part. Denying the feature turns off all of its parts.
- Features of addons carry the addon's namespace: `feature_<namespace>:<id>`.
- If your server also uses Apollo, a feature stays off as long as either of them disables it.

### Features

Only the features below can be turned off this way. Other features have no switch of their own, so denying them has no
effect.

| Id                           | Feature                    |
|------------------------------|----------------------------|
| `advanced_chat`              | Ingame Chat                |
| `afk_camera`                 | AFK Camera                 |
| `apollo`                     | Apollo Server API          |
| `armor_bar`                  | Armor Bar                  |
| `attack_indicator`           | Attack Indicator           |
| `auto_accept_resource_packs` | Auto-Accept Resource Packs |
| `auto_reconnect`             | Auto Reconnect             |
| `auto_text`                  | AutoText                   |
| `build_height_limit`         | Build Height Limit         |
| `clear_view`                 | Clear View                 |
| `clip_events`                | Clip Events                |
| `confirm_disconnect`         | Smart Disconnect           |
| `cosmetics`                  | Cosmetics                  |
| `custom_cursor`              | Custom Cursor              |
| `custom_player_list`         | Player List                |
| `damage_color`               | Hit Color                  |
| `discord`                    | Discord Rich Presence      |
| `dynamic_fps`                | Dynamic FPS                |
| `external_devices`           | External Devices           |
| `fov_changer`                | FOV Changer                |
| `fullbright`                 | Full Bright                |
| `glint`                      | Enchantment Glint          |
| `gui_scale`                  | Custom GUI Scale           |
| `hit_markers`                | Hit Markers                |
| `hitbox`                     | Hitbox                     |
| `hud_widgets`                | HUD Widgets                |
| `hurt_camera`                | Hurt Camera                |
| `inventory`                  | Inventory                  |
| `item_appearance`            | Item Appearance            |
| `kill_sounds`                | Kill Sounds                |
| `low_health_warning`         | Low Health Warning         |
| `marker`                     | Marker                     |
| `mob_size`                   | Mob Size                   |
| `motion_blur`                | Motion Blur                |
| `no_view_bobbing`            | Bobbing                    |
| `notifications`              | Notifications              |
| `one_row_hearts`             | Hearts in One Row          |
| `particles`                  | Particles                  |
| `shield`                     | Shields                    |
| `speech_bubble`              | Speech Bubbles             |
| `team_marker`                | Team Markers               |
| `tnt_fuse_timer`             | TNT Timer                  |
| `torch_placement`            | Improved Torch Placement   |
| `watch_party`                | Watch Party                |
| `wingtip_vortices`           | Wingtip Vortices           |

### Parts

| Id                     | Part                 | Feature    |
|------------------------|----------------------|------------|
| `font`                 | Font                 | Appearance |
| `centered_recipe_book` | Centered Recipe Book | Inventory  |
| `classic_inventory`    | Classic Inventory    | Inventory  |
| `container_preview`    | Container Preview    | Inventory  |
| `drop_stack`           | Drop Whole Stack     | Inventory  |
| `durability_warning`   | Durability Warning   | Inventory  |
| `hotbar_keys`          | Hotbar Key Labels    | Inventory  |
| `hotbar_links`         | Hotbar Links         | Inventory  |
| `hotbar_scrolling`     | Hotbar Scrolling     | Inventory  |
| `inventory_animation`  | Open Animation       | Inventory  |
| `inventory_colors`     | Inventory Colors     | Inventory  |
| `inventory_locks`      | Inventory Locks      | Inventory  |
| `inventory_search`     | Inventory Search     | Inventory  |
| `inventory_size`       | Inventory Size       | Inventory  |
| `item_durability`      | Durability Text      | Inventory  |
| `item_info`            | Item Info            | Inventory  |
| `keep_cursor`          | Keep Cursor Position | Inventory  |
| `new_item_marks`       | New Item Marks       | Inventory  |
| `rarity_background`    | Rarity Background    | Inventory  |
| `shiny_potions`        | Shiny Potions        | Inventory  |
| `storage_fill`         | Storage Fill         | Inventory  |
| `tooltip_lines`        | Extra Tooltip Lines  | Inventory  |
| `tooltip_scroll`       | Scrollable Tooltips  | Inventory  |
| `tooltip_size`         | Tooltip Size         | Inventory  |
| `cinema_bars`          | Cinema Bars          | Zoom       |
