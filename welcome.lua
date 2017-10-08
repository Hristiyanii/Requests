local function OnPlayerJoin(_, _, _, player)
  player:SendAreaTriggerMessage("Welcome to the server!")

  SendWorldMessage("[|cff1ABC9CAnnouncer|r] Welcome to the server "..player:GetName().."!")
end

function OnPlayerFirstJoin(event, player)
  player:RegisterEvent(OnPlayerJoin, 1000, 1)
end

RegisterPlayerEvent(30, OnPlayerFirstJoin)
