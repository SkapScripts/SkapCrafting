WebhookConfig = {}

-- Webhooks
WebhookConfig.AttemptCraft = "YOUR_WEBHOOK_HERE" -- När crafting försöks
WebhookConfig.CraftSuccess = "YOUR_WEBHOOK_HERE" -- När crafting lyckas
WebhookConfig.CraftLimitReached = "YOUR_WEBHOOK_HERE" -- När spelaren nått maxgräns
WebhookConfig.CraftMissingItems = "YOUR_WEBHOOK_HERE" -- När items saknas

function SendWebhook(url, title, description, color)
    local embed = {{
        ["title"] = title,
        ["description"] = description,
        ["color"] = color,
        ["footer"] = {
            ["text"] = os.date("%Y-%m-%d %H:%M:%S")
        }
    }}

    PerformHttpRequest(url, function(err, text, headers) end, 'POST', json.encode({
        username = "SkapCrafting Logs",
        embeds = embed
    }), { ['Content-Type'] = 'application/json' })
end
