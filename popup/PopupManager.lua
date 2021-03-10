local PopupManager = {}

local popups_factorys = {};
local open_popups = nil;
local queue = {};

function PopupManager.register_popup(id, factory)
	popups_factorys[id] = factory;
end

local function open_popup(id, data)
	if not popups_factorys[id] then return end
	local collection_popup = collectionfactory.create(popups_factorys[id]);
	local col_pop_ui = collection_popup[hash("/popup")];
	local url = msg.url(nil, col_pop_ui, "ui");
	open_popups = {id = id, url = url, go = collection_popup};
	table.remove(queue, 1);
	msg.post(url, "open_popup", data);
end

local function check_queue()
	if #queue > 0 and not open_popups then
		open_popup(queue[1].id, queue[1].data);
	end
end

function PopupManager.add_first(id, data)
	table.insert(queue, 1, {id = id, data = data})
	check_queue();
end

function PopupManager.add_last(id, data)
	table.insert(queue, {id = id, data = data})
	check_queue();
end

function PopupManager.update_queue()
	open_popups = nil;
	check_queue();
end

function PopupManager.close_popup(id, data)
	if not open_popups or open_popups.id ~= id then return end
	msg.post(open_popups.url, "close_popup", {data = data});
	collectionfactory.unload(popups_factorys[id])
end

function PopupManager.get_go()
	return open_popups.go;
end

function PopupManager.get_url()
	return open_popups.url;
end

function PopupManager.is_open(id)
	if open_popups and open_popups.id == id then 
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