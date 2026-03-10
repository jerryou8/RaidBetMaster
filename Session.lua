Session = {}
Session.activeSession = nil

function Session:Start(instanceName, startGold)
    self.activeSession = {
        instance = instanceName,
        startGold = startGold,
        bets = {},
        startTime = time()
    }
end

function Session:End(endGold)
    if not self.activeSession then return end
    self.activeSession.endGold = endGold
    if not RaidBetMasterDB.sessions then
        RaidBetMasterDB.sessions = {}
    end
    table.insert(RaidBetMasterDB.sessions, self.activeSession)
    self.activeSession = nil
end

function Session:HandleEvent(event, ...)
    -- 这里可以添加事件处理逻辑
end
