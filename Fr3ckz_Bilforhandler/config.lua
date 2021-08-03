Config = {}

Config.Webhook = "https://discord.com/api/webhooks/860646033717854249/36we4yxwlELR06gnDZQ15ZLDjYwS3WT27dP2ZxF757j4etoexIQm3tc5PHYb8USDViW1" -- Hvad er dit webhook. Til logs
Config.Rank = "Bilforhandler" -- Hvilket rank skal man have for at åbne menuen?
Config.CoolDownAmount = 50 -- Hvor meget cooldown skal der være imellem vær besked?
Config.MininimumMoneyAmount = 1000 -- Hvor meget skal minimun prisen være?
Config.ProcentToDealer = 20 -- Hvor meget procent skal bilforhandleren få af prisen?

-- BILFORHANDLER-ADMIN --
Config.AdminRank = "Bilforhandler" -- Hvilket rank skal man have for at åbne bilforhandler-admin-menuen?
Config.GlobalMessage = true -- Skal alle bilforhandlere få afvide hvis der bliver fyret eller ansat en bilforhandler?
Config.CustomerMessage = {
    Enabled = "true", -- Skal man kunne bruge en command til og kontakte bilforhandlere?
    Command = "dealer", -- Hvad skal kommado'en være?
    Log = "", -- (indsæt webhook HVIS!) - Hvis du gerne vil blive spammet, eftersom nogle vil nok spamme dette.
}