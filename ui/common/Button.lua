local GUI_Box 	= require "main.frameworck.ui.common.GUI_Box"
local SoundManager 	= require "main.frameworck.sound.SoundManager"
local Button = {};

-- if uncomment code below, Button will inherit all GUI_Box properties and methods
-- setmetatable(Button, GUI_Box);
-- GUI_Box.__index = GUI_Box
local sound_go = "main:/sounds#";

function Button.on_input(store, action_id, action)
	for _, btn in pairs(store) do
		btn.on_input(action_id, action);
	end
end

function Button.new(node_name, layout_settings, callback)
	local super = GUI_Box.new(node_name);
	local this = {};
	this.protected = {};

	--inheritance
	setmetatable(this, super);
	super.__index = super;

	local settings = layout_settings[this.id];
	
	local duration = settings.animation_duration;
	local easing_function_scale = settings.easing_function_scale;
	local up_state = settings.up_state; --or gui.get_flipbook(this.node);
	local up_scale = settings.up_scale;
	local up_color = settings.up_color;
	local down_state = settings.down_state;
	local hover_state = settings.hover_state;
	local hover_color = settings.hover_color;
	local hover_scale = settings.hover_scale;
	local pressed_color = settings.pressed_color;
	local pressed_scale = settings.pressed_scale;
	
	--local pressed_scale_value = settings.pressed_scale or 0.85;
	--local released_scale_value = settings.released_scale or 1;
	
	--local pressed_scale = vmath.vector3(pressed_scale_value, pressed_scale_value, 0);
	--local released_scale = vmath.vector3(released_scale_value, released_scale_value, 0);
	local _callback = callback;
	local click_sound = nil;
	if settings.sound then
		click_sound = sound_go .. settings.sound;
	end
	
	local _state = nil;
	local _enabled = true;
	local _pressed = false;
	local _is_over = false;

	local function play_sound()
		if click_sound then
			SoundManager.play_sound(click_sound);
		end
	end

	function this.protected.setOverAnim()
		if hover_state and _state ~= hover_state then
			gui.play_flipbook(this.node, hover_state);
		end
		
		if hover_color then
			this.animate("color", hover_color, gui.EASING_LINEAR, duration);
		end
		
		if hover_scale then
			this.animate("scale", hover_scale, easing_function_scale, duration);
		end
		
		_is_over = true;
		_state = hover_state;
	end

	function this.protected.setPressedAnim()
		if down_state and _state ~= down_state then
			gui.play_flipbook(this.node, down_state);
		end

		if pressed_scale then
			this.animate("scale", pressed_scale, easing_function_scale, duration);
		end
		
		if pressed_color then
			this.animate("color", pressed_color, gui.EASING_LINEAR, duration);
		end
		
		play_sound();
		_pressed = true;
		_state = down_state;
	end

	function this.protected.setReleasedAnim()
		if up_state and _state ~= up_state then
			gui.play_flipbook(this.node, up_state);
		end

		if up_color then
			this.animate("color", up_color, gui.EASING_LINEAR, duration);
		end

		if up_scale then
			this.animate("scale", up_scale, easing_function_scale, duration);
		end
		
		_pressed = false;
		_is_over = false;
		_state = up_state;
	end

	function this.set_input_enabled(value)
		_enabled = value;
	end

	function this.set_callback(cb)
		_callback = cb;
	end

	function this.release()
		this.protected.setReleasedAnim();
	end
	
	function this.on_input(action_id, action)
		if not _enabled then return end
		local over = gui.pick_node(this.node, action.x, action.y);
		if action_id == GUI_Box.TOUCH then
			if not this.is_enabled() then return end
			-- local over = gui.pick_node(this.node, action.x, action.y);
			if over then 
				if action.pressed and not _pressed then
					this.protected.setPressedAnim(this.node);
				elseif action.released and _pressed then
					this.protected.setReleasedAnim();
					if over and _callback then 
						_callback(this); 
					end
				end
				return;
			elseif _pressed then
				this.protected.setReleasedAnim(this.node);
				return;
			end
		end
		if over and not _pressed and not _is_over then 
			this.protected.setOverAnim();
		elseif not over and not _pressed and _is_over then
			this.protected.setReleasedAnim();
		end
	end

	this.protected.setReleasedAnim();
	
	return this;
end

return Button;