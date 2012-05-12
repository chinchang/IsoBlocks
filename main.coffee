###
isoblocks.coffee

version 1.0
Author	Kushagra Gour a.k.a. chinchang (chinchang457@gmail.com)
Licensed under The MIT License

Description:
IsoBlocks is a library to create eye candy isometric texts.

Usage:
var iso = new IsoBlocks();
iso.generate('Any Text here', start_x, start_y);
###

$(->
	$('#iso_input').bind 'keydown', onKeyPress
)

onKeyPress = (e) ->
	if e.key is 13 or e.keyCode is 13
		if iso then iso.generate $(e.target).val(), 20, 610

class Cube
	constructor: ->

	@width: 15
	@height: 15

class Colors
	constructor: ->

	@colors: ['yellow', 'green', '']

	@getRandomColor: ->
		Colors.colors[Math.floor Math.random() * Colors.colors.length]


class IsoBlocks
	origin_x: 0
	origin_y: 0
	offset_x: 0
	offset_y: 0
	character_spacing: 0
	current_cube_index: 0

	# Pre-generated array of cubes which are used throughout.
	cubes: []

	# A HTML string template for a block
	cube_template: '<div class="iso_block @color unused" style="left:@leftpx; top:@toppx"></div>'

	constructor: ->
		@preCreateCubes 450

	generate: (s, start_x, start_y) ->
		#cos = Math.cos(-30 * Math.PI /180)
		#sin = Math.sin(-30 * Math.PI /180)
		@current_cube_index = @cubes.length - 1

		# Hide all cubes and reset color
		for cube in @cubes
			$(cube).addClass('unused')#.removeClass('iso_color_yellow iso_color_green')
			#$(cube).css 'top', parseInt($(cube).css('top'), 10) - 400
		@origin_x = start_x
		@origin_y = start_y
		current_row = 0
		current_col = 0

		for ch, index in s
			current_col += @drawCharacter ch, current_row, current_col

			# Give some space between 2 characters
			current_col += @character_spacing
	
	### 
	It draws a character at given row and column
	Returns the width of the character in number of blocks
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

		current_ch = Alphabets[ch]
		for arr, i in current_ch
			for val, j in arr
				if val
					# Calulate isometric position of the cube
					pos_x = (row+i+col+j) * Cube.width * 0.85 + @origin_x
					pos_y = (row+i-(col+j)) * Cube.height / 2 * 0.85 + @origin_y
					
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
						cube.style.zIndex = z
						$(cube).removeClass 'unused'
						#$(cube).addClass 'iso_color_' + color
						@current_cube_index--
					else
						console.warn 'Cubes got Over!'
						return
		# Return the character width
		current_ch.length

	preCreateCubes: (cube_count) ->
		html_string = ''
		for i in [1...cube_count]
			current_cube = @cube_template
			
			current_cube = current_cube.replace '@left', (20 + Math.random() * (window.screen.width-20))
			current_cube = current_cube.replace '@top', (20 + Math.random() * (window.screen.height-20))
			current_cube = current_cube.replace '@color', 'iso_color_' + Colors.getRandomColor()
			html_string += current_cube
			#console.log current_cube

		# Insert the cubes into the DOM. Uses innerHTML for faster DOM Insertion.
		
		#console.log html_string
		if html_string then iso_container.innerHTML += html_string

		# Get the cube references
		@cubes = document.getElementsByClassName('iso_block')

	# IsoBlocks end