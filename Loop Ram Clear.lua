-- ==========================================
-- MEMORY / RAM MANAGEMENT (GARBAGE COLLECTION)
-- ==========================================
local ContentProvider = game:GetService("ContentProvider")
local gc = gcinfo or collectgarbage

local function clearMemory()
	-- 1. ล้าง Asset/Texture Cache ที่ไม่ได้ใช้ออกจาก Memory
	pcall(function()
		ContentProvider:UnloadUnusedAssets()
	end)

	-- 2. รัน Garbage Collector แบบย่อย (Incremental Step) 
	-- ใช้ step เพื่อไม่ให้เกมกระตุก (ไม่สั่ง 'collect' เต็มรูปแบบที่จะทำให้เกิด Freeze/Lag)
	if collectgarbage then
		collectgarbage("step", 100)
	elseif gc then
		gc()
	end
end

-- สั่งทำงานทุกๆ 5 นาที (300 วินาที) แยก Thread ไม่ดึงเฟรมเรตหลัก
task.spawn(function()
	while true do
		task.wait(300)
		clearMemory()
	end
end)
