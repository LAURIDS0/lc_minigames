-- Main client file for LC Minigames

-- Framework detection and initialization
local QBCore = exports['qb-core']:GetCoreObject()

-- Common functions that can be used across different minigames
function PlaySuccessSound()
    PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
end

function PlayFailSound()
    PlaySoundFrontend(-1, "Fail", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
end

-- Common animation function
function PlayAnimation(dict, anim, duration)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end
    
    TaskPlayAnim(PlayerPedId(), dict, anim, 8.0, -8.0, duration, 0, 0, false, false, false)
    Wait(duration)
    ClearPedTasks(PlayerPedId())
end
