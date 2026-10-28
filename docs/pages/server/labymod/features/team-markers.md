Team markers draw an arrow above every teammate, visible through walls. A HUD widget points to teammates out of view.
That's an advantage in PvP, so the Laby Client keeps them off on every server until the server sends the
`team_marker` permission. In singleplayer they always work.

## Allowing Team Markers

Send the `team_marker` permission with the [PermissionPacket](../moderation/permissions.md). The `Permission` class has
no constant for it, so create it with `Permission.of(String)`.

You can send the packet through the player's `LabyModPlayer` object or directly through the `LabyModProtocol`.

???+ note "Note"
    The Laby Client resets permissions when a player switches servers or leaves. Send the permission again every time
    a player joins.

### Via LabyModPlayer

```java
// Get the LabyModPlayer
LabyModPlayer labyModPlayer = LabyModProtocolService.get().getPlayer(uniqueId);

// Allow team markers
labyModPlayer.sendPermissions(Permission.of("team_marker").allow());
```

### Via the LabyModProtocol

```java
// Get the LabyModProtocol
LabyModProtocol labyModProtocol = LabyModProtocolService.get().labyModProtocol();

// Allow team markers
labyModProtocol.sendPacket(uniqueId, new PermissionPacket(Permission.of("team_marker").allow()));
```

Send `Permission.of("team_marker").deny()` to turn them off again.

The permission doesn't turn team markers on. Players still switch them on in their own settings.

## How Teammates Are Found

The Laby Client reads teammates from the scoreboard teams your server already sends. A player's team counts if:

- it has 2 to 16 members, the player included, and players can raise that limit to 64
- at least one player outside of it is not a spectator

The second rule skips lobbies that put everyone into one team, which servers often do to turn off collisions.

Spectators, dead players and NPCs never get a marker. Neither do members of a team whose name tag visibility is
`never` or `hideForOwnTeam`. If the team has a color, the marker uses it.

Players can also switch on detection by name color. It marks everyone whose name has the same color as their own.

## Apollo

If your server uses Apollo, its team module works too. Sending `UpdateTeamMembers` allows team markers, so you don't
need to send the permission. The Laby Client then marks exactly the players you listed and stops guessing from
scoreboard teams. It uses the colors you sent unless the player turned team colors off. `ResetTeamMembers` takes the
permission away again. The Apollo mod restriction `team-view` turns team markers off.
