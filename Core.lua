local RBM = CreateFrame("Frame")
RBM:RegisterEvent("PLAYER_LOGIN")
RBM:RegisterEvent("PLAYER_ENTERING_WORLD")
RBM:RegisterEvent("CHAT_MSG_MONEY")
RBM:RegisterEvent("CHAT_MSG_LOOT")
RBM:RegisterEvent("MERCHANT_SHOW")
RBM:RegisterEvent("TRADE_SHOW")
RBM:RegisterEvent("TRADE_ACCEPT_UPDATE")
RBM:RegisterEvent("ZONE_CHANGED_NEW_AREA")

RBM:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        if not RaidBetMasterDB then
            RaidBetMasterDB = {
                sessions = {},
                config = {
                    defaultOdds = 10,
                    defaultBet = 100,
                    defaultTimer = 30,
                    maxHistory = 10
                }
            }
        end
    end
    if Session and Session.HandleEvent then
        Session:HandleEvent(event, ...)
    end
end)

SLASH_RBM1 = "/rbm"
SlashCmdList["RBM"] = function(msg)
    if UI and UI.ShowMainFrame then
        UI:ShowMainFrame()
    end
end
