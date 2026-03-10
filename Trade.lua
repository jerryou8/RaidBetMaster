-- Trade.lua
local Trade = {}

-- 当前交易对象临时缓存
Trade.currentTrade = {
    partner = nil,
    goldGiven = 0,
    goldReceived = 0
}

-- 监听交易开始事件
function Trade:OnTradeShow()
    local targetName = UnitName("NPC")
    if targetName then
        Trade.currentTrade.partner = targetName
        Trade.currentTrade.goldGiven = 0
        Trade.currentTrade.goldReceived = 0
    end
end

-- 监听交易金额变化
function Trade:OnTradeMoneyChanged()
    -- 玩家给对方的金币
    Trade.currentTrade.goldGiven = GetPlayerTradeMoney()
    -- 对方给玩家的金币
    Trade.currentTrade.goldReceived = GetTargetTradeMoney()
end

-- 完成交易时记录下注
function Trade:OnTradeAcceptUpdate(_, accepted1, accepted2)
    if accepted1 and accepted2 then
        local player = Trade.currentTrade.partner
        local gold = Trade.currentTrade.goldReceived or 0
        if player and gold > 0 then
            -- 尝试与 Bets 模块匹配
            if RaidBetMaster.Bets then
                RaidBetMaster.Bets:AddBet(player, nil, gold)
            end
        end
    end
    Trade.currentTrade.goldGiven = 0
    Trade.currentTrade.goldReceived = 0
    Trade.currentTrade.partner = nil
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

RaidBetMaster.Trade = Trade
