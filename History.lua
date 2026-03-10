History = {}

function History:Save(session)
    if not RaidBetMasterDB.sessions then
        RaidBetMasterDB.sessions = {}
    end
    table.insert(RaidBetMasterDB.sessions, session)
    if #RaidBetMasterDB.sessions > (RaidBetMasterDB.config.maxHistory or 10) then
        table.remove(RaidBetMasterDB.sessions, 1)
    end
end

function History:Clear()
    RaidBetMasterDB.sessions = {}
end
