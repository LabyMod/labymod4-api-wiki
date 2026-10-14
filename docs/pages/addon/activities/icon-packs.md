# Icon packs

Since Laby Client 47, every icon in the Laby Client interface is its own PNG or SVG file. The old sprite sheets are
gone. Laby Client stitches the files into a texture atlas at runtime, and an icon pack is a folder of files that
replaces some or all of them. Players pick an icon pack in the theme settings. Resource packs and addons can both
ship one.

## How an icon is found

Every icon has a sprite id made of a namespace and a path, for example `labymod:common/gear`. The path is the file path
below the source folder, without the extension. Laby Client checks these folders in order and takes the first file it
finds:

| Order | Folder                                                    | Contains                                      |
|-------|-----------------------------------------------------------|-----------------------------------------------|
| 1     | `assets/<namespace>/icon_packs/<selected pack>/`          | The icon pack the player selected             |
| 2     | `assets/<namespace>/themes/<theme>/textures/gui/`         | The active theme, then each of its parents    |
| 3     | `assets/<namespace>/icon_packs/default/`                  | The default icons, used by every theme        |

Take `labymod:common/gear`. If the player selected a pack with the id `outline`, Laby Client reads
`assets/labymod/icon_packs/outline/common/gear.svg`. If not, and the fancy theme has its own gear, it reads
`assets/labymod/themes/fancy/textures/gui/common/gear.png`. Otherwise it falls back to
`assets/labymod/icon_packs/default/common/gear.png`.

Two more rules apply when one folder has more than one candidate:

- If a folder holds both `gear.png` and `gear.svg`, the SVG wins.
- If several packs provide the same file, the pack with the higher priority wins. A resource pack the player enabled
  always beats an addon and Laby Client itself.

An icon pack doesn't have to cover every icon. Anything it leaves out comes from the theme, then from the default
icons.

???+ tip "Hot reload"
    When you run your addon from the IDE, Laby Client rebuilds the atlas each time you save an icon file. You can
    edit icons with the game still running.

## Icons for your addon

Put your icons into the default icon pack of your own namespace. If your namespace is `example`, the file
`assets/example/icon_packs/default/common/heart.png` becomes the sprite `example:common/heart`.

```
src/main/resources/assets/example/
└── icon_packs/
    └── default/
        ├── common/
        │   └── heart.png
        └── mods/
            └── features/
                ├── example.png
                └── example_configuration/
                    └── enabled.png
```

### Using an icon in code

`Icon.lazyThemeGuiSprite` creates an icon from a sprite id. It's safe to keep in a constant, because the icon looks up
its sprite every time it's drawn. Theme changes, icon pack changes and resource reloads don't break it. While no folder
has the sprite, it draws nothing. This is the method you want in almost every case.

```java
public final class ExampleIcons {

  public static final Icon HEART = Icon.lazyThemeGuiSprite(
      ResourceLocation.create("example", "common/heart")
  );

  private ExampleIcons() {
  }
}
```

Use `Icon.themeGuiSprite` when you need to know whether the sprite exists right now. It returns `null` if neither the
selected pack, the theme nor the default icons have it. Call it only after the game has finished loading, since Laby
Client builds the atlas after it enables addons.

```java
Icon heart = Icon.themeGuiSprite(ResourceLocation.create("example", "common/heart"));
if (heart == null) {
  heart = Icon.texture(ResourceLocation.create("example", "textures/heart_fallback.png"));
}
```

### Icons for settings and HUD widgets

Settings and [HUD widgets](../features/hud-widgets.md) take their icons from `mods/features/` with no code at all. The
file names are the class and field names in snake case.

| Element                  | Sprite path                                    | Example                                          |
|--------------------------|------------------------------------------------|--------------------------------------------------|
| HUD widget               | `mods/features/<widget id>`                    | widget id `example` → `mods/features/example.png` |
| Setting in a config      | `mods/features/<config class>/<field name>`    | field `enabled` in `ExampleConfiguration` → `mods/features/example_configuration/enabled.png` |

Laby Client strips a leading `Default` and a trailing `Config` from the config class name, then a trailing
`HudWidget`. So the setting `showIcon` in `ExampleHudWidgetConfig` looks for `mods/features/example/show_icon.png`.
Characters that resource paths don't allow turn into `_`.

If the file exists, it wins over an icon set with `@SpriteSlot` or `setIcon`. If it doesn't, Laby Client keeps using
the old icon, so existing addons don't lose theirs.

### Icons for one theme only

To give a theme its own version of an icon, put a file with the same path into that theme's `textures/gui` folder.
`assets/example/themes/fancy/textures/gui/common/heart.png` replaces `example:common/heart` while the fancy theme is
active. A selected icon pack still wins over it.

## Creating an icon pack

An icon pack is a folder below `icon_packs/` with a `pack.json` in it. The folder name is the pack's id. The folder
can live in a resource pack or in an addon.

```
assets/labymod/icon_packs/outline/
├── pack.json
└── common/
    ├── gear.svg
    └── back.svg
```

```json
{
  "name": "Outline",
  "themes": ["fancy"]
}
```

| Field    | Description                                                                                       |
|----------|---------------------------------------------------------------------------------------------------|
| `name`   | The name shown in the theme settings. Defaults to the id.                                         |
| `themes` | The ids of the themes the pack is made for. Leave it out to offer the pack for every theme.       |

You can't use the id `default`. Laby Client reserves it for the default icons, and players can't select it.

The Laby Client jar has every default icon under `assets/labymod/icon_packs/default/`. Copy the path of the icon you
want to replace into your pack. `icon_packs/<your id>/common/gear.png` replaces `icon_packs/default/common/gear.png`.

### Covering several namespaces

One pack can replace Laby Client icons and addon icons at the same time. Use the same id in every namespace. Only one
of them needs a `pack.json`.

```
assets/
├── labymod/icon_packs/outline/
│   ├── pack.json
│   └── common/gear.svg
└── example/icon_packs/outline/
    └── common/heart.svg
```

If several packs ship a `pack.json` for the same id, Laby Client takes the name and themes from the pack with the
highest priority. It still uses the icon files of all of them, ordered by priority.

### Selecting a pack

Players choose the pack in the **Icon Pack** dropdown below the theme picker. The dropdown lists **Default** and every
pack made for the current theme. Each theme remembers its own choice.

Laby Client looks for new packs after every resource reload. A resource pack with an icon pack shows up in the
dropdown as soon as the player enables it.

## File formats

### PNG

Laby Client draws PNG icons with nearest filtering by default, which keeps pixel art sharp. For smooth, high
resolution icons, switch to linear filtering with a sidecar file.

### SVG

Laby Client rasterizes SVG icons at the current GUI scale and again whenever the scale changes, so they never blur.
The `width` and `height` of the `<svg>` element set the icon's size in GUI units. SVG icons always use linear
filtering. For new icons, SVG is the better choice.

```xml
<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24">
  <g fill="none" stroke="#fff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
    <circle cx="12" cy="12" r="9"/>
  </g>
</svg>
```

Laby Client supports static SVG with `path`, `rect`, `circle`, `ellipse`, `line`, `polyline`, `polygon`, groups, `use`
and `symbol`, transforms, linear and radial gradients, clip paths and `<style>` sheets. Text, embedded images, filters,
masks and animations don't work. A file can be up to 4 MB, and Laby Client rasterizes it at no more than 2048 pixels
per side.

???+ tip "Match the existing icons"
    Laby Client's own SVG icons are white line icons, 16 × 16 units, with a stroke and no fill. Draw yours the same
    way and they won't stand out next to the built-in ones.

### Sidecar metadata

Any icon can have a `.lmeta.json` file next to it, named after the icon's full file name, for example
`gear.png.lmeta.json` or `gear.svg.lmeta.json`. Every field is optional.

```json
{
  "filter": "linear",
  "padding": 2,
  "scaling": {
    "type": "nine_slice",
    "width": 11,
    "height": 11,
    "border": { "left": 5, "top": 5, "right": 5, "bottom": 5 },
    "stretch_inner": true
  }
}
```

| Field       | Description                                                                                                   |
|-------------|---------------------------------------------------------------------------------------------------------------|
| `filter`    | `nearest` (default) or `linear`.                                                                              |
| `padding`   | Gutter around the sprite in the atlas. Raise it if neighbouring sprites bleed into yours.                     |
| `scaling`   | How the sprite stretches. One of `stretch` (default), `tile` or `nine_slice`. `border` takes one number for all sides or an object as above. |
| `animation` | Frames stacked in one image, with `frame_width`, `frame_height`, `direction` (`vertical` or `horizontal`), `frametime` in ticks, `interpolate` and an optional `frames` list. |

An icon pack icon without a sidecar of its own keeps the sidecar of the icon it replaces. If the default icon is a
nine-slice, your replacement is a nine-slice too, until you give it its own sidecar.
