-- Core.lua

RaidBetMaster = RaidBetMaster or {}
local RBM = RaidBetMaster

RBM.Core = {}

local function ShowDisclaimer()

    if RBM.db and RBM.db.disclaimerAccepted then
        return
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
    f.title:SetPoint("TOP", 0, -10)
    f.title:SetText("Raid Bet Master 使用免责声明")

    f.text = f:CreateFontString(nil, "OVERLAY")
    f.text:SetFontObject("GameFontNormal")
    f.text:SetPoint("TOPLEFT", 15, -40)
    f.text:SetPoint("BOTTOMRIGHT", -15, 50)
    f.text:SetJustifyH("LEFT")

    f.text:SetText(
        "• 本插件仅用于记录游戏内行为，不涉及现实货币交易。\n" ..
        "• 所有下注和金币收益风险由玩家自行承担。\n" ..
        "• 插件不会自动交易或修改游戏客户端。\n\n" ..
        "使用插件表示您已同意以上条款。"
    )

    local btn = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")

    btn:SetPoint("BOTTOM", 0, 20)
    btn:SetSize(120, 30)
    btn:SetText("我同意")

    btn:SetScript("OnClick", function()

        if not RBM.db then
            RBM.db = {}
        end

        RBM.db.disclaimerAccepted = true

        f:Hide()

    end)

end


local frame = CreateFrame("Frame")

frame:RegisterEvent("ADDON_LOADED")

frame:SetScript("OnEvent", function(self, event, addon)

    if addon ~= "RaidBetMaster" then
        return
    end

    if not RaidBetMasterDB then
        RaidBetMasterDB = {}
    end

    RBM.db = RaidBetMasterDB

    ShowDisclaimer()

    print("|cff00ff00RaidBetMaster loaded")

end)
