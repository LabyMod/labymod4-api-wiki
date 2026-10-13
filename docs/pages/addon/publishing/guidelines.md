???+ warning "Important Note"

    If you need to "break" one (or more) of the following guidelines, you are required to explain this in form of 
    JavaDocs at this location of your source. This allows us to decide if we deem it necessary or not.

Before you can submit an addon to our addon store, make sure you are following these guidelines:

1. Addons cannot impact the game experience negatively, this includes performance.
    1. Don't create objects every tick or frame if you can cache them.
    2. Do not use `java.util.stream.Stream`. See [Why no streams?](#why-no-streams)
    3. Do not consume commands without providing a response.
2. Respect the privacy of your users.
    1. Do not use the player's session identifier maliciously.
    2. If creating a connection to a private server, do not store or send any information that is not specifically required.
    3. Do not send any information to external services/servers that could uniquely identify the player unless the player has explicitly consented or it is essential for a function of the addon.
3. Only access the users' file system if necessary.
4. Allow the user & servers to completely disable your addon at any time (see <a href="/pages/addon/features/config/#create-a-basic-configuration" target="_blank">Create a Basic Configuration</a>).
5. Make sure your addon is compatible and remains so for the foreseeable future.
    1. Do not use deprecated methods and/or classes that already have a replacement.
    2. Do not use Reflection in any way. If you want to get access to a field or method that is private or protected, use mixin or an accesswidener.
    3. Do not try to modify the LabyMod source in any way. If you are missing a sub-feature of one of our official features, suggest it <a href="https://www.labymod.net/ideas#category=client" target="_blank">here</a>.
    4. If you're injecting code via mixin, don't overdo it. Replacing a method in its entirety can cause incompatibilities.
    5. Do not access LabyMod core packages, as using them may break your addon at any time. If you need access to LabyMod internal methods, let us know <a href="https://labymod.net/dc/dev" target="_blank">on our development Discord</a>.
    6. Do not use legacy color codes
    7. Do not use System.out.println or similar methods.
6. You need to use our <a href="/pages/addon/features/internationalization/" target="_blank">Internationalization system</a> for every text the user sees.
    1. Excluded from this are strings that are the same for every language (like for example the prefix of commands).
    2. You are allowed to write f.e. German strings in the `en_us.json`, if there is no reason for international players to use your addon. For example a server addon for a server that is region locked or has no international players. This has to be clarified in the addon description.
7. Build & CI requirements.
    1. Your GitHub workflow must match the one from our <a href="https://github.com/LabyMod/addon-template" target="_blank">addon-template</a>. Addons with a diverging workflow will not be accepted.
    2. `gradle/wrapper/gradle-wrapper.properties` must contain a `distributionSha256Sum` entry. This verifies the integrity of the downloaded Gradle distribution. Add a line like:
        ```properties
        distributionSha256Sum=<sha256 of the distribution zip>
        ```
        The matching checksum for your `distributionUrl` can be found on the <a href="https://gradle.org/release-checksums/" target="_blank">Gradle release checksums page</a> (use the "Binary-only (-bin) ZIP Checksum"). You can also copy the full `gradle-wrapper.properties` from our <a href="https://github.com/LabyMod/addon-template/blob/master/gradle/wrapper/gradle-wrapper.properties" target="_blank">addon-template</a>.

## Why no streams?

We know streams are nicer to read. They are also slower than a plain loop, and addon code often runs every tick or
every frame. LabyMod can run at 1000 to 2000 FPS, which gives the whole game a millisecond or less per frame. The rule
covers `IntStream`, `LongStream` and `DoubleStream` too.

**Allocations.** Every pipeline creates short-lived objects, such as the stream stages, a spliterator, capturing
lambdas, `Optional` results and collector internals. At 2000 FPS, one stream in a render method creates more than ten
thousand objects per second, and most addons don't stop at one. The garbage collector has to clean all of that up, and
players notice it as frame drops and stutters. The JIT only removes these allocations if it manages to inline the whole
pipeline, and often it doesn't.

**JIT optimization.** Minecraft, LabyMod and every installed addon share the same stream implementation. Its internal
call sites see dozens of different lambda types, so the JIT often gives up on inlining them. A loop puts your logic
directly into your method, so there is nothing left for the JIT to inline.

**Boxing.** `Stream<Integer>` and `Stream<Double>` wrap every value in an object. This is easy to miss in `map(...)`
and `reduce(...)`.

**Debugging.** An exception inside a stream produces a long stack trace full of JDK internals.

A stream that runs once when your addon enables won't hurt anyone. We still ban streams everywhere, because nobody can
reliably tell which code ends up in a hot path. Code that runs once today can end up in a tick handler next month. If
you have a good reason to use a stream anyway, explain it in a JavaDoc as described in the note at the top of this page.

### Examples

**Filtering a list**

=== ":octicons-x-16: Stream"
    ```java
    List<Waypoint> visible = waypoints.stream()
        .filter(Waypoint::isVisible)
        .collect(Collectors.toList());
    ```

=== ":octicons-check-16: Loop"
    ```java
    List<Waypoint> visible = new ArrayList<>();
    for (Waypoint waypoint : waypoints) {
        if (waypoint.isVisible()) {
            visible.add(waypoint);
        }
    }
    ```

If this runs every frame, keep the list as a field and call `clear()` instead of creating a new one each time.

**Checking if any element matches**

=== ":octicons-x-16: Stream"
    ```java
    boolean hasFriend = players.stream()
        .anyMatch(player -> friends.contains(player.getUniqueId()));
    ```

=== ":octicons-check-16: Loop"
    ```java
    boolean hasFriend = false;
    for (Player player : players) {
        if (friends.contains(player.getUniqueId())) {
            hasFriend = true;
            break;
        }
    }
    ```

**Summing values**

=== ":octicons-x-16: Stream"
    ```java
    // Boxes every count into an Integer
    int total = items.stream()
        .map(Item::getCount)
        .reduce(0, Integer::sum);
    ```

=== ":octicons-check-16: Loop"
    ```java
    int total = 0;
    for (Item item : items) {
        total += item.getCount();
    }
    ```

**Finding the closest element**

=== ":octicons-x-16: Stream"
    ```java
    Optional<Entity> closest = entities.stream()
        .min(Comparator.comparingDouble(entity -> entity.distanceTo(origin)));
    ```

=== ":octicons-check-16: Loop"
    ```java
    Entity closest = null;
    double closestDistance = Double.MAX_VALUE;
    for (Entity entity : entities) {
        double distance = entity.distanceTo(origin);
        if (distance < closestDistance) {
            closestDistance = distance;
            closest = entity;
        }
    }
    ```
