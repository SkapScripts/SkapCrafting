WebhookConfig = {}

-- Webhooks
WebhookConfig.AttemptCraft = "https://discord.com/api/webhooks/1371633101075386399/_EygEX6xLvTepi6iKxII1MIzNxbg6eXJdFGWFXJDK26zKAfAxZv1gbVb5DC6YBseVXHQ" -- När crafting försöks
WebhookConfig.CraftSuccess = "https://discord.com/api/webhooks/1371633101075386399/_EygEX6xLvTepi6iKxII1MIzNxbg6eXJdFGWFXJDK26zKAfAxZv1gbVb5DC6YBseVXHQ" -- När crafting lyckas
WebhookConfig.CraftLimitReached = "https://discord.com/api/webhooks/1371633101075386399/_EygEX6xLvTepi6iKxII1MIzNxbg6eXJdFGWFXJDK26zKAfAxZv1gbVb5DC6YBseVXHQ" -- När spelaren nått maxgräns
WebhookConfig.CraftMissingItems = "https://discord.com/api/webhooks/1371633101075386399/_EygEX6xLvTepi6iKxII1MIzNxbg6eXJdFGWFXJDK26zKAfAxZv1gbVb5DC6YBseVXHQ" -- När items saknas

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
