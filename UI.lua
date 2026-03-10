UI = {}
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

    self.frames.main = f
end
