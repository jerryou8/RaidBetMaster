-- Disclaimer.lua
local function ShowDisclaimer()
    if RaidBetMasterDB and RaidBetMasterDB.disclaimerAccepted then
        return  -- 已经同意过，不再显示
    end

    local f = CreateFrame("Frame", "RBM_DisclaimerFrame", UIParent, "BasicFrameTemplateWithInset")
    f:SetSize(400, 200)
    f:SetPoint("CENTER")
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)

    f.title = f:CreateFontString(nil, "OVERLAY")
    f.title:SetFontObject("GameFontHighlight")
    f.title:SetPoint("TOP", f, "TOP", 0, -10)
    f.title:SetText("Raid Bet Master 使用免责声明")

    f.text = f:CreateFontString(nil, "OVERLAY")
    f.text:SetFontObject("GameFontNormal")
    f.text:SetPoint("TOPLEFT", f, "TOPLEFT", 15, -40)
    f.text:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -15, 50)
    f.text:SetJustifyH("LEFT")
    f.text:SetText(
        "• 本插件仅用于记录游戏内行为，不涉及现实货币交易。\n" ..
        "• 所有下注和金币收益风险由玩家自行承担。\n" ..
        "• 插件不会自动交易或修改游戏客户端。\n\n" ..
        "使用插件表示您已同意以上条款。"
    )

    local btn = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
    btn:SetPoint("BOTTOM", f, "BOTTOM", 0, 20)
    btn:SetSize(120, 30)
    btn:SetText("我同意")
    btn:SetNormalFontObject("GameFontNormal")
    btn:SetHighlightFontObject("GameFontHighlight")
    btn:SetScript("OnClick", function()
        if not RaidBetMasterDB then RaidBetMasterDB = {} end
        RaidBetMasterDB.disclaimerAccepted = true
        f:Hide()
    end)
end

-- 在插件初始化时调用
ShowDisclaimer()
