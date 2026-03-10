GoldTracker = {}
GoldTracker.startGold = 0
GoldTracker.lootGold = 0
GoldTracker.vendorGold = 0
GoldTracker.betIncome = 0
GoldTracker.betPayout = 0
GoldTracker.unknown = 0

function GoldTracker:RecordGoldChange(amount, source)
    if source == "Loot" then
        self.lootGold = self.lootGold + amount
    elseif source == "Vendor" then
        self.vendorGold = self.vendorGold + amount
    elseif source == "BetIncome" then
        self.betIncome = self.betIncome + amount
    elseif source == "BetPayout" then
        self.betPayout = self.betPayout + amount
    else
        self.unknown = self.unknown + amount
    end
end

function GoldTracker:GetProfit()
    return (self.betIncome - self.betPayout) + self.lootGold + self.vendorGold + self.unknown
end
