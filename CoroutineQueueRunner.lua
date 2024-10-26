local CoroutineQueueRunner = {}

function CoroutineQueueRunner.new()
	local is_busy = false;
	local coroutines_queue = {};
	local curent_coroutine = nil;
	local this = {};

	function this.execute_next()
		is_busy = false;
		curent_coroutine = nil;

		if table.getn(coroutines_queue) > 0 then
			is_busy = true;
			curent_coroutine = coroutines_queue[1];
			table.remove(coroutines_queue, 1);
			assert(coroutine.resume(curent_coroutine));
		end
	end

	function this.execute()
		if not is_busy then
			this.execute_next();
		end
	end

	function this.add_to_queue(co)
		table.insert(coroutines_queue, co);
		print("coroutines_queue - ", table.getn(coroutines_queue))
		this.execute();
	end

	return this;
end

return CoroutineQueueRunner;
