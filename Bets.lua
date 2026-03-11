-- Bets.lua

local RBM = RaidBetMaster
local Bets = {}

Bets.pendingBets = {}

function Bets:AddBet(player, item, gold)

    if not self.pendingBets[player] then
        self.pendingBets[player] = {}
    end

    local defaultTime = 30
    if RBM.db and RBM.db.config and RBM.db.config.defaultBetTime then
        defaultTime = RBM.db.config.defaultBetTime
    end

    table.insert(self.pendingBets[player], {
        item = item,
        gold = gold,
        payout = 0,
        locked = false,
        remainingTime = defaultTime
    })

end


-- 掉落结算
function Bets:FinalizeBets(bossLoot)

    for player, bets in pairs(self.pendingBets) do

        for _, bet in ipairs(bets) do

            if not bet.locked then

                local dropped = false

                for _, lootItem in ipairs(bossLoot) do
                    if lootItem == bet.item then
                        dropped = true
                        break
                    end
                end

                if dropped then

                    local odds = 10
                    if RBM.db and RBM.db.config and RBM.db.config.defaultOdds then
                        odds = RBM.db.config.defaultOdds
                    end

                    bet.payout = bet.gold * odds

                else
                    bet.payout = 0 -- 庄家通杀
                end

                bet.locked = true

            end

        end

    end

end


-- 倒计时
function Bets:UpdateTimers()

    for player, bets in pairs(self.pendingBets) do

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


RBM.Bets = Bets
