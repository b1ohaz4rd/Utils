local API = {}

function API:Load()
    API.Services = {}
    setmetatable(API.Services, {
        __index = function(_, Service_Name)
            return game:GetService(Service_Name)
        end
    })
end

function API:GetPlayerHeadshot()
    local Request = (syn and syn.request or http_request or request){
        Url = "https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds="..game.Players.LocalPlayer.UserId.."&size=720x720&format=Png&isCircular=false"
    }
    local HttpService = game:GetService("HttpService")
    local Body = HttpService:JSONDecode(Request.Body)
    return Body.data[1].imageUrl
end

function API:Webhook(Url, Data)
    (syn and syn.request or http_request or request){
        Url = Url,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = game:GetService("HttpService"):JSONEncode(Data)
    }
end

function API:VirtualPressButton(Button)
    game:GetService("VirtualInputManager"):SendKeyEvent(true, Button, false, nil)
    task.wait()
    game:GetService("VirtualInputManager"):SendKeyEvent(false, Button, false, nil)
end

function API:RobloxNotify(Title, Description, Duration)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = Title;
            Text = Description;
            Duration = Duration;
        })
    end)
end

function API:Player()
    return game:GetService("Players").LocalPlayer
end

function API:Character()
    return self:Player().Character
end

function API:Root()
    return self:Character():WaitForChild("HumanoidRootPart")
end

function API:Humanoid()
    return self:Character():WaitForChild("Humanoid")
end

function API:Teleport(CFrame)
    self:Root().CFrame = CFrame
end

function API:Magnitude(Pos1, Pos2)
    return (Pos1 - Pos2).Magnitude
end

function API:Tween(Object, Studs)
    pcall(function()
        local Time = self:Magnitude(self:Root(), Object) / Studs
        local Tween = game:GetService("TweenService"):Create(self:Root(), TweenInfo.new(Time, Enum.EasingStyle.Linear), { CFrame = CFrame.new(Object) })
        Tween:Play()
        Tween.Completed:Wait()
    end)
end

function API:Pathfind(Destination, Speed)
    local Path = game:GetService("PathfindingService"):CreatePath({ AgentCanJump = true, AgentCanClimb = true })

    local Success, ErrorMessage = pcall(function()
        Path:ComputeAsync(self:Root().Position, Destination)
    end)

    if Success and Path.Status == Enum.PathStatus.Success then
        local Waypoints = Path:GetWaypoints()

        for _, Waypoint in next, Waypoints do
            if self:Humanoid().Health <= 0 then
                break
            end
            if Waypoint.Action == Enum.PathWaypointAction.Jump then
                self:Humanoid().Jump = true
            end
            repeat task.wait() self:Humanoid():MoveTo(Waypoint.Position) until self:Humanoid().MoveToFinished
            local TimeOut = self:Humanoid().MoveToFinished:Wait(0.1)
            if not TimeOut then
                self:Humanoid().Jump = true
                self:Pathfind(Destination)
                break
            end
        end
    else
        warn(ErrorMessage)
        self:Tween(Speed, Destination)
    end
end

function API:FormatSeconds(Seconds)
    local Days = math.floor(Seconds / 86400)
    local Hours = math.floor((Seconds % 86400) / 3600)
    local Minutes = math.floor(((Seconds % 86400) % 3600) / 60)
    local RemainingSeconds = (Seconds % 86400) % 60
    local Result

    if Days == 0 then
        Result = string.format("%d:%02d:%02d", Hours, Minutes, RemainingSeconds)
    else
        Result = string.format("%d days, %d:%02d:%02d", Days, Hours, Minutes, RemainingSeconds)
    end

    return Result
end

function API:AbbreviateNumber(Number)
    local FormattedNumber
    local Abbreviations = {[10^3] = "K", [10^6] = "M", [10^9] = "B", [10^12] = "T", [10^15] = "Q", [10^18] = "Qi", [10^21] = "Sx", [10^24] = "Sp"}

    if Number < 1000 then
        FormattedNumber = string.format("%d", Number)
    else
        local Thresholds = {}
        for Threshold in next, Abbreviations do
          table.insert(Thresholds, Threshold)
        end
        table.sort(Thresholds, function(a, b) return a > b end)
        for _, Threshold in next, Thresholds do
            if Number >= Threshold then
                FormattedNumber = string.format("%.3f %s", Number / Threshold, Abbreviations[Threshold])
                break
            end
        end
    end

    return FormattedNumber
end

function API:Create(Class, Properties)
    local _Instance = Class

    if type(Class) == 'string' then
        _Instance = Instance.new(Class)
    end

    for Property, Value in next, Properties do
        _Instance[Property] = Value
    end

    return _Instance
end

return API
