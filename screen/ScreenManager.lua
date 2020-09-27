local ScreenManager = {}

function ScreenManager.new()
	local this = {};
	local scene_id_holder = {};
	this.state = nil;

	function this.register_screen(id, sceneVo)
		scene_id_holder[id] = sceneVo;
	end

	local function close_screen(proxy)
		if not proxy then return end
		msg.post(proxy, "disable")
		msg.post(proxy, "final")
		msg.post(proxy, "unload")
	end

	local function show_screen(id)
		if scene_id_holder[id] then
			if this.state then 
				close_screen(scene_id_holder[this.state].proxy)
			end
			this.state = id;
			msg.post(scene_id_holder[id].proxy, "load");
		end
	end

	function this.on_message(message_id, message, sender)
		if message_id == hash("show_screen") then
			show_screen(message.id)
		elseif message_id == hash("close_all") then
			close_screen(scene_id_holder[this.state].proxy);
			this.state = nil;
		elseif message_id == hash("proxy_loaded") then
			if sender == msg.url(scene_id_holder[this.state].proxy) then
				msg.post(sender, "enable")
				if scene_id_holder[this.state].callback then
					scene_id_holder[this.state].callback(this.state);
				end
			end
		end
	end

	return this;
end


setmetatable(ScreenManager, {
	-- this method used when table used as function
	__call = function(t, ...)
		return ScreenManager.new(...)
	end
})

return  ScreenManager;