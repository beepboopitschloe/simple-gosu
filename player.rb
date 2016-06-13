require 'gosu'
require 'chipmunk'

require './layer.rb'
require './constants.rb'

# Convenience method for converting from radians to a Vec2 vector.
def radians_to_vec2(rad)
	CP::Vec2.new(Math::cos(rad), Math::sin(rad))
end

class Player
	attr_reader :shape

	def initialize (window, shape)
		@image = Gosu::Image.new(window, "media/Starfighter.bmp", false)

		@shape = shape
		@shape.body.p = CP::Vec2.new(0, 0)
		@shape.body.v = CP::Vec2.new(0, 0)

		@shape.body.a = (3 * Math::PI/2.0)

		@turn_speed = 250.0 / Constants::FRAME_SUBSTEPS
		@move_speed = 1000.0 / Constants::FRAME_SUBSTEPS

		@boost_factor = 2
	end

	def warp_to (vec)
		@shape.body.p = vec
	end

	def turn_left
		@shape.body.t -= @turn_speed
	end

	def turn_right
		@shape.body.t += @turn_speed
	end

	def accelerate(boost)
		vec = radians_to_vec2(@shape.body.a) * @move_speed

		if (boost == true)
			vec *= @boost_factor
		end

		@shape.body.apply_force(vec, CP::Vec2.new(0.0, 0.0))
	end

	def reverse
		vec = radians_to_vec2(@shape.body.a) * @move_speed * -1

		@shape.body.apply_force(vec, CP::Vec2.new(0, 0))
	end

	def draw
		@image.draw_rot(@shape.body.p.x, @shape.body.p.y, Layer::Player, @shape.body.a.radians_to_gosu)
	end
end
