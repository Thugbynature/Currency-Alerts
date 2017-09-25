-- better alert (quest compleate popup)
-- add gold (would need a system on display to show like 10k, 100k, 1m without going over scale)
-- frame template cool looking (template idea, have the colors be ofsets from a primary tone, allow users to pick from tones then it tints for certain places)
-- quest partial compleate alert (aka when i kill 10/10 5/6 10 would alert on finish)
-- weekly seals warning
-- get a wow art viewer and find cooler arrow buttons, move symble and options button.
-- maybe create own BasicFrameTemplateWithInset and its parents and make it custom

--***** if close buttons work change all other buttons to that style

-- ///// test that save still workes with CASAVEcreated removed
-- ///// test new appearance
-- ///// test close buttons and on click look

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
	UIMain:SetSize(300, (value * 20)+20)
	if shown == true then UIMain.up:SetShown(true) else UIMain.up:SetShown(false) end
end

-- Event Handlers
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
UIMain:SetBackdropColor(0, 0, 0, .75)
UIMain:SetMovable(true)
UIMain.enableMouse="true"
UIMain:SetScript("OnEvent", OnEvent)
UIMain:RegisterEvent("PLAYER_LOGIN")
UIMain:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
UIMain:SetSize(300, 200)
UIMain:SetMinResize(300,100)
UIMain:SetMaxResize(300,420)
UIMain:SetResizable(true)
UIMain:SetPoint("TOPLEFT", UIParent, "BOTTOMRIGHT", -450, 350)
UIMain.titlef = CreateFrame("Frame", "CAmain", UIMain, "")
UIMain.titlef:SetBackdropColor(0, 0, 0, .85)
UIMain.titleF:SetPoint("TOPLEFT", UIMain, "TOPLEFT")
UIMain.titleF:SetPoint("BOTTOMRIGHT", UIMain, "TOPRIGHT", -20, -20)
UIMain.title = UIMain:CreateFontString(nil, "ARTWORK")
UIMain.title:SetFontObject("GameFontHighlight")
UIMain.title:SetPoint("LEFT", UIMain.titlef, "LEFT", 5, 0)
UIMain.title:SetText("|cffffff00Currency Alerts")
--Buttons
--Close
UIMain.close = CreateFrame("Button", nil, UIMain, "")
UIMain.close:SetPoint("TOPRIGHT", UIMain, "TOPRIGHT")
UIMain.close:SetSize(20,20)
UIMain.close:SetText("X")
UIMain.close:SetBackdropColor(255, 0, 0, 1)
UIMain.close:SetScript("OnClick",
function (self, button)
	if (button == "LeftButton")then
		UIMain:SetShown(false)
		save()
	end
end)
UIMain.close:SetScript("PreClick",
function (self, button)
	if (button == "LeftButton")then
		self:SetBackdropColor(193, 0, 0, 1)
	end
end)
UIMain.close:SetScript("PostClick",
function (self, button)
	if (button == "LeftButton")then
		self:SetBackdropColor(255, 0, 0, 1)
	end
end)
--Edit
UIMain.edit = CreateFrame("Button", nil, UIMain, "GameMenuButtonTemplate")
UIMain.edit:SetPoint("RIGHT", UIMain.titlef, "RIGHT")
UIMain.edit:SetSize(75,20)
UIMain.edit:SetText("Edit Goals")
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
--Add
UIMain.add = CreateFrame("Button", nil, UIMain, "GameMenuButtonTemplate")
UIMain.add:SetPoint("RIGHT", UIMain.titlef, "RIGHT", -75, 0)
UIMain.add:SetSize(17,17)
UIMain.add:SetText("+")
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
--Settingsb
UIMain.settingsb = CreateFrame("Button", nil, UIMain, "GameMenuButtonTemplate")
UIMain.settingsb:SetPoint("LEFT", UIMain.titlef, "LEFT", 95, 0)
UIMain.settingsb:SetSize(20,20)
UIMain.settingsb:SetText("*")
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
--Scroll Up
UIMain.up = CreateFrame("Button", nil, UIMain, "GameMenuButtonTemplate")
UIMain.up:SetPoint("TOPRIGHT", UIMain, "TOPRIGHT", -7, -25)
UIMain.up:SetSize(20,20)
UIMain.up:SetText("^")
UIMain.up:SetScript("OnMouseDown",
function (self, button)
	if (button == "LeftButton")then
		if scroll > 0 then scroll = scroll-1 end
		UIMain.content:SetPoint("TOP", 0, -20 + (scroll*20))
		PopulateLines()
	end
end)
--Scroll down
UIMain.down = CreateFrame("Button", nil, UIMain, "GameMenuButtonTemplate")
UIMain.down:SetPoint("BOTTOMRIGHT", UIMain, "BOTTOMRIGHT",-7, 7)
UIMain.down:SetSize(20,20)
UIMain.down:SetText("v")
UIMain.down:SetScript("OnMouseDown",
function (self, button)
	if (button == "LeftButton")then
		if (value + scroll +1) <= count then
			scroll = scroll+1
			UIMain.content:SetPoint("TOP", 0, -20 + (scroll*20))
			PopulateLines()
		end
	end
end)
--Move
UIMain.move = CreateFrame("Button", nil, UIMain, "GameMenuButtonTemplate")
UIMain.move:SetPoint("LEFT", UIMain.titlef, "LEFT", 115, 0)
UIMain.move:SetSize(20,20)
UIMain.move:SetText("^")
UIMain.move:SetScript("OnMouseDown",
function (self, button)
	if (button == "LeftButton")then
		self:GetParent():StartMoving()
	end
end)
UIMain.move:SetScript("OnMouseUp",
function (self, button)
	if (button == "LeftButton")then
		self:GetParent():StopMovingOrSizing() 
	end
end)
--Resize
UIMain.size = CreateFrame("Button", nil, UIMain, "")
UIMain.size:SetPoint("Bottom", UIMain, "Bottom")
UIMain.size:SetBackdropColor(249, 245, 5, .12)
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
UIMain.content:SetPoint("TOP", 0, -30)
UIMain.content:SetSize(280,400)
--Settings
UIMain.settings = CreateFrame("Frame", "CAmain", UIMain, "")
UIMain.settings:SetToplevel(true)
UIMain.settings:SetPoint("TOPLEFT", UIMain, "TOPLEFT", 10,-20)
UIMain.settings:SetPoint("BOTTOMRIGHT", UIMain, "BOTTOMRIGHT", -10, 10)
UIMain.settings:SetShown(false)
UIMain.settings:SetBackdropColor(20, 20, 20, .75)
UIMain.cblock =  CreateFrame("CheckButton", "CAmain", UIMain.settings, "UICheckButtonTemplate")
UIMain.cblock:SetPoint("TOPLEFT", UIMain.settings, "TOPLEFT", 0, 3)
UIMain.cblock:SetSize(20,20)
UIMain.cblock:SetChecked(not lock)
UIMain.cblockt = UIMain.settings:CreateFontString(nil, "ARTWORK")
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
UIMain.cblist =  CreateFrame("CheckButton", "CAmain", UIMain.settings, "UICheckButtonTemplate")
UIMain.cblist:SetPoint("TOPLEFT", UIMain.settings, "TOPLEFT", 0, -17)
UIMain.cblist:SetSize(20,20)
UIMain.cblist:SetChecked(UIMain.move:IsShown())
UIMain.cblistt = UIMain.settings:CreateFontString(nil, "ARTWORK")
UIMain.cblistt:SetFontObject("GameFontHighlight")
UIMain.cblistt:SetPoint("TOPLEFT", UIMain.settings, "TOPLEFT", 17, -20)
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
UIMain.reset = CreateFrame("Button", nil, UIMain.settings, "GameMenuButtonTemplate")
UIMain.reset:SetPoint("TOPLEFT", UIMain.settings, "TOPLEFT", 0, -40)
UIMain.reset:SetSize(60,20)
UIMain.reset:SetText("Reset")
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
UIMain.resetcf = CreateFrame("Button", nil, UIMain.settings, "GameMenuButtonTemplate")
UIMain.resetcf:SetPoint("TOPLEFT", UIMain.settings, "TOPLEFT", 63, -40)
UIMain.resetcf:SetSize(60,20)
UIMain.resetcf:SetText("Confirm")
UIMain.resetcf:SetShown(false)
UIMain.resetcf:SetScript("OnClick",
function (self, button)
	if (button == "LeftButton")then
		reset()
	end
end)
--ConfirmRemoveFrame
UIMain.confirm = CreateFrame("Frame", "CAmain", UIMain, "")
UIMain.confirm:SetToplevel(true)
UIMain.confirm:SetSize(70, 55)
UIMain.confirm:SetPoint("CENTER", UIMain, "CENTER")
UIMain.confirm:SetShown(false)
UIMain.ctitle = UIMain.confirm:CreateFontString(nil, "OVERLAY")
UIMain.ctitle:SetFontObject("GameFontHighlight")
UIMain.ctitle:SetPoint("TOPLEFT", UIMain.confirm, "TOPLEFT")
UIMain.ctitle:SetText("|cffffff00Confirm")
UIMain.cf = CreateFrame("Button", nil, UIMain.confirm, "GameMenuButtonTemplate")
UIMain.cf:SetPoint("BOTTOMLEFT", UIMain.confirm, "BOTTOMLEFT", -5, -5)
UIMain.cf:SetSize(60,25)
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
UIMain.cfcl = CreateFrame("Button", nil, UIMain.confirm, "")
UIMain.cfcl:SetPoint("TOPRIGHT", UIMain.confirm, "TOPRIGHT")
UIMain.cfcl:SetSize(20,20)
UIMain.cfcl:SetText("X")
UIMain.cfcl:SetBackdropColor(255, 0, 0, 1)
UIMain.cfcl:SetScript("OnClick",
function (self, button)
	if (button == "LeftButton")then
		UIMain.confirm:SetShown(false)
	end
end)
UIMain.cfcl:SetScript("PreClick",
function (self, button)
	if (button == "LeftButton")then
		self:SetBackdropColor(193, 0, 0, 1)
	end
end)
UIMain.cfcl:SetScript("PostClick",
function (self, button)
	if (button == "LeftButton")then
		self:SetBackdropColor(255, 0, 0, 1)
	end
end)
-- Add Editbox
UIMain.addbox = CreateFrame("EditBox", "CAmain", UIMain, "InputBoxTemplate")
UIMain.addbox:SetSize(65,20)
UIMain.addbox:SetAutoFocus(false)
UIMain.addbox:SetPoint("LEFT", UIMain.titlef, "LEFT", 115, 0)
UIMain.addbox:SetJustifyH("RIGHT")
UIMain.addbox:SetText("Name")
UIMain.addbox:SetShown(false)
UIMain.addbox:SetScript("OnEditFocusGained",
function (self) 
	if self:GetText() == "Enter Name" then
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
							self:SetText("Enter Name")
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
	UIMain:SetSize(w, (value * 20)+20)
	scroll = 0
	UIMain.content:SetPoint("TOP", 0, -20)
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
		local ins = {}
		local ins1
		local ins2
		local ins3
		if getID(list[i]) == nil then return nil end
		ins1,ins2,ins3 = GetCurrencyInfo(getID(list[i]))
		ins[1] = ins1
		ins[2] = ins2
		ins[3] = ins3
		
		list[i] = ins[1]
		list2[i] = ins[2]
		list3[i] = ins[3]
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
					UIMain.remove[i] = CreateFrame("Button", nil, UIMain.content, "GameMenuButtonTemplate")
					UIMain.remove[i]:SetPoint("TOPLEFT", UIMain.content, "TOPLEFT", 245, 20+(-i*20))
					UIMain.remove[i]:SetSize(20,20)
					UIMain.remove[i]:SetText("-")
					UIMain.remove[i]:SetScript("OnClick", 
					function (self, button)
						if (button == "LeftButton")then
							if (edit == false) then
								delete = i
								UIMain.confirm:SetShown(true)
							end
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