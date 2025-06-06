local isMinigameActive = false

-- Export function to start the wheel removal minigame
-- Returns: success (boolean)
exports('StartWheelRemovalGame', function(difficulty, callback)
    if isMinigameActive then return false end
    
    local difficultySettings = Config.WheelRemoval.Difficulty[difficulty] or Config.WheelRemoval.Difficulty[Config.WheelRemoval.DefaultDifficulty]
    isMinigameActive = true
    
    -- Send data to NUI
    SendNUIMessage({
        action = "startWheelRemovalGame",
        timeLimit = difficultySettings.TimeLimit,
        clicksRequired = difficultySettings.Clicks,
        errorTolerance = difficultySettings.ErrorTolerance
    })
    
    -- Show cursor and set NUI focus
    SetNuiFocus(true, true)
    
    -- Register NUI callback for when game is completed
    RegisterNUICallback('wheelGameCompleted', function(data, cb)
        isMinigameActive = false
        SetNuiFocus(false, false)
        
        if callback then
            callback(data.success)
        end
        
        cb('ok')
    end)
    
    return true
end)

-- Example usage within a mechanic script:
--[[
    -- Inside your mechanic script when player attempts to remove a wheel
    exports['lc_minigames']:StartWheelRemovalGame("Medium", function(success)
        if success then
            -- Remove the wheel, play animation, etc.
            TriggerEvent('QBCore:Notify', 'You successfully removed the wheel!', 'success')
        else
            -- Failed to remove wheel
            TriggerEvent('QBCore:Notify', 'You failed to remove the wheel properly!', 'error')
        end
    end)
]]--

-- Command for testing
RegisterCommand('testwheelgame', function(source, args)
    local difficulty = args[1] or "Medium"
    exports['lc_minigames']:StartWheelRemovalGame(difficulty, function(success)
        if success then
            TriggerEvent('chat:addMessage', {
                color = {0, 255, 0},
                multiline = true,
                args = {"Wheel Removal", "Success! You removed the wheel."}
            })
        else
            TriggerEvent('chat:addMessage', {
                color = {255, 0, 0},
                multiline = true,
                args = {"Wheel Removal", "Failed! You couldn't remove the wheel."}
            })
        end
    end)
end, false)
