_, P4 = ...

function P4.IsGCD()
    local info = C_Spell.GetSpellCooldown(61304) -- 61304 is the spell ID for the global cooldown

    if info.duration == 0 then
        return false
    end

    local remaining = info.startTime + info.duration - GetTime()
    return remaining > 0.3
end

function P4.IsSpellOffGCD(skillId)
    local cooldownMS, gcdMS = GetSpellBaseCooldown(skillId)
    return gcdMS == 0
end


function P4.GetActiveSpells()
    local activeSpells = {}
    local currentLevel = UnitLevel("player")
    
    -- Iterate over all spell book skill lines
    for i = 1, C_SpellBook.GetNumSpellBookSkillLines() do
        local skillLineInfo = C_SpellBook.GetSpellBookSkillLineInfo(i)
        local offset, numSlots = skillLineInfo.itemIndexOffset, skillLineInfo.numSpellBookItems
        
        -- Skip the "General" skill line as it's not class-specific
        if skillLineInfo.name ~= "General" then
            -- Iterate over all spells in the current skill line
            for j = offset + 1, offset + numSlots do
                local name, subName = C_SpellBook.GetSpellBookItemName(j, Enum.SpellBookSpellBank.Player)
                local spellID = select(2, C_SpellBook.GetSpellBookItemType(j, Enum.SpellBookSpellBank.Player))
                local spellInfo = C_SpellBook.GetSpellBookItemInfo(j, Enum.SpellBookSpellBank.Player)
                
                -- Determine if the spell is active and available to the current spec/level
                if spellID and not spellInfo.isPassive and not spellInfo.isOffSpec then
                    if IsSpellKnown(spellID) then
                        table.insert(activeSpells, {
                            spellID = spellID,
                            name = name,
                        })
                    end
                end
            end
        end
    end
    
    return activeSpells
end

function P4.getRemainingCooldown(spell)
    local timeNow = GetTime()
    local spellInfo = C_Spell.GetSpellCooldown(spell)
    local gcdInfo = C_Spell.GetSpellCooldown(61304)
    local gcd = (gcdInfo.startTime + gcdInfo.duration) - timeNow
    local cd = (spellInfo.startTime + spellInfo.duration) - timeNow

    if cd > 0 and cd ~= gcd and spellInfo.isEnabled == true then
        return cd
    end

    return 0
end

function P4.IsSpellReady(id)
    local cd = P4.getRemainingCooldown(id)

    if not IsPlayerSpell(id) then
        return false
    end

    local info = C_Spell.GetSpellCharges(id)
    local time = GetTime()

    if (info) then
        if info.currentCharges and info.currentCharges < info.maxCharges and info.cooldownStartTime < time then
            cd = info.cooldownStartTime + info.cooldownDuration - time
        end
    end
    local ready = cd == 0 or info and info.currentCharges and info.currentCharges > 0 or false
    return ready
end

function P4.GetSpellCharges(id)
    local info = C_Spell.GetSpellCharges(id)
    if info then
        return info.currentCharges or 0, info.maxCharges or 0
    end
    return 0, 0
end

function P4.GetTimeUntilNextCharge(spellID)
    local chargesInfo = C_Spell.GetSpellCharges(spellID)
    if not chargesInfo then return 0 end
    
    if chargesInfo.currentCharges >= chargesInfo.maxCharges then
        return 0 -- charges are full
    end
    
    local rechargeEnd = chargesInfo.cooldownStartTime + (chargesInfo.cooldownDuration / chargesInfo.chargeModRate)
    local timeLeft = rechargeEnd - GetTime()
    if timeLeft < 0 then timeLeft = 0 end
    
    return timeLeft
end