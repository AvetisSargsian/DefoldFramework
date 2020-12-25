local Module = {}

Module.SELECTOR = "selector";
Module.SEQUENCE = "sequence";
Module.CONDITION = "condition";

function Module.new()
	local this = {};
	local actions = {};
	local commands ={};
	local models = {};
	local coroutines = {};

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

	runAction = function (action, message, id)
		if not action then
			print("MESSAGE: " .. " NO BRANCH")
			return false;
		end
		local result;
		if type(action) == "table" then
			if action.type == Module.SELECTOR then
				result = runSelector(action, message);
			elseif action.type == Module.SEQUENCE then
				result = runSequence(action, message);
			elseif action.type == Module.CONDITION then
				result = runCondition(action, message)
			end
		elseif type(action) == "function" then
			result = action(this, message);
		end

		if id and coroutines[id] then
			print("module coroutine:: stop branch " .. id)
			coroutines[id] = nil 
		end
		return result;
	end

	function this.on_message(id, message)
		local co = coroutine.create(runAction);
		coroutines[id] = co;
		print("module coroutine:: start branch - " .. id)
		coroutine.resume(co, actions[id], message, id);
		-- runAction(actions[id], message);
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