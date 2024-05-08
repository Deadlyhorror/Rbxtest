   local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()
    if not OrionLib then
        error("Failed to load the OrionLib library")
        return
    end
local Window = OrionLib:MakeWindow({
        Name = "MercilessHub",
        HidePremium = false,
        SaveConfig = true,
        ConfigFolder = "WendelCfg",
        IntroEnabled = false
    })
getgenv().Settings = {
        AutoAtk = false, 
        AutoDungeon = false, 
        AutoBuyGems = {
            [10008] = false,
            [10009] = false,
            [10010] = false,
            [10011] = false,
            [10012] = false,
            [10013] = false,
            [10014] = false,
            [10015] = false,
            [10016] = false,
         },
	mespetsequiper = {},
	Range = 200,
	AutoFarm = false,
	WalkToEnemy = false,
	DamageBoost = false,
    }
    local function AutoAtk()
        while G.AutoAtk do
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 75
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("PlayerClickAttack"):FireServer()
            wait(0.01)
        end
    end
    local PlayerTab = Window:MakeTab({
        Name = "Player",
        Icon = "rbxassetid://4483345998",
        PremiumOnly = false
    })
    local ScriptsTab = Window:MakeTab({
        Name = "Scripts",
        Icon = "rbxassetid://4483345998",
        PremiumOnly = false
    })
local AutoBuyTab = Window:MakeTab({
        Name = "Shop",
        Icon = "rbxassetid://4483345998",
        PremiumOnly = false
    })

ScriptsTab:AddToggle({
    Name = "Kill Aura/Auto Collect",
    Callback = function(state)
        if state then
            getgenv().Settings.AutoFarm = not getgenv().Settings.AutoFarm
        end
    end,
})
ScriptsTab:AddToggle({
    Name = "Damage Boost",
    Callback = function(state)
        if state then
          getgenv().Settings.DamageBoost = not getgenv().Settings.DamageBoost
        end
    end,
})
--Anti-AFk
spawn(function()
for i,v in pairs(getconnections(game:GetService("Players").LocalPlayer.Idled)) do
v:Disable()
end
end)
spawn(function()
while wait(15) do
local VirtualUser=game:service'VirtualUser'
VirtualUser:CaptureController()
VirtualUser:ClickButton2(Vector2.new())
end
end)
    ScriptsTab:AddButton({
        Name = "Auto Fuse Swords",
        Callback = function()
            while wait() do
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("FuseWeapon"):FireServer()
end
        end
    })
local playerNames = {}
for _, player in pairs(game.Players:GetPlayers()) do
    table.insert(playerNames, player.Name)
end
PlayerTab:AddDropdown(
    {
        Name = "Select Player",
        Options = playerNames,
        Callback = function(selectedPlayer)
            getgenv().Settings.selectedPlayer = selectedPlayer
        end
    }
)
PlayerTab:AddButton(
    {
        Name = "Trade Selected Player",
        Callback = function()
            if getgenv().Settings.selectedPlayer then
                game:GetService("ReplicatedStorage").Remotes.SendTrade:InvokeServer(
                    game:GetService("Players")[getgenv().Settings.selectedPlayer]
                )
            else
                warn("No player selected.")
            end
        end
    }
)
PlayerTab:AddButton(
    {Name = "Refresh Player List", Callback = function()
            playerNames = {}
            for _, player in pairs(game.Players:GetPlayers()) do
                table.insert(playerNames, player.Name)
            end
            PlayerTab:GetElement("Select Player"):UpdateOptions(playerNames)
            getgenv().Settings.selectedPlayer = nil
        end
})
  
PlayerTab:AddButton({
        Name = "Dupe",
        Callback = function()
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("DeleteMultipleHero"):Destroy()
    end
})
autoGainPower = false
autoGainPowerLoop = nil
fireDelay = 0.1 
ScriptsTab:AddToggle({
    Name = "AutoGainPower",
    Default = false,
    Callback = function(Value)
        autoGainPower = Value
        print("Auto Gain Pwr is " .. tostring(autoGainPower))
        if autoGainPower then
            autoGainPowerLoop = game:GetService("RunService").Heartbeat:Connect(function()
                local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
                if remotes and remotes:FindFirstChild("PlayerClickAttack") then
                    remotes.PlayerClickAttack:FireServer()
                end
                wait(fireDelay)
            end)
        else
            if autoGainPowerLoop then
                autoGainPowerLoop:Disconnect()
                autoGainPowerLoop = nil
            end
        end
    end
})
    ScriptsTab:AddButton({
        Name = "SimpleSpy",
        Callback = function()
            loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/78n/SimpleSpy/main/SimpleSpyBeta.lua"))()
        end
    })
    local AutoDungeonTab = Window:MakeTab({
        Name = "Auto-Dungeon",
        Icon = "rbxassetid://4483345998",
        PremiumOnly = false
    })
    local FuseTab = Window:MakeTab({
        Name = "Auto-FuseGem",
        Icon = "rbxassetid://4483345998",
        PremiumOnly = false
    })
    local FuseGem1Tab = Window:MakeTab({
        Name = "Lvl 10 Dupe",
        Icon = "rbxassetid://4483345998", PremiumOnly = false
    })

    local FuseGem2Tab = Window:MakeTab({
        Name = "Lvl 9 Dupe",
        Icon = "rbxassetid://4483345998", PremiumOnly = false
    })

    for level = 1, 9 do
        FuseGem1Tab:AddButton({
            Name = "Fuse Gem to level 10 w/ Lv." .. level,
            Callback = function()
                local function GetNextGemID(currentLevel)
                    local player = game.Players.LocalPlayer

                    local gui = player:WaitForChild("PlayerGui")
                    local gemsPanel = gui:WaitForChild("GemsPanel")
                    local frame = gemsPanel:WaitForChild("Frame")
                    local bgImage = frame:WaitForChild("BgImage")
                    local list = bgImage:WaitForChild("List")
                    local scrollingFrame = list:WaitForChild("ScrollingFrame")

                    if scrollingFrame then
                        for _, child in ipairs(scrollingFrame:GetChildren()) do
                            local numtext = child:FindFirstChild("NumText")

                            if numtext then
                                local level = tonumber(numtext.Text:match("%d+"))
                                if level == currentLevel then
                                    return child.Name -- Return the ID of the gem
                                end
                            end
                        end
                    else
                        error("Error: ScrollingFrame not found.")
                    end

                    return nil
                end

                local function FuseGems()
                    local currentLevel = level

                    while currentLevel <= 10 do
                        local gemID = GetNextGemID(currentLevel)

                        if gemID then
                            print("Level", currentLevel, "gem ID found:", gemID)
                            currentLevel = currentLevel + 1 -- Increment the level for the next iteration

                            local args = {
                                [1] = {
                                    [1] = gemID,
                                    [2] = gemID,
                                    [3] = gemID,
                                    [4] = gemID,
                                    [5] = gemID
                                }
                            }

                            print("Invoking FuseGem remote with args:", args)

                            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("FuseGem"):InvokeServer(unpack(args))
                        else
                            print("Error: Could not find gem ID for level", currentLevel)
                        end
                        wait(0.000001)
                    end
                end

                FuseGems()
            end
        })
    end

    for level = 1, 9 do
        FuseGem2Tab:AddButton({
            Name = "Fuse Gem to level 9 w/ Lv." .. level,
            Callback = function()
                local function GetNextGemID(currentLevel)
                    local player = game.Players.LocalPlayer

                    local gui = player:WaitForChild("PlayerGui")
                    local gemsPanel = gui:WaitForChild("GemsPanel")
                    local frame = gemsPanel:WaitForChild("Frame")
                    local bgImage = frame:WaitForChild("BgImage")
                    local list = bgImage:WaitForChild("List")
                    local scrollingFrame = list:WaitForChild("ScrollingFrame")

                    if scrollingFrame then
                        for _, child in ipairs(scrollingFrame:GetChildren()) do
                            local numtext = child:FindFirstChild("NumText")

                            if numtext then
                                local level = tonumber(numtext.Text:match("%d+"))
                                if level == currentLevel then
                                    return child.Name -- Return the ID of the gem
                                end
                            end
                        end
                    else
                        error("Error: ScrollingFrame not found.")
                    end

                    -- If no matching gem ID was found, return nil
                    return nil
                end

                local function FuseGems()
                    local currentLevel = level

                    while currentLevel <= 8 do
                        local gemID = GetNextGemID(currentLevel)

                        if gemID then
                            print("Level", currentLevel, "gem ID found:", gemID)
                            currentLevel = currentLevel + 1 -- Increment the level for the next iteration

                            -- Construct the args table with gemID repeated five times
                            local args = {
                                [1] = {
                                    [1] = gemID,
                                    [2] = gemID,
                                    [3] = gemID,
                                    [4] = gemID,
                                    [5] = gemID
                                }
                            }

                            print("Invoking FuseGem remote with args:", args)

                            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("FuseGem"):InvokeServer(unpack(args))
                        else
                            print("Error: Could not find gem ID for level", currentLevel)
                        end

                        -- Wait for some time before checking for the next level
                        wait(0.000001)
                    end
                end

                FuseGems()
            end
        })
    end

local a=Window:MakeTab({Name="Roll-Tab",Icon="rbxassetid://4483345998",PremiumOnly=false})local b=a:AddButton({Name="Reroll Mask",Callback=function()local c=false;repeat local d={[1]=400001}local e=game:GetService("ReplicatedStorage").Remotes.RerollOrnament:InvokeServer(unpack(d))wait(.1)if tostring(e.ornamentId)~="410001"and tostring(e.ornamentId)~="410002"and tostring(e.ornamentId)~="410003"and tostring(e.ornamentId)~="410004"and tostring(e.ornamentId)~="410005"then print("Unknown reroll found ! : "..tostring(e.ornamentId))c=true end;if tostring(e.ornamentId)=="410004"or tostring(e.ornamentId)=="410005"then local f="None"if tostring(e.ornamentId)=="410004"then f="Legendary"elseif tostring(e.ornamentId)=="410005"then f="Rainbow"end;print("!! REROLL FOUND !! : "..f)c=true end until c;print("Script stopped !")end})local b=a:AddButton({Name="Reroll Awakening",Callback=function()local c=false;repeat local d={[1]=400002}local e=game:GetService("ReplicatedStorage").Remotes.RerollOrnament:InvokeServer(unpack(d))wait(.1)if tostring(e.ornamentId)~="410006"and tostring(e.ornamentId)~="410007"and tostring(e.ornamentId)~="410008"and tostring(e.ornamentId)~="410009"and tostring(e.ornamentId)~="410010"then print("Unknown reroll found ! : "..tostring(e.ornamentId))c=true end;if tostring(e.ornamentId)=="410009"or tostring(e.ornamentId)=="410010"then local f="None"if tostring(e.ornamentId)=="410009"then f="Legendary"elseif tostring(e.ornamentId)=="410010"then f="Rainbow"end;print("!! REROLL FOUND !! : "..f)c=true end until c;print("Script stopped !")end})local b=a:AddButton({Name="Reroll Ornament",Callback=function()local c=false;repeat local d={[1]=400003}local e=game:GetService("ReplicatedStorage").Remotes.RerollOrnament:InvokeServer(unpack(d))wait(.1)if tostring(e.ornamentId)~="410011"and tostring(e.ornamentId)~="410012"and tostring(e.ornamentId)~="410013"and tostring(e.ornamentId)~="410014"and tostring(e.ornamentId)~="410015"then print("Unknown reroll found ! : "..tostring(e.ornamentId))c=true end;if tostring(e.ornamentId)=="410014"or tostring(e.ornamentId)=="410015"then local f="None"if tostring(e.ornamentId)=="410014"then f="Legendary"elseif tostring(e.ornamentId)=="410015"then f="Rainbow"end;print("!! REROLL FOUND !! : "..f)c=true end until c;print("Script stopped !")end})local b=a:AddButton({Name="Reroll Trail",Callback=function()local c=false;repeat local d={[1]=400004}local e=game:GetService("ReplicatedStorage").Remotes.RerollOrnament:InvokeServer(unpack(d))wait(.1)if tostring(e.ornamentId)~="410016"and tostring(e.ornamentId)~="410017"and tostring(e.ornamentId)~="410018"and tostring(e.ornamentId)~="410019"and tostring(e.ornamentId)~="410020"then print("Unknown reroll found ! : "..tostring(e.ornamentId))c=true end;if tostring(e.ornamentId)=="410019"or tostring(e.ornamentId)=="410020"then local f="None"if tostring(e.ornamentId)=="410019"then f="Legendary"elseif tostring(e.ornamentId)=="410020"then f="Rainbow"end;print("!! REROLL FOUND !! : "..f)c=true end until c;print("Script stopped !")end})
 
local function a(b)local c=game.Players.LocalPlayer;local d=c:WaitForChild("PlayerGui")local e=d:WaitForChild("GemsPanel")local f=e:WaitForChild("Frame")local g=f:WaitForChild("BgImage")local h=g:WaitForChild("List")local i=h:WaitForChild("ScrollingFrame")local j,k,l,m,n;if i then local o=0;for p,q in ipairs(i:GetChildren())do if o>=5 then break end;local r=q:FindFirstChild("NumText")if r and r.Text=="Lv."..b then o=o+1;if o==1 then j=q.Name elseif o==2 then k=q.Name elseif o==3 then l=q.Name elseif o==4 then m=q.Name elseif o==5 then n=q.Name end end end;if o>0 then print("Gem IDs found:")print("gem1:",j)print("gem2:",k)print("gem3:",l)print("gem4:",m)print("gem5:",n)else print("No gem IDs found.")end else error("Error: ScrollingFrame not found.")end;return j,k,l,m,n end;local function s(b)while true do local j,k,l,m,n=a(b)if j and k and l and m and n then local t={[1]={[1]=j,[2]=k,[3]=l,[4]=m,[5]=n}}print("Invoking FuseGem remote with args:",t)game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("FuseGem"):InvokeServer(unpack(t))else print("Error: Could not find five gem IDs.")end;wait(0.1)end end;for u=1,9 do FuseTab:AddToggle({Name="Auto Fuse Lvl "..u.." Gems",Default=false,Callback=function(v)getgenv().Settings["AutoFuseGemsLevel"..u]=v;if v then while getgenv().Settings["AutoFuseGemsLevel"..u]do s(u)end end end})end
    
local AutoRaidTab = Window:MakeTab({
        Name = "Auto-Raid",
        Icon = "rbxassetid://4483345998",
        PremiumOnly = false
    })
AutoRaidTab:AddButton({
        Name = "AutoCollectChestInRaid",
        Callback = function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/xALLQWT/AUTORAID/main/g'))() 
        end
    })
    local difficultyDropdown = AutoRaidTab:AddDropdown({
        Name = "Difficulty",
        Options = {"Easy", "Medium", "Hard", "Impossible"},
        CurrentOption = "1",
        Callback = function(option)
            G.difficulty = tonumber(option)
        end
    })
    local AutoRaidToggle = AutoRaidTab:AddToggle({
        Name = "Auto-Raid",
        Default = false,
        Callback = function(Value)
            if Value then
                local function restartScript()
                    local userID = game.Players.LocalPlayer.UserId
                    local args = {
                        [1] = "Room3"
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("EnterRaidRoom"):FireServer(unpack(args))
                    args = {
                        [1] = {
                            ["difficulty"] = G.difficulty,
                            ["roomName"] = "Room3",
                            ["selectMapId"] = 50105
                        }
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SelectRaidsDifficulty"):FireServer(unpack(args))
                    args = {
                        [1] = {
                            ["userIds"] = {
                                [1] = userID
                            },
                            ["roomName"] = "Room3"
                        }
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("StartChallengeRaidMap"):InvokeServer(unpack(args))
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("LocalPlayerTeleportSuccess"):InvokeServer()
                    wait(240)
                    args = {
                        [1] = {
                            ["currentSlotIndex"] = 1,
                            ["toMapId"] = 50201
                        }
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("QuitRaidsMap"):InvokeServer(unpack(args))
                    wait(60)
                    restartScript()
                end
                restartScript()
            end
        end
    })

local function TeleportToAndFromDungeon(dungeonMapId, returnMapId, returnTime)
    -- Teleport the player to the specified dungeon
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("LocalPlayerTeleport"):FireServer(
        {
            ["mapId"] = dungeonMapId
        }
    )
    wait(returnTime)
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("LocalPlayerTeleport"):FireServer(
        {
            ["mapId"] = returnMapId
        }
    )
end
local AutoDungeonToggle =
    AutoDungeonTab:AddToggle(
    {
        Name = "Auto-Dungeon(FINALLY FIXED!!!)",
        Default = false,
        Callback = function(Value)
            if Value then
                while true do
                    local currentTime = os.time()
                    local nextTeleportTime = math.ceil(currentTime / (30 * 60)) * (30 * 60) - 15
                    local waitTime = nextTeleportTime - currentTime
                    wait(waitTime)
                    TeleportToAndFromDungeon(50016, 50001, 15 * 60)
                end
            end
        end
    }
)
           
		spawn(function()
                while wait(1) do
                    for _, v in pairs(game.Workspace.Golds:GetChildren()) do
                        v.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                    end
                end
            end)
		local WeaponsInventory = require(game:GetService("ReplicatedStorage").Scripts.Client.Manager.PlayerManager)
            pcall(function()
                for _, v in pairs(WeaponsInventory.localPlayerData.heros) do
                    if v.isEquip == true then
                        table.insert(getgenv().Settings.mespetsequiper, v.guid)
                    end
                end
            end)

            spawn(function()
                local function Getenemies()
                    local nearest, dist = nil, getgenv().Settings.Range
                    local Players = game.Players
                    local localPlayer = Players.LocalPlayer
                    local localCharacter = localPlayer.Character
                    local humanoidRootPart = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")
                    if not humanoidRootPart then return end
                    for _, enemy in pairs(Workspace.Enemys:GetChildren()) do
                        if enemy:FindFirstChild("HumanoidRootPart") and enemy.HumanoidRootPart:FindFirstChild("EnemyNameGui") and enemy.HumanoidRootPart.EnemyNameGui.HealthNum.Text ~= "0" then
                            local distance = (humanoidRootPart.Position - enemy.HumanoidRootPart.Position).magnitude
                            if distance < dist then
                                dist = distance
                                nearest = enemy
                            end
                        end
                    end
                    return nearest
                end
                while task.wait() do
                    if getgenv().Settings.AutoFarm then
                        local nearestEnemy = Getenemies()
                        if nearestEnemy then
                            spawn(function()
                                if getgenv().Settings.WalkToEnemy then
                                    if nearestEnemy:FindFirstChild("HumanoidRootPart") then
                                        player.Character.Humanoid:MoveTo(nearestEnemy.HumanoidRootPart.Position)
                                    end
                                end
                            end)
                            spawn(function()
                                local args = { nearestEnemy:GetAttribute("EnemyGuid") }
                                game:GetService("ReplicatedStorage").Remotes.ClickEnemy:InvokeServer(unpack(args))
                                game:GetService("ReplicatedStorage").Remotes.PlayerClickAttack:FireServer(unpack(args))
                            end)
    		if getgenv().Settings.DamageBoost then
                                for c, d in pairs(getgenv().Settings.mespetsequiper) do
                                    local a = { [1] = { ["heroGuid"] = tostring(d), ["harmIndex"] = 1, ["isSkill"] = false, ["skillId"] = 200003 } }
                                    game:GetService("ReplicatedStorage").Remotes.HeroSkillHarm:FireServer(unpack(a))
                                end
                            end
                        end
                    end
		end
            end)

