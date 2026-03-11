-- UI.lua

local RBM = RaidBetMaster
RBM.UI = {}
local UI = RBM.UI

UI.frames = {}

-- 显示主界面
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

    -- 标题
    f.title = f:CreateFontString(nil, "OVERLAY")
    f.title:SetFontObject("GameFontHighlight")
    f.title:SetPoint("TOP", f, "TOP", 0, -10)
    f.title:SetText("Raid Bet Master")

    -- 下注列表容器
    f.betList = CreateFrame("Frame", nil, f)
    f.betList:SetPoint("TOPLEFT", f, "TOPLEFT", 10, -40)
    f.betList:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -10, 40)

    -- 滚动区域
    f.scrollFrame = CreateFrame("ScrollFrame", nil, f.betList, "UIPanelScrollFrameTemplate")
    f.scrollFrame:SetAllPoints(f.betList)

    f.content = CreateFrame("Frame", nil, f.scrollFrame)
    f.content:SetSize(360, 500)
    f.scrollFrame:SetScrollChild(f.content)

    -- 初始化行表
    f.content.rows = {}

    self.frames.main = f

    -- 每秒刷新下注列表
    C_Timer.NewTicker(1, function()
        if RBM.Bets then
            UI:UpdateBetList()
        end
    end)
end

-- 更新下注列表
function UI:UpdateBetList()
    local f = self.frames.main
    if not f or not RBM.Bets then return end

    local y = -10
    local index = 1

    -- 隐藏旧行
    for _, row in pairs(f.content.rows) do
        row:Hide()
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
            local remaining = bet.remainingTime or 0
            local status = bet.locked and "[已锁定]" or string.format("[%ds]", remaining)
            row.text:SetText(string.format("%s → %s: %dG %s", player, bet.item or "未选择装备", bet.gold or 0, status))
            row:Show()
            y = y - 22
            index = index + 1
        end
    end

    -- 调整内容高度以适应滚动
    f.content:SetHeight(math.max(500, -y))
end
