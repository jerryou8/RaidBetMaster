-- Bets.lua
local Bets = {}
Bets.pendingBets = Bets.pendingBets or {}

function Bets:AddBet(player, item, gold)
    if not Bets.pendingBets[player] then Bets.pendingBets[player] = {} end
    table.insert(Bets.pendingBets[player], {
        item = item,
        gold = gold,
        payout = 0,
        locked = false,
        remainingTime = RaidBetMasterDB.config.defaultBetTime or 30
    })
end

-- 核心结算逻辑：掉落匹配、庄家通杀
function Bets:FinalizeBets(bossLoot)
    for player, bets in pairs(Bets.pendingBets) do
        for _, bet in ipairs(bets) do
            if bet.locked then goto continue end
            local dropped = false
            for _, lootItem in ipairs(bossLoot) do
                if lootItem == bet.item then
                    dropped = true
                    break
                end
            end
            if dropped then
                bet.payout = bet.gold * (RaidBetMasterDB.config.defaultOdds or 10)
            else
                bet.payout = 0 -- 庄家通杀
            end
            bet.locked = true
            ::continue::
        end
    end
end

-- 倒计时更新，每秒调用
function Bets:UpdateTimers()
    for player, bets in pairs(Bets.pendingBets) do
        for _, bet in ipairs(bets) do
            if not bet.locked and bet.remainingTime then
                bet.remainingTime = bet.remainingTime - 1
                if bet.remainingTime <= 0 then
                    bet.locked = true
                end
            end
        end
    end
end

RaidBetMaster.Bets = Bets
