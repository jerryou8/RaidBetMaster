-- UI.lua
RBM.UI = RBM.UI or {}
local UI = RBM.UI
UI.frames = {}

function UI:ShowMainFrame()
    if self.frames.main then
        self.frames.main:Show()
        return
    end

    local f = CreateFrame("Frame", "RBM_MainFrame", UIParent, "BasicFrameTemplateWithInset")
    f:SetSize(400, 600)
    f:SetPoint("CENTER")
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)

    f.title = f:CreateFontString(nil, "OVERLAY")
    f.title:SetFontObject("GameFontHighlight")
    f.title:SetPoint("TOP", f, "TOP", 0, -10)
    f.title:SetText("Raid Bet Master")

    f.betList = CreateFrame("Frame", nil, f)
    f.betList:SetPoint("TOPLEFT", f, "TOPLEFT", 10, -40)
    f.betList:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -10, 40)

    f.scrollFrame = CreateFrame("ScrollFrame", nil, f.betList, "UIPanelScrollFrameTemplate")
    f.scrollFrame:SetAllPoints(f.betList)

    f.content = CreateFrame("Frame", nil, f.scrollFrame)
    f.content:SetSize(360, 500)
    f.scrollFrame:SetScrollChild(f.content)

    f.content.rows = {}
    self.frames.main = f

    -- 定时刷新
    C_Timer.NewTicker(1, function()
        UI:UpdateBetList()
    end)
end

function UI:UpdateBetList()
    local f = self.frames.main
    if not f or not RBM.Bets then return end

    local y = -10
    local index = 1

    for _, row in pairs(f.content.rows) do row:Hide() end

    if not next(RBM.Bets.pendingBets) then
        local row = f.content.rows[1]
        if not row then
            row = CreateFrame("Frame", nil, f.content)
            row:SetSize(340, 20)
            row.text = row:CreateFontString(nil, "OVERLAY")
            row.text:SetFontObject("GameFontNormal")
            row.text:SetPoint("LEFT", row, "LEFT", 0, 0)
            f.content.rows[1] = row
        end
        row:SetPoint("TOPLEFT", f.content, "TOPLEFT", 0, y)
        row.text:SetText("暂无下注，可使用 /rbmtest 添加测试数据")
        row:Show()
        return
    end

    for player, bets in pairs(RBM.Bets.pendingBets) do
        for _, bet in ipairs(bets) do
            local row = f.content.rows[index]
            if not row then
                row = CreateFrame("Frame", nil, f.content)
                row:SetSize(340, 20)
                row.text = row:CreateFontString(nil, "OVERLAY")
                row.text:SetFontObject("GameFontNormal")
                row.text:SetPoint("LEFT", row, "LEFT", 0, 0)
                f.content.rows[index] = row
            end

            row:SetPoint("TOPLEFT", f.content, "TOPLEFT", 0, y)
            local status = bet.locked and "[已锁定]" or string.format("[%ds]", bet.remainingTime or 0)
            row.text:SetText(string.format("%s → %s: %dG %s", player, bet.item or "未选择装备", bet.gold or 0, status))
            row:Show()
            y = y - 22
            index = index + 1
        end
    end
end

-- Slash 命令
SlashCmdList["RBM"] = function()
    UI:ShowMainFrame()
end
SLASH_RBM1 = "/rbm"

-- 测试命令
SlashCmdList["RBMTEST"] = function()
    RBM.Bets:AddBet("玩家A", "装备1", 100)
    RBM.Bets:AddBet("玩家B", "装备2", 200)
    UI:ShowMainFrame()
end
SLASH_RBMTEST1 = "/rbmtest"
