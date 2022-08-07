Here you can find some information about things that didn't fit anywhere else.

## Why Is the Naming on Some of Our Methods So Weird?

We've decided to change how we name our getters & setters. 
The "established" naming for getters would be `getSomething()`, but we've decided as an "internal naming convention" that getters that can't return `null` and return a type created by us don't have the `get` prefix but instead are just called by their name. 
So instead of for example `getMinecraft()` you'll only find `minecraft()`. 
Setters would normally have the prefix `set`. 
But if the setter is returning the same type of the class it is in; the `set` prefix will also be removed (this is most common in builders, so for example, in our renderers. instead of `setPos(x, y)`, you'll only find `pos(x, y)`).
