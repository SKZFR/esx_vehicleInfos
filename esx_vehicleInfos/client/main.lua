-----
-- Copyright [2018] [SKZ]
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at

--     http://www.apache.org/licenses/LICENSE-2.0
-- 
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
----

local Keys = { ["E"] = 38 }
ESX = nil

Citizen.CreateThread(function()
  	while ESX == nil do
  	    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
  	    Citizen.Wait(1)
  	end
end)

function VehicleInFront() -- Pour le diagnostic, récupérer le véhicule devant le ped
    local vehicle, distance = ESX.Game.GetClosestVehicle()
    if vehicle ~= nil and distance < 3 then
        return vehicle
    else 
        return nil
    end
end

Citizen.CreateThread(function()
	  while true do
		    Citizen.Wait(1)

        if not IsPedInAnyVehicle(PlayerPedId(), false) then
            if InVehicleMenu then
                local Vehicle = VehicleInFront()

                if not DoesEntityExist(Vehicle) then
                    InVehicleMenu = false
                    ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'vehicle_infos')
                end
            end

      		  if IsControlJustPressed(1, Keys['E']) then -- If E key pressed then
                local Vehicle = VehicleInFront()

                if DoesEntityExist(Vehicle) then
                    InVehicleMenu = true

                    local EngineHealth = GetVehicleEngineHealth(Vehicle)

                    local VehicleClass = GetVehicleClass(Vehicle)
                    local VehiclePlate = GetVehicleNumberPlateText(Vehicle)

                    local VehicleModel = GetEntityModel(Vehicle)
                    local VehicleName = GetDisplayNameFromVehicleModel(VehicleModel)

                    -- Classes:

                        if VehicleClass == 0 then VehicleClass = _U('Compacts')
                        elseif VehicleClass == 1 then VehicleClass = _U('Sedans')
                        elseif VehicleClass == 2 then VehicleClass = _U('SUVs')
                        elseif VehicleClass == 3 then VehicleClass = _U('Coupes')
                        elseif VehicleClass == 4 then VehicleClass = _U('Muscle')
                        elseif VehicleClass == 5 then VehicleClass = _U('Sports Classics')
                        elseif VehicleClass == 6 then VehicleClass = _U('Sports')
                        elseif VehicleClass == 7 then VehicleClass = _U('Super')
                        elseif VehicleClass == 8 then VehicleClass = _U('Motorcycles')
                        elseif VehicleClass == 9 then VehicleClass = _U('Off-road')
                        elseif VehicleClass == 10 then VehicleClass = _U('Industrial')
                        elseif VehicleClass == 11 then VehicleClass = _U('Utility')
                        elseif VehicleClass == 12 then VehicleClass = _U('Vans')
                        elseif VehicleClass == 13 then VehicleClass = _U('Cycles')
                        elseif VehicleClass == 14 then VehicleClass = _U('Boats')
                        elseif VehicleClass == 15 then VehicleClass = _U('Helicopters')
                        elseif VehicleClass == 16 then VehicleClass = _U('Planes')
                        elseif VehicleClass == 17 then VehicleClass = _U('Service')
                        elseif VehicleClass == 18 then VehicleClass = _U('Emergency')
                        elseif VehicleClass == 19 then VehicleClass = _U('Military')
                        elseif VehicleClass == 20 then VehicleClass = _U('Commercial')
                        else VehicleClass = _U('notfound') end

                    if EngineHealth >= 850 then
                        EngineHealth = "<span style=\"color:#22780F;\">" .. _U('verygood') .. "</span>"
                    elseif EngineHealth >= 600 then
                        EngineHealth = "<span style=\"color:#D1B606;\">" .. _U('good') .. "</span>"
                    elseif EngineHealth >= 300 then
                        EngineHealth = "<span style=\"color:#ED7F10;\">" .. _U('medium') .. "</span>"
                    else 
                        EngineHealth = "<span style=\"color:#B82010;\">" .. _U('bad') .. "</span>"
                    end

                    local elements = {}

                    table.insert(elements, { label = '-- Infos --', value = nil })

                    table.insert(elements, { label = '' .. _U('model') .. '<span style="color:#CC5500;">' .. VehicleName .. '</span>', value = nil })
                    table.insert(elements, { label = '' .. _U('category') .. '<span style="color:#DFAF2C;">' .. VehicleClass .. '</span>', value = nil })

                    if VehiclePlate then
                        table.insert(elements, { label = '' .. _U('plate') .. '<span style="color:#318CE7;">' .. VehiclePlate .. '</span>', value = nil })
                    end
                    table.insert(elements, { label = '' .. _U('vehicleState') .. ' ' .. EngineHealth .. '</span>', value = nil })


                    ESX.UI.Menu.Open(
                        'default', GetCurrentResourceName(), 'vehicle_infos',
                        {
                          title    = _U('title'),
                          align    = 'top-left',
                          elements = elements
                        },

                        function(data, menu)
                        end,

                      function(data, menu)
                        menu.close()
                      end
                    )
                end
            end
        else
            Citizen.Wait(500)
        end
	  end
end)
