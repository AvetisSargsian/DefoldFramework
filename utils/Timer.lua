local Timer = {}

Timer.STATE = {
	IDLE = "Timer.IDLE",
	RUNNING = "Timer.RUNNING",
	STOPPED = "Timer.STOPPED",
	POUSED = "Timer.POUSED"
}

function Timer.new(time, callback, ...)
	local this = {};

	local _callBack = callback;
	local _on_update = nil;
	local _callBack_args = {...};
	local _current_time = 0;
	local _state = Timer.STATE.IDLE;

	local function call_func(func, args)
		if func and type(func) == "function" then
			func(unpack(args));
		end
	end

	function this.start()
		if _state == Timer.STATE.IDLE then
			_current_time = time;
			_state = Timer.STATE.RUNNING;
		end
	end

	function this.stop()
		if _state == Timer.STATE.RUNNING then
			_state = Timer.STATE.STOPPED;
			_current_time = 0;
		end
	end

	function this.pouse()
		if _state == Timer.STATE.RUNNING then
			_state = Timer.STATE.POUSED;
		end
	end

	function this.resume()
		if _state == Timer.STATE.POUSED then
			_state = Timer.STATE.RUNNING;
		end
	end

	function this.reset()
		_state = Timer.STATE.IDLE;
		_current_time = 0;
	end

	function this.set_callback(cb, ...)
		_callBack = cb;
		_callBack_args = {...};
	end

	function this.set_on_update(cb)
		_on_update = cb;
	end

	function this.update(dt)
		if dt == nil then return; end
		if _state ~= Timer.STATE.RUNNING then return; end
		_current_time = _current_time - dt;

		if _on_update then _on_update(dt); end

		if _current_time <= 0 then
			this.stop();
			call_func(_callBack, _callBack_args);
		end
	end

	return this;
end

return Timer;