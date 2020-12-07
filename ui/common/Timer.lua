
local Timer = {}

function Timer.new(node)

	local this = {}
	this.node = node;

	local start_time = 0;
	local minutes = 0;
	local seconds = 0;
	local hours = 0;
	local isRunning = false;

	local function update_node()
		if this.node then 
			local min_str = minutes > 9 and tostring(minutes) or "0" .. minutes;
			local sec_str = seconds > 9 and tostring(seconds) or "0" .. seconds;
			
			gui.set_text(this.node, hours .. ":" .. min_str .. ":" .. sec_str);
		end
	end

	function this.enterFrame(dt)
		if not isRunning then return; end
		
		local timePassed = os.time() - start_time;
		seconds = math.floor(timePassed % 60);
		minutes = math.floor((timePassed / 60) % 60);
		hours = math.floor((timePassed / 3600) % 24);

		update_node();
	end	

	function this.get_minutes()
		return minutes;
	end

	function this.get_seconds()
		return seconds;
	end

	function this.get_hours()
		return hours;
	end

	function this.start(self)
		isRunning = true;
		start_time = os.time();
	end

	function this.stop(self)
		isRunning = false;
		start_time = 0;
		minutes = 0;
		seconds = 0;
		milliseconds = 0;
	end

	return this;
end

return Timer;