-- Option to add currencies not on the list by typing in name and getting id from it
-- Option to remove currencies with a delete button
-- use name stored in list matrix with the ID compairer for adding to lookup each time
-- do not let delete function remove last currency
-- add a display frame and increase its size as items are added up to a cap
-- add a minimap button to show
-- add button for add new, removed (maybe a remove toggle then a - sign by the option), and a goal set (maybe makes a text box interactable so you can set goals)
-- make entery field work with shift click currency (should just need to remove [])

-- If discovered returns Name, amount player has, and texturePath. If not returns hide
local list = {}; --name array
local list2 = {}; --amount array
local list3 = {}; --icon array
local count;

if (count == null) then 
	list[1] = "veiled argunite";
	list[2] = "seal of broken fate";
	list[3] = "order resources";
	count = 3
end

local IDlist = {
	["ancient mana"] = 1155,
	["coins of air"] = 1416,
	["darkmoon prize ticket"] = 515,
	["brawler's gold"] = 1299,
	["legionfall war supplies"] = 1342,
	["order resources"] = 1220,
	["nethershard"] = 1226,	
	["seal of broken fate"] = 1273,
	["veiled argunite"] = 1508
};

local function getID(name)
if (string.sub(name, 1, 1) == "[") then
name = string.sub(name, 2, string.len(name)-1)
end
name = string.lower(name);
local id = IDlist[name];
return id;
end

local function getList()
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
	end
end

--testing
getList()