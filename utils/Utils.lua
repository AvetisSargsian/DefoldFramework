local Utils = {};

local store = {};

function Utils.set_time_out(time, callBack, ...)
    table.insert(store, {time = time, callBack = callBack, args={...}})
end

function Utils.run_coroutine(func, ...)
    local co = coroutine.create(func);
    local ok , err = coroutine.resume(co, ...);
    if not ok then 
        error("Error in co-routine: " .. err);
    end
    return co;
end

function Utils.pouse_coroutine(time, data)
    local co = coroutine.running();
    if co then
        if time > -1 then
            Utils.set_time_out(time, coroutine.resume, co);
        end
        coroutine.yield(data);
    end
end

function Utils.update(dt)
    if dt == nil then return end
    
    local item;
    for i = #store, 1, -1 do
        item = store[i];
        item.time = item.time - dt;
        if item.time <= 0 then
            table.remove(store, i)
            if item.callBack and type(item.callBack) == "function" then
                item.callBack(unpack(item.args));
            end
        end
    end
end

return Utils;
