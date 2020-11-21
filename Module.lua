local Module = {}

Module.SELECTOR = "selector";
Module.SEQUENCE = "sequence";
Module.CONDITION = "condition";

function Module.new()
	local this = {};
	local actions = {};
	local commands ={};
	local models = {};

	local runAction;

	local function runSequence(actions, message)
		for _, action in ipairs(actions) do 
			if not runAction(action, message) then 
				return false 
			end
		end
		return true;
	end

	local function runSelector(actions, message)
		for _, action in ipairs(actions) do 
			runAction(action, message)
		end
		return true;
	end

	local function runCondition(actions, message)
		if runAction(actions.condition, message) then
			return runAction(actions.success, message);
		else
			return runAction(actions.fail, message);
		end
	end

	runAction = function (action, message)
		if not action then
			print("MESSAGE: " .. " NO ACTION")
			return false;
		end
		if type(action) == "table" then
			if action.type == Module.SELECTOR then
				return runSelector(action, message);
			elseif action.type == Module.SEQUENCE then
				return runSequence(action, message);
			elseif action.type == Module.CONDITION then
				return runCondition(action, message)
			end
		elseif type(action) == "function" then
			return action(this, message);
		end
	end

	function this.on_message(id, message)
		runAction(actions[id], message);
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

setmetatable(Module, {
	-- this method used when table used as function
	__call = function(t, ...)
		return Module.new(...)
	end
})

return Module;