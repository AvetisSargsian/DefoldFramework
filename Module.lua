local ResumeCoroutineCommand = require "main.frameworck.commands.ResumeCoroutineCommand"

local Module = {}

Module.SELECTOR = "selector";
Module.SEQUENCE = "sequence";
Module.CONDITION = "condition";

local function init_id_producer(start_value)
	local id = start_value or 0;	
	return function()
		id = id + 1;
		return id;
	end
end

local UNIQUE_ID = init_id_producer();

function Module.new()
	local this = {};
	local actions = {};
	local commands ={};
	local models = {};
	local coroutines = {};

	local runAction;

	local function runSequence(actions, message, thread_id)
		for _, action in ipairs(actions) do 
			if not runAction(action, message, thread_id) then 
				return false 
			end
		end
		return true;
	end

	local function runSelector(actions, message, thread_id)
		for _, action in ipairs(actions) do 
			runAction(action, message, thread_id)
		end
		return true;
	end

	local function runCondition(actions, message, thread_id)
		if runAction(actions.condition, message, thread_id) then
			return runAction(actions.success, message, thread_id);
		else
			return runAction(actions.fail, message, thread_id);
		end
	end

	local function create_coroutine(id, message)
		local thread_id = UNIQUE_ID();
		local co = coroutine.create( function () 
			-- print("module coroutine:: start branch - " .. id);
			runAction(actions[id], message, thread_id);

			if coroutines[thread_id] then
				-- print("module coroutine:: stop branch " .. id)
				coroutines[thread_id] = nil;
			end
		end);
		coroutines[thread_id] = co;
		return co;
	end

	local function start_coroutine(co)
		assert(coroutine.resume(co));
	end

	runAction = function (action, message, thread_id)
		if not action then
			print("MESSAGE: " .. " NO BRANCH")
			return false;
		end
		if type(action) == "table" then
			if action.type == Module.SELECTOR then
				return runSelector(action, message, thread_id);
			elseif action.type == Module.SEQUENCE then
				return runSequence(action, message, thread_id);
			elseif action.type == Module.CONDITION then
				return runCondition(action, message, thread_id)
			end
		elseif type(action) == "function" then
			return action(this, message, thread_id);
		end
	end

	function this.on_message(id, message)
		local co = create_coroutine(id, message);
		start_coroutine(co);
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

	function this.get_coroutine(id)
		return coroutines[id]
	end

	this.bind_action(hash("resume_thread"), ResumeCoroutineCommand)
	
	return this;
end

setmetatable(Module, {
	-- this method used when table used as function
	__call = function(t, ...)
		return Module.new(...)
	end
})

return Module;