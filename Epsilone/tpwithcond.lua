--[[    How to add new locations!
               
                Example:
               
                The first line will be the main menu ID (Here [1],
                increment this for each main menu option!),
                the main menu gossip title (Here "Horde Cities"),
                as well as which faction can use the said menu (Here 1 (Horde)).
                0 = Alliance, 1 = Horde, 2 = Both
               
                The second line is the name of the main menu's sub menus,
                separated by name (Here "Orgrimmar") and teleport coordinates
                using Map, X, Y, Z, O (Here 1, 1503, -4415.5, 22, 0)
               
                [1] = { "Horde Cities", 1,      --  
                        {"Orgrimmar", 1, 1503, -4415.5, 22, 0},
                },
               
                You can copy paste the above into the script and change the values as informed.
]]


print(">> Teleporter Script With Conditions | Coded By TITKATA_BG <<")
 
 
local UnitEntry = 99199
local RED  = "|cffff0000"


local T = {
                [1] = { "Instances", 1,
						-- Name 	 MAP ID X     Y       Z   O  ITEM ID
                        {"Orgrimmar 1", 1, 1503, -4415.5, 22, 0, 58981},
                        {"Orgrimmar 2", 1, 1503, -4415.5, 22, 0, 58982},
                        {"Orgrimmar 3", 1, 1503, -4415.5, 22, 0, 58983},
                        {"Orgrimmar 4", 1, 1503, -4415.5, 22, 0, 58984},
                        {"Orgrimmar 5", 1, 1503, -4415.5, 22, 0, 58985},
                        {"Orgrimmar 6", 1, 1503, -4415.5, 22, 0, 58986},
                        {"Orgrimmar 7", 1, 1503, -4415.5, 22, 0, 58987},
                        {"Orgrimmar 8", 1, 1503, -4415.5, 22, 0, 58988},
                        {"Orgrimmar 9", 1, 1503, -4415.5, 22, 0, 58989},
                },
};
 
--[[ CODE STUFFS! DO NOT EDIT BELOW ]]--
--[[ UNLESS YOU KNOW WHAT YOU'RE DOING! ]]--
 
local function Teleporter_Gossip(event, player, unit)
        if (#T <= 10) then
                for i, v in ipairs(T) do
                        if(v[2] == 2 or v[2] == player:GetTeam()) then
                                player:GossipMenuAddItem(0, v[1], 0, i)
                        end
                end
                player:GossipSendMenu(1, unit)
        else
                print("This teleporter only supports 10 different menus.")
        end
end    
 
local function Teleporter_Event(event, player, unit, sender, intid, code)
        if(intid == 0) then
                Teleporter_Gossip(event, player, unit)
        elseif(intid <= 10) then
                for i, v in ipairs(T[intid]) do
                        if (i > 2) then
                                player:GossipMenuAddItem(0, v[1], 0, intid..i)
                        end
                end
                player:GossipMenuAddItem(0, "Back", 0, 0)
                player:GossipSendMenu(1, unit)
        elseif(intid > 10) then
                for i = 1, #T do
                        for j, v in ipairs(T[i]) do
                                if(intid == tonumber(i..j)) then
                                        player:GossipComplete()
										if player:HasItem(v[7]) then
                                        player:Teleport(v[2], v[3], v[4], v[5], v[6])
										else
										player:SendAreaTriggerMessage(RED.."You need a "..GetItemLink(v[7]))
										player:GossipComplete()
										end
                                end
                        end
                end
        end
end
 
RegisterCreatureGossipEvent(UnitEntry, 1, Teleporter_Gossip)
RegisterCreatureGossipEvent(UnitEntry, 2, Teleporter_Event)
