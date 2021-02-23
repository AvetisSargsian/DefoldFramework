
local Timer = {}

function Timer.new(node, start, callback)

	local this = {}
	this.node = node;

	local start_time = start + os.time() or 0;
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

		local timePassed
		
		if start then
			timePassed = start_time - os.time();
		else
			timePassed = os.time() - start_time;
		end
		
		seconds = math.floor(timePassed % 60);
		minutes = math.floor((timePassed / 60) % 60);
		hours = math.floor((timePassed / 3600) % 24);

		if timePassed <= 0 then
			callback();
		end

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
		if not start then
			start_time = os.time();
		end
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