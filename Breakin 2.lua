-- [[ WindUI Integration for Breakin 2 ]] --

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

-- Load WindUI
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

-- Check Place ID
if game.PlaceId == 14775231477 or game.PlaceId == 13864661000 then
	-- LOBBY MODE
	local Window = WindUI:CreateWindow({
		Title = "Breaking Blitz | Lobby",
		Icon = "solar:star-bold",
		Folder = "BreakinLobby",
		OpenButton = {
			Title = "UI",
			Scale = 0.35, -- ปุ่มย่อขนาดเล็ก
			Draggable = true,
			Color = ColorSequence.new(Color3.fromHex("#7775F2"), Color3.fromHex("#257AF7")),
		},
	})

	local Tab = Window:Tab({ Title = "Free Gamepasses", Icon = "solar:gift-bold" })

	Tab:Button({
		Title = "Free Hacker Role",
		Callback = function()
			ReplicatedStorage.RemoteEvents.OutsideRole:FireServer("Phone", true, false)
		end,
	})

	Tab:Button({
		Title = "Free Nerd Kid Role",
		Callback = function()
			ReplicatedStorage.RemoteEvents.OutsideRole:FireServer("Book", true, false)
		end,
	})

	for _, v in pairs(workspace:GetChildren()) do
		if v.Name == "Part" and v:FindFirstChild("TouchInterest") then
			firetouchinterest(v, LocalPlayer.Character.HumanoidRootPart, 0)
		end
	end

elseif game.PlaceId == 13864667823 then
	-- MAIN GAME MODE
	local Window = WindUI:CreateWindow({
		Title = "Breakin 2 | WindUI Hub",
		Icon = "solar:shield-bold",
		Folder = "Breakin2Hub",
		OpenButton = {
			Title = "Menu",
			Scale = 0.35, -- ปุ่มย่อเปิด/ปิดแบบกะทัดรัด
			Draggable = true,
			Color = ColorSequence.new(Color3.fromHex("#30FF6A"), Color3.fromHex("#257AF7")),
		},
	})

	-- Variables & State Controls
	local Events = ReplicatedStorage:WaitForChild("Events")
	local SelectedItem = "Med Kit"
	local Damange = 5
	local ModifiedWalkspeed = 50
	local ModifiedJumpPower = 100
	local OriginalWalkspeed = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character.Humanoid.WalkSpeed or 16
	local OriginalJumpPower = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character.Humanoid.JumpPower or 50
	local HailClone = workspace:FindFirstChild("Hails") and workspace.Hails:Clone() or nil

	getgenv().RemoveSlipping = false
	getgenv().SemiGodmode = false
	getgenv().HealLoop = false
	getgenv().HealAllLoop = false
	getgenv().KillAllLoop = false
	getgenv().BreakAllLoop = false
	getgenv().BringAllLoop = false
	getgenv().NoWind = false
	getgenv().NoWindSS = false
	getgenv().CollectAllCash = false
	getgenv().AutoPete = false
	getgenv().Noclipping = false
	getgenv().Float = false

	-- Metatable Hooks
	local mt = getrawmetatable(game)
	local old = mt.__namecall
	setreadonly(mt, false)
	mt.__namecall = newcclosure(function(self, ...)
		local args = {...}
		if getnamecallmethod() == 'FireServer' and self.Name == 'IceSlip' and getgenv().RemoveSlipping then
			return task.wait(387420489)
		end
		return old(self, unpack(args))
	end)

	local namecall
	namecall = hookmetamethod(game, "__namecall", function(self, ...)
		local args = {...}
		if getnamecallmethod() == 'FireServer' and self.Name == 'Energy' then
			if getgenv().SemiGodmode then
				if args[1] and args[1] < 0 then args[1] = 0 end
			end
			return namecall(self, unpack(args))
		end
		return namecall(self, ...)
	end)

	-- Core Logic Functions
	local function Notify(title, content)
		WindUI:Notify({ Title = title, Content = content, Duration = 3 })
	end

	local function TeleportTo(cf)
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			LocalPlayer.Character.HumanoidRootPart.CFrame = cf
		end
	end

	local function Delete(inst)
		pcall(function() Events:WaitForChild("OnDoorHit"):FireServer(inst) end)
	end

	local function GiveItem(Item)
		if Item == "Armor" then
			Events:WaitForChild("Vending"):FireServer(3, "Armor2", "Armor", tostring(LocalPlayer), 1)
		elseif Item:find("Crowbar") or Item == "Bat" or Item == "Pitchfork" or Item == "Hammer" or Item == "Wrench" or Item == "Broom" then
			Events.Vending:FireServer(3, tostring(Item:gsub(" ", "")), "Weapons", LocalPlayer.Name, 1)
		else
			Events:WaitForChild("GiveTool"):FireServer(tostring(Item:gsub(" ", "")))
		end
	end

	local function HealYourself()
		GiveItem("Pizza")
		Events.Energy:FireServer(25, "Pizza")
	end

	local function HealAllPlayers()
		for _, v in pairs(LocalPlayer.Character:GetChildren()) do if v:IsA("Tool") then v.Parent = LocalPlayer.Backpack end end
		task.wait(.1)
		GiveItem("Golden Apple")
		task.wait(.2)
		if LocalPlayer.Backpack:FindFirstChild("GoldenApple") then
			LocalPlayer.Backpack.GoldenApple.Parent = LocalPlayer.Character
		end
		task.wait(.2)
		Events:WaitForChild("HealTheNoobs"):FireServer()
	end

	local function Train(Ability)
		Events:WaitForChild("RainbowWhatStat"):FireServer(Ability)
	end

	local function KillEnemies()
		pcall(function()
			for _, v in pairs(workspace.BadGuys:GetChildren()) do Events:WaitForChild("HitBadguy"):FireServer(v, 64.8, 4) end
			for _, v in pairs(workspace.BadGuysBoss:GetChildren()) do Events:WaitForChild("HitBadguy"):FireServer(v, 64.8, 4) end
			for _, v in pairs(workspace.BadGuysFront:GetChildren()) do Events:WaitForChild("HitBadguy"):FireServer(v, 64.8, 4) end
		end)
	end

	local function BreakEnemies()
		pcall(function()
			for _, v in pairs(workspace.BadGuys:GetChildren()) do v:FindFirstChild("Humanoid", true).Health = 0 end
			for _, v in pairs(workspace.BadGuysBoss:GetChildren()) do v:FindFirstChild("Humanoid", true).Health = 0 end
			for _, v in pairs(workspace.BadGuysFront:GetChildren()) do v:FindFirstChild("Humanoid", true).Health = 0 end
		end)
	end

	local function BringAllEnemies()
		pcall(function()
			for _, container in ipairs({workspace.BadGuys, workspace.BadGuysBoss, workspace.BadGuysFront}) do
				for _, v in pairs(container:GetChildren()) do
					if v:FindFirstChild("HumanoidRootPart") then
						v.HumanoidRootPart.Anchored = true
						v.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -4)
					end
				end
			end
		end)
	end

	local function CollectCash()
		for _, v in pairs(workspace:GetChildren()) do
			if v.Name == "Part" and v:FindFirstChild("TouchInterest") and v:FindFirstChild("Weld") and v.Transparency == 1 then
				firetouchinterest(v, LocalPlayer.Character.HumanoidRootPart, 0)
			end
		end
	end

	local function GetDog()
		for _, v in pairs(LocalPlayer.PlayerGui.Assets.Note.Note.Note:GetChildren()) do
			if v.Name:match("Circle") and v.Visible then
				local itemName = v.Name:gsub("Circle", "")
				GiveItem(itemName)
				task.wait(.1)
				if LocalPlayer.Backpack:FindFirstChild(itemName) then
					LocalPlayer.Backpack[itemName].Parent = LocalPlayer.Character
				end
				TeleportTo(CFrame.new(-257.56, 29.44, -910.45))
				task.wait(.3)
				Events:WaitForChild("CatFed"):FireServer(itemName)
			end
		end
	end

	local function GetAgent()
		GiveItem("Louise")
		task.wait(.1)
		if LocalPlayer.Backpack:FindFirstChild("Louise") then LocalPlayer.Backpack.Louise.Parent = LocalPlayer.Character end
		Events:WaitForChild("LouiseGive"):FireServer(2)
	end

	local function GetUncle()
		GiveItem("Key")
		task.wait(.1)
		if LocalPlayer.Backpack:FindFirstChild("Key") then LocalPlayer.Backpack.Key.Parent = LocalPlayer.Character end
		Events.KeyEvent:FireServer()
	end

	-- ================= UI TABS ================= --

	-- 1. Overpowered Tab
	local OPTab = Window:Tab({ Title = "Overpowered", Icon = "solar:bolt-bold" })

	OPTab:Dropdown({
		Title = "Select Item",
		Values = { "Crowbar 1", "Crowbar 2", "Bat", "Pitchfork", "Hammer", "Wrench", "Broom", "Armor", "Med Kit", "Key", "Gold Key", "Louise", "Lollipop", "Chips", "Golden Apple", "Pizza", "Gold Pizza", "Rainbow Pizza", "Book", "Phone", "Cookie", "Apple", "Bloxy Cola" },
		Value = "Med Kit",
		Callback = function(val) SelectedItem = val end,
	})

	OPTab:Button({
		Title = "Get Selected Item",
		Callback = function() GiveItem(SelectedItem) end,
	})

	OPTab:Button({ Title = "Heal Yourself", Callback = function() HealYourself() end })

	OPTab:Toggle({
		Title = "Loop Heal Yourself",
		Value = false,
		Callback = function(v)
			getgenv().HealLoop = v
			task.spawn(function()
				while getgenv().HealLoop do
					HealYourself()
					task.wait(0.1)
				end
			end)
		end,
	})

	OPTab:Button({ Title = "Heal All Players", Callback = function() HealAllPlayers() end })

	OPTab:Button({ Title = "Train Strength", Callback = function() Train("Strength") end })
	OPTab:Button({ Title = "Train Speed", Callback = function() Train("Speed") end })

	OPTab:Toggle({ Title = "Semi-Godmode", Value = false, Callback = function(v) getgenv().SemiGodmode = v end })
	OPTab:Toggle({ Title = "Remove Slipping", Value = false, Callback = function(v) getgenv().RemoveSlipping = v end })

	-- 2. Combat Tab
	local CombatTab = Window:Tab({ Title = "Combat", Icon = "solar:swords-bold" })

	CombatTab:Button({ Title = "Kill All Enemies", Callback = function() KillEnemies() end })
	CombatTab:Toggle({
		Title = "Loop Kill All",
		Value = false,
		Callback = function(v)
			getgenv().KillAllLoop = v
			task.spawn(function()
				while getgenv().KillAllLoop do
					KillEnemies()
					task.wait(0.1)
				end
			end)
		end,
	})

	CombatTab:Button({ Title = "Break All Enemies", Callback = function() BreakEnemies() end })
	CombatTab:Button({ Title = "Bring All Enemies", Callback = function() BringAllEnemies() end })

	-- 3. Teleports Tab
	local TeleportTab = Window:Tab({ Title = "Teleports", Icon = "solar:map-point-bold" })

	TeleportTab:Button({ Title = "Boss Fight", Callback = function() TeleportTo(CFrame.new(-1565.78, -368.71, -1040.66)) end })
	TeleportTab:Button({ Title = "Shop", Callback = function() TeleportTo(CFrame.new(-246.65, 30.45, -847.31)) end })
	TeleportTab:Button({ Title = "Kitchen", Callback = function() TeleportTo(CFrame.new(-249.75, 30.45, -732.70)) end })
	TeleportTab:Button({ Title = "Fighting Arena", Callback = function() TeleportTo(CFrame.new(-255.52, 62.71, -723.43)) end })
	TeleportTab:Button({ Title = "The Gym", Callback = function() TeleportTo(CFrame.new(-256.47, 63.45, -840.82)) end })
	TeleportTab:Button({ Title = "Golden Apple", Callback = function() TeleportTo(CFrame.new(61.87, 29.44, -534.38)) end })

	-- 4. Game Breaking / Server Modifications
	local ServerTab = Window:Tab({ Title = "Server Control", Icon = "solar:danger-bold" })

	ServerTab:Button({
		Title = "Remove Wind For Everyone",
		Callback = function()
			if workspace:FindFirstChild("WavePart") then Delete(workspace.WavePart) end
		end,
	})
	ServerTab:Button({ Title = "Remove Ice For Everyone", Callback = function() Delete(workspace.Terrain) end })
	ServerTab:Button({ Title = "Remove Hailing For Everyone", Callback = function() if workspace:FindFirstChild("Hails") then Delete(workspace.Hails) end end })

	-- 5. Player & Misc Tab
	local MiscTab = Window:Tab({ Title = "Player & Misc", Icon = "solar:user-bold" })

	MiscTab:Slider({
		Title = "Walk Speed",
		Value = { Min = 16, Max = 300, Default = 50 },
		Callback = function(v)
			ModifiedWalkspeed = v
			if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
				LocalPlayer.Character.Humanoid.WalkSpeed = v
			end
		end,
	})

	MiscTab:Slider({
		Title = "Jump Power",
		Value = { Min = 50, Max = 300, Default = 100 },
		Callback = function(v)
			ModifiedJumpPower = v
			if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
				LocalPlayer.Character.Humanoid.UseJumpPower = true
				LocalPlayer.Character.Humanoid.JumpPower = v
			end
		end,
	})

	MiscTab:Button({ Title = "Collect All Cash", Callback = function() CollectCash() end })
	MiscTab:Toggle({
		Title = "Auto Collect Cash",
		Value = false,
		Callback = function(v)
			getgenv().CollectAllCash = v
			task.spawn(function()
				while getgenv().CollectAllCash do
					CollectCash()
					task.wait(1)
				end
			end)
		end,
	})

	-- 6. Badges & NPCs Tab
	local BadgeTab = Window:Tab({ Title = "Badges & NPCs", Icon = "solar:medal-star-bold" })

	BadgeTab:Button({ Title = "Get Dog NPC", Callback = function() GetDog() end })
	BadgeTab:Button({ Title = "Get Agent Bradley", Callback = function() GetAgent() end })
	BadgeTab:Button({ Title = "Get Uncle Pete", Callback = function() GetUncle() end })
	BadgeTab:Button({
		Title = "Get All NPCs (Dream Team)",
		Callback = function()
			GetDog()
			task.wait(4)
			GetAgent()
			task.wait(1)
			GetUncle()
		end,
	})

else
	LocalPlayer:Kick("Error! Game Not Supported!")
end
