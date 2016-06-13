require 'gosu'

module Animation
	attr_reader :animator

	# a single sprite animation
	class Animation
		attr_reader :width
		attr_reader :height

		def initialize(window, filename, frame_width, frame_height, frames_per_second)
			@sprite = Gosu::Image::load_tiles(window, filename, frame_width, frame_height, false)

			@frame_interval = 1000 / frames_per_second

			@width = frame_width
			@height = frame_height
		end

		def get_frame
			@sprite[Gosu::milliseconds / @frame_interval % @sprite.size]
		end
	end

	# defines and manages animations to prevent duplication
	class Animator
		def initialize
			@anims = {}
		end

		def add_anim(name, animation)
			if @anims[name] != nil
				@anims[name] = animation
			end
		end

		def has_anim(name)
			@anims[name] != nil
		end

		def get_anim(name)
			@anims[name]
		end
	end
end

ANIMATOR = Animation::Animator.new
