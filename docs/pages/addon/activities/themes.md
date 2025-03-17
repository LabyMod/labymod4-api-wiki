One of the key advantages of our Activity System with LSS over OpenGL is that you can easily theme your Activities with
LSS.
With OpenGL you'd have to rewrite the screen for every theme you want to support.
With LSS, just like with CSS, you can just have an LSS StyleSheet for each theme.
You can also create your own theme. All that is explained on this page.

???+ warning "Important Note"
Creating own themes doesn't work as of now. But we're working on it!

## How Themes Work

There are two types of themes:

- Root themes
- Extending themes

### Root themes

Root themes have no parent, everything that is not implemented is not there. This means that in this type of theme
everything needs to be implemented. Usually this is just the vanilla theme as this is maintained by LabyMod and
implemented
by every addon using the Activity System.

### Extending themes

Extending themes are themes based off of another theme, for example the LabyMod fancy theme extends the vanilla theme.
Everything that is not implemented will be inherited from its parent theme. When creating your own theme, you may want
to extend the vanilla theme, or you can also extend any other extending theme like the fancy theme.

If a resource (e.g. an LSS file, an image) or any kind of renderer is not found in an extending theme, it is
simply taken from its parent.

## Theme files

Besides any other file in your `assets/<my namespace>` folder there are also theme files located
in `assets/<my namespace>/themes/<theme>` with the following structure:

![Theme-File-Tree](/assets/files/screenshots/theme-file-structure.png)

Usually you don't need to access these files directly because LabyMod handles it for stuff like LSS stylesheets,
icons in the settings and hud widgets. If you still need to access a ThemeFile, it works like this:

```java
public ResourceLocation getThemeResource() {
    Theme theme = Laby.references().themeService().currentTheme();
    return theme.resource("my namespace", "textures/my-image.png");
}
```

## Implement an existing theme in your addon

Coming from [Understand LSS](/pages/addon/activities/lss) you already know how to create LSS stylesheets for the
vanilla theme by putting them in `assets/example/themes/vanilla/lss/`. When implementing the fancy theme, you now want
to put your new LSS stylesheets in `assets/example/themes/fancy/lss/` and name them exactly the same.

Having done this, LabyMod will now select the LSS stylesheets from the fancy theme. If a stylesheet doesn't exist in
the fancy theme, LabyMod will fall back to the stylesheet from the vanilla theme. The behavior is exactly the same for
textures, you may have defined your textures for your settings in `assets/example/themes/vanilla/textures/settings.png`,
now you can create a file with the same name in the directory for the fancy theme and LabyMod will find it
automatically.

### Theme your activity

todo: add an example Activity
