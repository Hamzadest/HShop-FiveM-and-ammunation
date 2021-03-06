ESX = nil

local PlayerData = {}

Citizen.CreateThread(function() 
	while ESX == nil do 
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) 
		Citizen.Wait(100)
	end 
end)

RegisterCommand("getpos", function(source, args, raw)
    local ped = GetPlayerPed(PlayerId())
    local coords = GetEntityCoords(ped, false)
    local heading = GetEntityHeading(ped)
    Citizen.Trace(tostring("X: " .. coords.x .. " Y: " .. coords.y .. " Z: " .. coords.z .. " HEADING: " .. heading))
end, false)

function OpenShopMenu()
	local elements = {}
	for _,v in pairs(Config.Food) do table.insert(elements, {label = v[1]..' | <span style="color:red;">'..v[3]..'$</span> ', name = v[2]}) end
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'actions', {title = _U('shop'), align = 'left', elements = elements }, function(data, menu)	
		for _,v in pairs(Config.Food) do
			if data.current.name == v[2] then
				TriggerServerEvent('Hamza_1:Shop', 1, v[1], v[2], v[3])
			end
		end
	end, function(data, menu) menu.close() end)
end

function OpenArmurerieMenu()
	local elements = {}
	for _,v in pairs(Config.Weapon) do table.insert(elements, {label = v[1]..' | <span style="color:red;">'..v[3]..'$</span> ', name = v[2]}) end
 	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'actions', { title = _U('armurerie'), align = 'left', elements = elements }, function(data, menu)		
		for _,v in pairs(Config.Weapon) do
			if data.current.name == v[2] then
				ESX.TriggerServerCallback('Hamza_1:checkLicense', function(hasWeaponLicense)
					if v[4] == 1 then
						if hasWeaponLicense then
							TriggerServerEvent('Hamza_1:Shop', 2, v[1], v[2], v[3])
                		else
							ESX.ShowAdvancedNotification(_U('armurerie'), '', _U('PasLicense'), 'CHAR_DOM', 1)
						end
					else
						TriggerServerEvent('Hamza_1:Shop', 2, v[1], v[2], v[3])
					end
				end, GetPlayerServerId(PlayerId()), 'weapon')   
			end
		end
	end, function(data, menu) menu.close() end)
end

function OpenPoleEmploiMenu()
	local elements = {}
	for _,v in pairs(Config.Job) do table.insert(elements, {label = v[1], name = v[2]}) end
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'actions', {title = _U('poleemploi'), align = 'left', elements = elements }, function(data, menu)		
		for _,v in pairs(Config.Job) do
			if data.current.name == v[2] then
				TriggerServerEvent('Hamza_1:Autre', v[1], v[2])
			end
		end
	end, function(data, menu) menu.close() end)
end

Citizen.CreateThread(function()
	while true do
        time = 500
		for _,v in pairs(Config.Shop) do
		    if v[1] == 1 then
				if Vdist2(GetEntityCoords(PlayerPedId(), false), v[2]) < 3 then time = 10 if IsControlJustPressed(1,51) then OpenShopMenu() end end	
		    elseif v[1] == 2 then
				if Vdist2(GetEntityCoords(PlayerPedId(), false), v[2]) < 3 then time = 10 if IsControlJustPressed(1,51) then OpenArmurerieMenu() end end
		    elseif v[1] == 3 then
				if Vdist2(GetEntityCoords(PlayerPedId(), false), v[2]) < 2 then time = 10 if IsControlJustPressed(1,51) then OpenPoleEmploiMenu() end end
			end	
		end
		Citizen.Wait(time)
	end
end)