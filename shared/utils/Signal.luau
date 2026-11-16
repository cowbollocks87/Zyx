local Signal = {}
Signal.__index = Signal

function Signal.new()
	return setmetatable({
		_conns = {},
		_waiting = {},
	}, Signal)
end

function Signal:Connect(fn)
	local conn = { fn = fn, connected = true }

	function conn:Disconnect()
		self.connected = false
	end

	table.insert(self._conns, conn)
	return conn
end

function Signal:Once(fn)
	local conn
	conn = self:Connect(function(...)
		conn:Disconnect()
		fn(...)
	end)
	return conn
end

function Signal:Fire(...)
	for i = #self._conns, 1, -1 do
		local c = self._conns[i]
		if c.connected then
			task.spawn(c.fn, ...)
		else
			table.remove(self._conns, i)
		end
	end
	for _, thread in self._waiting do
		task.spawn(thread, ...)
	end
	table.clear(self._waiting)
end

function Signal:Wait()
	table.insert(self._waiting, coroutine.running())
	return coroutine.yield()
end

function Signal:DisconnectAll()
	for _, c in self._conns do
		c.connected = false
	end
	table.clear(self._conns)
	table.clear(self._waiting)
end

function Signal:Destroy()
	self:DisconnectAll()
end

return Signal
