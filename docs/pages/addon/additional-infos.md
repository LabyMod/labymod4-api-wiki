# Additional Information

Here you can find some information about things that didn't really fit anywhere else.

## Why Is the Naming on Some of Our Methods So Weird?

We've decided to change how we name our getters. The "established" naming for getters would be `getSomething()` but we've decided as an "internal naming convention", that the getters of non-primitive data types don't have the "get" prefix but instead are just called by their name. So instead of for example `getPrefix()` you'll only find `prefix()`, as the returned type would be a String. In cases where a getter returns a primive data type, for example `getCount()`, which would return an int, the prefix stays.