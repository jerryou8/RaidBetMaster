-- Loot.lua
local Loot = {}

function Loot:ProcessDroppedItems(bossLoot)
    if RaidBetMaster.Bets then
        RaidBetMaster.Bets:FinalizeBets(bossLoot)
    end
    -- 可扩展：记录掉落金币、卖装备收益
end

RaidBetMaster.Loot = Loot
