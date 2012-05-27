###
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

###

$(->
	$('#iso_input').bind 'keydown', onKeyPress
)

onKeyPress = (e) ->
	if e.key is 13 or e.keyCode is 13
		if iso then iso.generate $(e.target).val(), {x: 320, y: 500, colors: $("input[name=color]:checked").map( -> return this.value; ).get()}

###
	Cube class
###
class Cube
	constructor: ->

	@width: 15
	@height: 15


###
	IsoBlocks class
###
class IsoBlocks

	# Array of pre-generated cubes which are used throughout.
	cubes: []

	# Current cube index in the @cubes array to be used for drawing
	current_cube_index: 0

	# An HTML string template for a block
	cube_template: '<div class="iso_block unused" style="left:@leftpx; top:@toppx"></div>'

	# Default Configuration Object
	default_config: {}

	# Current Configuration Object
	config: {}

	###
	Constructor
	@param	num_cubes	Number 	Number of cubes to pre-generate. Default is 450.
	###
	constructor: (num_cubes = 450) ->
		@default_config =
			# Colors to use for the text blocks
			colors: []

			# Starting x cordinate on the screen
			x: 30

			# Starting y cordinate on the screen
			y: window.innerHeight - 100

			# Spacing between 2 characters in terms of number of blocks. Default is 1.
			character_spacing: 1

		@preGenerateCubes num_cubes 

	###
	@params	s 		string 	String to draw
	@param	config 	Object	Configuration object.
	###
	generate: (s, config = {}) ->
		$.extend @config, @default_config, config
		colors = []
		# Append iso_color prefix to colors
		if config.colors
			if typeof config.colors is 'string'
				config.colors = [config.colors]
			colors = (color.toLowerCase().replace(/^/,' iso_color_') for color in config.colors)
			@config.colors = colors

		# Initialize the @current_cube_index to start using the cubes from end for current string
		@current_cube_index = @cubes.length - 1

		# Hide all cubes
		for cube in @cubes
			$(cube).addClass('unused')

		current_row = 0
		current_col = 0

		# Loop throught the characters and keep drawing them
		for ch, index in s
			current_col += @drawCharacter ch, current_row, current_col

			# Give some space between 2 characters
			current_col += @config.character_spacing
	
	### 
	It draws a character at given row and column
	Returns the width of the character in number of blocks
	@param 	ch 	String 	A character to draw
	@param 	row Number 	Current character's row
	@param 	col Number 	Current character's column
	###
	drawCharacter: (ch, row, col) ->
		# Lowercase the character
		ch = ch.toLowerCase()

		# Handle special characters
		if ch is ' ' then return 1
		else if ch is '#' then ch = 'fill'
		else if ch is '!' then ch = 'exclamation'
		else if ch is '?' then ch = 'question'
		else if ch is '.' then ch = 'fullstop'
		else if ch is ',' then ch = 'comma'
		else if ch is '-' then ch = 'dash'
		else if ch is ';' then ch = 'semicolon'
		else if ch is ':' then ch = 'colon'
		else if ch is '/' then ch = 'f_slash'
		else if ch is '[' then ch = 'l_square_bracket'
		else if ch is ']' then ch = 'r_square_bracket'

		# Skip if character matrix not found
		if not current_ch = Characters[ch] then return 0
		for arr, i in current_ch
			for val, j in arr
				if val
					# Calulate isometric position of the cube
					pos_x = (row+i+col+j) * Cube.width * 0.8 + @config.x
					pos_y = (row+i-(col+j)) * Cube.height / 2 * 0.8 + @config.y
					
					# Calculate z-index according to the cube's position
					z = parseInt 100 * pos_y - 40 * pos_x + 2000, 10

					###
					If its not the first time, we have already generated cubes.
					So no need of dom manipulation again and again.
					Else if we do not have some cubes, we generate them. This happens for the first time only.
					###
					if @current_cube_index >= 0
						cube = @cubes[@current_cube_index]
						cube.style.left = pos_x + 'px'
						cube.style.top = pos_y + 'px'
						# Remove previous color class, pick a new random color class and add it
						class_string = $(cube).attr 'class'
						class_string = class_string.replace(/iso_color_\w+/g, '')
						if @config.colors.length
							new_color = @config.colors[Math.floor Math.random() * @config.colors.length]
							class_string = class_string.concat(" #{new_color}")
						$(cube).removeClass().addClass class_string
						cube.style.zIndex = z
						$(cube).removeClass 'unused'
						@current_cube_index--
					else
						console.warn 'Cubes got Over!'
						return
		# Return the character width
		current_ch[0].length

	### 
	@param 	cube_count	Number 	Number of cubes to pre-generate
	###
	preGenerateCubes: (cube_count) ->
		html_string = ''
		for i in [1...cube_count]
			current_cube = @cube_template
			
			current_cube = current_cube.replace '@left', (150 + Math.random() * (window.screen.width-400))
			current_cube = current_cube.replace '@top', (200 + Math.random() * (window.screen.height - 500))
			html_string += current_cube

		# Insert the cubes into the DOM. Uses innerHTML for faster DOM Insertion.
		if html_string then $('#iso_container').get(0).innerHTML += html_string

		# Get the cube references
		@cubes = document.getElementsByClassName('iso_block')

	# IsoBlocks end