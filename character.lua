_, P4 = ...

P4.Character = {
    equipment = {}
}

function P4.Character:Init()
    self.equipment = {}
    for slot = 1, 19 do
        local itemID = GetInventoryItemID("player", slot)
        if itemID then
            self.equipment[itemID] = slot
        end
    end
end

function P4.Character:UpdateSlot(slot)
    for itemID, s in pairs(self.equipment) do
        if s == slot then
            self.equipment[itemID] = nil
        end
    end

    local itemID = GetInventoryItemID("player", slot)
    if itemID then
        self.equipment[itemID] = slot
    end

    print("Slot", slot, "updated for itemID", itemID)
end

function P4.Character:GetSlot(itemID)
    return self.equipment[itemID]
end
