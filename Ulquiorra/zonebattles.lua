--[[ THIS SCRIPT REQUIRES THE WorldStateExtension! DOWNLOAD IT HERE: http://pastebin.com/VWLXjqcp]]
 
local ZoneBattles = {
        ["BattleZone"] = {"Alterac Mountains", 0, 36}, -- Zone name, Map, ZoneId
        ["Rewards"] = {1000, 20, 20560, 1}, -- Copper, Honor, ItemId, ItemCount
        ["MaxScore"] = 5, -- Max score needed to win
        ["Cooldown"] = 5, -- Cooldown in minutes
        [0] = 0, -- Declare Alliance Score
        [1] = 0; -- Declare Horde Score
};
 
local function TeamAsString(team)
        if (team == 0) then
                return "Alliance";
        else
                return "Horde";
        end
end
 
local function HandleReward(player)
        local MoneyReward = ZoneBattles["Rewards"][1];
        local HonorReward = ZoneBattles["Rewards"][2];
        local ItemReward, ItemRewardCount = ZoneBattles["Rewards"][3], ZoneBattles["Rewards"][4];
 
        for k, _ in pairs(ZoneBattles["BattleContribution"]) do
                if (player:GetGUIDLow() == k) then
                        if (MoneyReward > 0) then -- Handle Money Reward
                                player:ModifyMoney(MoneyReward)
                        end
                        if (HonorReward > 0) then -- Handle Honor Reward
                                player:ModifyHonorPoints(HonorReward)
                        end
                        if (ItemReward > 0) and (ItemRewardCount > 0) then -- Handle Item/Token Reward
                                player:AddItem(ItemReward, ItemRewardCount)
                        end
                end
        end
end
 
function ZoneBattles.ResetBattleCounter()
        -- Reset battle variables
        ZoneBattles["BattleContribution"] = {};
        ZoneBattles[0] = 0;
        ZoneBattles[1] = 0;
        ZoneBattles["BattleInProgress"] = true;

        for _, v in pairs(GetMapById(ZoneBattles["BattleZone"][2]):GetPlayers(2)) do
                if (v:GetZoneId() == ZoneBattles["BattleZone"][3]) then
                        v:UpdateWorldState(2313, ZoneBattles[0]) -- Reset Alliance score when battle resets
                        v:UpdateWorldState(2314, ZoneBattles[1]) -- Reset Horde score when battle resets
                        v:SendAreaTriggerMessage("The Battle of "..ZoneBattles["BattleZone"][1].." has begun!")
                end
        end
end
 
function ZoneBattles.OnEnterArea(event, player, newZone, newArea)
        if (player:GetMapId() == ZoneBattles["BattleZone"][2]) and (player:GetZoneId() == ZoneBattles["BattleZone"][3]) then
                player:InitializeWorldState(1, 1377, 0, 1) -- Initialize world state, score 0/0
                player:UpdateWorldState(2317, ZoneBattles["MaxScore"]) -- Sets correct MaxScore
                player:UpdateWorldState(2313, ZoneBattles[0]) -- Set correct Alliance score
                player:UpdateWorldState(2314, ZoneBattles[1]) -- Set correct Horde score
        end
end
 
function ZoneBattles.OnPvPKill(event, killer, killed)
        if ((killer:GetMapId() and killed:GetMapId()) == ZoneBattles["BattleZone"][2]) and ((killer:GetZoneId() and killed:GetZoneId()) == ZoneBattles["BattleZone"][3]) then
                local Team = killer:GetTeam()
 
                if ZoneBattles[0] < ZoneBattles["MaxScore"] and ZoneBattles[1] < ZoneBattles["MaxScore"] then
                        if not ZoneBattles["BattleContribution"][killer:GetGUIDLow()] then
                                ZoneBattles["BattleContribution"][killer:GetGUIDLow()] = true; -- Make sure player has contributed to the battle.
                                killed:Teleport(map, x, y, z, o)
                        end
 
                        ZoneBattles[Team] = ZoneBattles[Team] + 1;
 
                        for _, v in pairs(GetMapById(ZoneBattles["BattleZone"][2]):GetPlayers(2)) do
                                if v:GetZoneId() == ZoneBattles["BattleZone"][3] then
                                        v:UpdateWorldState(2313+Team, ZoneBattles[Team])
                                end
                        end
                end
           
                if ZoneBattles["BattleInProgress"] == true and ZoneBattles[Team] == ZoneBattles["MaxScore"] then
                        killed:Teleport(map, x, y, z, o)
                        ZoneBattles["BattleInProgress"] = false;
 
                        for _, v in pairs(GetMapById(ZoneBattles["BattleZone"][2]):GetPlayers(2)) do
                                if v:GetZoneId() == ZoneBattles["BattleZone"][3] then
                                        if(v:GetTeam() == Team) then
                                                HandleReward(v)
                                        end
                                        v:SendAreaTriggerMessage("The "..TeamAsString(Team).." has won the Battle of "..ZoneBattles["BattleZone"][1].."! Next battle begins in "..ZoneBattles["Cooldown"].." minutes!")
                                end
                        end
 
                        CreateLuaEvent(ZoneBattles.ResetBattleCounter, ZoneBattles["Cooldown"]*60*1000, 1)
                end
        end
end
 
 print("Zone Battles Script Loaded")
ZoneBattles.ResetBattleCounter()
RegisterPlayerEvent(27, ZoneBattles.OnEnterArea)
RegisterPlayerEvent(6, ZoneBattles.OnPvPKill)
