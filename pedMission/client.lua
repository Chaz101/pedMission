ped = 0x9fd4292d 
playerCoords = GetEntityCoords(PlayerPedId())
isPlayerOnMission = false
spawnLocations = 
{
    [1] = {x = 985.3576, y = 188.0025, z = 80.41727},
    [2] = {x = 815.109, y = -86.7378, z = 80.20029},
    [3] = {x = 913.4983, y = -180.2784, z = 73.70481},
}


function getRandomLocation(variable)
    return variable[math.random(1, #variable)]
end

RegisterNetEvent("missiontext")
AddEventHandler("missiontext", function(text, time)
        ClearPrints()
        SetTextEntry_2("STRING")
        AddTextComponentString(text)
        DrawSubtitleTimed(time, 1)
end)


RegisterCommand('startMission', function()
    TriggerEvent("missiontext", "Go to the ~r~Blip~w~ to start your mission!", 2000)
    missionstarted = true

    RequestModel(ped)
    while (not HasModelLoaded(ped)) do
        Citizen.Wait(0)
    end
    friendly = CreatePed(4, ped, 673.1572, 629.3741, 129.1128, 0, false, true)
    blip = AddBlipForEntity(friendly)

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            toggleMission()
            playerCoords = GetEntityCoords(PlayerPedId())
    
        end
    end)
    
end)


function toggleMission()
    if (GetDistanceBetweenCoords(673.1572, 629.3741, 129.1128, playerCoords) < 5 and isPlayerOnMission == false) then
        TriggerEvent("missiontext", "Press ~o~'E'~s~ to speak", 2000)
        RemoveBlip(blip)

        if IsControlJustPressed(1, 38) then -- E
            isPlayerOnMission = true
            TriggerEvent("missiontext", "I need you to kill someone. He is ~r~marked~w~ on the GPS. Stay safe.", 2000)
            enemyCoords = getRandomLocation(spawnLocations)
            enemy = CreatePed(4, ped, enemyCoords.x, enemyCoords.y, enemyCoords.z, 0, false, true)
            blip = AddBlipForEntity(enemy)
            SetPedCombatAbility(enemy, 100)
            Wait(2000)
            countdown()

            while isPlayerOnMission do
                Citizen.Wait(0)
                enemyHealth = GetEntityHealth(enemy)
                playerHealth = GetEntityHealth(PlayerPedId())
                if enemyHealth == 0 then
                    missionSucceed()
                end
                if playerHealth == 0 then
                    missionFailed()
                end
            end
        end
    end
end

function missionSucceed()
    isPlayerOnMission = false
    Citizen.Wait(1000)
    TriggerEvent("missiontext", "Mission was ~g~successful~w~.", 2000)
    RemoveBlip(blip)
    DeleteEntity(friendly)
    Citizen.Wait(10000)
    DeleteEntity(enemy)
end

function missionFailed()
    isPlayerOnMission = false
    Citizen.Wait(1000)
    TriggerEvent("missiontext", "Mission was ~r~Failed~w~. Try Again.", 2000)
    RemoveBlip(blip)
    DeleteEntity(friendly)
    Citizen.Wait(10000)
    DeleteEntity(enemy)
end

function countdown()
    gametime = GetGameTimer()
    allowedTime = 300
    displayTime = allowedTime 
    Citizen.CreateThread(function()
        while isPlayerOnMission do
            Citizen.Wait(0)
            if displayTime > 0 then
                 timeDiff = GetGameTimer() - gametime
                displayTime = math.floor(allowedTime - (timeDiff/1000))
                TriggerEvent("missiontext", "Time remaining: " .. displayTime .. " seconds", 1000)
            else
                Citizen.Wait(1000)
                missionFailed()
            end
        end
    end)    
end





