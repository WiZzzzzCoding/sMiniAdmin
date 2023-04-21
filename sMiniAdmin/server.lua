ESX = exports['es_extended']:getSharedObject()

ESX.RegisterServerCallback('sMiniAdmin:GetGroup', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local group = xPlayer.getGroup()
    cb(group)
end)