local GUI_Box = require "main.frameworck.ui.common.GUI_Box"
Slider = {};

function Slider.new(main_node, thumb_name, line_name, text_name, callback)
	local super = GUI_Box.new(main_node);
	local this = {};

	setmetatable(this, super);
	super.__index = super;

	local thumb = GUI_Box.new(thumb_name);
	local line = GUI_Box.new(line_name);

	local thumb_local_position = thumb.get_position();
	local thumb_global_position = thumb.screen_position;
	local line_length = line.size.x;
	local _pressed = false;

	local function set_pos(new_pos_x)
		thumb_local_position.x = new_pos_x;
		thumb.set_position(thumb_local_position);
		thumb_global_position = thumb.screen_position;
	end

	local function move_thumb(dx)
		local new_pos_x = thumb_local_position.x + dx;
		
		if new_pos_x < 0 then new_pos_x = 0 end
		if new_pos_x > line_length then new_pos_x = line_length end
		
		set_pos(new_pos_x);
	end

	function this.set_text(text)
	end

	function this.set_ratio(value)
		if value < 0 then value = 0 end
		if value > 1 then value = 1 end
		set_pos(value * line_length);
		if callback then 
			callback(value);
		end
	end

	function this.on_input(action_id, action)
		if action_id == GUI_Box.TOUCH then
			if not this.is_enabled() then return end
			if gui.pick_node(thumb.node, action.x, action.y) then 
				if action.pressed and not _pressed then _pressed = true; end
			end

			if action.released and _pressed then 
				_pressed = false; 
				if callback then 
					callback(thumb_local_position.x / line_length);
				end
			end

			if _pressed and action.dx ~= 0 then
				move_thumb(action.x - thumb_global_position.x);
			end
		end
	end

	return this
end

return Slider;