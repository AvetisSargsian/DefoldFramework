local SoundManager = {}

local SOUND_DONE = hash("sound_done");
local _enabled = true;
local internal_store = {};

function SoundManager.is_enabled()
	return _enabled
end

function SoundManager.enable()
	_enabled = true
end

function SoundManager.disable()
	_enabled = false
	sound.stop()
end

function SoundManager.set_gain(value)
	for _, s in pairs(internal_store) do
		sound.set_gain(s, value);
	end
end

function SoundManager.set_group_gain(group, value)
	sound.set_group_gain(group, value)
end

function SoundManager.play_sound(sound_name, prop, callback)
	if not _enabled then return nil end
	local id = sound.play(sound_name, prop, function(self, message_id, message, sender)
		if message_id == SOUND_DONE then
			internal_store[message.play_id] = nil
			if callback then callback() end
		end
	end);
	internal_store[id] = sound_name;
	return id;
end

function SoundManager.stop_sound(sound_name)
	sound.stop(sound_name)
end

return SoundManager;