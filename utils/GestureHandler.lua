local GestureHandler = {}

GestureHandler.UP = "GestureHandler.UP";
GestureHandler.DOWN = "GestureHandler.DOWN";
GestureHandler.RIGHT = "GestureHandler.RIGHT";
GestureHandler.LEFT = "GestureHandler.LEFT";

function GestureHandler.new(dx, dy)
	local this = {}

	local on_swap_up = nil;
	local on_swap_down = nil;
	local on_swap_right = nil;
	local on_swap_left = nil;
	local on_touch = nil;

	local touch_start

	local function run_callback(cb)
		if cb then cb() end
	end

	function this.set_swap_up(callback)
		on_swap_up = callback
	end

	function this.set_swap_down(callback)
		on_swap_down = callback
	end

	function this.set_swap_right(callback)
		on_swap_right = callback
	end

	function this.set_swap_left(callback)
		on_swap_left = callback
	end

	function this.set_touch(callback)
		on_touch = callback
	end

	function this.on_input(action_id, action)
		local dif_x = 0;
		local dif_y = 0;
		
		if action.pressed and not touch_start then 
			touch_start = {x = action.x, y = action.y} 
		end
		
		if action.released and touch_start then 
			dif_x = touch_start.x - action.x
			dif_y = touch_start.y - action.y
			touch_start = nil;
		end
		
		if math.abs(dif_x) >= dx  then 
			if dif_x > 0 then
				run_callback(on_swap_right) 
			else
				run_callback(on_swap_left) 
			end
		end

		if math.abs(dif_y) >= dy  then 
			if dif_y < 0 then
				run_callback(on_swap_down)
			else
				run_callback(on_swap_up)
			end
		end

		if math.abs(dif_x) < dx and math.abs(dif_y) < dy then
			run_callback(on_touch)
		end
	end

	return this;
end

return GestureHandler;