local ResumeCoroutineCommand = require "main.frameworck.commands.ResumeCoroutineCommand"
local TreeBehaviourManager = require "main.frameworck.TreeBehaviourManager"

local Module = {}

Module.SELECTOR = TreeBehaviourManager.SELECTOR;
Module.SEQUENCE = TreeBehaviourManager.SEQUENCE;
Module.CONDITION = TreeBehaviourManager.CONDITION;

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
	local command_runner = TreeBehaviourManager.new(this);
	
	local function create_coroutine(id, message)
		local thread_id = UNIQUE_ID();
		local co = coroutine.create( function () 
			--print("Module coroutine:: start branch - " .. id);
			command_runner.run(actions[id], message, thread_id)
			if coroutines[thread_id] then
				--print("Module coroutine:: stop branch - " .. id)
				coroutines[thread_id] = nil;
			end
		end);
		coroutines[thread_id] = co;
		return co;
	end

	local function start_coroutine(co)
		assert(coroutine.resume(co));
	end

	function this.on_message(id, message)
		if message and message.coroutine then 
			local co = create_coroutine(id, message);
			start_coroutine(co);
		else
			--print("Module:: run branch:: " .. id);
			command_runner.run(actions[id], message, nil);
			--print("Module:: end branch:: " .. id);
		end
	end

	function this.bind_action(message_id, action)
		actions[message_id] = action;
		return this;
	end

	function this.register_command(id, command)
		commands[id] = command;
		return this;
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
		return Module.new()
	end
})

return Module;
