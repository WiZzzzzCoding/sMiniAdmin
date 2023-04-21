ESX = exports['es_extended']:getSharedObject()

CreateThread(function()
    ESX.TriggerServerCallback('sMiniAdmin:GetGroup', function(grup) 
        group = grup
    end)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
    AddTextEntry(entryTitle, textEntry)
    DisplayOnscreenKeyboard(1, entryTitle, '', inputText, '', '', '', maxLength)
  
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
      Citizen.Wait(0)
    end
  
    if UpdateOnscreenKeyboard() ~= 2 then
      local result = GetOnscreenKeyboardResult()
      Citizen.Wait(500)
      return result
    else
      Citizen.Wait(500)
      return nil
    end
  end

local display = false

RegisterCommand("+miniadmin", function()
    if group == 'admin' then
        SetDisplay(not display)
    end
end)

RegisterKeyMapping("+miniadmin", "Ouvrir le mini admin", "keyboard", "F9")

RegisterNUICallback("coords", function(data)
    local coords, heading = GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId())
    SendNUIMessage({
        type = 'clipboard',
        data = '' .. vec(coords.x, coords.y, coords.z, heading)
    })
    ESX.ShowNotification('Coordonnées copiés !')
end)

RegisterNUICallback('autrepage', function(data)
    DisableControlAction(0, 59, true)
end)

RegisterNUICallback('noclip', function(data)
    news_no_clip()
end)

RegisterNUICallback('bring', function(data)
    SetDisplay(false)
    local id = KeyboardInput("ID", "", "", 3)
    ExecuteCommand("bring "..id.."")
    SetDisplay(true)
end)

RegisterNUICallback('goto', function(data)
    SetDisplay(false)
    local id = KeyboardInput("ID", "", "", 3)
    ExecuteCommand("goto "..id.."")
    SetDisplay(true)
end)

RegisterNUICallback('freeze', function(data)
    SetDisplay(false)
    local id = KeyboardInput("ID", "", "", 3)
    ExecuteCommand("freeze "..id.."")
    SetDisplay(true)
end)

RegisterNUICallback('unfreeze', function(data)
    SetDisplay(false)
    local id = KeyboardInput("ID", "", "", 3)
    ExecuteCommand("unfreeze "..id.."")
    SetDisplay(true)
end)

RegisterNUICallback('tpm', function(data)
    SetDisplay(false)
    ExecuteCommand('tpm')
    Wait(1000)
    SetDisplay(true)
end)

RegisterNUICallback("error", function(data)
    print(data.error)
    SetDisplay(false)
end)

RegisterNUICallback("exit", function(data)
    SetDisplay(false)
end)

function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
    })
end

local noclip = false
local noclip_speed = 2.0

function news_no_clip()
  noclip = not noclip
  local ped = PlayerPedId()
  if noclip then -- activé
    SetEntityInvincible(ped, true)
	SetEntityVisible(ped, false, false)
	invisible = true
	ESX.ShowNotification("Noclip ~g~activé")
  else -- désactivé
    SetEntityInvincible(ped, false)
	SetEntityVisible(ped, true, false)
	invisible = false
	ESX.ShowNotification("Noclip ~r~désactivé")
  end
end

function getPosition()
  local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(),true))
  return x,y,z
end

function getCamDirection()
  local heading = GetGameplayCamRelativeHeading()+GetEntityHeading(PlayerPedId())
  local pitch = GetGameplayCamRelativePitch()

  local x = -math.sin(heading*math.pi/180.0)
  local y = math.cos(heading*math.pi/180.0)
  local z = math.sin(pitch*math.pi/180.0)

  local len = math.sqrt(x*x+y*y+z*z)
  if len ~= 0 then
    x = x/len
    y = y/len
    z = z/len
  end

  return x,y,z
end

function isNoclip()
  return noclip
end

Citizen.CreateThread(function()
	while true do
	  Citizen.Wait(0)
	  if noclip then
		local ped = PlayerPedId()
		local x,y,z = getPosition()
		local dx,dy,dz = getCamDirection()
		local speed = noclip_speed
  
		-- reset du velocity
		SetEntityVelocity(ped, 0.0001, 0.0001, 0.0001)
  
		-- aller vers le haut
		if IsControlPressed(0,32) then -- MOVE UP
		  x = x+speed*dx
		  y = y+speed*dy
		  z = z+speed*dz
		end
  
		-- aller vers le bas
		if IsControlPressed(0,269) then -- MOVE DOWN
		  x = x-speed*dx
		  y = y-speed*dy
		  z = z-speed*dz
		end
  
		SetEntityCoordsNoOffset(ped,x,y,z,true,true,true)
	  end
	end
end)