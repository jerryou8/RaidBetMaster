-- Core.lua
local RBM = {}
_G.RaidBetMaster = RBM  -- 全局引用

RBM.db = RaidBetMasterDB or {}  -- SavedVariables
RBM.Bets = RBM.Bets or {}
RBM.GoldTracker = RBM.GoldTracker or {}
RBM.Session = RBM.Session or {}
RBM.Loot = RBM.Loot or {}
RBM.UI = RBM.UI or {}

-- 显示免责声明
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
        "本插件仅用于记录游戏内行为，不涉及现实货币交易。\n" ..
        "所有下注和金币收益风险由玩家自行承担。\n" ..
        "插件不会自动交易或修改游戏客户端。\n\n" ..
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
    if RBM.UI.miniButton then return end

    local button = CreateFrame("Button", "RBM_MiniMapButton", Minimap)
    button:SetSize(32, 32)
    button:SetFrameStrata("MEDIUM")
    button:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 0, 0)

    button.icon = button:CreateTexture(nil, "BACKGROUND")
    button.icon:SetAllPoints()
    button.icon:SetTexture("Interface\\Icons\\INV_Misc_Coin_01") -- 可换图标

    button:SetScript("OnClick", function()
        RBM.UI:ShowMainFrame()
    end)

    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText("Raid Bet Master")
        GameTooltip:AddLine("点击打开插件界面", 1, 1, 1)
        GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    RBM.UI.miniButton = button
end

-- 注册 PLAYER_LOGIN 初始化
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(self, event, ...)
    ShowDisclaimer()
    CreateMiniMapButton()
end)

-- 注册 /rbm 命令
SLASH_RBM1 = "/rbm"
SlashCmdList["RBM"] = function(msg)
    RBM.UI:ShowMainFrame()
end
