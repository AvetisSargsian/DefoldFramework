local PersistanceManager = {}

local GAME_NAME = "NanogramGame";
local GAME_FILE_PREFIX = "NanogramGameData_";

function PersistanceManager.getGameName()
	return GAME_NAME;
end

function PersistanceManager.save(leveData, chapter)
	chapter = chapter or "";
	local full_name = GAME_FILE_PREFIX .. chapter;
	local my_file_path = sys.get_save_file(GAME_NAME, full_name)
	pprint("SAVE PATH - ", my_file_path)
	if not sys.save(my_file_path, leveData) then
		print("Can't save data");
	end
end

function PersistanceManager.load(chapter)
	chapter = chapter or "";
	local full_name = GAME_FILE_PREFIX .. chapter;
	local file_path = sys.get_save_file(GAME_NAME, full_name)
	local data_table = sys.load(file_path)
	if not next(data_table) then
		return nil;
	end
	return data_table;
end

function PersistanceManager.loadResorces(adress)
	local data = assert(sys.load_resource(adress));
	if data then
		return json.decode(data)
	end
	return nil
end

return PersistanceManager;