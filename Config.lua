
Config = {}

function Config:GetDefault()
    return RaidBetMasterDB.config or {
        defaultOdds = 10,
        defaultBet = 100,
        defaultTimer = 30,
        maxHistory = 10
    }
end
