local data = Cfg.Data
local Core = exports[data.Framework['coreName']]:GetCoreObject() 

local scoreboardOpen = false
local playerOptin = {}

RegisterNetEvent('scoreboard:client:SetActivityBusy',
                 function(activity, busy)
    data.illegalActions[activity].busy = busy
end)

if data.Settings.toggle then
    RegisterCommand('scoreboard', function()
        if not scoreboardOpen then
            Core.Functions.TriggerCallback(
                'scoreboard:server:GetScoreboardData',
                function(players, cops, playerList, info)
                    playerOptin = playerList
                    SendNUIMessage({
                        action = 'open',
                        players = players,
                        maxPlayers = data.Settings.maxPlayers,
                        requiredCops = data.illegalActions,
                        currentCops = cops,
                        ambulanceCount = info.ambulanceCount,
                        mechanicCount = info.mechanicCount,
                        taxiCount = info.taxiCount,
                        servername = info.servername,
                        job = info.job,
                        grade = info.grade,
                        duty = info.duty,
                        cops1 = data.copLevel[1],
                        cops2 = data.copLevel[2],
                        cops3 = data.copLevel[3],
                        
                        --locales
                        locDuty = data.locales['duty'],
                        locJobTitle = data.locales['job_title'],
                        locJobRank = data.locales['job_rank'],
                        locRobberies = data.locales['robberies'],
                        locStatus = data.locales['status'],
                        locCityActivity = data.locales['city_activity'],
                    })
                    scoreboardOpen = true
                end)
        else
            SendNUIMessage({action = 'close'})

            scoreboardOpen = false
        end
    end, false)

    RegisterKeyMapping('scoreboard', 'Open Scoreboard', 'keyboard', data.Settings.openKey)
else
    RegisterCommand('+scoreboard', function()
        if scoreboardOpen then return end
        Core.Functions.TriggerCallback(
            'scoreboard:server:GetScoreboardData',
            function(players, cops, playerList, info)
                playerOptin = playerList
                SendNUIMessage({
                    action = 'open',
                    players = players,
                    maxPlayers = data.Settings.maxPlayers,
                    requiredCops = data.illegalActions,
                    currentCops = cops,
                    ambulanceCount = info.ambulanceCount,
                    mechanicCount = info.mechanicCount,
                    taxiCount = info.taxiCount,
                    servername = info.servername,
                    job = info.job,
                    grade = info.grade,
                    duty = info.duty,
                    cops1 = data.copLevel[1],
                    cops2 = data.copLevel[2],
                    cops3 = data.copLevel[3],

                    --locales
                    locDuty = data.locales['duty'],
                    locJobTitle = data.locales['job_title'],
                    locJobRank = data.locales['job_rank'],
                    locRobberies = data.locales['robberies'],
                    locStatus = data.locales['status'],
                    locCityActivity = data.locales['city_activity'],
                })
                scoreboardOpen = true
            end)
    end, false)

    RegisterCommand('-scoreboard', function()
        if not scoreboardOpen then return end
        SendNUIMessage({action = 'close'})

        scoreboardOpen = false
    end, false)
    
    RegisterKeyMapping('+scoreboard', 'Open Scoreboard', 'keyboard', data.Settings.openKey)
end

-- Threads

CreateThread(function()
    Wait(1000)
    local actions = {}
    for k, v in pairs(data.illegalActions) do actions[k] = v.label end
    SendNUIMessage({action = 'setup', items = actions})
end)

CreateThread(function()
    while true do
        local loop = 1500
        if scoreboardOpen then
            Core.Functions.TriggerCallback(
                'scoreboard:server:GetScoreboardData',
                function(players, cops, playerList, info)
                    playerOptin = playerList
                    SendNUIMessage({
                        action = 'open',
                        players = players,
                        maxPlayers = data.Settings.maxPlayers,
                        requiredCops = data.illegalActions,
                        currentCops = cops,
                        ambulanceCount = info.ambulanceCount,
                        mechanicCount = info.mechanicCount,
                        taxiCount = info.taxiCount,
                        servername = info.servername,
                        job = info.job,
                        grade = info.grade,
                        duty = info.duty,
                        cops1 = data.copLevel[1],
                        cops2 = data.copLevel[2],
                        cops3 = data.copLevel[3],

                        --locales
                        locDuty = data.locales['duty'],
                        locJobTitle = data.locales['job_title'],
                        locJobRank = data.locales['job_rank'],
                        locRobberies = data.locales['robberies'],
                        locStatus = data.locales['status'],
                        locCityActivity = data.locales['city_activity'],
                    })
                    scoreboardOpen = true
                end)
        end
        Wait(loop)
    end
end)