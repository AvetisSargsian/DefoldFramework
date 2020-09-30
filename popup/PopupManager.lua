local PopupManager = {}

local popups_factorys = {};
local open_popups = {};

function PopupManager.register_popup(id, factory)
	popups_factorys[id] = factory;
end

function PopupManager.open_popup(id, data)
	if not popups_factorys[id] then return end
	local collection_popup = collectionfactory.create(popups_factorys[id]);
	local col_pop_ui = collection_popup[hash("/popup")];
	local url = msg.url(nil, col_pop_ui, "ui");
	open_popups[id] = url;
	msg.post(url, "open_popup", data);
end

function PopupManager.close_popup(id)
	if not open_popups[id] then return end
	msg.post(open_popups[id], "close_popup");
	collectionfactory.unload(popups_factorys[id])
	open_popups[id] = nil;
end

function PopupManager.is_open(id)
	if open_popups[id] then 
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