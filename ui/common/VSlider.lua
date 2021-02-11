local GUI_Box = require "main.frameworck.ui.common.GUI_Box"
local Slider = {};

function Slider.new(main_node, thumb_name, line_name, text_name, callback)
	local super = GUI_Box.new(main_node);
	local this = {};

	setmetatable(this, super);
	super.__index = super;

	local thumb = GUI_Box.new(thumb_name);
	local line = GUI_Box.new(line_name);

	local thumb_local_position = thumb.get_position();
	local line_length = -line.size.y;
	local _pressed = false;

	local function run_callback()
		if callback then 
			callback(thumb_local_position.y / line_length);
		end
	end

	local function set_pos(new_pos_y)
		thumb_local_position.y = new_pos_y;
		thumb.set_position(thumb_local_position);
	end

	local function move_thumb(dy)
		local new_pos_y = thumb_local_position.y + dy;
		if new_pos_y > 0 then new_pos_y = 0 end
		if new_pos_y < line_length then new_pos_y = line_length end
		set_pos(new_pos_y);
		run_callback()
	end

	function this.set_calback(cb)
		callback = cb
	end 

	function this.set_text(text)
	end

	function this.set_ratio(value, with_callback)
		if value < 0 then value = 0 end
		if value > 1 then value = 1 end
		set_pos(value * line_length);
		if with_callback then run_callback() end
	end

	function this.on_input(action_id, action)
		if action_id == GUI_Box.TOUCH then
			if not this.is_enabled() then return end
			
			if thumb.is_pick(action) then 
				if action.pressed and not _pressed then _pressed = true; end
			end

			if action.released and _pressed then 
				_pressed = false; 
				run_callback();
			end

			if _pressed and action.dy ~= 0 then
				move_thumb(action.screen_y - thumb.get_screen_position().y);
			end
		end
	end

	return this
end

return Slider;