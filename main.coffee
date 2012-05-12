$(->
	$(iso_input).bind 'keydown', onKeyPress
)

onKeyPress = (e) ->
	if e.key is 13 or e.keyCode is 13
		if iso then iso.generate $(e.target).val()

class Cube
	constructor: ->

	@width: 15
	@height: 15

class Colors
	constructor: ->

	@colors: ['yellow', 'green', '']

	@getRandomColor: ->
		Colors.colors[Math.floor Math.random() * Colors.colors.length]


class Isometric
	origin_x: 20
	origin_y: 610
	offset_x: 0
	offset_y: 0
	letter_width: 4
	letter_spacing: 8
	cubes: []

	cube_template: '<div class=iso_block @color style="top:@toppx; left:@leftpx; z-index:@z"></div>'

	constructor: (@alphabet_width = 5)->

	generate: (s) ->
		html_string = ''
		cos = Math.cos(-30 * Math.PI /180)
		sin = Math.sin(-30 * Math.PI /180)
		cubes_length = @cubes.length
		# Hide all cubes and reset color
		for cube in @cubes
			$(cube).addClass('unused').removeClass('iso_color_yellow iso_color_green')
			#$(cube).css 'top', parseInt($(cube).css('top'), 10) - 400
		for alphabet, index in s

			# Lowercase the character
			alphabet = alphabet.toLowerCase()

			# Handle special characters
			if alphabet is ' ' then alphabet = 'space'
			else if alphabet is '#' then alphabet = 'fill'
			else if alphabet is '!' then alphabet = 'exclamation'
			else if alphabet is '?' then alphabet = 'question'
			else if alphabet is '.' then alphabet = 'fullstop'
			else if alphabet is ',' then alphabet = 'comma'
			else if alphabet is '-' then alphabet = 'dash'
			else if alphabet is ';' then alphabet = 'semicolon'
			else if alphabet is ':' then alphabet = 'colon'

			current_alphabet = Alphabets[alphabet] 
			for arr, i in current_alphabet
				#z = arr.length
				#y = @origin_y + (Cube.height + @offset_y) * y_pos
				for val, j in arr
					if val
						x_iso = (i+j) * Cube.width * 0.85 + @origin_x + Cube.width * index * 5
						y_iso = (i-j) * Cube.height / 2 * 0.85 + @origin_y - Cube.width * 2.5 * index
						z = parseInt 100 * y_iso - 40 * x_iso + 2000, 10
						color = '' #Colors.getRandomColor()
						if cubes_length-- > 0
							cube = @cubes[cubes_length]
							#console.log 'resuing a cube', cube
							cube.style.left = x_iso + 'px'
							cube.style.top = y_iso + 'px'
							cube.style.zIndex = z
							$(cube).removeClass 'unused'
							$(cube).addClass 'iso_color_' + color
						else
							current_cube = @cube_template
							#x = @origin_x + (@alphabet_width + 2) * Cube.width * index + (Cube.width + @offset_x) * i
							#x_iso = x * cos - y * sin
							#y_iso = x * sin + y * cos
							current_cube = current_cube.replace '@left', x_iso
							current_cube = current_cube.replace '@top', y_iso
							current_cube = current_cube.replace '@z', z
							html_string += current_cube
			# Hide the unused cubes
			#for cube in @cubes
			#	if not $(cube).hasClass 'used' 
		if html_string then iso_container.innerHTML += html_string
		@cubes = document.getElementsByClassName('iso_block')
		#console.log @cubes.length
	
	createCube = (ox, oy) ->

	# 0 * sin−30 + 15 * cos−30
	# 0 * cos−30 - 15 * sin−30