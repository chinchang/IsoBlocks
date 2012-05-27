/*
isoblocks.coffee

version 1.0
Author	Kushagra Gour a.k.a. chinchang (chinchang457@gmail.com)
Licensed under The MIT License

Description:
IsoBlocks is a library to create eye candy isometric texts.

Usage:

var iso = new IsoBlocks(400); // pass the number of blocks to pre-generate
iso.generate('Your Text Here'); // By Default starts from the lower left of the screen

Position it:
iso.generate('Your Text Here', {x: 320, y: 600});

Colorize it (Presently supports- green, red, pink, blue, yellow only):
iso.generate('Your Text Here', {x: 320, y: 600, colors: 'green'}); // Pass a color using 'colors' option

Use multiple colors:
iso.generate('Your Text Here', {x: 320, y: 600, colors: ['green', 'yellow']}); // Pass an array of colors in 'colors'
*/
var Cube, IsoBlocks, onKeyPress;

$(function() {
  return $('#iso_input').bind('keydown', onKeyPress);
});

onKeyPress = function(e) {
  if (e.key === 13 || e.keyCode === 13) {
    if (iso) {
      return iso.generate($(e.target).val(), {
        x: 320,
        y: 500,
        colors: $("input[name=color]:checked").map(function() {
          return this.value;
        }).get()
      });
    }
  }
};

/*
	Cube class
*/

Cube = (function() {

  function Cube() {}

  Cube.width = 15;

  Cube.height = 15;

  return Cube;

})();

/*
	IsoBlocks class
*/

IsoBlocks = (function() {

  IsoBlocks.prototype.cubes = [];

  IsoBlocks.prototype.current_cube_index = 0;

  IsoBlocks.prototype.cube_template = '<div class="iso_block unused" style="left:@leftpx; top:@toppx"></div>';

  IsoBlocks.prototype.default_config = {};

  IsoBlocks.prototype.config = {};

  /*
  	Constructor
  	@param	num_cubes	Number 	Number of cubes to pre-generate. Default is 450.
  */

  function IsoBlocks(num_cubes) {
    if (num_cubes == null) num_cubes = 450;
    this.default_config = {
      colors: [],
      x: 30,
      y: window.innerHeight - 100,
      character_spacing: 1
    };
    this.preGenerateCubes(num_cubes);
  }

  /*
  	@params	s 		string 	String to draw
  	@param	config 	Object	Configuration object.
  */

  IsoBlocks.prototype.generate = function(s, config) {
    var ch, color, colors, cube, current_col, current_row, index, _i, _len, _len2, _ref, _results;
    if (config == null) config = {};
    $.extend(this.config, this.default_config, config);
    colors = [];
    if (config.colors) {
      if (typeof config.colors === 'string') config.colors = [config.colors];
      colors = (function() {
        var _i, _len, _ref, _results;
        _ref = config.colors;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          color = _ref[_i];
          _results.push(color.toLowerCase().replace(/^/, ' iso_color_'));
        }
        return _results;
      })();
      this.config.colors = colors;
    }
    this.current_cube_index = this.cubes.length - 1;
    _ref = this.cubes;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      cube = _ref[_i];
      $(cube).addClass('unused');
    }
    current_row = 0;
    current_col = 0;
    _results = [];
    for (index = 0, _len2 = s.length; index < _len2; index++) {
      ch = s[index];
      current_col += this.drawCharacter(ch, current_row, current_col);
      _results.push(current_col += this.config.character_spacing);
    }
    return _results;
  };

  /* 
  	It draws a character at given row and column
  	Returns the width of the character in number of blocks
  	@param 	ch 	String 	A character to draw
  	@param 	row Number 	Current character's row
  	@param 	col Number 	Current character's column
  */

  IsoBlocks.prototype.drawCharacter = function(ch, row, col) {
    var arr, class_string, cube, current_ch, i, j, new_color, pos_x, pos_y, val, z, _len, _len2;
    ch = ch.toLowerCase();
    if (ch === ' ') {
      return 1;
    } else if (ch === '#') {
      ch = 'fill';
    } else if (ch === '!') {
      ch = 'exclamation';
    } else if (ch === '?') {
      ch = 'question';
    } else if (ch === '.') {
      ch = 'fullstop';
    } else if (ch === ',') {
      ch = 'comma';
    } else if (ch === '-') {
      ch = 'dash';
    } else if (ch === ';') {
      ch = 'semicolon';
    } else if (ch === ':') {
      ch = 'colon';
    } else if (ch === '/') {
      ch = 'f_slash';
    } else if (ch === '[') {
      ch = 'l_square_bracket';
    } else if (ch === ']') {
      ch = 'r_square_bracket';
    }
    if (!(current_ch = Characters[ch])) return 0;
    for (i = 0, _len = current_ch.length; i < _len; i++) {
      arr = current_ch[i];
      for (j = 0, _len2 = arr.length; j < _len2; j++) {
        val = arr[j];
        if (val) {
          pos_x = (row + i + col + j) * Cube.width * 0.8 + this.config.x;
          pos_y = (row + i - (col + j)) * Cube.height / 2 * 0.8 + this.config.y;
          z = parseInt(100 * pos_y - 40 * pos_x + 2000, 10);
          /*
          					If its not the first time, we have already generated cubes.
          					So no need of dom manipulation again and again.
          					Else if we do not have some cubes, we generate them. This happens for the first time only.
          */
          if (this.current_cube_index >= 0) {
            cube = this.cubes[this.current_cube_index];
            cube.style.left = pos_x + 'px';
            cube.style.top = pos_y + 'px';
            class_string = $(cube).attr('class');
            class_string = class_string.replace(/iso_color_\w+/g, '');
            if (this.config.colors.length) {
              new_color = this.config.colors[Math.floor(Math.random() * this.config.colors.length)];
              class_string = class_string.concat(" " + new_color);
            }
            $(cube).removeClass().addClass(class_string);
            cube.style.zIndex = z;
            $(cube).removeClass('unused');
            this.current_cube_index--;
          } else {
            console.warn('Cubes got Over!');
            return;
          }
        }
      }
    }
    return current_ch[0].length;
  };

  /* 
  	@param 	cube_count	Number 	Number of cubes to pre-generate
  */

  IsoBlocks.prototype.preGenerateCubes = function(cube_count) {
    var current_cube, html_string, i;
    html_string = '';
    for (i = 1; 1 <= cube_count ? i < cube_count : i > cube_count; 1 <= cube_count ? i++ : i--) {
      current_cube = this.cube_template;
      current_cube = current_cube.replace('@left', 150 + Math.random() * (window.screen.width - 400));
      current_cube = current_cube.replace('@top', 200 + Math.random() * (window.screen.height - 500));
      html_string += current_cube;
    }
    if (html_string) $('#iso_container').get(0).innerHTML += html_string;
    return this.cubes = document.getElementsByClassName('iso_block');
  };

  return IsoBlocks;

})();
