On this page, we're explaining what exactly you have to do to publish your addon. 

## Version Compatibility

We're using version ranges to verify the compatibility of an addon with LabyMod 4 and the Minecraft version the user is playing with. 

### The Star

The version `*` indicates compatibility with all versions (even unreleased ones). Don't use this unless you're only using version-independent things from the official LabyMod 4 Addon API. 

### Single Version 

Version `1.8.9` indicates compatibility with just Minecraft 1.8.9 and thus no other Minecraft version except Minecraft 1.8.9 will be supported. 

### Version Range

A version range is a range of versions supported. Contains <a href="#the-star">The Star</a> and <a href="#single-version">Single Version</a>. <br>
A few examples: 

+ `1.17<1.19.2` - every version between 1.17.0 and 1.19.2 is supported - Everything below 1.17.0 (for example 1.16.5) or higher than 1.19.2 (for example 1.19.3) isn't.
+ `1.18.2<*` - every version after (and including) Minecraft 1.18.2 is supported. Every version below 1.18.2 isn't supported.

### Multi Version Range

A multi-version range is a combination of <a href="#version-range">Version Ranges</a> and <a href="#single-version">Single Versions</a>. This is mostly used to guarantee a good experience when supporting multiple versions that have one or more major releases in between.
Example: <br>
`1.8.9,1.12.2,1.16.5<1.19.2` - this supports Minecraft 1.8.9, 1.12.2 and everything in between (and including) 1.16.5 and 1.19.2. Minecraft 1.19-1.12.1, 1.13-1.16.4 and everything higher than (and including) 1.19.3 would not be supported.