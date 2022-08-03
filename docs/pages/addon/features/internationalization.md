All internationalization files have to be located in the module called `core` and then down the folder structure `src/main/resources/assets/NAMESPACE/i18n/` ("NAMESPACE" should be replaced with the namespace you set in your `build.gradle.kts`). The default file for internationalization is called `en_us.json`, as English is the default language. 

## Create Custom Translations

You can do more than just internationalize your settings. You also have the option to internationalize every other text that the user sees. Any time a `Component` of the Adventure Library is used, you have the option to just set a raw String via `Component.text`, but you also have the option to use your custom translations by using `Component.translatable`. Do you have arguments that need to be replaced? Not a problem! We apply `String.format` on every translation, so you can just use a Format Specifier in your translation (more about String Formatting <a href="https://www.javatpoint.com/java-string-format" target="_blank">here</a>). 

So for example instead of using a non-translated String like `"The Addon has a rating of " + rating + " Stars!"`, you could put a String like `"The Addon has a rating of %d Stars!"` in your internationalization file and create the Component with `Component.translatable("example.commands.info.rating", rating)` and the output would be the same. The only difference: your Addon can be used in many different languages without having to hard code every string.

To get the raw translation string you have to get the class `Internationalization` via Guice. FURTHER EXPLAIN WHEN ALL GETTERS WERE RENAMED

As already mentioned, you can internationalize every text the user can see, even the widgets of our Activity system that display text. A list of all widgets delivered with our Addon API can be found <a href="#FINAL_LINK_HERE">here</a>. 

## Support Multiple Languages at Once

The language in LabyMod and thus the preferred internationalization file of every Addon will change when switching the language in Minecraft itself. The fallback language always stays `en_us`. That means if for example, a user selected German as the language in which Minecraft is displayed, we will search for a file called `de_de.json` in your addon. If that file won't be found, we will use the default file and thus the English translations.

All official supported languages can be found in 
<a href="https://minecraft.fandom.com/wiki/Language#Languages" target="_blank">this Minecraft Fandom Wiki article</a>.
The relevant part of this chart is the In-game Locale Code. Your file has to have the same locale code. Otherwise, we can't identify your file as a match to the intended language.