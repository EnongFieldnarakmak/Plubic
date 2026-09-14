local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- ฟังก์ชันดึงตัวละคร
local function GetHRP()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	return char:WaitForChild("HumanoidRootPart")
end

-- โหลด WindUI Library
local cloneref = (cloneref or clonereference or function(instance) return instance end)
local WindUI

do
	local ok, result = pcall(function() return require("./src/Init") end)
	if ok then
		WindUI = result
	else
		WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
	end
end

-- สร้างหน้าต่าง UI และ ปุ่ม เปิด-ปิด แบบลากได้
local Window = WindUI:CreateWindow({
	Title = "Break In Hub | WindUI",
	Folder = "BreakinHub",
	Icon = "solar:shield-bold",
	NewElements = true,
	
	-- ตั้งค่าปุ่มเปิด/ปิด UI (ขยับได้)
	OpenButton = {
		Title = "Open Hub", 
		CornerRadius = UDim.new(1, 0), 
		StrokeThickness = 3, 
		Enabled = true, -- เปิดใช้งานปุ่มลอย
		Draggable = true, -- ทำให้ลากได้
		Scale = 1,
		Color = ColorSequence.new( 
			Color3.fromHex("#FF3030"),
			Color3.fromHex("#FF8000")
		),
	},
})

Window:Tag({
	Title = "Breakin 1 Hub",
	Color = Color3.fromHex("#1c1c1c"),
	Border = true,
})

-- ==========================================
-- แท็บที่ 1: ไอเทมและอาวุธ
-- ==========================================
local ItemsTab = Window:Tab({
	Title = "Items",
	Icon = "solar:box-minimalistic-bold",
})

ItemsTab:Section({ Title = "Food (ของกิน)" })

ItemsTab:Button({
	Title = "Get Chips",
	Callback = function()
		ReplicatedStorage.RemoteEvents.GiveTool:FireServer("Chips")
	end,
})

ItemsTab:Button({
	Title = "Get Cola",
	Callback = function()
		ReplicatedStorage.RemoteEvents.GiveTool:FireServer("BloxyCola")
	end,
})

ItemsTab:Button({
	Title = "Get Apple",
	Callback = function()
		ReplicatedStorage.RemoteEvents.GiveTool:FireServer("Apple")
	end,
})

ItemsTab:Button({
	Title = "Get Pizza",
	Callback = function()
		ReplicatedStorage.RemoteEvents.GiveTool:FireServer("Pizza2")
	end,
})

ItemsTab:Button({
	Title = "Get Cookie",
	Callback = function()
		ReplicatedStorage.RemoteEvents.GiveTool:FireServer("Cookie")
	end,
})

ItemsTab:Button({
	Title = "Get MedKit",
	Callback = function()
		ReplicatedStorage.RemoteEvents.GiveTool:FireServer("MedKit")
	end,
})

ItemsTab:Section({ Title = "Weapons (อาวุธ)" })

ItemsTab:Button({
	Title = "Get Bat (ไม้เบสบอล)",
	Callback = function()
		ReplicatedStorage.RemoteEvents.GiveTool:FireServer("Bat")
	end,
})

ItemsTab:Button({
	Title = "Get Sword (ดาบ)",
	Callback = function()
		ReplicatedStorage.RemoteEvents.GiveTool:FireServer("LinkedSword")
	end,
})

ItemsTab:Button({
	Title = "Get Teddy",
	Callback = function()
		ReplicatedStorage.RemoteEvents.GiveTool:FireServer("TeddyBloxpin")
	end,
})

-- ==========================================
-- แท็บที่ 2: สายอาชีพ
-- ==========================================
local RolesTab = Window:Tab({
	Title = "Roles",
	Icon = "solar:user-bold",
})

RolesTab:Section({ Title = "Get Roles (รับปืน)" })

RolesTab:Button({
	Title = "Get Police Role (ตำรวจ)",
	Callback = function()
		ReplicatedStorage.RemoteEvents.OutsideRole:FireServer("Gun", true)
	end,
})

RolesTab:Button({
	Title = "Get SWAT Role (สวาท)",
	Callback = function()
		ReplicatedStorage.RemoteEvents.OutsideRole:FireServer("SwatGun", true)
	end,
})

-- ==========================================
-- แท็บที่ 3: วาร์ป
-- ==========================================
local TPTab = Window:Tab({
	Title = "Teleports",
	Icon = "solar:map-point-bold",
})

TPTab:Section({ Title = "Locations (สถานที่)" })

TPTab:Button({
	Title = "TP House (บ้าน)",
	Callback = function()
		GetHRP().CFrame = CFrame.new(71, -15, -163)
	end,
})

TPTab:Button({
	Title = "TP Shop (ร้านค้า)",
	Callback = function()
		GetHRP().CFrame = CFrame.new(-422, 3, -121)
	end,
})

TPTab:Button({
	Title = "TP Evil Woods (ป่า)",
	Callback = function()
		GetHRP().CFrame = CFrame.new(-16, 35, -220)
	end,
})

TPTab:Button({
	Title = "TP Sewer (ท่อระบายน้ำ)",
	Callback = function()
		GetHRP().CFrame = CFrame.new(129, 3, -125)
	end,
})

TPTab:Button({
	Title = "TP Boss (บอส)",
	Callback = function()
		GetHRP().CFrame = CFrame.new(-39, -287, -1480)
	end,
})

-- ==========================================
-- แจ้งเตือนเมื่อสคริปต์โหลดเสร็จ
-- ==========================================
WindUI:Notify({
	Title = "Breakin Hub Loaded!",
	Content = "กดที่ปุ่ม 'Open Hub' เพื่อเปิด/ปิดเมนู",
	Duration = 5,
})