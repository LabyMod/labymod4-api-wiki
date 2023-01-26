All internationalization files have to be located in the module called `core` and then down the folder structure `src/main/resources/assets/NAMESPACE/i18n/` ("NAMESPACE" should be replaced with the namespace you set in your `build.gradle.kts`). The default file for internationalization is called `en_us.json`, as English is the default language. 

## Create Custom Translations

You can do more than internationalize your settings. You also have the option to internationalize every other text that the user sees. Any time a `Component` is used, you have the option to just set a raw String via `Component.text`. Still, you also have the option to use your custom translations by using `Component.translatable`. Do you have arguments that need to be replaced? Not a problem! We replace arguments that are indicated with `%s` on every translation. 

So, for example instead of using a non-translated String like `"The Addon has a rating of " + rating + " Stars!"`, you could put a String like `"The Addon has a rating of %s Stars!"` in your internationalization file and create the Component with `Component.translatable("example.commands.info.rating", rating)` and the output would be the same. The only difference is that your Addon can be used in many different languages without hard-coding every String.

There are two possibilities to get the translated String if you don't want to use Components.
If you want a String that cannot be null, you call `I18n.translate` with the translation key and the arguments. 
The method will return the key if the translation key cannot be found in any internationalization file.
Now, if you want to check if the translation key can be found easily, you call `I18n.getTranslation` with the translation key and possibly arguments. 
The method will return `null` if the key cannot be found.

As already mentioned, you can internationalize every text the user can see, even the widgets of our Activity system that display text. A list of all widgets delivered with our Addon API can be found <a href="/pages/addon/activities/widgets/#all-widgets">here</a>. 

## Support Multiple Languages

The language in LabyMod and thus the preferred internationalization file of every Addon will change when switching the language in Minecraft itself. The fallback language always stays `en_us`. That means if, for example, a user selected German as the language in which Minecraft is displayed, we will search for a file called `de_de.json` in your Addon. If that file isn't found, we will use the default file and thus the English translations.

All official supported languages can be found in 
<a href="https://minecraft.fandom.com/wiki/Language#Languages" target="_blank">this Minecraft Fandom Wiki article</a>.
The relevant part of this chart is the In-game Locale Code. Your file has to have the same locale code. Otherwise, we can't identify your file as a match to the intended language.