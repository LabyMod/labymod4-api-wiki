If you've worked with CSS before, LSS shouldn't be all too new, both share a similar basic syntax. We have implemented LSS as a system to conveniently design and theme responsive GUIs (Screens). No more OpenGL hustle, just Activities, Widgets and LSS. 

## LSS in a Nutshell

The main thing you need to know about LSS is, that while you add LSS StyleSheets to your Activity, you can't manipulate Activities directly, only the Widgets inside of that Activity. 
A list of all Widgets delivered with the API can be found <a href="#FINAL-LINK-HERE">here</a>.

CSS and LSS have a very similar syntax, but here are some of their differences:

 + CSS has classes, LSS has ids that can be added to Widgets directly in the Activities Java code.
 + In CSS you can just declare the type. You can do the same in LSS, there is one thing to keep in mind: if the name of a Widget ends with the suffix "Widget", the suffix gets removed (so for example `Component` instead of `ComponentWidget` or `Icon` instead of `IconWidget`).
 + LSS has no types like `p` for pixels, etc. LSS always works with relative pixels (1 = one pixel on GUI scale 1, four pixels on GUI scale 2 and 16 pixels on GUI scale 3)


## Creating Activities with LSS

