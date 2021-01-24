local GUI_Box = require "main.frameworck.ui.common.GUI_Box"
local Scroll = {};

Scroll.strategies = {
	step = function(scroll)
		return {
			move = function(value)
				if value ~= 0 then
					local current = scroll.get_current_pos();
					current.y = scroll.calculate_new_position(move);
					scroll.update_position(current);
				end
			end
		}
	end,
	animation = function(scroll, step)
		local in_progress = false;
		return {
			move = function(value)
				if in_progress then return end
				value = value > 0 and 1 or -1;
				in_progress = true;
				local current_pos = scroll.get_current_pos();
				current_pos.y = scroll.calculate_new_position(step * value);
				scroll.container.animate("position", current_pos, gui.EASING_OUTBACK, 0.4, 0, function()
					scroll.update_position(current);
					in_progress = false;
				end);
			end
		}
	end
}


function Scroll.new(mask_node_name, container_node_name, height)
	local this = {};

	local mask = GUI_Box.new(mask_node_name);
	local scroll_container = GUI_Box.new(container_node_name);
	this.container = scroll_container;

	local container_pos = scroll_container.get_position();
	local start_pos_y = container_pos.y;
	local end_pos_y = start_pos_y + height;

	function this.get_current_pos()
		return container_pos;
	end

	function this.calculate_new_position(dy)
		local pos = container_pos.y + dy;
		if pos < start_pos_y then 
			return start_pos_y;
		end
		if pos + dy > end_pos_y then
			return end_pos_y;
		end
		return pos;
	end

	function this.update_position(pos)
		container_pos = pos;
		scroll_container.set_position(pos);
	end

	function this.add_content(node)
		node.set_parent(scroll_container)
	end

	function this.on_input(action_id, action)
		if mask.is_pick(action) then
			if action_id == hash("wheel_up") then
				
			end

			if action_id == hash("wheel_down") then
				
			end
			
			if action_id == hash("touch") then
				
			end
		end
	end

	return this;
end

return Scroll;