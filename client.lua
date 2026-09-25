local musicians = {}
local playing = {}

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

local function refreshMusician(group, index)
    local groupMusicians = musicians[group]
    if not groupMusicians then
        return
    end

    local musician = groupMusicians[index]
    if not musician then
        return
    end

    local config = Config.Musicians[group][index]
    local scenario = config.idleScenario
    local label = Config.Texts.start

    if playing[group] == index then
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

local function spawnMusician(group, index)
    local config = Config.Musicians[group][index]
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

local function despawnMusician(group, index)
    local groupMusicians = musicians[group]
    if not groupMusicians then
        return
    end

    local musician = groupMusicians[index]
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

    groupMusicians[index] = nil

    if next(groupMusicians) == nil then
        musicians[group] = nil
    end
end

RegisterNetEvent('moro_piano:syncState')
AddEventHandler('moro_piano:syncState', function(group, index)
    local previous = playing[group]
    playing[group] = index

    if previous == index then
        return
    end

    if previous then
        refreshMusician(group, previous)
    end

    if index then
        refreshMusician(group, index)
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

        for group, groupConfig in pairs(Config.Musicians) do
            for index, config in ipairs(groupConfig) do
                local distance = #(playerCoords - vector3(config.position.x, config.position.y, config.position.z))
                local musician = musicians[group] and musicians[group][index]

                if distance <= Config.ActivationDistance then
                    if not musician then
                        local spawned = spawnMusician(group, index)
                        if spawned then
                            spawned.prompt = createPrompt(spawned.promptGroup, Config.Texts.start)
                            musicians[group] = musicians[group] or {}
                            musicians[group][index] = spawned
                            refreshMusician(group, index)
                        end
                    end
                elseif musician then
                    despawnMusician(group, index)
                end
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
            local closestGroup, closestIndex, closestDistance = nil, nil, Config.PromptDistance

            for group, groupMusicians in pairs(musicians) do
                for index, musician in pairs(groupMusicians) do
                    local distance = #(playerCoords - musician.coords)
                    if distance <= closestDistance then
                        closestGroup, closestIndex, closestDistance = group, index, distance
                    end
                end
            end

            if closestGroup and canInteract(playerPed) then
                local musician = musicians[closestGroup][closestIndex]
                PromptSetActiveGroupThisFrame(musician.promptGroup, CreateVarString(10, 'LITERAL_STRING', Config.Musicians[closestGroup][closestIndex].label))

                if PromptHasStandardModeCompleted(musician.prompt) then
                    TriggerServerEvent('moro_piano:toggle', closestGroup, closestIndex)
                    Wait(Config.ToggleCooldown)
                end
            end
        end

        Wait(hasActiveMusician and 1 or 500)
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        for group, groupMusicians in pairs(musicians) do
            for index in pairs(groupMusicians) do
                despawnMusician(group, index)
            end
        end
    end
end)
