local QBCore, dc, cc, wc, ct = exports['qb-core']:GetCoreObject(), {}, {}, WebhookConfig or {}, Config.CooldownTime

RegisterServerEvent("SkapCrafting:attemptCraft")
AddEventHandler("SkapCrafting:attemptCraft", function(i)
    local s, P = source, QBCore.Functions.GetPlayer(source)
    if not P then return end
    if cc[s] and GetGameTimer() < cc[s] then return TriggerClientEvent('QBCore:Notify', s, "You have to wait before you can craft again.", "error") end
    local c, n, r = P.PlayerData.citizenid, GetPlayerName(s), Config.CraftingRecipes[i]
    if not r then return end
    if Config.DailyCraftLimit[i] then
        dc[c] = dc[c] or {} dc[c][i] = (dc[c][i] or 0) + 1
        if dc[c][i] > Config.DailyCraftLimit[i] then
            TriggerClientEvent('QBCore:Notify', s, "You have already crafted max number of " .. i .. " today!", "error")
            return SendWebhook(wc.CraftLimitReached, "🔒 Craft Limit Reached", ("**%s** (%s) tried to craft more than allowed by **%s**"):format(n, c, i), 16711680)
        end
    end
    for _, x in pairs(r.requiredItems) do
        local it = P.Functions.GetItemByName(x.item)
        if not it or it.amount < x.amount then
            TriggerClientEvent('QBCore:Notify', s, "You are missing " .. x.amount .. "x " .. x.item .. "!", "error")
            return SendWebhook(wc.CraftMissingItems, "❌ Missing Items", ("**%s** (%s) was missing **%sx %s** to craft**%s**"):format(n, c, x.amount, x.item, i), 16753920)
        end
    end
    if r.cost and r.cost > 0 then
        local a = r.payWith or "cash"
        if P.Functions.GetMoney(a) < r.cost then return TriggerClientEvent('QBCore:Notify', s, "You don't have enough money on you " .. a .. "!", "error") end
        P.Functions.RemoveMoney(a, r.cost, "crafting-payment")
    end
    for _, x in pairs(r.requiredItems) do
        P.Functions.RemoveItem(x.item, x.amount)
        TriggerClientEvent("inventory:client:ItemBox", s, QBCore.Shared.Items[x.item], "remove")
    end
    cc[s] = GetGameTimer() + ct * 1000
    TriggerClientEvent("SkapCrafting:startProgress", s, r.time, i)
    SendWebhook(wc.AttemptCraft, "🛠️ Crafting Try", ("**%s** (%s) started crafting **%s** for $%s"):format(n, c, i, r.cost or 0), 65353)
end)

RegisterServerEvent("SkapCrafting:finishCrafting")
AddEventHandler("SkapCrafting:finishCrafting", function(i)
    local s, P = source, QBCore.Functions.GetPlayer(source)
    if not P then return end
    P.Functions.AddItem(i, 1)
    TriggerClientEvent("inventory:client:ItemBox", s, QBCore.Shared.Items[i], "add")
    TriggerClientEvent('QBCore:Notify', s, "You have crafted a " .. i .. "!", "success")
    SendWebhook(wc.CraftSuccess, "✅ Craft Succeeded", ("**%s** (%s) succeeded in crafting **%s**"):format(GetPlayerName(s), P.PlayerData.citizenid, i), 3145645)
end)

QBCore.Functions.CreateCallback("SkapCrafting:CheckCooldown", function(s, cb)
    local r = (cc[s] or 0) - GetGameTimer()
    cb(r <= 0, math.ceil(r / 1000))
end)

QBCore.Functions.CreateCallback("SkapCrafting:CanAccessStation", function(s, cb, d)
    local P = QBCore.Functions.GetPlayer(s)
    if not P then return cb(false, "Player data error") end
    if d.blockIfPolice and P.PlayerData.job.name == Config.PoliceJob then return cb(false, "We don't create things for pigs.") end
    if d.requiredCops and d.requiredCops > 0 then
        local c = 0
        for _, id in pairs(QBCore.Functions.GetPlayers()) do
            local p = QBCore.Functions.GetPlayer(id)
            if p and p.PlayerData.job.name == Config.PoliceJob then c += 1 end
        end
        if c < d.requiredCops then return cb(false, "Atleast " .. d.requiredCops .. " police officers must be on duty.") end
    end
    cb(true)
end)

CreateThread(function() while true do Wait(86400000) dc = {} end end)