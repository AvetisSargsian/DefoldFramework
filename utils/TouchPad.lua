local TouchPad = {}

local TAP_THRESHOLD = 20;
local DOUBLE_TAP_INTERVAL = 0.3;
local DRAG_THRESHOLD = 33;

function TouchPad.new()
	local this = {}

	this.state = {}

	local touch_start = nil;
	local pressed_time = nil;
	this.state.drag_x = 0;
	this.state.drag_y = 0;

	function this.on_input(action_id, action)
		if action_id ~= hash("touch") then return end
		
		this.state.was_tap = false;
		this.state.was_double_pressed = false;
		
		if action.pressed and not touch_start then 
			local time = socket.gettime();
			local dif_time = time - (pressed_time or 0);
			pressed_time = time;
			
			if dif_time <= DOUBLE_TAP_INTERVAL then
				this.state.is_double_pressed = true;
			end

			touch_start = { x = action.x, y = action.y };
			
		elseif action.released and touch_start then
			if this.state.is_double_pressed then
				this.state.is_double_pressed = false;
				this.state.was_double_pressed = true;
			end
			local dif_x = touch_start.x - action.x;
			local dif_y = touch_start.y - action.y;
			local distance = math.max(math.abs(dif_x), math.abs(dif_y));
			this.state.was_tap = distance < TAP_THRESHOLD;
			touch_start = nil;
			this.state.drag_x = 0;
			this.state.drag_y = 0;
		end

		if touch_start then
			if math.abs(action.x - touch_start.x) >= DRAG_THRESHOLD then
				this.state.drag_x = action.x - touch_start.x > 0 and 1 or -1;
				touch_start.x = action.x;
			else
				this.state.drag_x = 0;
			end

			if math.abs(action.y - touch_start.y) >= DRAG_THRESHOLD then
				this.state.drag_y = action.y - touch_start.y > 0 and 1 or -1;
				touch_start.y = action.y;
			else
				this.state.drag_y = 0;
			end
		end
	end

	return this;
end

return TouchPad;
