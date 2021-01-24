local GUI_Box = {}
GUI_Box.TOUCH = hash("touch");

local function init_instance(gui_box, node_name)
	gui_box.node = gui.get_node(node_name);
	gui_box.id = gui.get_id(gui_box.node);
	gui_box.size = gui.get_size(gui_box.node);
end

function GUI_Box.clone_node(orogin_node, new_id)
	local node_clone = gui.clone(orogin_node);
	gui.set_id(node_clone, new_id);
	return GUI_Box.new(new_id);
end

function GUI_Box.clone_box(orogin_box, new_id)
	local node_clone = orogin_box.get_clone();
	gui.set_id(node_clone, new_id);
	return GUI_Box.new(new_id);
end

function GUI_Box.new(node_name)
	local this = {};
	local children = {};

	-- if uncomment, table - "this" will inherit method "GUI_Box.new()"  and will be able to create new instances
	-- setmetatable(this, GUI_Box);
	-- GUI_Box.__index = GUI_Box;

	if node_name then 
		init_instance(this, node_name);
	end

	function this.get_id()
		return this.id;
	end

	function this.set_node(new_node)
		this.node = new_node;
		this.id = gui.get_id(this.node);
		this.size = gui.get_size(this.node);
	end

	function this.delete()
		gui.delete_node(this.node)
	end

	function this.get_position()
		return gui.get_position(this.node);
	end

	function this.get_screen_position()
		return gui.get_screen_position(this.node);
	end

	function this.set_position(new_pos)
		gui.set_position(this.node, new_pos);
	end

	function this.set_alpha(value)
		gui.set_color( this.node, vmath.vector4(1, 1, 1, value) );
	end

	function this.get_clone()
		return gui.clone(this.node);
	end

	function this.get_alpha()
		return gui.get_color(this.node).w;
	end

	function this.set_color(color)
		color = color or vmath.vector4(1, 1, 1, 1);
		gui.set_color( this.node, color);
	end

	function this.set_enabled(value)
		gui.set_enabled(this.node, value);
	end

	function this.is_enabled()
		return gui.is_enabled(this.node);
	end

	function this.set_parent(parent)
		gui.set_parent(this.node, parent);
	end

	function this.set_id(id)
		gui.set_id(this.node, id);
	end

	function this.set_fill_angle(value)
		gui.set_fill_angle(this.node, value);
	end

	function this.animate(property, to, easing, duration, delay, complete_function, playback)
		delay = delay or 0;
		duration = duration or 0;
		gui.animate(this.node, property, to, easing, duration, delay, complete_function, playback);
	end

	function this.is_pick(action)
		return gui.pick_node(this.node, action.x, action.y);
	end

	function this.on_input(action_id, action)
	end

	return this;
end

return GUI_Box;

-- gui.PROP_POSITION
-- gui.PROP_ROTATION
-- gui.PROP_SCALE
-- gui.PROP_COLOR
-- gui.PROP_OUTLINE
-- gui.PROP_SHADOW
-- gui.PROP_SIZE
-- gui.PROP_FILL_ANGLE
-- gui.PROP_INNER_RADIUS
-- gui.PROP_SLICE9

-- gui.EASING_INBACK
-- gui.EASING_INBOUNCE
-- gui.EASING_INCIRC
-- gui.EASING_INCUBIC
-- gui.EASING_INELASTIC
-- gui.EASING_INEXPO
-- gui.EASING_INOUTBACK
-- gui.EASING_INOUTBOUNCE
-- gui.EASING_INOUTCIRC
-- gui.EASING_INOUTCUBIC
-- gui.EASING_INOUTELASTIC
-- gui.EASING_INOUTEXPO
-- gui.EASING_INOUTQUAD
-- gui.EASING_INOUTQUART
-- gui.EASING_INOUTQUINT
-- gui.EASING_INOUTSINE
-- gui.EASING_INQUAD
-- gui.EASING_INQUART
-- gui.EASING_INQUINT
-- gui.EASING_INSINE
-- gui.EASING_LINEAR
-- gui.EASING_OUTBACK
-- gui.EASING_OUTBOUNCE
-- gui.EASING_OUTCIRC
-- gui.EASING_OUTCUBIC
-- gui.EASING_OUTELASTIC
-- gui.EASING_OUTEXPO
-- gui.EASING_OUTINBACK
-- gui.EASING_OUTINBOUNCE
-- gui.EASING_OUTINCIRC
-- gui.EASING_OUTINCUBIC
-- gui.EASING_OUTINELASTIC
-- gui.EASING_OUTINEXPO
-- gui.EASING_OUTINQUAD
-- gui.EASING_OUTINQUART
-- gui.EASING_OUTINQUINT
-- gui.EASING_OUTINSINE
-- gui.EASING_OUTQUAD
-- gui.EASING_OUTQUART
-- gui.EASING_OUTQUINT
-- gui.EASING_OUTSINE
