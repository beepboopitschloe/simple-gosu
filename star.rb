require 'gosu'
require 'chipmunk'

require './layer.rb'
require './animation.rb'

class Star
	def initialize(animation, shape)
		@animation = animation
	
		@color = Gosu::Color.new(0xff000000)
		@color.red = rand(256-40) + 40
		@color.green = rand(256-40) + 40
		@color.blue = rand(256-40) + 40

		@shape = shape
		@shape.body.p = CP::Vec2.new(rand * 640, rand * 480)
	end

	def center_x
		@shape.body.p.x - @animation.width / 2.0
	end

	def center_y
		@shape.body.p.y - @animation.height / 2.0
	end

	def draw
		@animation.get_frame.draw(self.center_x, self.center_y,
			Layer::Stars, 1, 1, @color, :add)
	end
end
