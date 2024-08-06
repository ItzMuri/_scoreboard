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

function DrawText3D(x, y, z, text, textR, textG, textB, textA, scale, shadowR, shadowG, shadowB, shadowA, shadowOffset)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    
    -- Draw text shadow
    SetTextScale(scale, scale)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextColour(shadowR, shadowG, shadowB, shadowA)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x + shadowOffset, _y + shadowOffset)
    
    -- Draw main text
    SetTextScale(scale, scale)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextColour(textR, textG, textB, textA)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
end



local function GetPlayers()
    local players = {}
    for _, player in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(player)
        if DoesEntityExist(ped) then
            players[#players+1] = player
        end
    end
    return players
end

local function GetPlayersFromCoords(coords, distance)
    local players = GetPlayers()
    local closePlayers = {}

    if coords == nil then
		coords = GetEntityCoords(PlayerPedId())
    end
    if distance == nil then
        distance = 5.0
    end
    for _, player in pairs(players) do
		local target = GetPlayerPed(player)
		local targetCoords = GetEntityCoords(target)
		local targetdistance = #(targetCoords - vector3(coords.x, coords.y, coords.z))
		if targetdistance <= distance then
            closePlayers[#closePlayers+1] = player
		end
    end

    return closePlayers
end

CreateThread(function()
    while true do
        local loop = 100
        if scoreboardOpen then
            local playerPedId = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPedId)
            local nearbyPlayers = GetPlayersFromCoords(playerCoords, 10.0)
            
            for _, player in pairs(nearbyPlayers) do
                local playerId = GetPlayerServerId(player)
                local playerPed = GetPlayerPed(player)
                local playerCoords = GetEntityCoords(playerPed)
                
                if Cfg.ShowIDforALL or (playerOptin[playerId] and playerOptin[playerId].optin) then
                    loop = 0
                    DrawText3D(playerCoords.x, playerCoords.y, playerCoords.z + 1.0, 
                        'PID : ' .. playerId .. ' ', -- Text
                        169, 227, 75, 255, -- Text Color (Light Green)
                        0.35, -- Scale
                        255, 255, 0, 100, -- Shadow Color (Black)
                        0.001) -- Shadow Offset
                end
            end
        end
        Wait(loop)
    end
end)
