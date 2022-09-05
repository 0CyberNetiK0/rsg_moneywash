local QBCore = exports['qb-core']:GetCoreObject()

-- remove token
RegisterServerEvent("rsg_moneywash:server:removetoken")
AddEventHandler("rsg_moneywash:server:removetoken", function(item, amount)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	Player.Functions.RemoveItem(item, amount)
	TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "remove")
end)

-- money washing
RegisterServerEvent("rsg_moneywash:server:dowashing")
AddEventHandler("rsg_moneywash:server:dowashing", function(amount)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	local amount = tonumber(amount)
	local checkdirty = Player.Functions.GetItemByName("dirtymoney")
	if checkdirty ~= nil then
		local amountdirty = Player.Functions.GetItemByName('dirtymoney').amount
		if amountdirty >= amount then
			Player.Functions.RemoveItem('dirtymoney', amount)
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['dirtymoney'], "remove")
			Player.Functions.AddMoney('cash', amount)
			TriggerClientEvent('QBCore:Notify', src, 'You washed ' ..amount.. ' dirty money!', 'success')
		else
			TriggerClientEvent('QBCore:Notify', src, 'You do not have enough dirty money to do that!', 'error')
		end
	else
		TriggerClientEvent('QBCore:Notify', src, 'You do not have any dirty money!', 'error')
	end
end)