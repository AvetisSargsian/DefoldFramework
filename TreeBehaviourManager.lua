local TreeBehaviourManager = {}
	
TreeBehaviourManager.SELECTOR = "selector";
TreeBehaviourManager.SEQUENCE = "sequence";
TreeBehaviourManager.CONDITION = "condition";

function TreeBehaviourManager.new(module)
	local this = {}
	local run_action;
	
	local function runSequence(actions, message, thread_id)
		for _, action in ipairs(actions) do 
			if not run_action(action, message, thread_id) then 
				return false 
			end
		end
		return true;
	end

	local function runSelector(actions, message, thread_id)
		for _, action in ipairs(actions) do 
			run_action(action, message, thread_id)
		end
		return true;
	end

	local function runCondition(actions, message, thread_id)
		if run_action(actions.condition, message, thread_id) then
			return run_action(actions.success, message, thread_id);
		else
			return run_action(actions.fail, message, thread_id);
		end
	end

	run_action = function (action, message, thread_id)
		if not action then
			print("MESSAGE: " .. " NO BRANCH")
			return false;
		end
		if type(action) == "table" then
			if action.type == TreeBehaviourManager.SELECTOR then
				return runSelector(action, message, thread_id);
			elseif action.type == TreeBehaviourManager.SEQUENCE then
				return runSequence(action, message, thread_id);
			elseif action.type == TreeBehaviourManager.CONDITION then
				return runCondition(action, message, thread_id)
			end
		elseif type(action) == "function" then
			return action(module, message, thread_id);
		end
	end
	
	function this.run(action, message, thread_id)
		run_action(action, message, thread_id);
	end
	
	return this;
end

return TreeBehaviourManager
