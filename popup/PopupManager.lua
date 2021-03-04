local PopupManager = {}

local popups_factorys = {};
local open_popups = {};
local queue = {};
local is_open = false;

function PopupManager.register_popup(id, factory)
	popups_factorys[id] = factory;
end

function PopupManager.open_popup(id, data)
	if not popups_factorys[id] then return end
	local collection_popup = collectionfactory.create(popups_factorys[id]);
	local col_pop_ui = collection_popup[hash("/popup")];
	local url = msg.url(nil, col_pop_ui, "ui");
	open_popups[id] = {url = url, go = collection_popup};
	is_open = true;
	msg.post(url, "open_popup", data);
end

function PopupManager.add_to_queue(id, data, position)
	if #queue > 0 then
		position = 2;
	end
	table.insert(queue, position or #queue + 1, {id = id, data = data})
	PopupManager.check_queue();
end

function PopupManager.check_queue()
	if #queue > 0 and not is_open then
		PopupManager.open_popup(queue[1].id, queue[1].data);
	end
end

function PopupManager.delete_queue()
	table.remove(queue, 1);
	is_open = false;
	PopupManager.check_queue();
end

function PopupManager.close_popup(id)
	if not open_popups[id] then return end
	msg.post(open_popups[id].url, "close_popup");
	collectionfactory.unload(popups_factorys[id])
	open_popups[id].url = nil;
end

function PopupManager.get_go(id)
	return open_popups[id].go;
end

function PopupManager.is_open(id)
	if open_popups[id] and open_popups[id].url then 
		return true;
	else
		return false;
	end
end

function PopupManager.clear_registry()
	popups_factorys = {};
	open_popups = {};
end

return PopupManager;