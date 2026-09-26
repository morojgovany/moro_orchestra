local playing = {}

for group, index in pairs(Config.DefaultMusicians) do
    playing[group] = index
end

local function isPlayerNear(_source, group, index)
    local musicians = Config.Musicians[group]
    if not musicians then
        return false
    end

    local musician = musicians[index]
    if not musician then
        return false
    end

    local playerPed = GetPlayerPed(_source)
    if not playerPed or playerPed == 0 then
        return false
    end

    local distance = #(GetEntityCoords(playerPed) - vector3(musician.position.x, musician.position.y, musician.position.z))

    return distance <= (Config.PropSearchRadius + Config.PromptDistance)
end

RegisterNetEvent('moro_orchestra:requestState')
AddEventHandler('moro_orchestra:requestState', function()
    local _source = source

    for group in pairs(Config.Musicians) do
        TriggerClientEvent('moro_orchestra:syncState', _source, group, playing[group])
    end
end)

RegisterNetEvent('moro_orchestra:toggle')
AddEventHandler('moro_orchestra:toggle', function(group, index)
    local _source = source
    if not isPlayerNear(_source, group, index) then
        return
    end

    if playing[group] == index then
        playing[group] = nil
    else
        playing[group] = index
    end

    TriggerClientEvent('moro_orchestra:syncState', -1, group, playing[group])
end)
