function GetAffixWeeksTable()
    local affixWeeks = {    
        [1] = {[1]=5,[2]=3,[3]=9,[4]=120},
        [2] = {[1]=7,[2]=2,[3]=10,[4]=120},
        [3] = {[1]=11,[2]=4,[3]=9,[4]=120},
        [4] = {[1]=8,[2]=14,[3]=10,[4]=120},
        [5] = {[1]=7,[2]=13,[3]=9,[4]=120},
        [6] = {[1]=11,[2]=3,[3]=10,[4]=120},
        [7] = {[1]=6,[2]=4,[3]=9,[4]=120},
        [8] = {[1]=5,[2]=14,[3]=10,[4]=120},
        [9] = {[1]=11,[2]=2,[3]=9,[4]=120},
        [10] = {[1]=7,[2]=12,[3]=10,[4]=120},
        [11] = {[1]=6,[2]=13,[3]=9,[4]=120},
        [12] = {[1]=8,[2]=12,[3]=10,[4]=120},
    }  --격아 4시즌
    return affixWeeks
end
function GetAffixNamesTable()
    local affixNames = {
        [1] ="과잉",
        [2] ="변덕",
        [3] =GetSpellLink(209862),--화산
        [4] =GetSpellLink(209858),--괴저
        [5] ="무리",
        [6] =GetSpellLink(228318),--분노
        [7] =GetSpellLink(209859),--강화
        [8] =GetSpellLink(226512),--피웅
        [9] ="폭군",
        [10] ="경화",
        [11] =GetSpellLink(243237),--파열
        [12] =GetSpellLink(240559),--치명상
        [13] =GetSpellLink(240446),--폭탄
        [14] =GetSpellLink(240447),--전율
        [15] ="불굴",
        [16] ="감염",
        [117] ="수확",
        [119] ="미혹",
        [120] ="각성",
    }--격아 4시즌
    return affixNames
end

local affixAddedLevel={
    [1]="(2),",
    [2]="(4),",
    [3]="(7),",
    [4]="(10),",
}

function GetAffixFullText(AffixTable)    
    local AffixNames={}
    local affixNames=GetAffixNamesTable()
    AffixNames[1]=affixNames[AffixTable[3]]    
    AffixNames[2]=affixNames[AffixTable[1]]    
    AffixNames[3]=affixNames[AffixTable[2]]    
    AffixNames[4]=affixNames[AffixTable[4]]        
    local affixLevelText=""
    local affixFullText=""
    for i=1,#AffixNames do        
        affixFullText=affixFullText..AffixNames[i]..affixAddedLevel[i]         
    end
    return affixFullText
end

function GetAnyWeeksAffix(week)
    
    local thisWeek=GetThisWeek()
    local calledWeek=thisWeek
    local affixWeeks=GetAffixWeeksTable()
    local howManyWeeks=#affixWeeks
    if week~=nil then         
        calledWeek=thisWeek+week
        if calledWeek<1 then calledWeek=calledWeek+howManyWeeks 
        elseif calledWeek>howManyWeeks then calledWeek=calledWeek-howManyWeeks
        end        
    end 
    
    local calledWeekAffix=affixWeeks[calledWeek]    
    
    local calledWeekFullText=GetAffixFullText(calledWeekAffix)
    
    return calledWeekFullText    
    
end

function GetThisWeek()
    if not IsAddOnLoaded("Blizzard_ChallengesUI") then
        LoadAddOn("Blizzard_ChallengesUI")
    end
    C_MythicPlus.RequestCurrentAffixes()
    C_MythicPlus.RequestMapInfo()
    C_MythicPlus.RequestRewards()
    local affixIds = C_MythicPlus.GetCurrentAffixes()
    if not affixIds then return end  
    local affixWeeks=GetAffixWeeksTable()
    local thisWeek=1    
    for week,affixes in ipairs(affixWeeks) do
        if affixes[1] == affixIds[2].id and affixes[2] == affixIds[3].id and affixes[3] == affixIds[1].id then
            thisWeek=week
        end
    end
    return thisWeek
end

function isThisWeekHasSpecificAffix(affixNum)
    local thisWeek=GetThisWeek()
    local affixWeeks=GetAffixWeeksTable()
    local affixTable=affixWeeks[thisWeek]
    for i=1,#affixTable do
        if affixTable[i]==affixNum then
            return true
        end        
    end    
end
