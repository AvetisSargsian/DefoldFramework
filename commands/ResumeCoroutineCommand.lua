local function ResumeCoroutineCommand(module, data, thread_id)
	print('ResumeCoroutineCommand')
	local co = module.get_coroutine(data.thread_id);
	if co then 
		assert(coroutine.resume(co));
	end
	return true;
end

return ResumeCoroutineCommand

