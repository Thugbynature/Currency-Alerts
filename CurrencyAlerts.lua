-- Option to add currencies not on the list by typing in name and getting id from it
-- Option to remove currencies with a delete button
-- use name stored in list matrix with the ID compairer for adding to lookup each time
-- do not let delete function remove last currency
-- manually populate ID list, give not in addon response for not added to getID
-- add a display frame and increase its size as items are added up to a cap
-- add a minimap button to show
-- add button for add new, removed (maybe a remove toggle then a - sign by the option), and a goal set (maybe makes a text box interactable so you can set goals)

-- If discovered returns Name, amount player has, and texturePath. If not returns hide
local list = {}; --create array
for i=1, 20, 1 do
	list[i] = {}
	list[i][i] = {}
end

-- fill out matrix with actual names and ids
local IDlist = {
	["coin"] = 12345,
	["shard"] = 123335,
	["resorce"] = 123
};

local count = 1;

--add default currencies here (main legion ones) cant let it get bellow 0


local function getCurrency(id)
local name, amount, texturePath, earnedThisWeek, weeklyMax, totalMax, isDiscovered, quality = GetCurrencyInfo(id)
if (isDiscovered == false) then return "hide" end
return name, amount, texturePath;
end

local function getList()
	for i=1, count, 1 do
		local currency, amount, texturePath = getCurrency(list[1])
		if (currency ~= "hide") then
		list[i][1] = currency;
		list[i][2] = amount;
		list[i][3] = texturePath;
		end
	end
end

local function getID(name)
local id = IDlist[name]

return id
end