local cleaner = {};
cleaner.__index = cleaner;

function cleaner.new()
	local self = {
		threads = {};
		connections = {};
		functions = {};
	};
	
	return setmetatable(self, cleaner);
end

function cleaner:add_thread(id, func)
	self.threads[id] = task.spawn(func);
end

function cleaner:add_connection(id, connection)
	self.connections[id] = connection;
end

function cleaner:add_function(id, _function)
	self.functions[id] = _function;
end

function cleaner:get_by_id(id)
	return self.threads[id] or self.connections[id] or self.functions[id];
end

function cleaner:clean_up()
	for _, thread in self.threads do
		task.cancel(thread);
	end
	
	for _, connection in self.connections do
		connection:Disconnect();
	end
	
	for _, _function in self.functions do
		_function();
	end
end

return cleaner;
