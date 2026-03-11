-- History.lua

local RBM = RaidBetMaster
RBM.History = {}

local History = RBM.History

-- 保存一次副本/Session记录
function History:Save(session)

    if not RBM.db then
        RBM.db = {}
    end

    if not RBM.db.sessions then
        RBM.db.sessions = {}
    end

    table.insert(RBM.db.sessions, session)

    local maxHistory = 10
    if RBM.db.config and RBM.db.config.maxHistory then
        maxHistory = RBM.db.config.maxHistory
    end

    if #RBM.db.sessions > maxHistory then
        table.remove(RBM.db.sessions, 1)
    end

end

-- 清空历史记录
function History:Clear()
    if RBM.db then
        RBM.db.sessions = {}
    end
end
