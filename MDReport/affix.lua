function GetAffixWeeksTable()
    local affixWeeks = {    
        [1] =  {[1]=11,[2]=3,[3]=10,[4]=121}, -->>파열,화산,경화 (5)
        [2] =  {[1]=7,[2]=124,[3]=9,[4]=121},-->>폭풍,강화,폭군(6)
        [3] =  {[1]=123,[2]=12,[3]=10,[4]=121},-->원한,치명상,경화(7)
        [4] =  {[1]=122,[2]=4,[3]=9,[4]=121},-->>고취,괴저,폭군(8)
        [5] =  {[1]=8,[2]=14,[3]=10,[4]=121},-->>피웅,전율,경화(9)
        [6] =  {[1]=6,[2]=13,[3]=9,[4]=121},-->>분노,폭탄,폭군(10)
        [7] =  {[1]=4,[2]=3,[3]=10,[4]=121},-->>원한,화산,경화(11)
        [8] =  {[1]=7,[2]=4,[3]=9,[4]=121},  -->>강화,괴저,폭군 (12)
        [9] =  {[1]=11,[2]=124,[3]=10,[4]=121},   -->>파열,폭풍,경화(1)
        [10] = {[1]=8,[2]=12,[3]=9,[4]=121},  -->>피웅,치명,폭군(2)
        [11] = {[1]=122,[2]=13,[3]=10,[4]=121}, -->>고취,폭탄,경화(3)
        [12] = {[1]=6,[2]=14,[3]=9,[4]=121}, -->>분노,전율,폭군(4)
    }  --어둠땅 1시즌
    return affixWeeks
end

function GetAffixNamesTable()
    local affixNames = {
        [1] ={"과잉",7,"{rt4}", "대상의 최대 생명력을 초과하는 치유량은 치유 흡수 효과로 전환됩니다."},
        [2] ={"변덕",7,"{rt6}", "모든 적에 대해 방어 전담이 생성하는 위협 수준이 감소합니다."},
        [3] ={"화산",7,"{rt2}","전투 중 주기적으로 적이 멀리 떨어진 플레이어의 발 밑에서 불길이 솟아나오게 합니다.",[5]=GetSpellLink(209862)}, 
        [4] ={"괴저",7,"{rt6}","모든 적의 근접 공격이 중첩되는 역병 효과를 부여하여, 대상에게 지속 피해를 입히고 받는 치유 효과를 감소시킵니다." ,[5]=GetSpellLink(209858)},
        [5] ={"무리",4,"{rt2}", "던전 내의 우두머리가 아닌 적의 수가 증가합니다."},
        [6] ={"분노",4,"{rt2}", "우두머리가 아닌 적의 남은 생명력이 30% 이하로 떨어지면 격노 상태가 되어, 죽기 전까지 공격력이 100%만큼 증가합니다.",[5]=GetSpellLink(228318)},
        [7] ={"강화",4,"{rt1}", "우두머리가 아닌 적이 죽으면 그 죽음의 메아리가 주위의 아군을 강화하여, 최대 생명력과 공격력이 20%만큼 증가합니다." ,[5]=GetSpellLink(209859)},
        [8] ={"피웅덩이",4,"{rt2}","우두머리가 아닌 적이 죽으면 수액 웅덩이가 남아, 적의 아군을 치유하고 플레이어에게 피해를 입힙니다.",[5]=GetSpellLink(226512)},
        [9] ={"폭군",2,"{rt7}","우두머리의 생명력이 40%만큼 증가합니다. 우두머리와 그 하수인의 공격력이 최대 15%만큼 증가합니다."},
        [10] ={"경화",2,"{rt7}","우두머리가 아닌 적의 생명력이 20%만큼, 공격력이 30%만큼 증가합니다."},    
        [11] ={"파열",4,"{rt8}","우두머리가 아닌 적이 사망 시 파열이 발생해, 모든 플레이어가 피해를 4초에 걸쳐 입습니다. 이 효과는 중첩됩니다." , [5]=GetSpellLink(243237)},
        [12] ={"치명상",7,"{rt4}","부상당한 플레이어는 치유될 때까지 점차 증가하는 지속 피해를 받습니다." ,[5]=GetSpellLink(240559)},
        [13] ={"폭탄",7,"{rt1}","전투 중에 적이 주기적으로 폭발성 보주를 소환합니다. 보주는 파괴되지 않으면 폭발합니다." ,[5]=GetSpellLink(240446)},
        [14] ={"전율",7,"{rt1}","모든 플레이어에게 주기적으로 파장이 발생합니다. 이 파장은 자신 및 주위 아군에게 피해를 입히고 주문 시전을 차단합니다." ,[5]=GetSpellLink(240447)},
        --[15] ={"불굴",},
        [16] ={"감염",10,"{rt3}","우두머리 아닌 적의 일부가 그훈의 피조물에 감염되었습니다."},
        [117] ={"수확",10,"{rt3}","우두머리가 아닌 적이 브원삼디에 의해 강화되어, 주기적으로 무덤 밖으로 나와 복수의 대상을 찾습니다..."},
        [119] ={"미혹",10,"{rt3}","던전 전역에서 아즈샤라의 사절이 출현합니다."},
        [120] ={"각성",10,"{rt3}","던전 구석구석 배치된 방첨탑을 통해 나이알로사로 들어가 느조스의 강력한 하수인과 맞서야 합니다. 하수인을 처리하지 않으면 최종 우두머리와 전투를 벌일 때 상대해야 합니다."},
        [121] ={"교만",10,"{rt3}","우두머리가 아닌 적을 처치하면 플레이어가 교만으로 넘쳐나 끝내 교만의 현신을 형성시킵니다. 이 현신을 처치하면 플레이어가 크게 강화됩니다." ,GetSpellLink(340880),GetSpellLink(342332),GetSpellLink(342494)}, 
        [122] ={"고취",4,"{rt2}","일부 우두머리가 아닌 적이 아군을 강화하는 고무적인 기운을 발산합니다.",[5]="고취: "..GetSpellLink(343502)}, 
        [123] ={"원한",4,"{rt8}","우두머리가 아닌 적의 시체에서 마귀가 나타나 무작위 플레이어를 추적합니다."},
        [124] ={"폭풍",7,"{rt1}","전투 중에 적이 주기적으로 피해를 입히는 돌개바람을 소환합니다." ,[5]=GetSpellLink(343520)},
        
    }--격아 4시즌
    return affixNames
end
local affixAddedLevel={
    [1]="{rt6}",
    [2]="{rt2}",
    [3]="{rt3}",
    [4]="{rt8}",--해골    
}

function GetAffixFullText(AffixTable)
    if AffixTable[1]==0 then
        print("▶MDReport: 적절한 쐐기 속성을 찾을 수 없습니다. 애드온을 업데이트하세요.")
        return
    end    
    local AffixNames={}
    local affixNames=GetAffixNamesTable()
    AffixNames[1]=affixNames[AffixTable[3]][3]..(affixNames[AffixTable[3]][5] or affixNames[AffixTable[3]][1])
    AffixNames[2]=affixNames[AffixTable[1]][3]..(affixNames[AffixTable[1]][5] or affixNames[AffixTable[1]][1])
    AffixNames[3]=affixNames[AffixTable[2]][3]..(affixNames[AffixTable[2]][5] or affixNames[AffixTable[2]][1])    
    AffixNames[4]=affixNames[AffixTable[4]][3]..(affixNames[AffixTable[4]][5] or affixNames[AffixTable[4]][1])        
    local affixLevelText=""
    local affixFullText=""
    for i=1,#AffixNames do        
        affixFullText=affixFullText..AffixNames[i]     
    end
    return affixFullText
end

function GetAffixFullDescription(keyword)
    local affixNames=GetAffixNamesTable()
    for k,v in pairs(affixNames) do
        if v[1]==keyword then
            local message={}
            message[1]="▶"..v[1].." ["..v[2].."단 이상]: "..v[4]
            if v[5] then
                message[2]="▷"                
                for i=5,7 do                
                    if v[i] then
                        message[2]=(message[2] or "")..v[i]..", "
                    end                
                end
                if message[2] and strsub(message[2],-2)==", " then
                    message[2]=strsub(message[2],1,-3)
                end   
            end              
            return message
        end        
    end    
end

function GetAnyWeeksAffix(week)
    
    local thisWeek=GetThisWeek()
    local calledWeek=thisWeek
    local affixWeeks=GetAffixWeeksTable()
    local howManyWeeks=#affixWeeks
    local calledWeekFullTex,calledWeekAffix="",{}
    
    if week~=0 then --이번주가 아니면
        if thisWeek==nil then
            print("▶MDReport: 적절한 쐐기 속성을 찾을 수 없습니다. 애드온을 업데이트하세요.")
            return
        end        
        
        if week~=nil then         
            calledWeek=thisWeek+week
            if calledWeek<1 then calledWeek=calledWeek+howManyWeeks 
            elseif calledWeek>howManyWeeks then calledWeek=calledWeek-howManyWeeks
            end        
        end                 
        calledWeekAffix=affixWeeks[calledWeek]       
    else
        local thisWeeksAffix=C_MythicPlus.GetCurrentAffixes()
        calledWeekAffix[1]=thisWeeksAffix[2]["id"]        
        calledWeekAffix[2]=thisWeeksAffix[3]["id"]        
        calledWeekAffix[3]=thisWeeksAffix[1]["id"]        
        calledWeekAffix[4]=thisWeeksAffix[4]["id"]                
    end 
    calledWeekFullText=GetAffixFullText(calledWeekAffix)
    
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
    local thisWeek    
    for week,affixes in ipairs(affixWeeks) do
        if affixes[1] == affixIds[2].id and affixes[2] == affixIds[3].id and affixes[3] == affixIds[1].id then
            thisWeek=week
        end
    end
    return thisWeek
end

function isThisWeekHasSpecificAffix(affixNum)
    local thisWeek=GetThisWeek()
    if thisWeek==nil then return false end
    local affixWeeks=GetAffixWeeksTable()
    local affixTable=affixWeeks[thisWeek]
    for i=1,#affixTable do
        if affixTable[i]==affixNum then
            return true
        end        
    end    
end
