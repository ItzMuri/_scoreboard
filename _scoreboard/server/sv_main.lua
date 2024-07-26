local data = Cfg.Data
local Core = exports[data.Framework['coreName']]:GetCoreObject() 

Core.Functions.CreateCallback('scoreboard:server:GetScoreboardData', function(source, cb)
    local src = source
    local Player = Core.Functions.GetPlayer(src)
    if Player ~= nil then
        job = Player.PlayerData.job.label
        duty = Player.PlayerData.job.onduty
        grade = Player.PlayerData.job.grade.name
    end
    local totalPlayers = 0
    local policeCount = 0
    local players = {}
    local info = {
        servername = data.Settings.serverName,
        ambulanceCount = 0,
        mechanicCount = 0,
        job = job,
        duty = duty,
        grade = grade

    }

    for _, v in pairs(Core.Functions.GetQBPlayers()) do
        if v then
            totalPlayers += 1

            if v.PlayerData.job.name == 'police' and v.PlayerData.job.onduty then
                policeCount += 1
            end

            if v.PlayerData.job.name == 'ambulance' and v.PlayerData.job.onduty then
                info.ambulanceCount += 1
            end
            if v.PlayerData.job.name == 'mechanic' and v.PlayerData.job.onduty then
                info.mechanicCount += 1
            end

            players[v.PlayerData.source] = {}
            players[v.PlayerData.source].optin = Core.Functions.IsOptin(v.PlayerData.source)
        end
    end
    cb(totalPlayers, policeCount, players, info)
end)

RegisterNetEvent('scoreboard:server:SetActivityBusy', function(activity, bool)
    data.illegalActions[activity].busy = bool
    TriggerClientEvent('scoreboard:client:SetActivityBusy', -1, activity, bool)
end)

