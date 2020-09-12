local Module = {}

function Module.new()
	local this = {};
	local actions = {};
	local commands ={};
	local models = {};

	function this.on_message(id, message)
		if actions[id] then
			if type(actions[id]) == "table" then
				for _, command in ipairs(actions[id]) do 
					if not command(this, message) then break end
				end
			elseif type(actions[id]) == "function" then
				actions[id](this, message)
			end
		else
			print("MESSAGE ".. id .. " NOT REGISTERED")
		end
	end

	function this.bind_action(message_id, action)
		actions[message_id] = action;
		return this;
	end

	function this.register_command(id, command)
		commands[id] = command;
	end

	function this.get_command(id)
		return commands[id];
	end

	function this.register_model(id, model)
		models[id] = model;
	end

	function this.get_model(id)
		return models[id];
	end
	
	return this;
end

return Module;