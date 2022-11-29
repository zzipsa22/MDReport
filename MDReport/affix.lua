local affixNames = {
    [0] = {
        ["name"]="알수없음",
        ["level"]=2,
        ["rt"]="{rt4}",
        ["disc"]=""
    },
    [1] ={
        ["name"]="과잉",
        ["level"]=7,
        ["rt"]="{rt4}",
        ["disc"]="대상의 최대 생명력을 초과하는 치유량은 치유 흡수 효과로 전환됩니다."
    },
    [2] ={
        ["name"]="변덕",
        ["level"]=7,
        ["rt"]="{rt6}", 
        ["disc"]="모든 적에 대해 방어 전담이 생성하는 위협 수준이 감소합니다."
    },
    [3] ={
        ["name"]="화산",
        ["level"]=7,
        ["rt"]="{rt2}",
        ["disc"]="전투 중 주기적으로 적이 멀리 떨어진 플레이어의 발 밑에서 불길이 솟아나오게 합니다.",
        [5]=209862
    }, 
    [4] ={            
        ["name"]="괴저",
        ["level"]=7,
        ["rt"]="{rt6}",
        ["disc"]="모든 적의 근접 공격이 중첩되는 역병 효과를 부여하여, 대상에게 지속 피해를 입히고 받는 치유 효과를 감소시킵니다." ,
        [5]=209858
    },
    [5] ={
        ["name"]="무리",
        ["level"]=4,
        ["rt"]="{rt2}",
        ["icon"]=136054,
        ["disc"]="던전 내의 우두머리가 아닌 적의 수가 증가합니다."
    },
    [6] ={
        ["name"]="분노",
        ["level"]=4,
        ["rt"]="{rt2}", 
        ["disc"]="우두머리가 아닌 적의 남은 생명력이 30% 이하로 떨어지면 격노 상태가 되어, 죽기 전까지 공격력이 75%만큼 증가합니다.",
        [5]=228318
    },
    [7] ={
        ["name"]="강화",
        ["level"]= 4,
        ["rt"]="{rt1}", 
        ["disc"]="우두머리가 아닌 적이 죽으면 그 죽음의 메아리가 주위의 아군을 강화하여, 최대 생명력이 15%만큼, 공격력이 20%만큼 증가합니다." ,
        [5]=209859
    },
    [8] ={
        ["name"]="피웅덩이",
        ["level"]=4,
        ["rt"]="{rt2}",
        ["disc"]="우두머리가 아닌 적이 죽으면 수액 웅덩이가 남아, 적의 아군을 치유하고 플레이어에게 피해를 입힙니다.",
        [5]=226512
    },
    [9] ={
        ["name"]="폭군",
        ["level"]=2,
        ["rt"]="{rt7}",
        ["icon"]=236401,
        ["disc"]="우두머리의 생명력이 30%만큼 증가합니다. 우두머리와 그 하수인의 공격력이 최대 15%만큼 증가합니다."
    },
    [10] ={
        ["name"]="경화",
        ["level"]=2,
        ["rt"]="{rt7}",            
        ["icon"]= 463829,            
        ["disc"]="우두머리가 아닌 적의 생명력이 20%만큼, 공격력이 30%만큼 증가합니다."
    },    
    [11] ={
        ["name"]="파열",
        ["level"]=4,
        ["rt"]="{rt8}",
        ["disc"]="우두머리가 아닌 적이 사망 시 파열이 발생해, 모든 플레이어가 피해를 4초에 걸쳐 입습니다. 이 효과는 중첩됩니다." ,
        [5]=243237
    },
    [12] ={
        ["name"]="치명상",
        ["level"]=7,
        ["rt"]="{rt4}",
        ["disc"]="부상당한 플레이어는 치유될 때까지 점차 증가하는 지속 피해를 받습니다." ,
        [5]=240559
    },
    [13] ={
        ["name"]="폭탄",
        ["level"]=7,
        ["rt"]="{rt1}",
        ["disc"]="전투 중에 적이 주기적으로 폭발성 보주를 소환합니다. 보주는 파괴되지 않으면 폭발합니다." ,
        [5]=240446
    },
    [14] ={
        ["name"]="전율",
        ["level"]=7,
        ["rt"]="{rt1}",
        ["disc"]="모든 플레이어에게 주기적으로 파장이 발생합니다. 이 파장은 자신 및 주위 아군에게 피해를 입히고 주문 시전을 차단합니다." ,
        [5]=240447
    },
    --[15] ={"불굴",},
    [16] ={
        ["name"]="감염",
        ["level"]=10,
        ["rt"]="{rt3}",
        ["disc"]="우두머리 아닌 적의 일부가 그훈의 피조물에 감염되었습니다."
    },
    [117] ={
        ["name"]="수확",
        ["level"]=10,
        ["rt"]="{rt3}",
        ["disc"]="우두머리가 아닌 적이 브원삼디에 의해 강화되어, 주기적으로 무덤 밖으로 나와 복수의 대상을 찾습니다..."
    },
    [119] ={
        ["name"]="미혹",
        ["level"]=10,
        ["rt"]="{rt3}",
        ["disc"]="던전 전역에서 아즈샤라의 사절이 출현합니다."
    },
    [120] ={
        ["name"]="각성",
        ["level"]=10,
        ["rt"]="{rt3}",
        ["disc"]="던전 구석구석 배치된 방첨탑을 통해 나이알로사로 들어가 느조스의 강력한 하수인과 맞서야 합니다. 하수인을 처리하지 않으면 최종 우두머리와 전투를 벌일 때 상대해야 합니다."
    },
    [121] ={
        ["name"]="교만",
        ["level"]=10,
        ["rt"]="{rt3}",
        ["disc"]="우두머리가 아닌 적을 처치하면 플레이어가 교만으로 넘쳐나 끝내 교만의 현신을 형성시킵니다. 이 현신을 처치하면 플레이어가 크게 강화됩니다." ,
        [5]=340880,
        [6]=342332,
        [7]=342494,
    }, 
    [122] ={
        ["name"]="고취",
        ["level"]=4,
        ["rt"]="{rt2}",
        ["disc"]="일부 우두머리가 아닌 적이 아군을 강화하는 고무적인 기운을 발산합니다.",
        [5]=343502
    }, 
    [123] ={
        ["name"]="원한",
        ["level"]=4,
        ["rt"]="{rt8}",
        ["icon"]=135945,
        ["disc"]="우두머리가 아닌 적의 시체에서 마귀가 나타나 무작위 플레이어를 추적합니다."
    },
    
    [124] ={
        ["name"]="폭풍",
        ["level"]= 7,
        ["rt"]="{rt1}",
        ["disc"]="전투 중에 적이 주기적으로 피해를 입히는 돌개바람을 소환합니다." ,
        [5]=343520
    },
    
    [128] ={
        ["name"]="고통",
        ["level"]= 10,
        ["rt"]="{rt3}",
        ["icon"]=3528304,
        ["disc"]="던전 곳곳에서 간수의 종복이 출현합니다. 이들을 처치하면 강력한 은총을 받습니다. 종복을 처리하지 않으면 마지막 우두머리가 강화됩니다." ,
    },
	
	[130] ={
        ["name"]="암호",
        ["level"]= 10,
        ["rt"]="{rt3}",
        ["icon"]=4038106,
        ["disc"]="던전에 태초의 존재의 유물을 가진 적이 출현합니다. 유물을 파괴하면 태초의 존재의 자동기계가 소환됩니다. 자동기계를 파괴하는 순서에 따라 강력한 추가 효과를 얻습니다." ,
    },
	
	[131] ={
        ["name"]="장막",
        ["level"]= 10,
        ["rt"]="{rt3}",
        ["icon"]=136177,
        ["disc"]="나스레짐 침입자들이 변장해 던전 곳곳의 적들 사이로 숨어들었습니다. 이 침입자들을 잡는다면 타 중개단이 후한 사례를 할 것입니다." ,
    },
	
	[132] ={
        ["name"]="천둥",
        ["level"]= 10,
        ["rt"]="{rt3}",
        ["icon"]=1385910,
        ["disc"]="적의 생명력이 5% 더 증가합니다. 전투 중 플레이어가 주기적으로 라자게스의 끝없는 폭풍에 휘말려 원시의 힘으로 충만해집니다. 이 힘에는 큰 위험이 따르며, 신속하게 방출하지 않으면 정신이 아득해지는 결과가 뒤따릅니다." ,
    },
    
}--둠땅 4시즌

local affixs
if C_MythicPlus.GetCurrentSeason()==8 then --어둠땅 4시즌
	affixs = {
		{"강화","폭탄","폭군","장막"},
		{"파열","폭풍","경화","장막"},
		{"분노","화산","폭군","장막"},
		{"고취","치명상","경화","장막"},
		{"원한","괴저","폭군","장막"},
		{"강화","전율","경화","장막"},
		{"피웅덩이","폭풍","폭군","장막"},
		{"분노","폭탄","경화","장막"},
		{"파열","화산","폭군","장막"},
		{"원한","괴저","경화","장막"},
		{"고취","전율","폭군","장막"},
		{"피웅덩이","치명상","경화","장막"},        
	}
else -- 용군단 1시즌
	affixs = {    
		{"분노","전율","폭군","천둥"},
		{"파열","치명상","경화","천둥"},
		{"피웅덩이","화산","폭군","천둥"},
		{"분노","폭풍","경화","천둥"},
		{"원한","치명상","폭군","천둥"},
		{"피웅덩이","폭탄","경화","천둥"},
		{"강화","폭풍","폭군","천둥"},
		{"원한","전율","경화","천둥"},
		{"파열","폭탄","폭군","천둥"},
		{"강화","화산","경화","천둥"},   
	}
end

local affixIDs={}
for k,v in pairs(affixNames) do
    affixIDs[v.name]=k
end

function GetAffixIDByName(keyword)
	for k,v in pairs(affixNames) do
		if v.name==keyword then
			return k
		end
	end
end

function GetAffixWeeksTable()
    local t=affixIDs
    local affixWeeks={}
    for i=1, #affixs do
        affixWeeks[i]={}
        for j=1,4 do
            tinsert(affixWeeks[i],t[affixs[i][j]])
        end
    end
    return affixWeeks
end

function GetAffixNamesTable()
    return affixNames
end

function GetAffixFullText(AffixTable,channel)
    if AffixTable[1]==0 then
        print("▶MDReport: 적절한 쐐기 속성을 찾을 수 없습니다. 애드온을 업데이트하세요.")
        return
    end    
    local AffixNames={}
    local affixNames=GetAffixNamesTable()
    local tempTable={}
    tempTable[1]=affixNames[AffixTable[3]]
    tempTable[2]=affixNames[AffixTable[1]]
    tempTable[3]=affixNames[AffixTable[2]]
    tempTable[4]=affixNames[AffixTable[4]]
    
    for i=1,#tempTable do
        local icon,spellLink="",""
        if channel=="ADDON_GUILD" or channel=="ADDON_WHISPER" or channel=="ADDON_PARTY" or channel=="ADDON_OFFICER" or  channel=="print" then
            if tempTable[i][5] then
                _,_,icon=GetSpellInfo(tempTable[i][5])
                icon="\124T"..icon..":0:::-4\124t"
                spellLink=GetSpellLink(tempTable[i][5])
            else
                icon="\124T"..tempTable[i]["icon"]..":0:::-4\124t"
                spellLink=tempTable[i]["name"]
            end  
        else
            icon=tempTable[i]["rt"]
            spellLink=tempTable[i]["name"]
        end        
        AffixNames[i]=icon..spellLink        
    end    
    
    local affixLevelText=""
    local affixFullText=""
    for i=1,#AffixNames do        
        affixFullText=affixFullText..AffixNames[i]
        if i<#AffixNames then affixFullText=affixFullText..", " end     
    end
    return affixFullText
end

function GetAffixWeekForSpecificAffix(affix)
    local affixWeeks=GetAffixWeeksTable()
    local affixID=affixIDs[affix]
    local hasAffix={}
    for k,v in pairs(affixWeeks) do
        for i=1,4 do
            if v[i]==affixID then
                tinsert(hasAffix,k)
            end
        end
    end    
    return hasAffix
end

function GetAffixFullDescription(keyword,channel)
    local affixNames=GetAffixNamesTable()    
    local thisWeek=GetThisWeek() or 0 --이번주
    local specificWeek=GetAffixWeekForSpecificAffix(keyword) --포함하는 주
    local tempTable={}
	local affixID=GetAffixIDByName(keyword)
	local affixLevel=affixNames[affixID].level
    
    local message={}
    
    for k,v in pairs(affixNames) do
        if v["name"]==keyword then
            local icon=""
            if channel=="ADDON_GUILD" or channel=="ADDON_WHISPER" or channel=="ADDON_PARTY" or channel=="ADDON_OFFICER" or  channel=="print" then
                if v[5] then
                    _,_,icon=GetSpellInfo(v[5])
                    icon="\124T"..icon..":0:::-4\124t"
                else
                    icon="\124T"..v["icon"]..":0:::-4\124t"
                end
            else
                icon=v["rt"]
            end              
            message[1]="▶"..icon..v["name"].." ["..v["level"].."단 이상]: "..v["disc"]     
            break
        end        
    end
	--print(specificWeek)
    if affixLevel~=2 and affixLevel~=10 then
        local comparison = function(entry1, entry2)
            local week1=entry1 and entry1-thisWeek or nil
            local week2=entry2 and entry2-thisWeek or nil
            if week1 and week1<0 then week1=week1+#affixs end
            if week2 and week2<0 then week2=week2+#affixs end
            if week1 and week2 and week1 < week2 then
                return entry1 > entry2
            else
                return entry1 < entry2
            end        
        end		
        table.sort(specificWeek, comparison)
        
        for i=1,#specificWeek do    
            local header=""
            local week=specificWeek[i]-thisWeek
            if week<0 then
                week=week+#affixs
            end
            if week==0 then
                header="▶이번주"
            elseif week==1 then
                header="▶다음주"
            else
                header="▷"..week.."주뒤"
            end
            message[#message+1]=header.." 속성: "..(GetAnyWeeksAffix(week,channel) or "")
        end
    end
    return message
end

function GetAnyWeeksAffix(week,channel)  
    local thisWeek=GetThisWeek() or 0
    local calledWeek=thisWeek
    local affixWeeks=GetAffixWeeksTable()
    local howManyWeeks=#affixWeeks
    local calledWeekFullTex,calledWeekAffix="",{}
    
    if week~=0 then --이번주가 아니면
        if thisWeek==nil then
            print("▶MDReport: 적절한 쐐기 속성을 찾을 수 없습니다. 애드온을 업데이트하거나 새로운 시즌이 열릴때까지 기다려야 합니다.")
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
		if not thisWeeksAffix or #thisWeeksAffix<4 then return end
        calledWeekAffix[1]=thisWeeksAffix[2]["id"]        
        calledWeekAffix[2]=thisWeeksAffix[3]["id"]        
        calledWeekAffix[3]=thisWeeksAffix[1]["id"]        
        calledWeekAffix[4]=thisWeeksAffix[4]["id"]                
    end 
    calledWeekFullText=GetAffixFullText(calledWeekAffix,channel)
    
    return calledWeekFullText        
end

function GetThisWeek()
    C_MythicPlus.RequestCurrentAffixes()
    C_MythicPlus.RequestMapInfo()
    C_MythicPlus.RequestRewards()
    local affixIds = C_MythicPlus.GetCurrentAffixes()
    if not affixIds or #affixIds<4 then return end  
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
    local thisWeeksAffix=C_MythicPlus.GetCurrentAffixes()
    local affixTable={}    
    if thisWeeksAffix==nil or #thisWeeksAffix<4 then 
		return false 
	end
    affixTable[1]=thisWeeksAffix[2]["id"]        
    affixTable[2]=thisWeeksAffix[3]["id"]        
    affixTable[3]=thisWeeksAffix[1]["id"]        
    affixTable[4]=thisWeeksAffix[4]["id"]   
    for i=1,#affixTable do
        if affixTable[i]==affixNum then
            return true
        end        
    end
    return false
end
