local ConnectionLibrary = {}

function ConnectionLibrary:AddConnection(Info, Path)
    table.insert(Path, Info)
end

function ConnectionLibrary:RemoveConnection(Name, Path)
    for i = 1, #Path do
        if Path[i].Name == Name then
            Path[i].Connection:Disconnect()
            table.remove(Path, i)
            return
        end
    end
end

function ConnectionLibrary:DisconnectAll(Path)
    for i = #Path, 1, -1 do
        Path[i].Connection:Disconnect()
        table.remove(Path, i)
    end
end

return ConnectionLibrary
