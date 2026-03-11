-- Core.lua
RBM = RBM or {}
local Core = {}

-- 初始化 SavedVariables
if not RaidBetMasterDB then
    RaidBetMasterDB = {}
end
RBM.db = RaidBetMasterDB
RBM.Bets = RBM.Bets or {}
RBM.Bets.pendingBets = RBM.Bets.pendingBets or {}

-- 免责声明
local function ShowDisclaimer()
    if RBM.db.disclaimerAccepted then return end

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
        RBM.db.disclaimerAccepted = true
        f:Hide()
    end)
end

-- 小地图按钮
local function CreateMiniMapButton()
    local button = CreateFrame("Button", "RBM_MiniMapButton", Minimap)
    button:SetSize(20, 20)  -- 调整为合理尺寸
    button:SetFrameStrata("MEDIUM")
    button:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", -2, -2)
    button:SetNormalTexture("Interface\\Icons\\INV_Misc_Coin_01")
    button:SetHighlightTexture("Interface\\BUTTONS\\UI-Panel-Button-Highlight")
    button:SetScript("OnClick", function()
        RBM.UI:ShowMainFrame()
    end)
    button.tooltipText = "Raid Bet Master"
    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:SetText(self.tooltipText)
        GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
end

-- PLAYER_LOGIN 初始化
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(_, event)
    if event == "PLAYER_LOGIN" then
        ShowDisclaimer()
        CreateMiniMapButton()
    end
end)

RBM.Core = Core
