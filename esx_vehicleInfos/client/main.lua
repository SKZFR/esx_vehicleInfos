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

local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX                 = nil

Citizen.CreateThread(function()
	while ESX == nil do
	    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	    Citizen.Wait(35)
	end
end)

function VehicleInFront() -- Pour le diagnostic, récupérer le véhicule devant le ped

    local vehicle, distance = ESX.Game.GetClosestVehicle()
    if vehicle ~= nil and distance < 3 then
        return vehicle
    else 
        return 0 
    end
end

Citizen.CreateThread(function() -- If there are no vehicles in front of you, it close the menu.
    while true do
        Citizen.Wait(50)

        local playerPed   = GetPlayerPed(-1)
        local vehicle     = VehicleInFront()

        if vehicle == 0 then
            ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'vehicle_infos')
            Wait(1000)
        end
    end
end)


Citizen.CreateThread(function()
	while true do
		Wait(1)

		  if IsControlJustPressed(1, Keys['E']) then -- If E key pressed then

          local playerPed   = GetPlayerPed(-1)

          local vehicle     = VehicleInFront()
          local closecar    = GetClosestVehicle(x, y, z, 6.0, 0, 71)

          local healthMeca  = GetVehicleEngineHealth(vehicle)

          local categ       = GetVehicleClass(vehicle)

          local plate       = GetVehicleNumberPlateText(vehicle)

          local model       = GetEntityModel(vehicle)
          local modelName 	= GetDisplayNameFromVehicleModel(model)

          if model ~= 0 and modelName ~= "CARNOTFOUND" then -- If there is a vehicle in front of you then

                if categ == 0 then categ = _U('Compacts')
                elseif categ == 1 then categ = _U('Sedans')
                elseif categ == 2 then categ = _U('SUVs')
                elseif categ == 3 then categ = _U('Coupes')
                elseif categ == 4 then categ = _U('Muscle')
                elseif categ == 5 then categ = _U('Sports Classics')
                elseif categ == 6 then categ = _U('Sports')
                elseif categ == 7 then categ = _U('Super')
                elseif categ == 8 then categ = _U('Motorcycles')
                elseif categ == 9 then categ = _U('Off-road')
                elseif categ == 10 then categ = _U('Industrial')
                elseif categ == 11 then categ = _U('Utility')
                elseif categ == 12 then categ = _U('Vans')
                elseif categ == 13 then categ = _U('Cycles')
                elseif categ == 14 then categ = _U('Boats')
                elseif categ == 15 then categ = _U('Helicopters')
                elseif categ == 16 then categ = _U('Planes')
                elseif categ == 17 then categ = _U('Service')
                elseif categ == 18 then categ = _U('Emergency')
                elseif categ == 19 then categ = _U('Military')
                elseif categ == 20 then categ = _U('Commercial')
                else categ = _U('notfound') end

                if healthMeca >= 850 then healthMeca = "<span style=\"color:#22780F;\">" .. _U('verygood') .. "</span>"
                elseif healthMeca >= 600 then healthMeca = "<span style=\"color:#D1B606;\">" .. _U('good') .. "</span>"
                elseif healthMeca >= 300 then healthMeca = "<span style=\"color:#ED7F10;\">" .. _U('medium') .. "</span>"
                else healthMeca = "<span style=\"color:#B82010;\">" .. _U('bad') .. "</span>" end

                local elements = {}

                table.insert(elements, {label = '-- Infos --', value = nil})
                --
                table.insert(elements, {label = '' .. _U('model') .. '<span style="color:#CC5500;">'           .. modelName .. '</span>', value = nil})
                table.insert(elements, {label = '' .. _U('category') .. '<span style="color:#DFAF2C;">'                    .. categ .. '</span>', value = nil})
                if plate ~= nil then
                    table.insert(elements, {label = '' .. _U('plate') .. '<span style="color:#318CE7;">'                   .. plate .. '</span>', value = nil})
                end
                table.insert(elements, {label = '' .. _U('vehicleState') .. ' '                                    .. healthMeca .. '</span>', value = nil})


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

	 end
end)
