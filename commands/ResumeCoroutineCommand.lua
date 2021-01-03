local function ResumeCoroutineCommand(module, data, thread_id)
	print('--ResumeCoroutineCommand')
	local co = module.get_coroutine(data.thread_id);
	if co then 
		assert(coroutine.resume(co));
		return true;
	end
	return false;
end

return ResumeCoroutineCommand

