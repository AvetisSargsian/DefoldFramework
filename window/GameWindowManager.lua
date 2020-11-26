local GameWindowManager = {};

GameWindowManager.on_focus_lost = nil;
GameWindowManager.on_focus_return = nil;
GameWindowManager.on_resize = nil;
GameWindowManager.on_iconfied = nil;
GameWindowManager.on_deiconified = nil;

local screenW	= tonumber(sys.get_config("display.width"));
local screenH	= tonumber(sys.get_config("display.height"));

local window_width = nil;
local window_height = nil;
local scale = nil;
local xoffset = nil;
local yoffset = nil;

local function calculate_params(width, height)
	window_width = width;
	window_height = height;
	scale = math.min( window_width / screenW , window_height / screenH );
	local projected_width = window_width / (scale or 1)
	local projected_height = window_height / (scale or 1)
	xoffset = (projected_width - screenW) / 2
	yoffset = (projected_height - screenH) / 2
end

local function window_callback(self, event, data)
	if event == window.WINDOW_EVENT_FOCUS_LOST then
		if GameWindowManager.on_focus_lost then
			GameWindowManager.on_focus_lost();
		end
	elseif event == window.WINDOW_EVENT_FOCUS_GAINED then
		if GameWindowManager.on_focus_return then 
			GameWindowManager.on_focus_return();
		end
	elseif event == window.WINDOW_EVENT_ICONFIED then
		if GameWindowManager.on_iconfied then
			GameWindowManager.on_iconfied();
		end
	elseif event == window.WINDOW_EVENT_DEICONIFIED then
		if GameWindowManager.on_deiconified then
			GameWindowManager.on_deiconified();
		end
	elseif event == window.WINDOW_EVENT_RESIZED then
		calculate_params(data.width, data.height);
		if GameWindowManager.on_resize then 
			GameWindowManager.on_resize(data.width, data.height)
		end
	end
end

function GameWindowManager.get_display_dimension()
	return { width = screenW, height = screenH };
end

function GameWindowManager.get_offset()
	return { x = xoffset, y = yoffset };
end

function GameWindowManager.get_scale()
	return scale;
end

function GameWindowManager.get_window_size()
	return {width = window_width, height = window_height};
end

function GameWindowManager.validate_input(action)
	return {x = action.screen_x / scale - xoffset, y = action.screen_y / scale - yoffset}
end

function GameWindowManager.init_listeners()
	window.set_listener(window_callback);
end

calculate_params(window.get_size());
return GameWindowManager;
