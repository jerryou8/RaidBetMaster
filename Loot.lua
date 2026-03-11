-- Loot.lua

local RBM = RaidBetMaster
RBM.Loot = {}
local Loot = RBM.Loot

-- 处理掉落物品（bossLoot 为掉落物品列表）
function Loot:ProcessDroppedItems(bossLoot)
    if RBM.Bets then
        RBM.Bets:FinalizeBets(bossLoot)
    end

    -- 可扩展：统计掉落金币
    -- 这里可以调用 GoldTracker
    if RBM.GoldTracker then
        local goldLooted = 0
        for i = 1, GetNumLootItems() do
            local _, _, _, _, _, _, _, _, _, lootMoney = GetLootSlotInfo(i)
            if lootMoney and lootMoney > 0 then
                goldLooted = goldLooted + lootMoney
            end
        end
        if goldLooted > 0 then
            RBM.GoldTracker:RecordGoldChange(goldLooted, "Loot")
        end
    end

    -- TODO: 可扩展卖装备收益统计
end

-- 注册全局
RBM.Loot = Loot
