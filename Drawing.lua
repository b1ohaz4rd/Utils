local Drawing = {}
Drawing.__index = Drawing

function Drawing.New()
    local self = setmetatable({}, Drawing)
    self.Cache = {}

    return self
end

function Drawing:Add(ID, Type, Props)
    local Item = Drawing.New(Type)
    for i, v in next, Props do
        Item[i] = v
    end
    self.Cache[ID] = Item
    return Item
end

function Drawing:Delete(ID)
    self.Cache[ID]:Remove()
    self.Cache[ID] = nil
end

function Drawing:ClearAll()
    for _, Cache in pairs(self.Cache) do
        Cache:Remove()
    end
end

function Drawing:Destroy()
    self:ClearAll()

    setmetatable(self, nil)
end

return Drawing
