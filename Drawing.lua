local DrawingLibrary = {}
DrawingLibrary.__index = DrawingLibrary

function DrawingLibrary.New()
    local self = setmetatable({}, DrawingLibrary)
    self.Cache = {}

    return self
end

function DrawingLibrary:Add(ID, Type, Props)
    local Item = Drawing.new(Type)
    for i, v in next, Props do
        Item[i] = v
    end
    self.Cache[ID] = Item
    return Item
end

function DrawingLibrary:Delete(ID)
    self.Cache[ID]:Remove()
    self.Cache[ID] = nil
end

function DrawingLibrary:ClearAll()
    for _, Cache in pairs(self.Cache) do
        Cache:Remove()
    end
end

function DrawingLibrary:Destroy()
    self:ClearAll()

    setmetatable(self, nil)
end

return DrawingLibrary
