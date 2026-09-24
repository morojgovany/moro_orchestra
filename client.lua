local musicians = {}
local playing = nil

local function loadModel(model)
    local hash = joaat(model)
    if not IsModelInCdimage(hash) then
        print(('moro_piano: invalid ped model %s'):format(model))
        return nil
    end

    RequestModel(hash)
    local timeout = GetGameTimer() + Config.LoadTimeout
    while not HasModelLoaded(hash) and GetGameTimer() < timeout do
        Wait(10)
    end

    if not HasModelLoaded(hash) then
        return nil
    end

    return hash
end

local function findClosestProp(coords, props)
    local closestProp, closestOffset, closestDistance = nil, nil, Config.PropSearchRadius

    for _, prop in ipairs(props) do
        local entity = GetClosestObjectOfType(coords.x, coords.y, coords.z, Config.PropSearchRadius, joaat(prop.model), false, false, false)

        if entity ~= 0 and DoesEntityExist(entity) then
            local distance = #(coords - GetEntityCoords(entity))
            if distance < closestDistance then
                closestProp = entity
                closestOffset = prop.offset
                closestDistance = distance
            end
        end
    end

    return closestProp, closestOffset
end

local function getPlacement(config)
    local coords = vector3(config.position.x, config.position.y, config.position.z)
    local heading = config.position.w

    if not config.props then
        return coords, heading
    end

    local prop, offset = findClosestProp(coords, config.props)
    if not prop then
        return nil
    end

    offset = offset or vector4(0.0, 0.0, 0.0, 0.0)

    return GetOffsetFromEntityInWorldCoords(prop, offset.x, offset.y, offset.z), GetEntityHeading(prop) + offset.w
end

local function createPrompt(group, label)
    local prompt = PromptRegisterBegin()
    PromptSetControlAction(prompt, Config.PromptKey)
    PromptSetText(prompt, CreateVarString(10, 'LITERAL_STRING', label))
    PromptSetEnabled(prompt, 1)
    PromptSetVisible(prompt, 1)
    PromptSetStandardMode(prompt, 1)
    PromptSetGroup(prompt, group)
    PromptRegisterEnd(prompt)

    return prompt
end

local function canInteract(playerPed)
    return not IsEntityInWater(playerPed)
            and not IsPedRunning(playerPed)
            and not IsPedSprinting(playerPed)
            and not IsPedDeadOrDying(playerPed, 1)
            and not IsPedOnMount(playerPed)
            and not IsPedInCombat(playerPed)
            and not IsPedInMeleeCombat(playerPed)
end

local function refreshMusician(index)
    local musician = musicians[index]
    if not musician then
        return
    end

    local config = Config.Musicians[index]
    local scenario = config.idleScenario
    local label = Config.Texts.start

    if playing == index then
        scenario = config.scenario
        label = Config.Texts.stop
    end

    if DoesEntityExist(musician.ped) then
        ClearPedTasksImmediately(musician.ped)

        if scenario then
            TaskStartScenarioAtPosition(musician.ped, joaat(scenario), musician.coords.x, musician.coords.y, musician.coords.z, musician.heading, -1, false, true)
        end
    end

    PromptSetText(musician.prompt, CreateVarString(10, 'LITERAL_STRING', label))
end

local function spawnMusician(index)
    local config = Config.Musicians[index]
    local coords, heading = getPlacement(config)
    if not coords then
        return nil
    end

    local hash = loadModel(config.model)
    if not hash then
        return nil
    end

    local ped = CreatePed(hash, coords.x, coords.y, coords.z, heading, false, false, false, false)
    local timeout = GetGameTimer() + Config.LoadTimeout
    while not DoesEntityExist(ped) and GetGameTimer() < timeout do
        Wait(10)
    end

    SetModelAsNoLongerNeeded(hash)

    if not DoesEntityExist(ped) then
        return nil
    end

    Citizen.InvokeNative(0x283978A15512B2FE, ped, true) -- SetRandomOutfitVariation
    SetEntityAsMissionEntity(ped, true, true)
    SetEntityInvincible(ped, true)
    SetEntityCanBeDamaged(ped, false)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)

    return {
        ped = ped,
        coords = coords,
        heading = heading,
        promptGroup = GetRandomIntInRange(0, 0xffffff)
    }
end

local function despawnMusician(index)
    local musician = musicians[index]
    if not musician then
        return
    end

    if DoesEntityExist(musician.ped) then
        ClearPedTasksImmediately(musician.ped)
        DeletePed(musician.ped)
    end

    if musician.prompt then
        PromptDelete(musician.prompt)
    end

    musicians[index] = nil
end

RegisterNetEvent('moro_piano:syncState')
AddEventHandler('moro_piano:syncState', function(index)
    local previous = playing
    playing = index

    if previous == index then
        return
    end

    if previous then
        refreshMusician(previous)
    end

    if index then
        refreshMusician(index)
    end
end)

Citizen.CreateThread(function()
    if IsLoadingScreenVisible() or IsScreenFadedOut() then
        repeat Wait(500) until not IsLoadingScreenVisible() and not IsScreenFadedOut()
    end

    TriggerServerEvent('moro_piano:requestState')

    while true do
        Wait(Config.SpawnCheckInterval)
        local playerCoords = GetEntityCoords(PlayerPedId())

        for index, config in ipairs(Config.Musicians) do
            local distance = #(playerCoords - vector3(config.position.x, config.position.y, config.position.z))
            local musician = musicians[index]

            if distance <= Config.ActivationDistance then
                if not musician then
                    local spawned = spawnMusician(index)
                    if spawned then
                        spawned.prompt = createPrompt(spawned.promptGroup, Config.Texts.start)
                        musicians[index] = spawned
                        refreshMusician(index)
                    end
                end
            elseif musician then
                despawnMusician(index)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        local hasActiveMusician = next(musicians) ~= nil

        if hasActiveMusician then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)

            for index, musician in pairs(musicians) do
                if #(playerCoords - musician.coords) <= Config.PromptDistance and canInteract(playerPed) then
                    PromptSetActiveGroupThisFrame(musician.promptGroup, CreateVarString(10, 'LITERAL_STRING', Config.Musicians[index].label))

                    if PromptHasStandardModeCompleted(musician.prompt) then
                        TriggerServerEvent('moro_piano:toggle', index)
                        Wait(Config.ToggleCooldown)
                    end
                end
            end
        end

        Wait(hasActiveMusician and 1 or 500)
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        for index in pairs(musicians) do
            despawnMusician(index)
        end
    end
end)
