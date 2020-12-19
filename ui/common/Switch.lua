local GUI_Box = require "main.frameworck.ui.common.GUI_Box"
Switch = {};

local States = {
	STATE_1 = "States.STATE_1",
	STATE_2 = "States.SATES_2"
}

function Switch.new(node_name, button1, button2, callback)
	local super = GUI_Box.new(node_name);
	local this = {};
	
	setmetatable(this, super);
	super.__index = super;
	
	local _state = States.STATE_1;
	local _callback = callback;
	this.button1 = button1;
	this.button2 = button2

	local function switch_state()
		if _state == States.STATE_1 then 
			_state = States.STATE_2;
			this.button2.set_enabled(true);
			this.button1.set_enabled(false);
		else
			_state = States.STATE_1;
			this.button2.set_enabled(false);
			this.button1.set_enabled(true);
		end
	end

	local function button_callback()
		switch_state();
		if _callback then _callback(this); end
	end

	function this.toggle_state()
		switch_state();
	end

	function this.on_input(action_id, action)
		if _state == States.STATE_1 then 
			this.button1.on_input(action_id, action);
		else
			this.button2.on_input(action_id, action);	
		end
	end

	this.button1.set_callback(button_callback);
	this.button2.set_callback(button_callback);
	this.button2.set_enabled(false);

	return this;
end

return Switch;