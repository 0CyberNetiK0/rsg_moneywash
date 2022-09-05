local QBCore = exports['qb-core']:GetCoreObject()

-- money wash outside (enter)
Citizen.CreateThread(function()

	exports['qb-target']:AddBoxZone("wash-access", vector3(1135.83, -3232.15, 5.89), 1, 1, {
		name = "wash-access",
		heading = 0,
		debugpoly = false,
		minZ=4.89,
		maxZ=6.89
	}, {
		options = {
			{  
				type = "client",
				event = "rsg_moneywash:client:client:washenterance",
				icon = "fas fa-donate",
				label = "Enter Wash",
			},
		},
		distance = 2.5
	})
	
end)

-- enter wash
RegisterNetEvent('rsg_moneywash:client:client:washenterance')
AddEventHandler('rsg_moneywash:client:client:washenterance', function()
	local hasItem = QBCore.Functions.HasItem('washtoken', Config.TokensNeeded)
	local player = GetPlayerPed(-1)
	if hasItem then
		QBCore.Functions.Progressbar("enter-wash", "Handing over token..", 5000, false, true, {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
			}, {
				animDict = "mp_common",
				anim = "givetake1_a",
				flags = 8,
			}, {}, {}, function() -- Done			
			DoScreenFadeOut(500)
			Wait(500)
			SetEntityCoords(player, 1118.8697, -3195.195, -40.40298)
			SetEntityHeading(player, 184.05032)
			DoScreenFadeIn(500)
			TriggerServerEvent("rsg_moneywash:server:removetoken", 'washtoken', Config.TokensNeeded)
		end, function()
			QBCore.Functions.Notify("Cancelled..", "error")
		end)
	else
		QBCore.Functions.Notify("You do not have any tokens!", "error")
	end
end)

-- money wash inside (leave)
Citizen.CreateThread(function()

	exports['qb-target']:AddBoxZone("wash-exit", vector3(1118.76, -3193.27, -40.4), 1, 1, {
		name = "wash-exit",
		heading = 0,
		debugpoly = false,
		minZ=-41.4,
		maxZ=-39.4
	}, {
		options = {
			{  
				type = "client",
				event = "rsg_moneywash:client:client:washexit",
				icon = "far fa-comment-dots",
				label = "Exit Wash",
			},
		},
		distance = 2.5
	})
	
end)

-- exit wash
RegisterNetEvent('rsg_moneywash:client:client:washexit')
AddEventHandler('rsg_moneywash:client:client:washexit', function()
	local player = GetPlayerPed(-1)
	QBCore.Functions.Progressbar("exit-wash", "Leaving..", 5000, false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
		}, {
			animDict = "mp_common",
			anim = "givetake1_a",
			flags = 8,
		}, {}, {}, function() -- Done			
		DoScreenFadeOut(500)
		Wait(500)
		SetEntityCoords(player, 1135.8297, -3230.636, 5.8986325)
		SetEntityHeading(player, 3.222536)
		DoScreenFadeIn(500)
	end, function()
		QBCore.Functions.Notify("Cancelled..", "error")
	end)
end)

-- target
Citizen.CreateThread(function()

	local washstation = { 
	`bkr_prop_prtmachine_dryer`,
	`bkr_prop_prtmachine_dryer_op`,
	`bkr_prop_prtmachine_dryer_spin`,
	}
    exports['qb-target']:AddTargetModel(washstation, {
        options = {
            {
                type = "client",
				event = "rsg_moneywash:client:dowashing",
                icon = "fas fa-hammer",
                label = "Start Washing",
            },
        },
        distance = 3.0
    })
	
end)

-- input
RegisterNetEvent('rsg_moneywash:client:dowashing', function()
    local input = exports['qb-input']:ShowInput({
        header = "Super Money Wash",
        submitText = "wash",
        inputs = {
            {
                type = 'number',
                isRequired = true,
                name = 'amount',
                text = 'amount to wash'
            }
        }
    })
    if input then
        if not input.amount then return end
        TriggerEvent("rsg_moneywash:client:client:washcycle", input.amount)
    end
end)

-- start the wash cycle
RegisterNetEvent('rsg_moneywash:client:client:washcycle')
AddEventHandler('rsg_moneywash:client:client:washcycle', function(amount)
	QBCore.Functions.Progressbar("wash-cycle", "Washing Money..", 30000, false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
		}, {
			animDict = "mp_common",
			anim = "givetake1_a",
			flags = 8,
		}, {}, {}, function() -- Done			
		TriggerServerEvent("rsg_moneywash:server:dowashing", amount)
	end, function()
		QBCore.Functions.Notify("Cancelled..", "error")
	end)
end)