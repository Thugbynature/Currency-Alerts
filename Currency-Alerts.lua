-- better alert (quest compleate popup)
-- add gold
-- frame template cool looking
-- quest partial compleate alert (aka when i kill 10/10 5/6 10 would alert on finish)
-- weekly seals warning

--SAVED VARIABLES
CASAVElist = {}
CASAVElist4 = {}
CASAVEcount = count
CASAVEcreated = {}
CASAVEfinished = {}

local list = {}; --name array
local list2 = {}; --amount array
local list3 = {}; --icon array
local list4 = {}; --goal array
local count
local edit = false
local length = 240
local delete
local getList
local getID
local save
local PopulateLines
local created = {}
local finished = {}

local function init()
	if (count == nil) then
		list = CASAVElist
		count = CASAVEcount
		created = CASAVEcreated
		list4 = CASAVElist4
		finished = CASAVEfinished
	end
	if (count == nil) then
		list[1] = "veiled argunite";
		list[2] = "seal of broken fate";
		list[3] = "order resources";
		list[4] = "nethershard";
		list[5] = "legionfall war supplies"
		list[6] = "curious coin";
		list[7] = "ancient mana";
		list[8] = "darkmoon prize ticket";
		list[9] = "brawler's gold";
		list[10] = "coins of air";
		count = 10;
		for i=1,20,1 do	list4[i] = 0 end
		save()
	end
	for i=1,20,1 do	created[i] = false end
	for i=1,20,1 do	finished[i] = false end
end

local function OnEvent(frame, event, ...)
	if (event == "PLAYER_LOGIN") then
		init()
		getList()
		PopulateLines()
	elseif (event == "CURRENCY_DISPLAY_UPDATE") then
		init()
		getList()
		PopulateLines()
	end
end

--UI
--Frame
local UIMain = CreateFrame("Frame", "CAmain", UIParent, "BasicFrameTemplateWithInset")
UIMain.goal = {}
UIMain.icon = {}
UIMain.line = {}
UIMain.amount = {}
UIMain.remove = {}
UIMain:SetMovable(true)
UIMain.enableMouse="true"
UIMain:SetScript("OnEvent", OnEvent)
UIMain:RegisterEvent("PLAYER_LOGIN")
UIMain:RegisterEvent("CHAT_MSG_CURRENCY")
UIMain:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
UIMain:SetSize(300, 200);
UIMain:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -150, 150);
UIMain.title = UIMain:CreateFontString(nil, "ARTWORK");
UIMain.title:SetFontObject("GameFontHighlight");
UIMain.title:SetPoint("LEFT", UIMain.TitleBg, "LEFT", 5, 0);
UIMain.title:SetText("|cffffff00Currency Alerts");
--Buttons
UIMain.edit = CreateFrame("Button", nil, UIMain, "GameMenuButtonTemplate")
UIMain.edit:SetPoint("RIGHT", UIMain.TitleBg, "RIGHT", 0, 0)
UIMain.edit:SetSize(75,17)
UIMain.edit:SetText("Edit Goals")
UIMain.edit:SetScript("OnClick",
function (self)
	if (edit == false) then
		for i=1, count, 1 do
			UIMain.goal[i]:Enable()
			UIMain.goal[i]:SetText(UIMain.goal[i]:GetText())
			UIMain.goal[i]:SetTextColor(1,1,1,1)
		end
		edit = true;
	else
		for i=1, count, 1 do
			UIMain.goal[i]:Disable()
			if (UIMain.goal[i]:GetText() ~= "") then
				list4[i] = tonumber(UIMain.goal[i]:GetText())
				UIMain.goal[i]:SetTextColor(1,1,1,.3)
			end
		end
		edit = false;
	end
end)
UIMain.add = CreateFrame("Button", nil, UIMain, "GameMenuButtonTemplate")
UIMain.add:SetPoint("RIGHT", UIMain.TitleBg, "RIGHT", -70, 0)
UIMain.add:SetSize(17,17)
UIMain.add:SetText("+")
UIMain.add:SetScript("OnClick",
function (self)
	if (UIMain.addbox:IsShown()) then
		UIMain.addbox:SetShown(false)
	else
		UIMain.addbox:SetShown(true)
	end
end)
UIMain.move = CreateFrame("Button", nil, UIMain, "GameMenuButtonTemplate")
UIMain.move:SetPoint("LEFT", UIMain.TitleBg, "LEFT", 95, 0)
UIMain.move:SetSize(17,17)
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
--ScrollFrame
scrollframe = CreateFrame("ScrollFrame", nil, UIMain) 
scrollframe:SetPoint("TOPLEFT", 10, -30) 
scrollframe:SetPoint("BOTTOMRIGHT", -10, 10) 
local texture = scrollframe:CreateTexture() 
texture:SetAllPoints() 
texture:SetTexture(.5,.5,.5,1) 
UIMain.scrollframe = scrollframe
--ScrollBar
scrollbar = CreateFrame("Slider", nil, UIMain.scrollframe, "UIPanelScrollBarTemplate") 
scrollbar:SetPoint("TOPLEFT", scrollframe, "TOPRIGHT", -15, -16) 
scrollbar:SetPoint("BOTTOMLEFT", scrollframe, "BOTTOMRIGHT", -15, 16) 
scrollbar:SetMinMaxValues(1, length)
scrollbar:SetValueStep(20) 
scrollbar.scrollStep = 20
scrollbar:SetValue(0) 
scrollbar:SetWidth(16) 
scrollbar:SetScript("OnValueChanged", 
function (self, value) 
self:GetParent():SetVerticalScroll(value) 
end) 
local scrollbg = scrollbar:CreateTexture(nil, "BACKGROUND") 
scrollbg:SetAllPoints(scrollbar) 
scrollbg:SetTexture(0, 0, 0, 0.4) 
UIMain.scrollbar = scrollbar
--ContentFrame
local content = CreateFrame("Frame", nil) 
content:SetSize(175, 500)
scrollframe.content = content
UIMain.scrollframe:SetScrollChild(content)
--ConfirmRemoveFrame
UIMain.confirm = CreateFrame("Frame", "CAmain", UIMain, "BasicFrameTemplateWithInset")
UIMain.confirm:SetToplevel(true)
UIMain.confirm:SetSize(75, 55);
UIMain.confirm:SetPoint("CENTER", UIMain, "CENTER", 175, 0);
UIMain.confirm:SetShown(false) 
UIMain.ctitle = UIMain.confirm:CreateFontString(nil, "OVERLAY");
UIMain.ctitle:SetFontObject("GameFontHighlight");
UIMain.ctitle:SetPoint("LEFT", UIMain.confirm.TitleBg, "LEFT", 5, 0);
UIMain.ctitle:SetText("|cffffff00Confirm");UIMain.edit = CreateFrame("Button", nil, UIMain, "GameMenuButtonTemplate")
UIMain.cf = CreateFrame("Button", nil, UIMain.confirm, "GameMenuButtonTemplate")
UIMain.cf:SetPoint("CENTER", UIMain.confirm, "CENTER", 0, -10)
UIMain.cf:SetSize(60,25)
UIMain.cf:SetText("Delete")
UIMain.cf:SetScript("OnClick",
function (self)
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
	UIMain.confirm:SetShown(false) 
end)
-- Add Editbox
UIMain.addbox = CreateFrame("EditBox", "CAmain", UIMain, "InputBoxTemplate");
UIMain.addbox:SetSize(75,17)
UIMain.addbox:SetAutoFocus(false)
UIMain.addbox:SetPoint("RIGHT", UIMain.TitleBg, "RIGHT", -85, 0)
UIMain.addbox:SetText("Enter Name")
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
		self:SetText("Enter Name")
	end
end)
UIMain.addbox:SetScript("OnEnterPressed",
	function (self) 
	if self:GetText() ~= "" then
		if(count <= 20) then
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
	["epicureans award"] = 81,
	["felessence"] = 1355,
	["garrison resources"] = 824,
	["ironpaw token"] = 402,
	["writhing essence"] = 1501,
	["lingering soul fragment"] = 1314
};

function getID(name)
if (string.sub(name, 1, 1) == "[") then
name = string.sub(name, 2, string.len(name)-1)
end
name = string.lower(name);
local id = IDlist[name];
return id;
end

function getList()
	for i=1, count, 1 do
		local ins = {}
		local ins1
		local ins2
		local ins3

		ins1,ins2,ins3 = GetCurrencyInfo(getID(list[i]))
		ins[1] = ins1
		ins[2] = ins2
		ins[3] = ins3
		
		list[i] = ins[1];
		list2[i] = ins[2];
		list3[i] = ins[3];
		if(list4[i] == nil) then list4[i] = 0 end
	end
end



function PopulateLines()
	for i=1, 20, 1 do
		if list[i] ~= nil then
			if created[i] == false then
				-- Icon
				UIMain.icon[i] = content:CreateTexture(nil , "ARTWORK")
				UIMain.icon[i]:SetPoint("TOPLEFT", content, "TOPLEFT", 0, 20+(-i*20)) 
				UIMain.icon[i]:SetTexture(list3[i])
				UIMain.icon[i]:SetSize(20, 20)
				-- Name
				UIMain.line[i] = content:CreateFontString(nil, "ARTWORK");
				UIMain.line[i]:SetFontObject("GameFontHighlight");
				UIMain.line[i]:SetPoint("TOPLEFT", content, "TOPLEFT", 55, 15+(-i*20));
				UIMain.line[i]:SetText("|cff00ffff" .. list[i])
				-- Amount
				UIMain.amount[i] = content:CreateFontString(nil, "ARTWORK");
				UIMain.amount[i]:SetFontObject("GameFontHighlight");
				UIMain.amount[i]:SetPoint("TOPLEFT", content, "TOPLEFT", 22, 15+(-i*20));
				UIMain.amount[i]:SetText(list2[i])
				-- Goal
				UIMain.goal[i] = CreateFrame("EditBox", "CAmain", content, "InputBoxTemplate");
				UIMain.goal[i]:SetSize(40,20)
				UIMain.goal[i]:SetNumeric(true)
				UIMain.goal[i]:SetMaxLetters(5)
				UIMain.goal[i]:SetAutoFocus(false)
				UIMain.goal[i]:SetPoint("TOPLEFT", content, "TOPLEFT", 205, 20+(-i*20));
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
				UIMain.remove[i] = CreateFrame("Button", nil, content, "GameMenuButtonTemplate")
				UIMain.remove[i]:SetPoint("TOPLEFT", content, "TOPLEFT", 245, 20+(-i*20));
				UIMain.remove[i]:SetSize(20,20)
				UIMain.remove[i]:SetText("-")
				UIMain.remove[i]:SetScript("OnClick", 
				function (self)
					if (edit == false) then
						delete = i;
						UIMain.confirm:SetShown(true)
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
				UIMain.goal[i]:SetText(tostring(list4[i]))
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
	save()
end


SLASH_CA1 = "/ca"
SlashCmdList["CA"] = function()
	if (UIMain:IsShown()) then
		UIMain:SetShown(false)
	else
		UIMain:SetShown(true)
	end
end

function save() 
	CASAVElist = list
	CASAVEcount = count
	CASAVEcreated = created
	CASAVElist4 = list4
	CASAVEfinished = finished
end
print(UIMain.edit:GetBackdropColor())
UIMain:SetShown(false)