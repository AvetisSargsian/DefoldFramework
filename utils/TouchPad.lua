local TouchPad = {}

local TAP_THRESHOLD = 20;
local DOUBLE_TAP_INTERVAL = 0.3;
TouchPad.DRAG_THRESHOLD = 33;

function TouchPad.set_sensitivity(value)
	local min_sensitivity = 33;
	local max_sensitivity = 100;
	TouchPad.DRAG_THRESHOLD = max_sensitivity - value * 100;
	if TouchPad.DRAG_THRESHOLD < min_sensitivity then
		TouchPad.DRAG_THRESHOLD = min_sensitivity;
	end
end

TouchPad.state = {}

local touch_start = nil;
local pressed_time = nil;
TouchPad.state.drag_x = 0;
TouchPad.state.drag_y = 0;

function TouchPad.on_input(action_id, action)
	if action_id ~= hash("touch") then return end

	TouchPad.state.was_tap = false;
	TouchPad.state.was_double_pressed = false;

	if action.pressed and not touch_start then 
		local time = socket.gettime();
		local dif_time = time - (pressed_time or 0);
		pressed_time = time;

		if dif_time <= DOUBLE_TAP_INTERVAL then
			TouchPad.state.is_double_pressed = true;
		end

		touch_start = { x = action.x, y = action.y };

	elseif action.released and touch_start then
		if TouchPad.state.is_double_pressed then
			TouchPad.state.is_double_pressed = false;
			TouchPad.state.was_double_pressed = true;
		end
		local dif_x = touch_start.x - action.x;
		local dif_y = touch_start.y - action.y;
		local distance = math.max(math.abs(dif_x), math.abs(dif_y));
		TouchPad.state.was_tap = distance < TAP_THRESHOLD;
		touch_start = nil;
		TouchPad.state.drag_x = 0;
		TouchPad.state.drag_y = 0;
	end

	if touch_start then
		if math.abs(action.x - touch_start.x) >= TouchPad.DRAG_THRESHOLD then
			TouchPad.state.drag_x = action.x - touch_start.x > 0 and 1 or -1;
			touch_start.x = action.x;
		else
			TouchPad.state.drag_x = 0;
		end

		if math.abs(action.y - touch_start.y) >= TouchPad.DRAG_THRESHOLD then
			TouchPad.state.drag_y = action.y - touch_start.y > 0 and 1 or -1;
			touch_start.y = action.y;
		else
			TouchPad.state.drag_y = 0;
		end
	end
end


return TouchPad;
