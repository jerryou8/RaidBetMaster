-- Trade.lua

local RBM = RaidBetMaster
RBM.Trade = {}
local Trade = RBM.Trade

-- 当前交易对象临时缓存
Trade.currentTrade = {
    partner = nil,
    goldGiven = 0,
    goldReceived = 0
}

-- 交易打开
function Trade:OnTradeShow()
    local targetName = UnitName("NPC") or UnitName("target")
    if targetName then
        self.currentTrade.partner = targetName
        self.currentTrade.goldGiven = 0
        self.currentTrade.goldReceived = 0
    end
end

-- 交易金额变化
function Trade:OnTradeMoneyChanged()
    if not self.currentTrade.partner then return end
    -- 玩家给对方的金币
    self.currentTrade.goldGiven = GetPlayerTradeMoney() or 0
    -- 对方给玩家的金币
    self.currentTrade.goldReceived = GetTargetTradeMoney() or 0
end

-- 完成交易时记录下注
function Trade:OnTradeAcceptUpdate(_, accepted1, accepted2)
    if accepted1 and accepted2 then
        local player = self.currentTrade.partner
        local gold = self.currentTrade.goldReceived or 0

        if player and gold > 0 then
            -- 这里不传装备，由聊天贴装备分配
            if RBM.Bets then
                RBM.Bets:AddBet(player, nil, gold)
            end
            -- 统计金币收入
            if RBM.GoldTracker then
                RBM.GoldTracker:RecordGoldChange(gold, "BetIncome")
            end
        end
    end

    -- 清空缓存
    self.currentTrade.partner = nil
    self.currentTrade.goldGiven = 0
    self.currentTrade.goldReceived = 0
end

-- 注册事件
local frame = CreateFrame("Frame")
frame:RegisterEvent("TRADE_SHOW")
frame:RegisterEvent("TRADE_MONEY_CHANGED")
frame:RegisterEvent("TRADE_ACCEPT_UPDATE")

frame:SetScript("OnEvent", function(_, event, ...)
    if event == "TRADE_SHOW" then
        Trade:OnTradeShow()
    elseif event == "TRADE_MONEY_CHANGED" then
        Trade:OnTradeMoneyChanged()
    elseif event == "TRADE_ACCEPT_UPDATE" then
        Trade:OnTradeAcceptUpdate(...)
    end
end)
