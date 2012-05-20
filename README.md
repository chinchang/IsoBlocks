IsoBlocks
=========

What is it?
-----------

IsoBlocks is an experimental library to create eye-candy isometric texts. It is written in **coffeescript**, uses **CSS3 transforms** for creating the cubes and **CSS3 transitions** for the animation.

How to use
-----

To use the library, you need to include the following files:
* js/characters.js
* js/isoblocks.js
* css/isoblocks.css

Put the following in your HTML:
```
<div id="iso_container"></div>
```


Then in your code create an instance of **IsoBlocks** class and call the **generate** method to create the text you want:

**NOTE:** IsoBlocks requires jQuery to be included before it.

```
var iso = new IsoBlocks(400); // pass the number of blocks to pre-generate
iso.generate('Your Text Here'); // By Default starts from lower left of the screen
```

Position it:
```
iso.generate('Your Text Here', {x: 320, y: 600});
```

Colorize it (Presently supports- green, red, pink, blue, yellow only):
```
iso.generate('Your Text Here', {x: 320, y: 600, colors: 'green'}); // Pass a color using 'colors' option
```

Use multiple colors:
```
iso.generate('Your Text Here', {x: 320, y: 600, colors: ['green', 'yellow']}); // Pass an array of colors in 'colors'
```

Try it out
------------
Demo: [http://kushagragour.in/lab/isoblocks/](http://kushagragour.in/lab/isoblocks/)

[Works best in Google Chrome]


License
-------

Licensed under The MIT License



