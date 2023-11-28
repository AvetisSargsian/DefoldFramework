local ScreenManager = {}

local DISABLE = hash("disable");
local ENABLE = hash("enable");
local FINAL = hash("final");
local UNLOAD = hash("unload");
local LOAD = hash("load");
local SHOW_SCREEN = hash("show_screen");
local CLOSE_ALL = hash("close_all");
local PROXY_LOADED = hash("proxy_loaded");

local scene_id_holder = {};
ScreenManager.state = nil;

function ScreenManager.register_screen(id, sceneVo)
	scene_id_holder[id] = sceneVo;
end

local function close_screen(proxy)
	if not proxy then return end
	msg.post(proxy, DISABLE)
	msg.post(proxy, FINAL)
	msg.post(proxy, UNLOAD)
end

local function show_screen(id)
	if scene_id_holder[id] then
		if ScreenManager.state then 
			close_screen(scene_id_holder[ScreenManager.state].proxy)
		end
		ScreenManager.state = id;
		msg.post(scene_id_holder[id].proxy, LOAD);
	end
end

function ScreenManager.on_message(message_id, message, sender)
	if message_id == SHOW_SCREEN then
		show_screen(message.id)
	elseif message_id == CLOSE_ALL then
		close_screen(scene_id_holder[ScreenManager.state].proxy);
		ScreenManager.state = nil;
	elseif message_id == PROXY_LOADED then
		if sender == msg.url(scene_id_holder[ScreenManager.state].proxy) then
			msg.post(sender, ENABLE);
			if scene_id_holder[ScreenManager.state].callback then
				scene_id_holder[ScreenManager.state].callback(ScreenManager.state);
			end
		end
	end
end





-- setmetatable(ScreenManager, {
-- 	-- this method used when table used as function
-- 	__call = function(t, ...)
-- 		return ScreenManager.new(...)
-- 	end
-- })

return  ScreenManager;