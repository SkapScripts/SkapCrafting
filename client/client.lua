local QBCore, spawnedTables = exports['qb-core']:GetCoreObject(), {}
local function IsOpen(o, c) local t = GetClockHours() return o < c and t >= o and t < c or t >= o or t < c end
local function LoadModel(m) RequestModel(m) while not HasModelLoaded(m) do Wait(10) end end
local function GetRandomFrom(t) return (not t or #t == 0) and nil or t[math.random(#t)] end

local function AddTargetToEntity(e, t)
    exports['qb-target']:AddTargetEntity(e, {
        options = {{
            icon = "fas fa-tools", label = "Open crafting-menu",
            action = function()
                if not IsOpen(t.openTime, t.closeTime) then return QBCore.Functions.Notify("This workbench is currently closed!", "error") end
                QBCore.Functions.TriggerCallback("SkapCrafting:CheckCooldown", function(ok, r)
                    if not ok then return QBCore.Functions.Notify("Vänta " .. r .. " seconds before you can use this station again.", "error") end
                    QBCore.Functions.TriggerCallback("SkapCrafting:CanAccessStation", function(a, msg)
                        if a then TriggerEvent("SkapCrafting:openMenu") else QBCore.Functions.Notify(msg, "error") end
                    end, {requiredCops = t.requiredCops or 0, blockIfPolice = t.blockIfPolice or false})
                end)
            end
        }}, distance = 2.0
    })
end

local function CreateCraftingProp(t) LoadModel(t.prop) local o = CreateObject(t.prop, t.coords.x, t.coords.y, t.coords.z - 1.0, false, false, true) SetEntityHeading(o, t.heading) FreezeEntityPosition(o, true) return o end
local function CreateCraftingPed(t)
    local m, s = GetRandomFrom(t.pedModels or {t.pedModel}), GetRandomFrom(t.scenarios or {t.scenario})
    LoadModel(m) local p = CreatePed(4, m, t.coords.x, t.coords.y, t.coords.z - 1.0, t.heading, false, true)
    SetEntityInvincible(p, true) SetBlockingOfNonTemporaryEvents(p, true) FreezeEntityPosition(p, true)
    if s then TaskStartScenarioInPlace(p, s, 0, true) end return p
end

local function CreateCraftingVehicle(t)
    LoadModel(t.vehicleModel) LoadModel(t.pedModel)
    local v = CreateVehicle(t.vehicleModel, t.coords.x, t.coords.y, t.coords.z, t.heading, false, false)
    local p = CreatePed(4, t.pedModel, t.coords.x, t.coords.y, t.coords.z, t.heading, false, true)
    TaskWarpPedIntoVehicle(p, v, -1)
    SetEntityInvincible(v, true) SetVehicleDoorsLocked(v, 2) FreezeEntityPosition(v, true)
    SetEntityInvincible(p, true) SetBlockingOfNonTemporaryEvents(p, true)
    return v, p
end

AddEventHandler("onClientResourceStart", function(res)
    if res ~= GetCurrentResourceName() then return end
    for i, t in ipairs(Config.CraftingTables) do
        if t.type == "prop" then local o = CreateCraftingProp(t) spawnedTables[i] = o AddTargetToEntity(o, t)
        elseif t.type == "ped" then local p = CreateCraftingPed(t) spawnedTables[i] = p AddTargetToEntity(p, t)
        elseif t.type == "vehicle" then local v, p = CreateCraftingVehicle(t) spawnedTables[i] = {vehicle = v, ped = p} AddTargetToEntity(v, t) AddTargetToEntity(p, t)
        end
    end
end)

RegisterNetEvent("SkapCrafting:openMenu", function()
    local opts = {id = 'skapcrafting_menu', title = 'Crafting Station', options = {}}
    for item, r in pairs(Config.CraftingRecipes) do
        local reqs = {} for _, req in pairs(r.requiredItems) do reqs[#reqs+1] = req.amount .. "x " .. req.item end
        local txt = table.concat(reqs, ", ") .. ((r.cost and r.cost > 0) and (" | Price: $" .. r.cost) or "")
        opts.options[#opts.options+1] = {title = r.label, description = "Requires: " .. txt, icon = "fas fa-hammer", image = r.image, onSelect = function() TriggerEvent("SkapCrafting:startCrafting", item) end}
    end
    opts.options[#opts.options+1] = {title = "Close", icon = "fas fa-xmark", onSelect = function() end}
    lib.registerContext(opts) lib.showContext('skapcrafting_menu')
end)

RegisterNetEvent("SkapCrafting:startCrafting", function(item)
    if Config.CraftingRecipes[item] then TriggerServerEvent("SkapCrafting:attemptCraft", item) end
end)

RegisterNetEvent("SkapCrafting:startProgress", function(time, item)
    local r = Config.CraftingRecipes[item] if not r then return end
    local ped, g, o = PlayerPedId(), Config.Minigame.type, Config.Minigame.options[Config.Minigame.type]
    local function done() TriggerEvent("animations:client:EmoteCommandStart", {"c"}) TriggerServerEvent("SkapCrafting:finishCrafting", item) end
    local function fail() QBCore.Functions.Notify("You failed the crafting!", "error") end
    local function start()
        TaskStartScenarioInPlace(ped, Config.Animation, 0, true)
        if r.emote then TriggerEvent("animations:client:EmoteCommandStart", {r.emote}) end
        QBCore.Functions.Progressbar("crafting", "Craftar...", time * 1000, false, true,
            {disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true},
            {}, {}, {}, done, function() TriggerEvent("animations:client:EmoteCommandStart", {"c"}) QBCore.Functions.Notify("Crafting was suspended!", "error") end)
    end
    if g == "maze" then exports['ps-ui']:Maze(function(s) if s then start() else fail() end end, o.timeLimit)
    elseif g == "circle" then exports['ps-ui']:Circle(function(s) if s then start() else fail() end end, o.numCircles, o.time)
    elseif g == "scrambler" then exports['ps-ui']:Scrambler(function(s) if s then start() else fail() end end, o.type, o.time, o.mirrored)
    elseif g == "varhack" then exports['ps-ui']:VarHack(function(s) if s then start() else fail() end end, o.numBlocks, o.time)
    elseif g == "thermite" then exports['ps-ui']:Thermite(function(s) if s then start() else fail() end end, o.time, o.gridSize, o.incorrectBlocks)
    else start() end
end)
