-- DO NOT CHANGE ANYTHING BUT THE ITEM ID , GMLEVEL , AND COMMAND INTEGERS BELOW THIS LINE UNLESS YOU KNOW WHAT YOU ARE DOING --
local itemID_VIP = 58153 --VIP ITEM ID
local GMLEVEL = 1;
function CheckItemVIP (event, player, unit)
	local VIP_ITEM_COUNT = player:HasItem(itemID_VIP, 1); 
	local playerid = player:GetAccountId(); --GETS THE PLAYERS INGAME ACCOUNT ID
	if (VIP_ITEM_COUNT) then -- CHECK IF HE IS ALREADY VIP I
		if player:GetGMRank() >= 1 then
		player:SendAreaTriggerMessage("You are already VIP I or bigger!")
		else
		AuthDBQuery("REPLACE INTO `ACCOUNT_ACCESS` VALUES (".. playerid ..","..GMLEVEL..",-1)") -- CHANGES PLAYER GMLEVEL INSIDE AUTH DATABASE
		player:RemoveItem(itemID_VIP, 1) -- REMOVES THE ITEM
		player:SendBroadcastMessage("Updated Account! Have Fun! Please Relog Completely and delete your cache") --DEBUG MESSAGE ALSO VERIFIES THE PLAYER DID HAVE THE ITEM
		Kick(player) --KICK THE PLAYER INSTEAD OF WAITING TO LOGOUT
		end
	end
	return false;
end

RegisterItemEvent(itemID_VIP, 2, CheckItemVIP)






-- VIP I activation via stone 2017 Written by TITKATA_BG/Deathless
-- You can vind the sql file at the folder!
