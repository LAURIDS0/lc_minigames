local isMinigameActive = false
local currentVehicle = nil
local currentWheel = nil
local wheelProps = {}
local uiActive = false
local wheelModel = nil
local bolts = {}
local wheelUiActive = false

-- Debug function
local function DebugPrint(msg)
    if Config.Debug then
        print("^3[lc_minigames]^7 " .. msg)
    end
end

-- Helper Functions
local function LoadModel(model)
    if not IsModelValid(model) then return false end
    if HasModelLoaded(model) then return true end
    
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(10)
    end
    return true
end

local function GetClosestVehicleWheel()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)
    if not DoesEntityExist(vehicle) then return nil, nil end
    
    local vehicleCoords = GetEntityCoords(vehicle)
    local wheelBones = {
        {bone = "wheel_lf", index = 0, label = "Front Left"}, -- Front Left
        {bone = "wheel_rf", index = 1, label = "Front Right"}, -- Front Right
        {bone = "wheel_lr", index = 2, label = "Rear Left"}, -- Rear Left
        {bone = "wheel_rr", index = 3, label = "Rear Right"}, -- Rear Right
    }
    
    local closestDist = 2.0
    local closestWheel = nil
    
    for _, wheel in pairs(wheelBones) do
        local wheelPos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, wheel.bone))
        if wheelPos.x ~= 0 and wheelPos.y ~= 0 and wheelPos.z ~= 0 then
            local dist = #(coords - wheelPos)
            if dist < closestDist then
                closestDist = dist
                closestWheel = wheel
            end
        end
    end
    
    if closestWheel then
        return vehicle, closestWheel
    end
    
    return nil, nil
end

-- 3D UI for Wheel Minigame
function CreateWheelChangeUI(vehicle, wheelData)
    if uiActive then return end
    
    uiActive = true
    isMinigameActive = true
    currentVehicle = vehicle
    currentWheel = wheelData
    
    -- Get wheel position
    local wheelPos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, wheelData.bone))
    
    -- Create 3D wheel model for UI
    local modelName = Config.WheelGame.UI.WheelModels[1]
    if LoadModel(modelName) then
        wheelModel = CreateObject(GetHashKey(modelName), wheelPos.x, wheelPos.y, wheelPos.z, false, false, false)
        SetEntityCollision(wheelModel, false, false)
        
        -- Position the wheel properly
        local vehicleHeading = GetEntityHeading(vehicle)
        SetEntityHeading(wheelModel, vehicleHeading)
        
        -- Create bolts around the wheel
        CreateBoltsUI(wheelPos, vehicleHeading)
    end
    
    -- Start UI interaction loop
    Citizen.CreateThread(function()
        while uiActive do
            Wait(0)
            DrawWheelChangeUI(wheelPos)
            
            -- Check for input to interact with UI
            if IsControlJustPressed(0, 38) then -- E key
                InteractWithBolt()
            end
            
            if IsControlJustPressed(0, 177) then -- Backspace to cancel
                CloseWheelChangeUI()
            end
        end
    end)
end

function CreateBoltsUI(wheelPos, heading)
    bolts = {}
    local numBolts = Config.WheelGame.Difficulty.Medium.BoltsCount
    local radius = 0.15
    
    for i = 1, numBolts do
        local angle = (i - 1) * (360 / numBolts)
        local radians = math.rad(angle + heading)
        local boltX = wheelPos.x + radius * math.cos(radians)
        local boltY = wheelPos.y + radius * math.sin(radians)
        local boltZ = wheelPos.z
        
        table.insert(bolts, {
            pos = vector3(boltX, boltY, boltZ),
            tightened = true,
            highlighted = false,
            angle = angle
        })
    end
end

function DrawWheelChangeUI(wheelPos)
    -- Draw 3D text above the wheel
    local onScreenPos = GetScreenCoordFromWorldCoord(wheelPos.x, wheelPos.y, wheelPos.z + 0.3)
    if onScreenPos then
        SetTextScale(0.35 * Config.WheelGame.UI.Scale, 0.35 * Config.WheelGame.UI.Scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(currentWheel.label .. " Wheel")
        DrawText(onScreenPos.x, onScreenPos.y)
        
        -- Draw instruction text
        SetTextScale(0.25 * Config.WheelGame.UI.Scale, 0.25 * Config.WheelGame.UI.Scale)
        SetTextEntry("STRING")
        AddTextComponentString("Press [E] to interact with bolts")
        DrawText(onScreenPos.x, onScreenPos.y + 0.025)
    end
    
    -- Draw bolts
    local allBoltsLoose = true
    for i, bolt in ipairs(bolts) do
        local boltScreenPos = GetScreenCoordFromWorldCoord(bolt.pos.x, bolt.pos.y, bolt.pos.z)
        if boltScreenPos then
            -- Draw bolt circle
            local color = bolt.highlighted and Config.WheelGame.UI.Colors.Highlight or Config.WheelGame.UI.Colors.Text
            DrawMarker(25, bolt.pos.x, bolt.pos.y, bolt.pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 
                       0.02 * Config.WheelGame.UI.Scale, 0.02 * Config.WheelGame.UI.Scale, 0.02, 
                       color[1], color[2], color[3], color[4], false, true, 2, false, nil, nil, false)
            
            -- Draw bolt tightness indicator
            if bolt.tightened then
                allBoltsLoose = false
                DrawMarker(25, bolt.pos.x, bolt.pos.y, bolt.pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 
                           0.01 * Config.WheelGame.UI.Scale, 0.01 * Config.WheelGame.UI.Scale, 0.01, 
                           color[1], color[2], color[3], color[4], false, true, 2, false, nil, nil, false)
            end
        end
    end
    
    -- If all bolts are loose, finish the minigame
    if allBoltsLoose then
        FinishWheelChange()
    end
end

function InteractWithBolt()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    
    -- Find closest bolt to interact with
    local closestBolt = nil
    local closestDist = 0.5
    
    for i, bolt in ipairs(bolts) do
        local dist = #(coords - bolt.pos)
        if dist < closestDist then
            closestDist = dist
            closestBolt = i
        end
    end
    
    if closestBolt then
        -- Do a skill check to loosen/tighten the bolt
        local success = lib.skillCheck('easy')
        if success then
            -- Toggle bolt state
            bolts[closestBolt].tightened = not bolts[closestBolt].tightened
            
            -- Play appropriate sound
            if bolts[closestBolt].tightened then
                PlaySoundFrontend(-1, "Drill_Pin_Break", "DLC_HEIST_FLEECA_SOUNDSET", 1)
            else
                PlaySoundFrontend(-1, "Drill_Pin_Break", "DLC_HEIST_FLEECA_SOUNDSET", 1)
            end
        else
            -- Failed skill check
            PlaySoundFrontend(-1, "CHECKPOINT_MISSED", "HUD_MINI_GAME_SOUNDSET", 1)
        end
    end
end

function FinishWheelChange()
    -- Show wheel removal animation
    if DoesEntityExist(wheelModel) then
        local originalPos = GetEntityCoords(wheelModel)
        local animDuration = 1000 -- 1 second
        local startTime = GetGameTimer()
        
        Citizen.CreateThread(function()
            while GetGameTimer() - startTime < animDuration do
                local progress = (GetGameTimer() - startTime) / animDuration
                local offset = progress * 0.5 -- Move wheel 0.5 units away
                local newZ = originalPos.z + (progress * 0.2) -- Lift wheel slightly
                
                SetEntityCoords(wheelModel, 
                    originalPos.x, 
                    originalPos.y, 
                    newZ, 
                    false, false, false, false)
                
                Wait(0)
            end
            
            -- Give player the wheel item
            TriggerServerEvent('lc_minigames:giveWheel')
            
            -- Clean up UI
            CloseWheelChangeUI()
            
            -- Notify player
            lib.notify({
                title = 'Success',
                description = 'Wheel successfully removed',
                type = 'success'
            })
        end)
    else
        CloseWheelChangeUI()
    end
end

function CloseWheelChangeUI()
    uiActive = false
    isMinigameActive = false
    
    -- Clean up 3D objects
    if DoesEntityExist(wheelModel) then
        DeleteEntity(wheelModel)
        wheelModel = nil
    end
    
    bolts = {}
end

-- Variables
local wheelUiActive = false

-- Command to open the 3D wheel UI
RegisterCommand(Config.WheelUI.Command, function()
    DebugPrint("Command triggered: " .. Config.WheelUI.Command)
    ToggleWheelUI(not wheelUiActive)
end, false)

-- Add a keybind for easier testing
RegisterKeyMapping(Config.WheelUI.Command, 'Open Wheel UI', 'keyboard', 'f5')

-- Function to toggle the wheel UI
function ToggleWheelUI(state)
    DebugPrint("ToggleWheelUI called with state: " .. tostring(state))
    
    wheelUiActive = state
    
    -- Show/hide the NUI
    SetNuiFocus(state, state)
    
    -- Get the wheel model from config
    local wheelModel = Config.WheelUI.DefaultWheelModel
    DebugPrint("Using wheel model from config: " .. wheelModel)
    
    -- Example part qualities - these would normally be fetched from the vehicle
    local qualities = {
        tire = { label = "Excellent", class = "excellent" },
        rim = { label = "Good", class = "good" },
        bolts = {
            { class = "excellent" },
            { class = "good" },
            { class = "fair" },
            { class = "poor" },
            { class = "excellent" }
        }
    }
    
    -- Send message to NUI
    DebugPrint("Sending NUI message: toggleUI, show=" .. tostring(state))
    SendNUIMessage({
        action = "toggleUI",
        show = state,
        wheelModel = wheelModel,
        qualities = qualities,
        timestamp = GetGameTimer()
    })
end

-- NUI Callback for when the UI is closed
RegisterNUICallback('closeUI', function(data, cb)
    DebugPrint("NUI callback received: closeUI")
    ToggleWheelUI(false)
    cb('ok')
end)

-- NUI Callback for when a wheel is "saved" or action completed
RegisterNUICallback('completeAction', function(data, cb)
    DebugPrint("NUI callback received: completeAction")
    DebugPrint("Wheel model: " .. (data.wheelModel or "none"))
    
    cb('ok')
    ToggleWheelUI(false)
end)

-- Debug command to check if NUI is working
RegisterCommand('checkui', function()
    DebugPrint("Sending test message to NUI")
    
    SendNUIMessage({
        action = "testConnection",
        message = "Testing NUI connection at " .. os.date('%H:%M:%S')
    })
end, false)

-- Initialize when resource starts
AddEventHandler('onClientResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    
    DebugPrint("Resource started: " .. resourceName)
    DebugPrint("Use /" .. Config.WheelUI.Command .. " to open wheel UI")
    DebugPrint("Use /checkui to test NUI connection")
    
    -- Ensure UI is closed on resource start
    wheelUiActive = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = "toggleUI",
        show = false
    })
end)