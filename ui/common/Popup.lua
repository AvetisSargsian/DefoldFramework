local Button 		= require "main.frameworck.ui.common.Button"
local GUI_Box 		= require "main.frameworck.ui.common.GUI_Box"

local Popup = {};

function Popup.new(node_name, show_position, hide_position) 
	local super = GUI_Box.new(node_name);
	local this = {};
	local is_visible = false;
	local inputs_handlers = {};

	--inheritance
	setmetatable(this, super);
	super.__index = super;

	this.id = gui.get_id(this.node);
	this.set_enabled(false);

	function this.show()
		if is_visible then return end
		is_visible = true,
		this.set_enabled(true);
		this.animate("position", show_position, gui.EASING_OUTBACK, 0.5);
	end

	function this.hide()
		if not is_visible then return end
		this.animate("position", hide_position, gui.EASING_INOUTBACK, 0.5, 0, function() 
			this.set_enabled(false);
			is_visible = false;
		end);
	end

	function this.is_visible()
		return is_visible;
	end

	function this.add_input_handler(input)
		table.insert(inputs_handlers, input);
	end

	function this.on_input(action_id, action)
		for _, input in pairs(inputs_handlers) do
			input.on_input(action_id, action);
		end
	end

	return this;
end

return Popup;