-- better alert (quest compleate popup)
-- add gold (would need a system on display to show like 10k, 100k, 1m without going over scale)
-- frame template cool looking (template idea, have the colors be ofsets from a primary tone, allow users to pick from tones then it tints for certain places)
-- quest partial compleate alert (aka when i kill 10/10 5/6 10 would alert on finish)
-- weekly seals warning

--"" might want to make X for close turn red on hover over but stay black normally, maybe with a bit of an outline
--***** move new icons to wow folder
--***** look into quest compleate alert and add how to add to it, if thats is too hard create a frame with a movable toggle and resize and display alearts on it

--SAVED VARIABLES
CASAVElist = {}
CASAVElist4 = {}
CASAVEcount = {}
CASAVEfinished = {}
--

--Local Variables
local list = {} --name array
local list2 = {} --amount array
local list3 = {} --icon array
local list4 = {} --goal array
local created = {} --frames created for that row
local finished = {} --if goal has been reach, stays untill bellow goal again
local load=false --on each load switch
local count --count of current list to display
local edit = false --edit button toggle
local delete --stores liine - was clicked on
local scroll = 0 --scroll offset number
local value --size value for viewable
local shown = false --main frame display toggle
local lock --lock postion scale toggle
local editl --removes + - signs
local time = 0 --time for fading alert frame
local getList --function declaration
local getID --""
local save --""
local PopulateLines --""
local scaleset --""
local reset --""
--

--frame declarations
local UIMain = CreateFrame("Frame", "CAmain", UIParent, "")
UIMain.goal = {}
UIMain.icon = {}
UIMain.line = {}
UIMain.content = {}
UIMain.amount = {}
UIMain.remove = {}
UIMain.resetcf = {}
UIMain.alert = {}
UIMain.alert.text = {}

--init
local function init()
	-- load saved globals
	list = CASAVElist
	count = CASAVEcount[1]
	value = CASAVEcount[2]
	shown = CASAVEcount[3]
	lock = CASAVEcount[4]
	editl = CASAVEcount[5]
	list4 = CASAVElist4
	finished = CASAVEfinished
	--

	--No saves/First run
	if (count == nil) then
		list[1] = "veiled argunite"
		list[2] = "seal of broken fate"
		list[3] = "order resources"
		list[4] = "nethershard"
		list[5] = "legionfall war supplies"
		list[6] = "curious coin"
		list[7] = "ancient mana"
		list[8] = "darkmoon prize ticket"
		list[9] = "brawler's gold"
		list[10] = "coins of air"
		count = 10
		value = 10
		for i=1,20,1 do	list4[i] = 0 end
		shown = true
		for i=1,20,1 do	finished[i] = false end
		save()
	end
	--
	
	UIMain.settings:SetShown(false)
	UIMain.content:SetShown(true)
	if not UIMain.cblock:GetChecked() then UIMain.move:SetShown(true) end
	for i=1,20,1 do	created[i] = false end
	scroll = 0
	UIMain:SetSize(280, (value * 20)+30)
	if shown == true then UIMain:SetShown(true) else UIMain:SetShown(false) end
end

--UIMain Event Handlers
local function OnEvent(frame, event, ...)
	if (event == "PLAYER_LOGIN") then
		init()
		load = true
		getList()
		PopulateLines()
	elseif (event == "CURRENCY_DISPLAY_UPDATE") then
		if load == true then
			getList()
			PopulateLines()
		end
	end
end
--

--UI
--Frame
UIMain.bg = UIMain:CreateTexture(nil , "BACKGROUND")
UIMain.bg:SetAllPoints(UIMain)
UIMain.bg:SetColorTexture(0, 0, 0, .75)
UIMain:SetMovable(true)
UIMain.enableMouse="true"
UIMain:SetScript("OnEvent", OnEvent)
UIMain:RegisterEvent("PLAYER_LOGIN")
UIMain:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
UIMain:SetSize(280, 200)
UIMain:SetMinResize(280,90)
UIMain:SetMaxResize(280,420)
UIMain:SetResizable(true)
UIMain:SetPoint("TOPLEFT", UIParent, "BOTTOMRIGHT", -450, 350)
UIMain.titlef = UIMain:CreateTexture(nil , "BACKGROUND")
UIMain.titlef:SetColorTexture(0, 0, 0, .85)
UIMain.titlef:SetPoint("TOPLEFT", UIMain, "TOPLEFT")
UIMain.titlef:SetPoint("BOTTOMRIGHT", UIMain, "TOPRIGHT", -20, -20)
UIMain.title = UIMain:CreateFontString(nil, "ARTWORK")
UIMain.title:SetFontObject("GameFontHighlight")
UIMain.title:SetPoint("LEFT", UIMain.titlef, "LEFT", 5, 0)
UIMain.title:SetText("|cffffff00Currency Alerts")
--Alert
UIMain.alert = CreateFrame("Frame", "CAmain", UIParent, "")
UIMain.alert:SetPoint("Center", UIParent, "Center", 0, 0)
UIMain.alert:SetSize(500, 500)
UIMain.alert:SetScript("OnEvent", OnEvent)
UIMain.alert:RegisterEvent("PLAYER_LOGIN")
UIMain.alert.bg = UIMain.alert:CreateTexture(nil , "BACKGROUND")
UIMain.alert.bg:SetAllPoints(UIMain.alert)
UIMain.alert.bg:SetColorTexture(0, 0, 0, .25)
UIMain.alert.text = UIMain.alert:CreateFontString(nil, "ARTWORK")
UIMain.alert.text:SetFontObject("GameFontHighlight")
UIMain.alert.text:SetPoint("CENTER", UIMain.alert, "CENTER", 0, 0)
UIMain.alert.text:SetText("")
UIMain.alert:SetShown(false)
UIMain.alert:SetScript("OnUpdate",
function ()
	if time > 0 then
		if time < GetTime() - 3 then
			local alpha = UIMain.alert.text:GetAlpha()
			if alpha > 0 then UIMain.alert.text:SetAlpha(alpha-.05)
			else
				UIMain.alert:SetShown(false)
				time = 0
			end
		end
	end
end)
--Buttons
--Close
UIMain.close = CreateFrame("Button", nil, UIMain, "")
UIMain.close:SetPoint("TOPRIGHT", UIMain, "TOPRIGHT")
UIMain.close:SetSize(20,20)
UIMain.close.bg = UIMain.close:CreateTexture(nil , "BACKGROUND")
UIMain.close.bg:SetAllPoints(UIMain.close)
UIMain.close.bg:SetColorTexture(1, 0, 0, 1)
UIMain.close.icon = UIMain.close:CreateTexture(nil , "ARTWORK")
UIMain.close.icon:SetAllPoints(UIMain.close)
UIMain.close.icon:SetTexture("Interface\\AddOns\\Currency-Alerts\\icon\\x.blp")
UIMain.close:SetScript("OnClick",
function (self, button)
	if (button == "LeftButton")then
		UIMain:SetShown(false)
		save()
	end
end)
UIMain.close:SetScript("OnMouseDown",
function (self, button)
	if (button == "LeftButton")then
		UIMain.close.bg:SetColorTexture(.3, 0, 0, 1)
	end
end)
UIMain.close:SetScript("OnMouseUp",
function (self, button)
	if (button == "LeftButton")then
		UIMain.close.bg:SetColorTexture(1, 0, 0, 1)
	end
end)
--Edit
UIMain.edit = CreateFrame("Button", nil, UIMain, "")
UIMain.edit:SetPoint("RIGHT", UIMain.titlef, "RIGHT")
UIMain.edit:SetSize(75,20)
UIMain.edit.bg = UIMain.edit:CreateTexture(nil , "BACKGROUND")
UIMain.edit.bg:SetAllPoints(UIMain.edit)
UIMain.edit.bg:SetColorTexture(1, 0, 0, 1)
UIMain.edit.t = UIMain.edit:CreateFontString(nil, "ARTWORK")
UIMain.edit.t:SetFontObject("GameFontHighlight")
UIMain.edit.t:SetPoint("CENTER", UIMain.edit, "CENTER")
UIMain.edit.t:SetText("Edit Goals")
UIMain.edit:SetScript("OnClick",
function (self, button)
	if (button == "LeftButton")then
		if (edit == false) then
			for i=1, count, 1 do
				UIMain.goal[i]:Enable()
				UIMain.goal[i]:SetText(UIMain.goal[i]:GetText())
				UIMain.goal[i]:SetTextColor(1,1,1,1)
			end
			edit = true
		else
			for i=1, count, 1 do
				UIMain.goal[i]:Disable()
				if (UIMain.goal[i]:GetText() ~= "") then
					list4[i] = tonumber(UIMain.goal[i]:GetText())
					UIMain.goal[i]:SetTextColor(1,1,1,.3)
				end
			end
			edit = false
		end
	end
end)
UIMain.edit:SetScript("OnMouseDown",
function (self, button)
	if (button == "LeftButton")then
		UIMain.edit.bg:SetColorTexture(.3, 0, 0, 1)
	end
end)
UIMain.edit:SetScript("OnMouseUp",
function (self, button)
	if (button == "LeftButton")then
		UIMain.edit.bg:SetColorTexture(255, 0, 0, 1)
	end
end)
--Add
UIMain.add = CreateFrame("Button", nil, UIMain, "")
UIMain.add:SetPoint("RIGHT", UIMain.titlef, "RIGHT", -73, 0)
UIMain.add:SetSize(17,17)
UIMain.add.bg = UIMain.add:CreateTexture(nil , "BACKGROUND")
UIMain.add.bg:SetAllPoints(UIMain.add)
UIMain.add.bg:SetColorTexture(1, 0, 0, 1)
UIMain.add.icon = UIMain.add:CreateTexture(nil , "ARTWORK")
UIMain.add.icon:SetAllPoints(UIMain.add)
UIMain.add.icon:SetTexture("Interface\\AddOns\\Currency-Alerts\\icon\\plus.blp")
UIMain.add:SetScript("OnClick",
function (self, button)
	if (button == "LeftButton")then
		if (UIMain.addbox:IsShown()) then
			UIMain.addbox:SetShown(false)
			UIMain.move:SetShown(true)
		else
			UIMain.addbox:SetShown(true)
			UIMain.move:SetShown(false)
		end
	end
end)
UIMain.add:SetScript("OnMouseDown",
function (self, button)
	if (button == "LeftButton")then
		UIMain.add.bg:SetColorTexture(.3, 0, 0, 1)
	end
end)
UIMain.add:SetScript("OnMouseUp",
function (self, button)
	if (button == "LeftButton")then
		UIMain.add.bg:SetColorTexture(1, 0, 0, 1)
	end
end)
--Settingsb
UIMain.settingsb = CreateFrame("Button", nil, UIMain, "")
UIMain.settingsb:SetPoint("LEFT", UIMain.titlef, "LEFT", 95, 0)
UIMain.settingsb:SetSize(20,20)
UIMain.settingsb.bg = UIMain.settingsb:CreateTexture(nil , "BACKGROUND")
UIMain.settingsb.bg:SetAllPoints(UIMain.settingsb)
UIMain.settingsb.bg:SetColorTexture(1, 0, 0, 1)
UIMain.settingsb.icon = UIMain.settingsb:CreateTexture(nil , "ARTWORK")
UIMain.settingsb.icon:SetAllPoints(UIMain.settingsb)
UIMain.settingsb.icon:SetTexture("Interface\\AddOns\\Currency-Alerts\\icon\\settings.blp")
UIMain.settingsb:SetScript("OnClick",
function (self, button)
	if (button == "LeftButton")then
		if (UIMain.settings:IsShown()) then
			UIMain.settings:SetShown(false)
			UIMain.content:SetShown(true)
			UIMain.size:SetShown(not lock)
			PopulateLines()
		else
			UIMain.settings:SetShown(true)
			UIMain.content:SetShown(false)
			UIMain.down:SetShown(false)
			UIMain.up:SetShown(false)
			UIMain.size:SetShown(false)
		end
	end
end)
UIMain.settingsb:SetScript("OnMouseDown",
function (self, button)
	if (button == "LeftButton")then
		UIMain.settingsb.bg:SetColorTexture(.3, 0, 0, 1)
	end
end)
UIMain.settingsb:SetScript("OnMouseUp",
function (self, button)
	if (button == "LeftButton")then
		UIMain.settingsb.bg:SetColorTexture(1, 0, 0, 1)
	end
end)
--Scroll Up
UIMain.up = CreateFrame("Button", nil, UIMain, "")
UIMain.up:SetPoint("TOPRIGHT", UIMain, "TOPRIGHT", 0, -23)
UIMain.up:SetSize(20,20)
UIMain.up.bg = UIMain.up:CreateTexture(nil , "BACKGROUND")
UIMain.up.bg:SetAllPoints(UIMain.up)
UIMain.up.bg:SetColorTexture(1, 0, 0, 1)
UIMain.up.icon = UIMain.up:CreateTexture(nil , "ARTWORK")
UIMain.up.icon:SetAllPoints(UIMain.up)
UIMain.up.icon:SetTexture("Interface\\AddOns\\Currency-Alerts\\icon\\up.blp")
UIMain.up:SetScript("OnMouseDown",
function (self, button)
	if (button == "LeftButton")then
		if scroll > 0 then scroll = scroll-1 end
		UIMain.content:SetPoint("TOP", 0, -25 + (scroll*20))
		PopulateLines()
	end
end)
UIMain.up:SetScript("OnMouseDown",
function (self, button)
	if (button == "LeftButton")then
		UIMain.up.bg:SetColorTexture(.3, 0, 0, 1)
	end
end)
UIMain.up:SetScript("OnMouseUp",
function (self, button)
	if (button == "LeftButton")then
		UIMain.up.bg:SetColorTexture(1, 0, 0, 1)
	end
end)
--Scroll down
UIMain.down = CreateFrame("Button", nil, UIMain, "")
UIMain.down:SetPoint("BOTTOMRIGHT", UIMain, "BOTTOMRIGHT", 0, 3)
UIMain.down:SetSize(20,20)
UIMain.down.bg = UIMain.down:CreateTexture(nil , "BACKGROUND")
UIMain.down.bg:SetAllPoints(UIMain.down)
UIMain.down.bg:SetColorTexture(1, 0, 0, 1)
UIMain.down.icon = UIMain.down:CreateTexture(nil , "ARTWORK")
UIMain.down.icon:SetAllPoints(UIMain.down)
UIMain.down.icon:SetTexture("Interface\\AddOns\\Currency-Alerts\\icon\\down.blp")
UIMain.down:SetScript("OnMouseDown",
function (self, button)
	if (button == "LeftButton")then
		if (value + scroll +1) <= count then
			scroll = scroll+1
			UIMain.content:SetPoint("TOP", 0, -25 + (scroll*20))
			PopulateLines()
		end
	end
end)
UIMain.down:SetScript("OnMouseDown",
function (self, button)
	if (button == "LeftButton")then
		UIMain.down.bg:SetColorTexture(.3, 0, 0, 1)
	end
end)
UIMain.down:SetScript("OnMouseUp",
function (self, button)
	if (button == "LeftButton")then
		UIMain.down.bg:SetColorTexture(1, 0, 0, 1)
	end
end)
--Move
UIMain.move = CreateFrame("Button", nil, UIMain, "")
UIMain.move:SetPoint("LEFT", UIMain.titlef, "LEFT", 115, 0)
UIMain.move:SetSize(20,20)
UIMain.move.bg = UIMain.move:CreateTexture(nil , "BACKGROUND")
UIMain.move.bg:SetAllPoints(UIMain.move)
UIMain.move.bg:SetColorTexture(1, 0, 0, 1)
UIMain.move.icon = UIMain.move:CreateTexture(nil , "ARTWORK")
UIMain.move.icon:SetAllPoints(UIMain.move)
UIMain.move.icon:SetTexture("Interface\\AddOns\\Currency-Alerts\\icon\\move.blp")
UIMain.move:SetScript("OnMouseDown",
function (self, button)
	if (button == "LeftButton")then
		self:GetParent():StartMoving()
		UIMain.move.bg:SetColorTexture(.3, 0, 0, 1)
	end
end)
UIMain.move:SetScript("OnMouseUp",
function (self, button)
	if (button == "LeftButton")then
		self:GetParent():StopMovingOrSizing()
		UIMain.move.bg:SetColorTexture(1, 0, 0, 1)
	end
end)
--Resize
UIMain.size = CreateFrame("Button", nil, UIMain, "")
UIMain.size:SetPoint("Bottom", UIMain, "Bottom")
UIMain.size:SetSize(300,8)
UIMain.size:SetScript("OnMouseDown",
function (self, button)
	if (button == "LeftButton")then
		for i = 1, count, 1 do
			if created[i] == true then
						UIMain.icon[i]:SetShown(false)
						UIMain.line[i]:SetShown(false)
						UIMain.amount[i]:SetShown(false)
						UIMain.goal[i]:SetShown(false)
						UIMain.remove[i]:SetShown(false)
			end
		end
		UIMain.up:SetShown(false)
		UIMain.down:SetShown(false)
		self:GetParent():StartSizing()
	end
end)
UIMain.size:SetScript("OnMouseUp",
function (self, button)
	if (button == "LeftButton")then
		self:GetParent():StopMovingOrSizing()
		scaleset()
	end
end)
--ContentFrame
UIMain.content = CreateFrame("Frame", "CAmain", UIMain, "")
UIMain.content:SetPoint("TOP", 0, -25)
UIMain.content:SetSize(270,400)
--Settings
UIMain.settings = CreateFrame("Frame", "CAmain", UIMain, "")
UIMain.settings:SetToplevel(true)
UIMain.settings:SetPoint("TOPLEFT", UIMain, "TOPLEFT", 5,-25)
UIMain.settings:SetPoint("BOTTOMRIGHT", UIMain, "BOTTOMRIGHT", -5, 5)
UIMain.settings:SetShown(false)
UIMain.settings.bg =UIMain.settings:CreateTexture(nil , "BACKGROUND")
UIMain.settings.bg:SetAllPoints(UIMain.settings)
UIMain.settings.bg:SetColorTexture(.1, .1, .1, .8)
UIMain.cblock =  CreateFrame("CheckButton", "CAmain", UIMain.settings, "")
UIMain.cblock:SetPoint("TOPLEFT", UIMain.settings, "TOPLEFT", 0, 3)
UIMain.cblock:SetSize(20,20)
UIMain.cblock:SetChecked(not lock)
UIMain.cblockt = UIMain.settings:CreateFontString(nil, "BACKGROUND")
UIMain.cblockt:SetFontObject("GameFontHighlight")
UIMain.cblockt:SetPoint("TOPLEFT", UIMain.settings, "TOPLEFT", 17, 0)
UIMain.cblockt:SetText("Lock Frame")
UIMain.cblock:SetScript("PostClick",
function (self, button, down)
	if self:GetChecked() then
		UIMain.move:SetShown(false)
		lock = true
		save()
	else
		UIMain.move:SetShown(true)
		lock = false
		save()
	end
end)
UIMain.cblist =  CreateFrame("CheckButton", "CAmain", UIMain.settings, "")
UIMain.cblist:SetPoint("TOPLEFT", UIMain.settings, "TOPLEFT", 0, -15)
UIMain.cblist:SetSize(20,20)
UIMain.cblist:SetChecked(UIMain.move:IsShown())
UIMain.cblistt = UIMain.settings:CreateFontString(nil, "BACKGROUND")
UIMain.cblistt:SetFontObject("GameFontHighlight")
UIMain.cblistt:SetPoint("TOPLEFT", UIMain.settings, "TOPLEFT", 17, -17)
UIMain.cblistt:SetText("Edit List")
UIMain.cblist:SetScript("PostClick",
function (self, button, down)
	if self:GetChecked() then
		UIMain.add:SetShown(true)
		editl = true
	save()
		else
		UIMain.add:SetShown(false)
		UIMain.confirm:SetShown(false)
		UIMain.addbox:SetShown(false)
		editl = false
	save()
	end
end)
UIMain.reset = CreateFrame("Button", nil, UIMain.settings, "")
UIMain.reset:SetPoint("TOPLEFT", UIMain.settings, "TOPLEFT", 0, -35)
UIMain.reset:SetSize(60,20)
UIMain.reset.bg = UIMain.reset:CreateTexture(nil , "BACKGROUND")
UIMain.reset.bg:SetAllPoints(UIMain.reset)
UIMain.reset.bg:SetColorTexture(1, 0, 0, 1)
UIMain.reset.t = UIMain.reset:CreateFontString(nil, "ARTWORK")
UIMain.reset.t:SetFontObject("GameFontHighlight")
UIMain.reset.t:SetPoint("CENTER", UIMain.reset, "CENTER")
UIMain.reset.t:SetText("Reset")
UIMain.reset:SetScript("OnClick",
function (self, button)
	if (button == "LeftButton")then
		if (UIMain.resetcf:IsShown()) then
			UIMain.resetcf:SetShown(false)
		else
			UIMain.resetcf:SetShown(true)
		end
	end
end)
UIMain.reset:SetScript("OnMouseDown",
function (self, button)
	if (button == "LeftButton")then
		UIMain.reset.bg:SetColorTexture(.3, 0, 0, 1)
	end
end)
UIMain.reset:SetScript("OnMouseUp",
function (self, button)
	if (button == "LeftButton")then
		UIMain.reset.bg:SetColorTexture(1, 0, 0, 1)
	end
end)
UIMain.resetcf = CreateFrame("Button", nil, UIMain.settings, "")
UIMain.resetcf:SetPoint("TOPLEFT", UIMain.settings, "TOPLEFT", 63, -35)
UIMain.resetcf:SetSize(60,20)
UIMain.resetcf.bg = UIMain.resetcf:CreateTexture(nil , "BACKGROUND")
UIMain.resetcf.bg:SetAllPoints(UIMain.resetcf)
UIMain.resetcf.bg:SetColorTexture(1, 0, 0, 1)
UIMain.resetcf.t = UIMain.resetcf:CreateFontString(nil, "ARTWORK")
UIMain.resetcf.t:SetFontObject("GameFontHighlight")
UIMain.resetcf.t:SetPoint("CENTER", UIMain.resetcf, "CENTER")
UIMain.resetcf.t:SetText("Confirm")
UIMain.resetcf:SetShown(false)
UIMain.resetcf:SetScript("OnClick",
function (self, button)
	if (button == "LeftButton")then
		reset()
	end
end)
UIMain.resetcf:SetScript("OnMouseDown",
function (self, button)
	if (button == "LeftButton")then
		UIMain.resetcf.bg:SetColorTexture(.3, 0, 0, 1)
	end
end)
UIMain.resetcf:SetScript("OnMouseUp",
function (self, button)
	if (button == "LeftButton")then
		UIMain.resetcf.bg:SetColorTexture(1, 0, 0, 1)
	end
end)
--ConfirmRemoveFrame
UIMain.confirm = CreateFrame("Frame", "CAmain", UIMain, "")
UIMain.confirm:SetToplevel(true)
UIMain.confirm:SetSize(70, 50)
UIMain.confirm:SetPoint("CENTER", UIMain, "CENTER")
UIMain.confirm.bg = UIMain.confirm:CreateTexture(nil , "BACKGROUND")
UIMain.confirm.bg:SetAllPoints(UIMain.confirm)
UIMain.confirm.bg:SetColorTexture(0, 0, 0, .9)
UIMain.confirm:SetShown(false)
UIMain.ctitle = UIMain.confirm:CreateFontString(nil, "OVERLAY")
UIMain.ctitle:SetFontObject("GameFontHighlight")
UIMain.ctitle:SetPoint("TOPLEFT", UIMain.confirm, "TOPLEFT", 1, -5)
UIMain.ctitle:SetText("|cffffff00Confirm")
UIMain.cf = CreateFrame("Button", nil, UIMain.confirm, "")
UIMain.cf:SetPoint("BOTTOMLEFT", UIMain.confirm, "BOTTOMLEFT", 5, 3)
UIMain.cf:SetSize(60,25)
UIMain.cf.bg = UIMain.cf:CreateTexture(nil , "BACKGROUND")
UIMain.cf.bg:SetAllPoints(UIMain.cf)
UIMain.cf.bg:SetColorTexture(1, 0, 0, 1)
UIMain.cf.t = UIMain.cf:CreateFontString(nil, "ARTWORK")
UIMain.cf.t:SetFontObject("GameFontHighlight")
UIMain.cf.t:SetPoint("CENTER", UIMain.cf, "CENTER")
UIMain.cf:SetText("Delete")
UIMain.cf:SetScript("OnClick",
function (self, button)
	if (button == "LeftButton")then
		if delete == count then
			if count > 1 then
				delete = 0
				list[count] = nil
				list2[count] = nil
				list3[count] = nil
				list4[count] = nil
				count = count-1
				getList()
				PopulateLines()
			end
		else
				list[delete] = nil
				list2[delete] = nil
				list3[delete] = nil
				list4[delete] = nil
				for i=1,20-delete,1 do
					if list[delete+i] ~= nil then
						list[delete+i-1] = list[delete+i]
						list2[delete+i-1] = list2[delete+i]
						list3[delete+i-1] = list3[delete+i]
						list4[delete+i-1] = list4[delete+i]
					end
				end
				list[count] = nil
				list2[count] = nil
				list3[count] = nil
				list4[count] = nil
				count = count-1
				getList()
				PopulateLines()
				delete = 0
		end
		scaleset()
		UIMain.confirm:SetShown(false)
	end
end)
UIMain.cf:SetScript("OnMouseDown",
function (self, button)
	if (button == "LeftButton")then
		UIMain.cf.bg:SetColorTexture(.3, 0, 0, 1)
	end
end)
UIMain.cf:SetScript("OnMouseUp",
function (self, button)
	if (button == "LeftButton")then
		UIMain.cf.bg:SetColorTexture(1, 0, 0, 1)
	end
end)
UIMain.cfcl = CreateFrame("Button", nil, UIMain.confirm, "")
UIMain.cfcl:SetPoint("TOPRIGHT", UIMain.confirm, "TOPRIGHT")
UIMain.cfcl:SetSize(20,20)
UIMain.cfcl.icon = UIMain.cfcl:CreateTexture(nil , "ARTWORK")
UIMain.cfcl.icon:SetAllPoints(UIMain.cfcl)
UIMain.cfcl.icon:SetTexture("Interface\\AddOns\\Currency-Alerts\\icon\\x.blp")
UIMain.cfcl.bg = UIMain.cfcl:CreateTexture(nil , "BACKGROUND")
UIMain.cfcl.bg:SetAllPoints(UIMain.cfcl)
UIMain.cfcl.bg:SetColorTexture(1, 0, 0, 1)
UIMain.cfcl:SetScript("OnClick",
function (self, button)
	if (button == "LeftButton")then
		UIMain.confirm:SetShown(false)
	end
end)
UIMain.cfcl:SetScript("OnMouseDown",
function (self, button)
	if (button == "LeftButton")then
		UIMain.cfcl.bg:SetColorTexture(.3, 0, 0, 1)
	end
end)
UIMain.cfcl:SetScript("OnMouseUp",
function (self, button)
	if (button == "LeftButton")then
		UIMain.cfcl.bg:SetColorTexture(1, 0, 0, 1)
	end
end)
-- Add Editbox
UIMain.addbox = CreateFrame("EditBox", "CAmain", UIMain, "InputBoxTemplate")
UIMain.addbox:SetSize(55,20)
UIMain.addbox:SetAutoFocus(false)
UIMain.addbox:SetPoint("RIGHT", UIMain.titlef, "RIGHT", -90, 0)
UIMain.addbox:SetJustifyH("RIGHT")
UIMain.addbox:SetText("Name")
UIMain.addbox:SetShown(false)
UIMain.addbox:SetScript("OnEditFocusGained",
function (self) 
	if self:GetText() == "Name" then
		self:SetText("")
	end
	if self:GetText() == "Invalid" then
		self:SetText("")
	end
	if self:GetText() == "Duplicate" then
		self:SetText("")
	end
end)
UIMain.addbox:SetScript("OnEditFocusLost",
	function (self) 
	if self:GetText() == "" then
		self:SetText("Name")
	end
end)
UIMain.addbox:SetScript("OnEnterPressed",
	function (self) 
	if self:GetText() ~= "" then
		if(count < 20) then
				if(getID(self:GetText()) ~= nil) then
						local test = false
						for i=1, count, 1 do
							if string.lower(list[i]) == string.lower(self:GetText()) then
								test = false
								break
							else
								test = true
							end
						end
						if(test == true) then 
							count = count+1
							list[count] = self:GetText()
							self:SetText("Name")
							getList()
							PopulateLines()
							self:ClearFocus()
							self:SetShown(false)
							
						else
							self:SetText("Duplicate")
							self:ClearFocus()
						end
				else
					self:SetText("Invalid")
					self:ClearFocus()
				end
		end
	end
end)
--

-- Scale Set
function scaleset()
	local w
	local h
	w, h = UIMain:GetSize()
	h = h-20
	value = math.floor(h/20)
	if (value > count) then value = count end
	if (value * 20) <60 then value = 3 end
	UIMain:SetSize(w, (value * 20)+30)
	scroll = 0
	UIMain.content:SetPoint("TOP", 0, -25)
	PopulateLines()
end
--

-- ID registry
local IDlist = {
	["ancient mana"] = 1155,
	["coins of air"] = 1416,
	["darkmoon prize ticket"] = 515,
	["brawler's gold"] = 1299,
	["legionfall war supplies"] = 1342,
	["order resources"] = 1220,
	["nethershard"] = 1226,	
	["seal of broken fate"] = 1273,
	["veiled argunite"] = 1508,
	["curious coin"] = 1275,
	["apexis crystal"] = 823,
	["argus waystone"] = 1506,
	["artifact knowledge"] = 1171,
	["champions seal"] = 241,
	["bloody coin"] = 789,
	["dalaran jewelcrafters token"] = 61,
	["dingy iron coins"] = 980,
	["echoes of battle"] = 1356,
	["echoes of domination"] = 1357,
	["felessence"] = 1355,
	["garrison resources"] = 824,
	["ironpaw token"] = 402,
	["writhing essence"] = 1501,
	["lingering soul fragment"] = 1314,
	["timewarped badge"] = 1166,
	["sightless eye"] = 1149
}

-- ID from name
function getID(name)
if (string.sub(name, 1, 1) == "[") then
name = string.sub(name, 2, string.len(name)-1)
end
name = string.lower(name)
local id = IDlist[name]
return id
end

-- Get currency information from wow
function getList()
	for i=1, count, 1 do
		local ins1
		local ins2
		local ins3
		if getID(list[i]) == nil then return nil end
		ins1,ins2,ins3 = GetCurrencyInfo(getID(list[i]))
		
		list[i] = ins1
		list2[i] = ins2
		list3[i] = ins3
		if(list4[i] == nil) then list4[i] = 0 end
	end
end


-- Creates frames and displayes infromation from get list
function PopulateLines()
	for i=1, 20, 1 do
		if list[i] ~= nil then
				if created[i] == false then
					-- Icon
					UIMain.icon[i] = UIMain.content:CreateTexture(nil , "ARTWORK")
					UIMain.icon[i]:SetPoint("TOPLEFT", UIMain.content, "TOPLEFT", 0, 20+(-i*20)) 
					UIMain.icon[i]:SetTexture(list3[i])
					UIMain.icon[i]:SetSize(20, 20)
					-- Name
					UIMain.line[i] = UIMain.content:CreateFontString(nil, "ARTWORK")
					UIMain.line[i]:SetFontObject("GameFontHighlight")
					UIMain.line[i]:SetPoint("TOPLEFT", UIMain.content, "TOPLEFT", 55, 15+(-i*20))
					UIMain.line[i]:SetText("|cff00ffff" .. list[i])
					-- Amount
					UIMain.amount[i] = UIMain.content:CreateFontString(nil, "ARTWORK")
					UIMain.amount[i]:SetFontObject("GameFontHighlight")
					UIMain.amount[i]:SetPoint("TOPLEFT", UIMain.content, "TOPLEFT", 22, 15+(-i*20))
					UIMain.amount[i]:SetText(list2[i])
					-- Goal
					UIMain.goal[i] = CreateFrame("EditBox", "CAmain", UIMain.content, "InputBoxTemplate")
					UIMain.goal[i]:SetSize(40,20)
					UIMain.goal[i]:SetNumeric(true)
					UIMain.goal[i]:SetMaxLetters(5)
					UIMain.goal[i]:SetAutoFocus(false)
					UIMain.goal[i]:SetPoint("TOPLEFT", UIMain.content, "TOPLEFT", 200, 20+(-i*20))
					UIMain.goal[i]:SetText(tostring(list4[i]))
					UIMain.goal[i]:SetTextColor(1,1,1,.3)
					UIMain.goal[i]:SetJustifyH("RIGHT")
					UIMain.goal[i]:SetScript("OnEditFocusGained",
					function (self) 
						if self:GetText() == "0" then
							self:SetText("")
						end
					end)
					UIMain.goal[i]:SetScript("OnEditFocusLost",
					function (self) 
						if self:GetText() == "" then
							self:SetText("0")
						end
					end)
					UIMain.goal[i]:SetScript("OnEnterPressed",
					function (self) 
						if self:GetText() ~= "" then
							list4[i] = tonumber(self:GetText())
							self:ClearFocus()
							save()
						end
					end)
					UIMain.goal[i]:Disable()
					-- Remove
					UIMain.remove[i] = CreateFrame("Button", nil, UIMain.content, "")
					UIMain.remove[i]:SetPoint("TOPLEFT", UIMain.content, "TOPLEFT", 240, 20+(-i*20))
					UIMain.remove[i]:SetSize(20,20)
					UIMain.remove[i].bg = UIMain.remove[i]:CreateTexture(nil , "BACKGROUND")
					UIMain.remove[i].bg:SetAllPoints(UIMain.remove[i])
					UIMain.remove[i].bg:SetColorTexture(1, 0, 0, 1)
					UIMain.remove[i].icon = UIMain.remove[i]:CreateTexture(nil , "ARTWORK")
					UIMain.remove[i].icon:SetAllPoints(UIMain.remove[i])
					UIMain.remove[i].icon:SetTexture("Interface\\AddOns\\Currency-Alerts\\icon\\minus.blp")
					UIMain.remove[i]:SetScript("OnClick", 
					function (self, button)
						if (button == "LeftButton")then
							if (edit == false) then
								delete = i
								UIMain.remove[i]:SetShown(true)
							end
						end
					end)
					UIMain.remove[i]:SetScript("OnMouseDown",
					function (self, button)
						if (button == "LeftButton")then
							UIMain.remove[i].bg:SetColorTexture(.3, 0, 0, 1)
						end
					end)
					UIMain.remove[i]:SetScript("OnMouseUp",
					function (self, button)
						if (button == "LeftButton")then
							UIMain.remove[i].bg:SetColorTexture(1, 0, 0, 1)
						end
					end)
					created[i] = true
				else
					UIMain.icon[i]:SetTexture(list3[i])
					UIMain.line[i]:SetText("|cff00ffff" .. list[i])
					UIMain.amount[i]:SetText(list2[i])
					UIMain.goal[i]:SetText(tostring(list4[i]))

					if UIMain.icon[i]:IsShown() == false then UIMain.icon[i]:SetShown(true) end
					if UIMain.amount[i]:IsShown() == false then UIMain.amount[i]:SetShown(true) end
					if UIMain.line[i]:IsShown() == false then UIMain.line[i]:SetShown(true) end
					if UIMain.goal[i]:IsShown() == false then UIMain.goal[i]:SetShown(true) end
					if UIMain.remove[i]:IsShown() == false then UIMain.remove[i]:SetShown(true) end
				end
		else
			if created[i] == true then
				UIMain.icon[i]:SetShown(false)
				UIMain.line[i]:SetShown(false)
				UIMain.amount[i]:SetShown(false)
				UIMain.goal[i]:SetShown(false)
				UIMain.remove[i]:SetShown(false)
			end
		end
		if created[i] == true then
			if editl then
				UIMain.remove[i]:SetShown(true)
			else
				UIMain.remove[i]:SetShown(false)
			end
		end
		if scroll > 0 then
			if i <= scroll then
				if created[i] == true then
					UIMain.icon[i]:SetShown(false)
					UIMain.line[i]:SetShown(false)
					UIMain.amount[i]:SetShown(false)
					UIMain.goal[i]:SetShown(false)
					UIMain.remove[i]:SetShown(false)
				end
			end
		end
		if i > (scroll+value) then
			if created[i] == true then
					UIMain.icon[i]:SetShown(false)
					UIMain.line[i]:SetShown(false)
					UIMain.amount[i]:SetShown(false)
					UIMain.goal[i]:SetShown(false)
					UIMain.remove[i]:SetShown(false)
			end
		end
		if (list4[i] ~= 0)then
			if(list4[i] ~= nil) then
				if (list4[i] ~= "")then
					if (list2[i] >= tonumber(list4[i])) then
						if finished[i] == false then
							UIMain.line[i]:SetText("|cffffcc00" .. list[i])
							print("|cffffcc00" .. list[i] .. " has reached the Goal!")
							UIMain.alert.text:SetText("|cffffcc00" .. list[i] .. " has reached the Goal!")
							UIMain.alert:SetShown(true)
							UIMain.alert.text:SetAlpha(1)
							time = GetTime()
							PlaySound(888 , "SFX")
							finished[i] = true
						end
					elseif(finished[i] == true)then
						finished[i] = false
					end
				end
			end
		end
	end
	if scroll ~= 0 then UIMain.up:SetShown(true) else UIMain.up:SetShown(false) end
	if (value+scroll) < count then UIMain.down:SetShown(true) else UIMain.down:SetShown(false) end
	UIMain.cblock:SetChecked(lock)
	UIMain.cblist:SetChecked(editl)
	UIMain.size:SetShown(not lock)
	UIMain.move:SetShown(not lock)
	UIMain.add:SetShown(editl)
	save()
end

-- reset
function reset()
	CASAVElist = {}
	CASAVEcount = {}
	CASAVElist4 = {}
	CASAVEfinished = {}
	CASAVEcount[4] = false
	CASAVEcount[5] = true
	UIMain.resetcf:SetShown(false)
	UIMain.settings:SetShown(false)
	UIMain.move:SetShown(true)
	UIMain.size:SetShown(true)
	UIMain.addbox:SetShown(false)
	UIMain.confirm:SetShown(false)
	init()
	getList()
	PopulateLines()
end

-- slash commands
SLASH_CA1 = "/ca"
SlashCmdList["CA"] = function()
	if (UIMain:IsShown()) then
		UIMain:SetShown(false)
		save()
	else
		UIMain:SetShown(true)
		save()
	end
end

-- save global VARIABLES
function save()
	CASAVElist = list
	CASAVEcount[1] = count
	CASAVEcount[2] = value
	CASAVElist4 = list4
	CASAVEfinished = finished
	CASAVEcount[3] = UIMain:IsShown()
	CASAVEcount[4] = lock
	CASAVEcount[5] = editl
end