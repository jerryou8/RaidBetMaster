-- Session.lua

local RBM = RaidBetMaster
RBM.Session = {}
local Session = RBM.Session

Session.activeSession = nil

-- 开始副本/Session
function Session:Start(instanceName, startGold)
    if not RBM.db then RBM.db = {} end

    self.activeSession = {
        instance = instanceName or "Unknown",
        startGold = startGold or 0,
        bets = {},
        startTime = time()
    }
end

-- 结束副本/Session
function Session:End(endGold)
    if not self.activeSession then return end

    self.activeSession.endGold = endGold or 0

    if not RBM.db.sessions then
        RBM.db.sessions = {}
    end

    table.insert(RBM.db.sessions, self.activeSession)
    self.activeSession = nil
end

-- 事件处理占位
function Session:HandleEvent(event, ...)
    -- 可以扩展事件处理逻辑，比如：
    -- PLAYER_ENTERING_WORLD / LOOT_OPENED / CHAT_MSG_SYSTEM 等
end
