local function cleanItem(item)
	local t = typeof(item)
	if t == "Instance" then
		item:Destroy()
	elseif t == "RBXScriptConnection" then
		item:Disconnect()
	elseif type(item) == "table" then
		if type(item.Destroy) == "function" then
			item:Destroy()
		elseif type(item.Disconnect) == "function" then
			item:Disconnect()
		elseif type(item.destroy) == "function" then
			item:destroy()
		end
	elseif type(item) == "function" then
		item()
	end
end

local Trove = {}
Trove.__index = Trove

function Trove.new()
	return setmetatable({ _items = {} }, Trove)
end

function Trove:Add(item)
	table.insert(self._items, item)
	return item
end

function Trove:Connect(signal, fn)
	return self:Add(signal:Connect(fn))
end

function Trove:Construct(class, ...)
	return self:Add(class.new(...))
end

function Trove:Extend()
	return self:Construct(Trove)
end

function Trove:Remove(item)
	for i, v in self._items do
		if v == item then
			table.remove(self._items, i)
			cleanItem(v)
			return true
		end
	end
	return false
end

function Trove:Clean()
	for i = #self._items, 1, -1 do
		cleanItem(self._items[i])
	end
	table.clear(self._items)
end

Trove.Destroy = Trove.Clean

return Trove
