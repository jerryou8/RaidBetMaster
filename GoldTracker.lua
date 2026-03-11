-- GoldTracker.lua

local RBM = RaidBetMaster
RBM.GoldTracker = {}

local GT = RBM.GoldTracker

-- 初始化
GT.startGold = 0
GT.lootGold = 0
GT.vendorGold = 0
GT.betIncome = 0
GT.betPayout = 0
GT.unknown = 0

-- 记录金币变化
function GT:RecordGoldChange(amount, source)
    if not amount then return end

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

-- 获取总收益
function GT:GetProfit()
    return (self.betIncome - self.betPayout) + self.lootGold + self.vendorGold + self.unknown
end

-- 记录副本开始时的金币
function GT:RecordStartGold()
    self.startGold = GetMoney() or 0
end

-- 获取副本总变化
function GT:GetTotalChange()
    local current = GetMoney() or 0
    return current - self.startGold
end
