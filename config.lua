Config = {
    PoliceJob = "police", 
    Animation = "WORLD_HUMAN_WELDING",
    CooldownTime = 50,

    Minigame = {
        type = "varhack",
        options = {
            maze = {timeLimit = 10},
            circle = {numCircles = 3, time = 5000},
            scrambler = {type = "alphanumeric", time = 10, mirrored = 0},
            varhack = {numBlocks = 4, time = 10},
            thermite = {time = 10, gridSize = 5, incorrectBlocks = 3}
        }
    },

    DailyCraftLimit = {
        weapon_knife = 2,
        advancedlockpick = 3
    },

    CraftingTables = {
        {type = "prop", coords = vec3(-124.42, -1413.17, 31.30), heading = 125.0, prop = "prop_ld_farm_table01", openTime = 22, closeTime = 5, requiredCops = 0, blockIfPolice = true},
        {type = "location", coords = vec3(200.0, -300.0, 54.0), heading = 0.0, openTime = 22, closeTime = 4, requiredCops = 2, blockIfPolice = true},
        {type = "ped", coords = vec3(464.40, -851.92, 26.93), heading = 95.8, pedModel = "a_m_o_soucent_03", openTime = 22, closeTime = 4, requiredCops = 2, blockIfPolice = true, scenario = "WORLD_HUMAN_WELDING"},
        {type = "ped", coords = vec3(823.85, -492.22, 30.41), heading = 275.79, pedModels = {"a_m_o_soucent_03", "a_m_m_hillbilly_01"}, scenarios = {"WORLD_HUMAN_WELDING", "WORLD_HUMAN_CONST_DRILL"}, openTime = 22, closeTime = 23, requiredCops = 2, blockIfPolice = true},
        {type = "vehicle", vehicleModel = "tractor", pedModel = "a_m_o_tramp_01", coords = vec3(1537.49, 3654.51, 34.80), heading = 89.51, openTime = 22, closeTime = 3, requiredCops = 2, blockIfPolice = true}
    },

    CraftingRecipes = {
        advancedlockpick = {
            label = "advanced lockpick", image = "nui://qs-inventory/html/images/advancedlockpick.png", time = 60,
            requiredItems = {
                {item = "steel", amount = 50},
                {item = "plastic", amount = 30},
                {item = "screwdriverset", amount = 3}
            },
            cost = 250, payWith = "cash"
        },
        lockpick = {
            label = "lockpick", image = "nui://qs-inventory/html/images/lockpick.png", time = 30,
            requiredItems = {
                {item = "steel", amount = 30},
                {item = "plastic", amount = 20}
            },
            cost = 250, payWith = "cash"
        },
        weapon_bat = {
            label = "Bat", image = "nui://qs-inventory/html/images/weapon_bat.png", time = 100,
            requiredItems = {
                {item = "wood", amount = 7},
                {item = "nails", amount = 3},
                {item = "metalscrap", amount = 2}
            },
            cost = 250, payWith = "cash"
        },
        weapon_knife = {
            label = "knife", image = "nui://qs-inventory/html/images/weapon_knife.png", time = 120,
            requiredItems = {
                {item = "steel", amount = 40},
                {item = "wood", amount = 2},
                {item = "leather", amount = 4}
            },
            cost = 250, payWith = "cash"
        },
        angle_grinder = {
            label = "angle grinder", image = "nui://qs-inventory/html/images/angle_grinder.png", time = 20,
            requiredItems = {
                {item = "steel", amount = 40},
                {item = "wood", amount = 6},
                {item = "metalscrap", amount = 60},
                {item = "plastic", amount = 60}
            },
            cost = 250, payWith = "cash"
        }
    }
}
