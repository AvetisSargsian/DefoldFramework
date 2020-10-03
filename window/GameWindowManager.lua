local GameWindowManager = {};

GameWindowManager.on_focus_lost = nil;
GameWindowManager.on_focus_return = nil;
GameWindowManager.on_resize = nil;
GameWindowManager.on_iconfied = nil;
GameWindowManager.on_deiconified = nil;

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
		if GameWindowManager.on_resize then 
			GameWindowManager.on_resize(data.width, data.height)
		end
	end
end

function GameWindowManager.init()
	window.set_listener(window_callback)
end

return GameWindowManager;
