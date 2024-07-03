The `PermissionPacket` is a client-bound packet that allows servers to deactivate and/or activate certain features for
their LabyMod players.

## What permissions are available?

All permissions available in LabyMod 4 itself can be found as constants in the `Permission` class, integrations may also
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
