The `game-runner` module has one source set per Minecraft version (`src/v1_16_5`, `src/v1_21_5`, ...). Most of
that code is the same in every version, apart from a few renamed classes or methods. Instead of copying it into
every source set, you can write it once in the `shared` source set.

LabyGradle compiles the shared code once against the Minecraft union. That is a jar with every class and member of
all versions your addon registers, under their newest Mojang names. It then compiles the same files again inside every
version, rewritten to that version's names. If you use something a version doesn't have, the build tells you which
version lacks it.

!!! danger "Experimental"

    The shared source set is experimental. Its annotations, tasks and file layout may change drastically in future
    LabyGradle versions, and you may have to adapt your shared code when you update. Keep that in mind before you
    move a lot of code into it.

???+ warning "Important Note"

    Shared code needs LabyGradle 0.11.0 or newer. It only covers versions with Mojang names, which are 1.16.5 and
    newer. Code for 1.8.9 and 1.12.2 stays in their own source sets.

## Set Up the Shared Source Set

1. Make sure `defaultPackageName` is set in the `labyMod` block of your `build.gradle.kts`. We use `org.example` on
   this page.
2. Create the folder `game-runner/src/shared/java/org/example/shared`.
3. Reload the Gradle project.

The `shared` source set only exists while `src/shared/java` does. Your IDE now shows it next to the version source
sets, and it can see the Minecraft classes of the union.

## How It Compiles

| Task | What happens |
|---|---|
| `generateMinecraftUnion` | Builds the union in `build/minecraft-union/` of the root project: `minecraft-union.jar`, the mappings of every version and `review.txt` |
| `:game-runner:compileSharedJava` | Compiles `src/shared/java` against the union jar and checks every Minecraft class, method and field you use against the versions that have it. Afterwards it updates the locks in `game-runner/mappings/minecraft-union-lock/` |
| `:game-runner:compileV1_21_5Java` | Compiles the shared files again next to the version's own files, with the names of 1.21.5. Version checks become `true` or `false` and code for other versions is removed |

The shared classes move into the package of each version: `org.example.shared.chat.ChatExecutor` ships as
`org.example.v1_21_5.chat.ChatExecutor` in 1.21.5. Version code keeps importing the class from its own package.

!!! danger
    Never keep a copy of a shared class in a version source set. Both end up with the same name, and the compile
    fails.

Since every version compiles the shared classes like its own, annotations such as `@Implements` and `@Singleton`
work as usual. Each version gets its own implementation in its reference storage.

## Write Shared Code

- Put the files in `game-runner/src/shared/java/org/example/shared/...`, with the package `org.example.shared...`.
- Write the newest Mojang names. Older versions that use another name need nothing from you.
- Import one class per line. A star import of a Minecraft package fails, because classes move between packages.
- Don't use unicode escapes in names or Mixin strings.

### Example: One Chat Executor for All Versions

On the page [Write Version Dependent Code](version-dependent.md) we implemented `ExampleChatExecutor` in a single
version. In the shared source set, one class covers every version from 1.16.5 on. Two things differ between the
versions:

- Creating a text component. `Component.literal` was added in 1.19. Older versions create a `TextComponent`.
- Adding a message to the chat. 26.1 renamed `addMessage` to `addClientSystemMessage`, and 26.3 moved the chat to
  `gui.hud`.

=== ":octicons-file-code-16: org.example.shared.VersionedExampleChatExecutor"
    ```java
    package org.example.shared;

    import javax.inject.Singleton;
    import net.labymod.api.Laby;
    import net.labymod.api.client.render.font.ComponentMapper;
    import net.labymod.api.models.Implements;
    import net.labymod.target.MinecraftTarget;
    import net.minecraft.client.Minecraft;
    import net.minecraft.network.chat.Component;
    import net.minecraft.network.chat.TextComponent;
    import org.example.core.ExampleChatExecutor;

    @Singleton
    @Implements(ExampleChatExecutor.class)
    public class VersionedExampleChatExecutor implements ExampleChatExecutor {

      @Override
      public void displayMessageInChat(String message) {
        Component component = MinecraftTarget.V1_19_4.orNewer()
            ? Component.literal(message)
            : new TextComponent(message);
        this.addMessageToChat(component);
      }

      @Override
      public void displayMessageInChat(net.labymod.api.client.component.Component labyComponent) {
        ComponentMapper componentMapper = Laby.labyAPI().minecraft().componentMapper();
        this.addMessageToChat((Component) componentMapper.toMinecraftComponent(labyComponent));
      }

      private void addMessageToChat(Component component) {
        if (MinecraftTarget.V26_3.orNewer()) {
          Minecraft.getInstance().gui.hud.getChat().addClientSystemMessage(component);
        } else if (MinecraftTarget.V26_1.orNewer()) {
          Minecraft.getInstance().gui.getChat().addClientSystemMessage(component);
        } else {
          Minecraft.getInstance().gui.getChat().addMessage(component);
        }
      }
    }
    ```

Delete the copies in the version source sets once the shared class exists. 1.8.9 and 1.12.2 keep theirs.

## Version Differences

`MinecraftTarget`, `@RequiresTarget`, `@AnnotationRequiresTarget` and `@ProvidedByVersion` are generated into the
union jar, in the package `net.labymod.target`. `MinecraftTarget` has one constant per registered version, so `V1_19_4` only exists if your
addon registers 1.19.4. Pre-releases and snapshots count as the version they lead to: `26.4-snapshot-4` is `V26_4`.

LabyGradle resolves every check at compile time. Each version only keeps the code for itself, so there is no runtime cost.

### Check the Version in Code

```java
if (MinecraftTarget.V1_21_5.orNewer()) {
  // 1.21.5 and newer
} else {
  // older versions
}

boolean newChat = MinecraftTarget.V1_19_4.orNewer() ? newCall() : oldCall();

if (MinecraftTarget.isBetween(MinecraftTarget.V1_17_1, MinecraftTarget.V1_20_6)) {
  // 1.17.1 up to and including 1.20.6
}

if (!MinecraftTarget.V1_19_4.orNewer()) {
  return; // the rest of the method only runs from 1.19.4 on
}
```

`orNewer()`, `orOlder()` and `isCurrent()` are available on every constant. `!`, `&&`, `||`, `else if` chains and an
early `return` or `throw` narrow the versions too. A check only narrows the versions where it is written in the
condition itself. Stored in a variable or passed to a method, it still becomes `true` or `false`, but the code behind
it counts as running on every version. Any other use of a `MinecraftTarget` constant is an error.

If you use something outside of a matching check, the shared compile fails with a message like:

```
Component.literal(String) exists from 1.19.4, but this code also runs on 1.16.5 to 1.18.2
```

The message can also read `exists until ...` or `only in ...`.

Fix it with a check. Don't fall back to reflection.

### Limit a Declaration to Some Versions

`@RequiresTarget` limits a class, method, constructor or field to a range of versions. Both bounds are inclusive.
The versions outside of the range don't get the declaration at all, so everything that uses it must be limited to
the same range.

```java
@RequiresTarget(since = MinecraftTarget.V1_21_5)
public void onlyInNewVersions() { ... }

@RequiresTarget(until = MinecraftTarget.V1_16_5)
private int legacyField;
```

### One Declaration per Version Range

A method, constructor or field that differs per version can be written once per range, with the same name and
signature. This is most useful for mixins that hook another method from some version on:

```java
@RequiresTarget(until = MinecraftTarget.V1_21_11)
@Inject(method = "runTick", at = @At("HEAD"))
private void example$tick(CallbackInfo ci) { ... }

@RequiresTarget(since = MinecraftTarget.V26_1)
@Inject(method = "renderFrame", at = @At("HEAD"))
private void example$tick(CallbackInfo ci) { ... }
```

The ranges must not overlap. The shared compile checks calls against the first declaration, each version against
its own. If the declarations return different types, a call has to compile with the type of the first one.

### Annotations Only Some Versions Have

If an annotation only fits some versions, add `@AnnotationRequiresTarget` next to it with the same bounds as
`@RequiresTarget`. Versions outside of the range drop the annotation.

```java
@Implements(ExampleFeature.class)
@AnnotationRequiresTarget(value = Implements.class, since = MinecraftTarget.V1_20_1)
public class VersionedExampleFeature implements ExampleFeature { ... }
```

A different superclass, other interfaces or a record in some versions can't be expressed this way. Keep such a class
in the version source sets.

### Same Name, Different Behavior

A method can exist in every version and still do something else in some of them. For example, `PrimedTnt.getFuse()`
returns the fuse at spawn time in 1.16.5, while it returns the current countdown from 1.17.1 on. The union only
compares names and signatures, so it can't see this. If the behavior matters, compare the method in the versions
you support and add a check.

### Wrong or Missing Renames

The union decides which elements of two versions are the same, even if they were renamed. It lists the links it wasn't sure
about in `build/minecraft-union/review.txt` of the root project. Elements without any counterpart aren't listed
there. If it linked two elements that don't belong together, or
missed a rename, add a hint to `game-runner/mappings/minecraft-union-hints.txt`. The header of `review.txt` shows
the format. Then run `./gradlew generateMinecraftUnion` again.

## Mixins

Shared mixins go into `org/example/shared/mixins` and end up in `org/example/{version}/mixins` of every version,
where Laby Client finds them as usual.

=== ":octicons-file-code-16: org.example.shared.mixins.MixinMinecraft"
    ```java
    @Mixin(Minecraft.class)
    public class MixinMinecraft {

      @Unique
      private int example$tickCount = 0;

      @Inject(method = "tick", at = @At("HEAD"))
      private void example$onTick(CallbackInfo ci) {
        System.out.println("[Mixin] Tick log " + this.example$tickCount++);
      }
    }
    ```

In addition to the usual mixin rules:

- Targets, `method` selectors, `@At(target = ...)`, `@Definition` and `@Accessor`/`@Invoker` values must be string
  literals with union names, including descriptors. The build rewrites them for every version.
- `@At(target = ...)` needs the owner: `Lnet/minecraft/client/Minecraft;tick()V`.
- A `@Shadow` member with a prefix follows the name after the prefix, so `shadow$getFuse` shadows `getFuse`.
- Shadows and overrides of something only some versions have need `@RequiresTarget`.

## Access Wideners

The union has the widest access of each element over all versions. Where a version is narrower, the build adds an
access widener entry for that version on its own.

If something is private in every version, write a union access widener in
`game-runner/src/shared/resources/META-INF/<namespace>/accesswidener/union/`. `<namespace>` is your addon's
namespace. The file uses the header `accessWidener v1 union` and union names:

=== ":octicons-file-code-16: example.accesswidener"
    ```
    accessWidener v1 union

    accessible field net/minecraft/world/inventory/Slot slot I
    ```

It applies to every version. The build ships it, in each version's names, together with the version's own access
wideners.

## Classes That Only Exist per Version

The shared compile can't see your version source sets. If shared code needs a class that each version has on its
own, you have two options:

1. Move that class to the shared source set first. This is the preferred way.
2. Declare what you use of it with `@ProvidedByVersion`, at the same path below `org.example.shared`. The version
   compiles drop the declaration, so the uses reach the version's real class.

=== ":octicons-file-code-16: org.example.shared.util.VersionedItemUtil"
    ```java
    @ProvidedByVersion
    public final class VersionedItemUtil {

      public static ItemStack toLabyStack(net.minecraft.world.item.ItemStack itemStack) {
        throw new UnsupportedOperationException();
      }
    }
    ```

Method bodies stay empty or a single `throw`. Fields only get literals. A version that has no such class fails to
compile. If only some versions have it, add `@RequiresTarget` to the declaration.

## Add a New Minecraft Version

The union uses the newest Mojang names. A new version can rename something your shared code uses. The locks in
`game-runner/mappings/minecraft-union-lock/` remember the names your code is written against. There is one lock per
shared source file that uses Minecraft names and one per union access widener. As long as they differ from the union, the build stops before `compileSharedJava` and asks you to
run `migrateSharedSources`.

1. Add the version to `net.labymod.minecraft-versions` in your `gradle.properties` and reload the Gradle project.
2. Run `./gradlew :game-runner:migrateSharedSources`. It rewrites your shared sources, mixin strings, union access
   wideners and locks to the new names.
3. Read `game-runner/build/minecraft-union/migration/report.txt`. Renames are already done. Everything the report
   lists as missing in the new version needs a check or `@RequiresTarget` from you. A rename the union didn't detect
   shows up as missing too, see [Wrong or Missing Renames](#wrong-or-missing-renames).
4. Build your addon.

!!! warning
    Commit the files in `game-runner/mappings/minecraft-union-lock/` together with your shared sources. Without
    them, the next version can't be migrated.

## Verify Your Code

1. Run `./gradlew :game-runner:compileSharedJava`, then the version compiles, e.g.
   `./gradlew :game-runner:compileV1_16_5Java :game-runner:compileV26_3Java`. Before you release, build all
   versions.
2. If you're unsure whether a check works, look at the compiled class of a version, e.g. with
   `javap -c -p -cp game-runner/build/classes/java/v1_16_5 org.example.v1_16_5.VersionedExampleChatExecutor`. It
   must only use the names of that version and nothing from `org.example.shared` or `net.labymod.target`.
3. Start the game in the oldest and the newest version you support.

Line numbers in stack traces match the shared file. The class name in a stack trace is the one of the version,
e.g. `org.example.v1_21_5.VersionedExampleChatExecutor`.

## Troubleshooting

| Message | Solution |
|---|---|
| `Cannot query the value of extension 'labyMod' property 'defaultPackageName' ...` | Set `defaultPackageName` in your `build.gradle.kts` |
| `... is not compiled into any version` | A warning, the build goes on without the shared code. No version 1.16.5 or newer is registered, or the root project doesn't apply the LabyGradle plugin |
| `... exists from 1.19.4, but this code also runs on 1.16.5 to 1.18.2` | Add a check, see [Version Differences](#version-differences) |
| `Import the classes of ... one by one` | Replace the star import with one import per class |
| `MinecraftTarget can only be used as ...` | Use the constant only in a check or in `@RequiresTarget` |
| `Cannot resolve "...", a target needs its owner` | Write the owner into `@At(target = ...)`, e.g. `Lnet/minecraft/client/Minecraft;tick()V` |
| `... is @ProvidedByVersion, but 1.16.5 has no ...` | Add the class to that version, or limit the declaration with `@RequiresTarget` |
| `... is declared more than once for ...` | The ranges of two declarations with the same signature overlap |
| `Run migrateSharedSources` | The union names changed, see [Add a New Minecraft Version](#add-a-new-minecraft-version) |
