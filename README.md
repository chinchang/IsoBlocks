IsoBlocks
=========

What is it?
-----------

IsoBlocks is an experimental library to create eye-candy isometric texts. It is written in **coffeescript**, uses **CSS3 transforms** for creating the cubes and **CSS3 transitions** for the animation.

How to use
-----

To use the library, you need to include the following files:
* js/isoblocks.js
* js/characters.js
* css/isoblocks.css

Then in your code create an instance of **IsoBlocks** class and call the **generate** method to create the text you want:

```
var iso = new IsoBlocks(400); // pass the number of blocks to pre-generate
iso.generate('Your Text Here', 320, 500);
```

Try it out
------------
Demo: [http://kushagragour.in/lab/isoblocks/](http://kushagragour.in/lab/isoblocks/)

License
-------

Licensed under The MIT License


