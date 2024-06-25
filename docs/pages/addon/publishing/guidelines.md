???+ warning "Important Note"

    If you need to "break" one (or more) of the following guidelines, you are required to explain this in form of 
    JavaDocs at this location of your source. This allows us to decide if we deem it necessary or not.

Before you can submit an addon to our addon store, make sure you are following these guidelines:

1. Addons cannot impact the game experience negatively, this includes performance.
    1. Don't create objects every tick or frame if you can cache them.
    2. Do not consume commands without providing a response.
2. Respect the privacy of your users.
    1. Do not use the player's session identifier maliciously.
    2. If creating a connection to a private server, do not store or send any information that is not specifically
       required.
3. Only access the users' file system if necessary.
4. Allow the user & servers to completely disable your addon at any time (
   see <a href="/pages/addon/features/config/#create-a-basic-configuration" target="_blank">Create a Basic
   Configuration</a>).
5. Make sure your addon is compatible and remains so for the foreseeable future.
    1. Do not use deprecated methods and/or classes that already have a replacement.
    2. Do not use Reflection in any way. If you want to get access to a field or method that is private or protected,
       use mixin or an accesswidener.
    3. Do not try to modify the LabyMod source in any way. If you are missing a sub-feature of one of our official
       features, suggest it <a href="https://www.labymod.net/ideas#category=client" target="_blank">here</a>.
    4. If you're injecting code via mixin, don't overdo it. Replacing a method in its entirety can cause
       incompatibilities.
    5. Do not access LabyMod core packages, as using them may break your addon at any time. If you need access to
       LabyMod internal methods, let us know <a href="https://labymod.net/dc/dev" target="_blank">on our development
       Discord</a>.
    6. Do not use legacy color codes
6. You need to use our <a href="/pages/addon/features/internationalization/" target="_blank">Internationalization
   system</a> for every text the user sees.
    1. Excluded from this are strings that are the same for every language (like for example the prefix of commands).
    2. You are allowed to write f.e. German strings in the `en_us.json`, if there is no reason for international players
       to use your addon. For example a server addon for a server that is region locked or has no international players.
       This has to be clarified in the addon description.