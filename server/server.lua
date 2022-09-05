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
	local checkbills = Player.Functions.GetItemByName("markedbills")
	if checkbills ~= nil then
		local amountbills = Player.Functions.GetItemByName('markedbills').amount
		if amountbills >= amount then
			Player.Functions.RemoveItem('markedbills', amount)
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['markedbills'], "remove")
			Player.Functions.AddMoney('cash', amount)
			TriggerClientEvent('QBCore:Notify', src, 'You washed ' ..amount.. ' makred bills!', 'success')
		else
			TriggerClientEvent('QBCore:Notify', src, 'You do not have enough marked bills to do that!', 'error')
		end
	else
		TriggerClientEvent('QBCore:Notify', src, 'You do not have any marked bills!', 'error')
	end
end)