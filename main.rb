require 'gosu'
require 'chipmunk'

require './layer.rb'
require './constants.rb'
require './player.rb'
require './star.rb'
require './animation.rb'

class MyWindow < Gosu::Window
	def initialize
		super(Constants::SCREEN_WIDTH, Constants::SCREEN_HEIGHT, false)
		self.caption = 'Spaec gaim'

		self.load

		# the length of a single timestep
		@dt = 1.0 / 60.0

		@space = CP::Space.new
		@space.damping = 0.8

		# body for the player
		body = CP::Body.new(10, 150)
    
    # In order to create a shape, we must first define it
    # use 4 sided Poly for our Player
    # define the vectors so that the "top" of the Shape is towards 0 radians (the right)
    shape_array = [CP::Vec2.new(-25.0, -25.0), CP::Vec2.new(-25.0, 25.0), CP::Vec2.new(25.0, 1.0), CP::Vec2.new(25.0, -1.0)]
    shape = CP::Shape::Poly.new(body, shape_array, CP::Vec2.new(0,0))
    
    # The collision_type of a shape allows us to set up special collision behavior
    # based on these types.  The actual value for the collision_type is arbitrary
    # and, as long as it is consistent, will work for us; of course, it helps to have it make sense
    shape.collision_type = :ship
    
    @space.add_body(body)
    @space.add_shape(shape)

    @player = Player.new(self, shape)

		@player.warp_to(CP::Vec2.new(320, 240))

		@stars = Array.new

		@font = Gosu::Font.new(self, Gosu::default_font_name, 20)
	end

	def load
		@background_image = Gosu::Image.new(self, "media/Space.png", true)

		# load animations
		ANIMATOR.add_anim("star", Animation::Animation.new(self, "media/Star.png", 25, 25, 10))
	end

	# update method
	def update
		# step the physics world FRAME_SUBSTEPS times per frame
		Constants::FRAME_SUBSTEPS.times do
			@player.shape.body.reset_forces

			if button_down? Gosu::KbLeft then
				@player.turn_left
			end
			if button_down? Gosu::KbRight then
				@player.turn_right
			end
			if button_down? Gosu::KbUp then
				boost = (button_down? Gosu::KbRightShift) || (button_down? Gosu::KbLeftShift)

				@player.accelerate(boost)
			end
			if button_down? Gosu::KbDown then
				@player.reverse
			end

			if rand(100) < 4 and @stars.size < 25 then
				# @stars.push(Star.new(@star_anim))
			end
		
			@space.step(@dt)
		end
	end

	# render method
	def draw
		@background_image.draw(0, 0, Layer::Background)
		@player.draw

		@stars.each { |star| star.draw }

		@font.draw("Score: #{0}", 10, 10, Layer::UI, 1.0, 1.0, 0xffffff00)
	end

	def button_down(id)
		if id == Gosu::KbEscape
			close
		end
	end
end

window = MyWindow.new
window.show
