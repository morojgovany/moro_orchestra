local playing = Config.DefaultMusician

local function isPlayerNear(_source, index)
    local musician = Config.Musicians[index]
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

RegisterNetEvent('moro_piano:requestState')
AddEventHandler('moro_piano:requestState', function()
    TriggerClientEvent('moro_piano:syncState', source, playing)
end)

RegisterNetEvent('moro_piano:toggle')
AddEventHandler('moro_piano:toggle', function(index)
    local _source = source
    if not isPlayerNear(_source, index) then
        return
    end

    if playing == index then
        playing = nil
    else
        playing = index
    end

    TriggerClientEvent('moro_piano:syncState', -1, playing)
end)
