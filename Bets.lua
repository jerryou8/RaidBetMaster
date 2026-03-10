Bets = {}
Bets.pendingBets = {}

function Bets:AddPendingBet(player, item, gold)
    if not self.pendingBets[player] then
        self.pendingBets[player] = {}
    end
    table.insert(self.pendingBets[player], {item = item, gold = gold, time = time()})
end

function Bets:ResolveBet(player, item)
    local bets = self.pendingBets[player]
    if not bets then return end
    for i, bet in ipairs(bets) do
        if not bet.item and item then
            bet.item = item
        end
    end
end

function Bets:GetAllBets()
    return self.pendingBets
end
