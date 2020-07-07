local version="1.1.2"
local lastUpdate="20.07.07"
local warning=1
local searchingTip1=0
local searchingTip2=0
local searchingTip3=0
local searchingTip4=0
local searchingTip5=0
local searchingTip6=0
local searchingTip7=0
local howManyWarn=3
local warnMessage={
    [1]="▶ Saved Instances 애드온이 설치되어 있지 않아 쐐기돌 정보를 불러올 수 없습니다.",
    [2]="▶ 트위치나 인벤, 루리웹등에서 Saved Instances 를 다운받아 설치해주세요."    
}
local MY_NAME_IN_GAME=UnitName("player").."-"..GetRealmName()    
local MY_NAME_IN_ADDON=UnitName("player").." - "..GetRealmName()    

function mysplit (inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

local skull={
    ["술사"]="{rt6}",--네모(파랑)
    ["법사"]="{rt6}",--네모(파랑)
    ["수도"]="{rt4}",--역삼(역삼)
    ["냥꾼"]="{rt4}",--역삼(역삼)
    ["도적"]="{rt1}",--별(노랑)
    ["드루"]="{rt2}",--동그(주황)
    ["전사"]="{rt2}",--동그(주황)
    ["악사"]="{rt3}",--다야(보라)
    ["흑마"]="{rt3}",--다야(보라)
    ["기사"]="{rt3}",--다야(보라)
    ["사제"]="{rt5}",--달(흰색)
    ["죽기"]="{rt7}",--엑스(빨강)          
}
local hasteClass={
    {"술사",GetSpellLink(32182)},
    {"법사",GetSpellLink(80353)},
    {"냥꾼",GetSpellLink(90355)},
}
local resurrectClass={
    {"드루",GetSpellLink(20484)},
    {"죽기",GetSpellLink(61999)},
    {"흑마",GetSpellLink(20707)},
}

local poisonClass={
    {"드루",GetSpellLink(2782)},
    {"수도",GetSpellLink(218164)},
    {"기사",GetSpellLink(213644)},
}
local diseaseClass={
    {"사제",GetSpellLink(527)},
    {"기사",GetSpellLink(213644)},
    {"수도",GetSpellLink(218164)},
}

local curseClass={
    {"드루",GetSpellLink(2782)},
    {"법사",GetSpellLink(475)},
    {"술사",GetSpellLink(51886)},
}

local clothClass={"법사","사제","흑마"}
local leatherClass={"드루","수도","도적","악사"}
local mailClass={"냥꾼","술사"}
local plateClass={"전사","죽기","기사"}
local shieldClass={"전사","기사","술사"}

local callTypeTable={
    
    ["돌"]={"all", nil},
    ["쐐기돌"]={"all", nil},
    ["쐐기"]={"all", nil},
    ["전체돌"]={"all", nil},
    ["아무"]={"all", nil},    
    ["모든돌"]={"all", nil},
    
    ["내돌"]={"mykey", nil},
    
    ["지금내돌"]={"currentmykey", nil},
    ["무슨돌"]={"currentmykey", nil},
    
    ["지금돌"]={"currentall", nil},
    ["현재돌"]={"currentall", nil},
    ["돌내놔"]={"currentall", nil},   
    
    ["주차"]={"parking", nil},
    
    ["이상"]={"levelrange", "이상"},
    ["+"]={"levelrange", "이상"},
    ["이하"]={"levelrange", "이하"},
    ["-"]={"levelrange", "이하"},
    ["미만"]={"levelrange", "미만"},
    ["초과"]={"levelrange", "초과"},  
    
    ["힘"]={"stat", "힘"},  
    ["민"]={"stat", "민첩"},  
    ["지"]={"stat", "지능"},      
    ["민첩"]={"stat", "민첩"},  
    ["지능"]={"stat", "지능"},  
    
    ["드"]={"class", "드루"},
    ["들후"]={"class", "드루"},
    ["드루"]={"class", "드루"},
    ["드루이드"]={"class", "드루"},
    ["DRUID"]={"class", "드루"},
    ["수"]={"class", "수도"},
    ["수도"]={"class", "수도"},    
    ["수도사"]={"class", "수도"},
    ["도사"]={"class", "수도"},
    ["MONK"]={"class", "수도"},
    ["성"]={"class", "기사"},    
    ["기"]={"class", "기사"},    
    ["기사"]={"class", "기사"},
    ["성기사"]={"class", "기사"},
    ["PALADIN"]={"class", "기사"},
    ["술"]={"class", "술사"},    
    ["술사"]={"class", "술사"},
    ["주술사"]={"class", "술사"},
    ["SHAMAN"]={"class", "술사"},
    ["사"]={"class", "사제", "지능"},
    ["사제"]={"class", "사제", "지능"},
    ["흰거"]={"class", "사제", "지능"},
    ["PRIEST"]={"class", "사제", "지능"},
    ["죽"]={"class", "죽기"},
    ["죽기"]={"class", "죽기"},
    ["죽음의기사"]={"class", "죽기"},
    ["DEATHKNIGHT"]={"class", "죽기"},
    ["악"]={"class", "악사", "민첩"},
    ["악사"]={"class", "악사", "민첩"},
    ["악마사냥꾼"]={"class", "악사", "민첩"},
    ["DEMONHUNTER"]={"class", "악사", "민첩"},
    ["도"]={"class", "도적"},
    ["도적"]={"class", "도적"},
    ["돚거"]={"class", "도적"},
    ["ROGUE"]={"class", "도적"},
    ["전"]={"class", "전사"},
    ["전사"]={"class", "전사"},
    ["WARRIOR"]={"class", "전사"},
    ["흑"]={"class", "흑마", "지능"},
    ["흑마"]={"class", "흑마", "지능"},
    ["흑마법사"]={"class", "흑마", "지능"},
    ["WARLOCK"]={"class", "흑마", "지능"},
    ["법"]={"class", "법사", "지능"},
    ["법사"]={"class", "법사", "지능"},
    ["물빵"]={"class", "법사", "지능"},
    ["마법사"]={"class", "법사", "지능"},
    ["MAGE"]={"class", "법사", "지능"},
    ["냥"]={"class", "냥꾼"},
    ["냥꾼"]={"class", "냥꾼"},
    ["사냥꾼"]={"class", "냥꾼"},
    ["HUNTER"]={"class", "냥꾼"},
    
    ["회드"]={"spec", "회복", "지능"},
    ["회복"]={"spec", "회복", "지능"},
    ["조드"]={"spec", "조화", "지능"},
    ["조화"]={"spec", "조화", "지능"},
    ["수드"]={"spec", "수호", "민첩"},
    ["수호"]={"spec", "수호", "민첩"},
    ["야드"]={"spec", "야성", "민첩"},
    ["야성"]={"spec", "야성", "민첩"},
    
    ["암사"]={"spec", "사제", "지능"},
    ["암흑"]={"spec", "사제", "지능"},
    ["신사"]={"spec", "사제", "지능"},
    ["신성"]={"spec", "사제", "지능"},
    ["수사"]={"spec", "사제", "지능"},
    ["수양"]={"spec", "사제", "지능"},
    
    ["운무"]={"spec", "운무", "지능"},
    ["풍운"]={"spec", "풍운", "민첩"},
    ["양조"]={"spec", "양조", "민첩"},
    
    ["정술"]={"spec", "정기", "지능"},
    ["정기"]={"spec", "정기", "지능"},
    ["고술"]={"spec", "고양", "민첩"},
    ["고양"]={"spec", "고양", "민첩"},
    ["복술"]={"spec", "복원", "지능"},
    ["복원"]={"spec", "복원", "지능"},
    
    ["보기"]={"spec", "보호", "힘"},
    ["보호"]={"spec", "보호", "힘"},
    ["신기"]={"spec", "신성", "지능"},
    ["징기"]={"spec", "징벌", "힘"},
    ["징벌"]={"spec", "징벌", "힘"},
    
    ["화법"]={"spec", "법사", "지능"},
    ["냉법"]={"spec", "법사", "지능"},
    ["비법"]={"spec", "법사", "지능"},
    ["비전"]={"spec", "법사", "지능"},
    ["화염"]={"spec", "법사", "지능"},
    
    
    
    
    ["파흑"]={"spec", "흑마", "지능"},
    ["파괴"]={"spec", "흑마", "지능"},
    ["고흑"]={"spec", "흑마", "지능"},
    ["고통"]={"spec", "흑마", "지능"},
    ["악흑"]={"spec", "흑마", "지능"},
    ["악마"]={"spec", "흑마", "지능"},
    
    ["무법"]={"spec", "무법", "민첩"},
    ["암살"]={"spec", "암살", "민첩"},
    ["잠행"]={"spec", "잠행", "민첩"},
    
    ["무전"]={"spec", "무기", "힘"},
    ["분노"]={"spec", "분노", "힘"},
    ["분전"]={"spec", "분노", "힘"},
    ["방어"]={"spec", "방어", "힘"},
    ["방전"]={"spec", "방어", "힘"},
    
    ["혈죽"]={"spec", "혈기", "힘"},
    ["혈기"]={"spec", "혈기", "힘"},
    ["부죽"]={"spec", "부정", "힘"},
    ["부정"]={"spec", "부정", "힘"},
    ["냉죽"]={"spec", "냉기", "힘"},
    ["냉기"]={"spec", "냉기", "힘"},
    
    ["파멸"]={"spec", "악사", "민첩"},
    ["복수"]={"spec", "악사", "민첩"},
    
    ["야냥"]={"spec", "야수", "민첩"},
    ["야수"]={"spec", "야수", "민첩"},
    ["격냥"]={"spec", "사격", "민첩"},
    ["사격"]={"spec", "사격", "민첩"},
    ["생냥"]={"spec", "생존", "민첩"},
    ["생존"]={"spec", "생존", "민첩"},  
    
    ["독"]={"spell", "독"},
    ["저주"]={"spell", "저주"},
    ["질병"]={"spell", "질병"},
    
    ["방패"]={"specificitem", "방패"},
    ["한손도검"]={"specificitem", "한손도검"},
    ["양손도검"]={"specificitem", "양손도검"},
    ["한손검"]={"specificitem", "한손도검"},
    ["양손검"]={"specificitem", "양손도검"},
    ["전투검"]={"specificitem", "전투검"},
    ["단검"]={"specificitem", "단검"},
    ["지팡이"]={"specificitem", "지팡이"},
    ["장착무기"]={"specificitem", "장착무기"},
    ["장착"]={"specificitem", "장착무기"},
    ["활"]={"specificitem", "활"},
    ["총"]={"specificitem", "총"},
    ["석궁"]={"specificitem", "석궁"},
    ["한손둔기"]={"specificitem", "한손둔기"},
    ["양손둔기"]={"specificitem", "양손둔기"},
    ["한손도끼"]={"specificitem", "한손도끼"},
    ["한손도끼"]={"specificitem", "양손도끼"},
    ["마법봉"]={"specificitem", "마법봉"},
    ["보조"]={"specificitem", "보조"},
    ["보조장비"]={"specificitem", "보조"},
    ["장창"]={"specificitem", "장창"},
    ["무기"]={"item", "무기"},
    
    ["양손무기"]={"category", "양손장비"},     
    ["양손장비"]={"category", "양손장비"},     
    ["양손"]={"category", "양손장비"}, 
    
    ["한손"]={"category", "한손장비"},  
    ["한손무기"]={"category", "한손장비"},     
    ["한손장비"]={"category", "한손장비"},     
    
    ["근접무기"]={"category", "근접장비"},     
    ["근접장비"]={"category", "근접장비"},  
    ["근거리"]={"category", "근접장비"},     
    ["근접"]={"category", "근접장비"},      
    
    ["원거리"]={"category", "원거리장비"},     
    ["원거리장비"]={"category", "원거리장비"},     
    
    ["천"]={"spell", "천"},
    ["사슬"]={"spell", "사슬"},
    ["판금"]={"spell", "판금"},
    ["가죽"]={"spell", "가죽"},
    
    ["웅심"]={"spell", "웅심"},
    ["영웅심"]={"spell", "웅심"},
    ["블러드"]={"spell", "웅심"},
    
    ["전부"]={"spell", "전부"},
    ["전투부활"]={"spell", "전부"},
    
    ["폭사"]={"dungeon", "폭사"},
    ["폭풍의사원"]={"dungeon", "폭사"},
    ["톨다"]={"dungeon", "톨다"},
    ["톨다고르"]={"dungeon", "톨다"},
    ["보랄"]={"dungeon", "보랄"},
    ["보공"]={"dungeon", "보랄"},
    ["보랄러스공성전"]={"dungeon", "보랄"},
    ["세스"]={"dungeon", "세스"},
    ["사원"]={"dungeon", "세스"},
    ["세스랄리스사원"]={"dungeon", "세스"},
    ["썩굴"]={"dungeon", "썩굴"},
    ["썩은굴"]={"dungeon", "썩굴"},
    ["아탈"]={"dungeon", "아탈"},
    ["아탈다자르"]={"dungeon", "아탈"},
    ["왕노"]={"dungeon", "왕노"},
    ["왕노다지"]={"dungeon", "왕노"},
    ["왕안"]={"dungeon", "왕안"},
    ["왕들의안식처"]={"dungeon", "왕안"},
    ["자유"]={"dungeon", "자유"},
    ["자유지대"]={"dungeon", "자유"},
    ["고철장"]={"dungeon", "고철"},
    ["고철"]={"dungeon", "고철"},
    ["작업장"]={"dungeon", "작업"},
    ["작업"]={"dungeon", "작업"},
    
    ["버전"]={"version", nil},
    ["버젼"]={"version", nil},
    
    ["MDReport_VC"]={"forceversion", nil},
    
    ["속성"]={"affix", 0},
    ["이번주"]={"affix", 0},
    ["이번속성"]={"affix", 0},
    ["다음주"]={"affix", 1},
    ["다음주속성"]={"affix", 1},
    ["다음속성"]={"affix", 1},
    ["다다음주"]={"affix", 2},
    ["다다음속성"]={"affix", 2},
    ["다다음주속성"]={"affix", 2},
    ["다다다음주"]={"affix", 3},
    ["다다다음속성"]={"affix", 3},
    ["다다다음주속성"]={"affix", 3},
    ["지난주"]={"affix", -1},
    ["지난속성"]={"affix", -1},
    ["지난주속성"]={"affix", -1},
    ["지지난주"]={"affix", -2},
    ["지지난속성"]={"affix", -2},
    ["지지난주속성"]={"affix", -2},
}

function getCallTypeTable(keyword)
    for k,v in pairs(callTypeTable) do
        if keyword==k then
            return v
        end        
    end 
end


function GetAffixFullText(AffixTable)
    local affixNames = {
        [1] ="과잉",
        [2] ="변덕",
        [3] =GetSpellLink(209862),--치명
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
    }
    local AffixNames={}
    AffixNames[1]=affixNames[AffixTable[3]]    
    AffixNames[2]=affixNames[AffixTable[1]]    
    AffixNames[3]=affixNames[AffixTable[2]]    
    AffixNames[4]=affixNames[AffixTable[4]]        
    local affixLevelText=""
    local affixFullText=""
    for i=1,#AffixNames do
        if i==1 then
            affixLevelText="(2),"
        elseif i==2 then
            affixLevelText="(4),"
        elseif i==3 then
            affixLevelText="(7),"
        elseif i==4 then
            affixLevelText="(10)"            
        end
        affixFullText=affixFullText..AffixNames[i]..affixLevelText         
    end
    return affixFullText
end

function GetAnyWeeksAffix(week)  
    if not IsAddOnLoaded("Blizzard_ChallengesUI") then
        LoadAddOn("Blizzard_ChallengesUI")
    end
    C_MythicPlus.RequestCurrentAffixes()
    C_MythicPlus.RequestMapInfo()
    C_MythicPlus.RequestRewards()
    local affixIds = C_MythicPlus.GetCurrentAffixes()
    if not affixIds then return end    
    
    
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
    }  
    
    local thisWeek=1    
    for week,affixes in ipairs(affixWeeks) do
        if affixes[1] == affixIds[2].id and affixes[2] == affixIds[3].id and affixes[3] == affixIds[1].id then
            thisWeek=week
        end
    end   
    
    local calledWeek=thisWeek
    local howManyWeeks=#affixWeeks
    if week~=nil then         
        calledWeek=thisWeek+week
        if calledWeek<1 then calledWeek=calledWeek+howManyWeeks 
        elseif calledWeek>howManyWeeks then calledWeek=calledWeek-howManyWeeks
        end        
    end 
    --print("요청한 주"..calledWeek)
    
    local calledWeekAffix=affixWeeks[calledWeek]    
    
    local calledWeekFullText=GetAffixFullText(calledWeekAffix)
    
    return calledWeekFullText    
    
end


function filterCallType(callTypeT,channel,who,k2) 
    
    --SavedInstance 체크
    if not SavedInstancesDB then
        doWarningReport(channel,who,"warning") 
        return
    end     
    local level
    if k2~=nil and tonumber(k2)==nil and k2[1]~=nil then
        level=k2
    else
        level=tonumber(k2)
    end
    local callType=callTypeT[1]
    local keyword=callTypeT[2] 
    local extraKeyword=callTypeT[3]    
    local callTypeT2=getCallTypeTable(k2)
    
    --범위지정인데 범위값이 없으면 리턴
    if callType=="levelrange" and k2==nil then
        return
    end  
    
    --내가 아닌 사람이 !속성 !타락저항을 요청하는 경우 리턴
    if who~=MY_NAME_IN_GAME and (callType=="affix" or callType=="corruption")then
        return        
    end   
    
    --버전요청을 한 사람이 나일 경우 리턴
    if callType=="forceversion" and who==MY_NAME_IN_GAME then
        return
    end  
    
    --버전체크를 한 사람이 내가 아닐 경우 리턴
    if callType=="version" and who~=MY_NAME_IN_GAME then
        return
    end      
    
    --내가 보낸 귓말이고, 나한테 보냈거나 !내돌/!지금내돌을 요청한게 아니면 리턴
    if (channel=="WHISPER_OUT") and ((who==MY_NAME_IN_GAME) or (callType~="mykey" and callType~="currentmykey"))  then
        return       
    end    
    
    --채널이 없으면 프린트로 변경
    if channel==nil then channel="print" end  
    
    --나에게서 귓말이 들어오는 경우 프린트로 변경
    if (channel=="WHISPER_IN") and who==MY_NAME_IN_GAME then
        channel="print"
    end       
    
    --버전체크 채널 강제 조정
    if callType=="version" then
        channel="print"
    elseif callType=="forceversion" then
        channel="WHISPER"        
    end     
    
    if callTypeT2 then        
        local callType2=callTypeT2[1]
        local keyword2=callTypeT2[2]
        
        local comb
        
        if (callType=="class" and callType2=="item") or (callType=="class" and callType2=="category")  or (callType=="class" and callType2=="specificitem")  then
            if keyword=="사제" or keyword=="흑마" or keyword=="법사" or keyword=="악사" then
                callType="spec"
            else
                if who==MY_NAME_IN_GAME then
                    if searchingTip1<=howManyWarn then
                        print("입력하신 직업은 전문화에 따라 착용가능한 아이템이 상이하여 전문화를 지정해야만 검색할 수 있습니다. (ex.!회복!한손 or !혈죽!무기)")
                        searchingTip1=searchingTip1+1
                    end
                end
                return
            end
        end
        
        
        if (callType=="spec" and callType2=="item")then
            comb="Spec_Item"
            findCharAllItem(keyword,nil,comb,channel,who,callType)
            
            
        elseif (callType=="stat" and callType2=="specificitem")then 
            comb="Stat_Specificitem"
            
            
            findCharAllItem(keyword,keyword2,comb,channel,who,callType) 
            
            
        elseif (callType=="spec" and callType2=="specificitem")then
            comb="Spec_Specificitem"
            
            
            findCharAllItem(extraKeyword,keyword2,comb,channel,who,callType)           
            
            
            
        elseif (callType=="stat" and callType2=="category")then 
            comb="Stat_Category"            
            
            findCharAllItem(keyword,keyword2,comb,channel,who,callType)             
            
            
        elseif (callType=="spec" and callType2=="category")then 
            comb="Spec_Category"
            
            
            findCharAllItem(keyword,keyword2,comb,channel,who,callType)             
            
            
        elseif (callType=="stat" and callType2=="item") then
            if who==MY_NAME_IN_GAME then
                if searchingTip2<=howManyWarn then
                    print("주능력치와"..'"'.."무기"..'"'.."는 함께 검색할 수 없습니다. 무기 유형(단검,지팡이)이나 종류(양손,한손)를 지정해주세요. (ex. !힘!양손 or !지능!단검)")
                    searchingTip2=searchingTip2+1
                end
            end
        else return            
        end
        return
    else        
        if callType=="currentmykey" or callType=="currentall" then
            findCharCurrent(channel,who,callType)
        elseif callType=="all" or callType=="mykey" or callType=="levelrange" then        
            findCharAllKey(keyword,channel,who,callType,level)
        elseif callType=="parking" then        
            findCharNeedParking(channel,who,callType) 
        elseif callType=="dungeon"then        
            findCharDungeon(keyword,channel,who,callType,level)  
        elseif callType=="class" then            
            findCharClass(keyword,channel,who,callType)       
        elseif callType=="spell" then        
            findCharSpell(keyword,channel,who,callType)     
        elseif callType=="version" or callType=="forceversion"then        
            doCheckVersion(channel,who,callType)    
        elseif callType=="affix" then        
            doOnlyAffixReport(keyword,channel,who,callType)  
        elseif callType=="specificitem"then        
            findCharSpecificItem(nil,keyword,channel,who,callType)
        elseif callType=="spec" and k2==nil then
            if who==MY_NAME_IN_GAME then
                if searchingTip6<=howManyWarn then
                    print("특성을 단독으로 입력하여 착용가능한 모든 무기로 던전을 검색합니다. 특정 직업의 돌이 알고 싶을 경우 !직업(ex.!드루 or !사제)으로 검색하거나, 특정 무기를 지정하고 싶을 경우 무기종류,무기유형과 함께 검색해보세요.(ex.!회복!양손 or !풍운!장착)")
                    searchingTip6=searchingTip6+1
                end
            end                     
            findCharAllItem(keyword,nil,"Spec_Item",channel,who,callType)
        elseif callType=="item" and k2==nil then
            if who==MY_NAME_IN_GAME then
                if searchingTip3<=howManyWarn then
                    print("!무기는 단독으로 검색할 수 없습니다. 특성을 지정해주세요 (ex. !화염!무기)")
                    searchingTip3=searchingTip3+1
                end
            end  
        elseif callType=="stat" and k2==nil then
            if who==MY_NAME_IN_GAME then
                if searchingTip4<=howManyWarn then
                    print("능력치는 단독으로 검색할 수 없습니다. 무기종류를 지정해주세요 (ex. !"..keyword.."!지팡이)")
                    searchingTip4=searchingTip4+1
                end
            end   
        elseif callType=="category" and k2==nil then
            if who==MY_NAME_IN_GAME then
                if searchingTip5<=howManyWarn then
                    print("무기유형은 단독으로 검색할 수 없습니다. !한손도검 !양손둔기 처럼 무기의 종류를 지정하거나 !힘 !지능 등의 능력치와 함께 검색해주세요 (ex. !민첩!원거리장비: 총,활,석궁 검색)")
                    searchingTip5=searchingTip5+1
                end
            end     
        else return end     
    end    
end


--보유한 모든 돌 불러오기
function GetHaveKeyChar()
    if not SavedInstancesDB then  return end   
    local t=SavedInstancesDB.Toons
    local num=1
    local chars={}
    for k,v in pairs(t) do        
        if t[k].MythicKey.link then
            chars[num]={}
            chars[num][1]=k
            chars[num][2]=getCallTypeTable(t[k].Class)[2]
            num=num+1           
        end                
    end
    --[[
    chars[num]={}
    chars[num][1]="드루알이휴지 - 윈드러너"
    chars[num][2]="드루"    
    ]]
    return chars
end


function findCharCurrent(channel,who,callType)
    
    --"currentmykey"
    --"currentall"
    local chars=GetHaveKeyChar() 
    
    --명령어가 !지금내돌 인데 내가 보낸게 아니면 리턴
    if (callType=="currentmykey") and who~=MY_NAME_IN_GAME and channel~="WHISPER_OUT" then 
        return 
    end    
    
    local findChars={}   
    local num=1        
    
    if chars~=nil then        
        
        for i=1,#chars do
            if MY_NAME_IN_ADDON==chars[i][1] then                
                findChars[1]=chars[i]
            end
        end    
    end
    --이캐릭 돌이 없으면
    if #findChars==0 then
        if channel=="GUILD" and callType=="currentall" then
            return
        end        
        local messageLines={}
        messageLines[1]="▶이캐릭은 현재 갖고 있는 돌이 없습니다!" 
        reportMessageLines(messageLines,channel,who,callType)
        return
    end      
    
    doFullReport(findChars,channel,who,callType) 
end



--보유한 모든 돌 보고하기
function findCharAllKey(keyword,channel,who,callType,level)
    
    --"all"
    --"mykey"
    local chars=GetHaveKeyChar()     
    local forceToShort=0 
    
    --레벨이 범위인 경우
    local level2=nil
    if level~=nil and tonumber(level)==nil and level[1]~=nil then  
        table.sort(level)        
        level2=level[2] 
        level=level[1]   
    end          
    --명령어가 !내돌 인데 내가 보낸게 아니면 리턴
    if (callType=="mykey") and who~=MY_NAME_IN_GAME and channel~="WHISPER_OUT" then 
        return 
    end       
    
    --!돌이나 !레벨범위를 길드로 요청한 경우 짧게 보고
    if (callType=="all"or callType=="levelrange") and ((channel=="GUILD") or (channel=="PARTY")) then
        forceToShort=1
    end 
    
    --!내돌을 길드로 요청한 경우우 짧게 보고
    if callType=="mykey" and (channel=="GUILD") then
        forceToShort=1
    end 
    
    --!돌이고 레벨을 지정하지 않았으며 길드가 아닌 곳에서 요청했는데 키가 하나도 없을 경우
    if callType=="all" and (channel~="GUILD")  and (#chars==0) and (level==0) then
        local messageLines={}
        messageLines[1]="▶저는 현재 갖고 있는 돌이 하나도 없습니다!" 
        reportMessageLines(messageLines,channel,who,callType)
        return
    end  
    
    if level and level>0 then
        local findChars={}
        local num=1
        for i=1,#chars do    
            local p=chars[i][1]
            local c=SavedInstancesDB.Toons[p]
            local keyLevel=c.MythicKey.level 
            --범위검색
            if keyword=="이상"then
                if level<=keyLevel then
                    findChars[num]=chars[i]
                    num=num+1                
                end         
            elseif keyword=="이하"then
                if level>=keyLevel then
                    findChars[num]=chars[i]
                    num=num+1                
                end        
            elseif keyword=="초과"then
                if level<keyLevel then
                    findChars[num]=chars[i]
                    num=num+1                
                end             
            elseif keyword=="미만"then
                if level>keyLevel then
                    findChars[num]=chars[i]
                    num=num+1                
                end 
            elseif level2 and level2>0 then
                if (level<=keyLevel) and (level2>=keyLevel) then
                    findChars[num]=chars[i]
                    num=num+1                
                end      
            else
                if level==keyLevel then
                    findChars[num]=chars[i]
                    num=num+1                
                end
            end            
        end
        --모든돌의 레벨검색을 했는데 채널이 길드가 아니면 풀리포트
        if channel~="GUILD"then
            forceToShort=0
        end        
        chars=findChars      
        
    end
    
    
    if forceToShort==1 then        
        doShortReport(chars,channel,who,callType)  
    else
        doFullReport(chars,channel,who,callType) 
    end    
end


--돌이 있으나 주차 못한 캐릭 보고하기
function findCharNeedParking(channel,who,callType)
    local chars=GetHaveKeyChar()
    
    if channel==nil then channel="print" end   
    
    local findChars={}
    local parknum=1
    local bestnum=1
    local bestLevels={}
    local lowestLevel=0
    local highstLevel=0
    
    if chars~=nil then       
        
        for i=1,#chars do    
            local p=chars[i][1]
            local c=SavedInstancesDB.Toons[p]
            local best=c.MythicKeyBest.level
            if (best==nil) or (best==0) then
                findChars[parknum]=chars[i]                
                parknum=parknum+1
            else
                bestLevels[bestnum]=best
                bestnum=bestnum+1
            end
        end
        
        --주차를 하나라도 했으면
        if bestnum>1 then
            table.sort(bestLevels)
            lowestLevel=bestLevels[1]
            highstLevel=bestLevels[#bestLevels]         
            
        end        
    end   
    
    --주차안한 캐릭이 없으면 보고서 없이 한줄 출력으로 마무리
    if parknum==1 then
        
        --!주차를 내가 보낸 경우 리턴
        if (channel=="WHISPER_OUT") then return end
        
        local messageLines={}
        local message=""
        if (chars~=nil) and (#chars>0) then            
            message="▶저는 이번주 주차 다했어요! ("..lowestLevel.."-"..highstLevel.."단)" 
        else
            message="▶저는 주차는 고사하고 현재 갖고 있는 돌이 하나도 없습니다!"             
        end    
        
        messageLines[1]=message
        reportMessageLines(messageLines,channel,who,callType)       
        
        return
    end       
    
    --!주차를 길드엔 짧게 보고
    if channel=="GUILD" then                
        doShortReport(findChars,channel,who,callType)                  
    else                
        doFullReport(findChars,channel,who,callType)            
    end            
    
end


--원하는 던전 돌 보고하기
function findCharDungeon(keyword,channel,who,callType,level)
    local level=tonumber(level)
    local chars=GetHaveKeyChar() 
    
    local keyword=getFullDungeonName(keyword) 
    
    local findChars={}   
    local num=1        
    
    if chars~=nil then         
        
        for i=1,#chars do    
            local p=chars[i][1]
            local c=SavedInstancesDB.Toons[p]
            local mapName=c.MythicKey.name
            if mapName==keyword then
                findChars[num]=chars[i]
                num=num+1
            end
        end    
    end  
    
    if level and level>0 then
        local findChars2={}
        local num=1
        for i=1,#findChars do    
            local p=findChars[i][1]
            local c=SavedInstancesDB.Toons[p]
            local keyLevel=c.MythicKey.level            
            if level==keyLevel then
                findChars2[num]=findChars[i]
                num=num+1                
            end            
        end             
        findChars=findChars2
    end
    
    doFullReport(findChars,channel,who,callType)  
    
end

--원하는 직업 돌 보고하기
function findCharClass(class,channel,who,callType)
    
    local chars=GetHaveKeyChar() 
    
    local findChars={}
    local num=1    
    
    if chars~=nil then   
        
        for i=1,#chars do
            if chars[i][2]==class then
                findChars[num]=chars[i]
                num=num+1
            end        
        end
    end        
    
    doFullReport(findChars,channel,who,callType)     
    
end

--원하는 특징을 가진 돌 보고하기
function findCharSpell(class,channel,who,callType)
    
    local chars=GetHaveKeyChar() 
    
    local findChars={}
    local num=1
    
    local classTable={}
    local hasSpellLink=0
    local doFullGuildReport=0
    if class=="웅심" then
        classTable=hasteClass
        hasSpellLink=1
        doFullGuildReport=1
    elseif class=="전부" then
        classTable=resurrectClass
        hasSpellLink=1
        doFullGuildReport=1
    elseif class=="천" then
        classTable=clothClass
    elseif class=="가죽" then
        classTable=leatherClass
    elseif class=="사슬" then
        classTable=mailClass
    elseif class=="판금" then
        classTable=plateClass
    elseif class=="방패" then
        classTable=shieldClass
    elseif class=="독" then        
        classTable=poisonClass
        hasSpellLink=1
    elseif class=="질병" then
        classTable=diseaseClass
        hasSpellLink=1
    elseif class=="저주" then
        classTable=curseClass
        hasSpellLink=1
    end
    
    if chars~=nil then   
        
        for i=1,#chars do
            local yourClass=chars[i][2]
            local thisCharHaveTheSpell=0
            if hasSpellLink==1 then
                for j=1,#classTable do
                    if yourClass==classTable[j][1] then
                        thisCharHaveTheSpell=1
                        chars[i][3]=classTable[j][2]
                    end
                end
            else
                for j=1,#classTable do
                    if yourClass==classTable[j] then
                        thisCharHaveTheSpell=1                    
                    end
                end
            end
            
            if thisCharHaveTheSpell==1 then
                findChars[num]=chars[i]
                num=num+1 
            end        
        end
    end       
    
    --웅심,전부는 채널에 상관없이 풀리포트
    if doFullGuildReport==1 then        
        doFullReport(findChars,channel,who,callType)  
    else
        --나머지는 길드엔 숏, 나머진 풀 리포트
        if channel=="GUILD"  then
            doShortReport(findChars,channel,who,callType)  
        else
            doFullReport(findChars,channel,who,callType)     
        end       
    end    
end

function doCheckVersion(channel,who,callType)
    
    local messageLines={}   
    messageLines[1]="▶[쐐기돌 보고서] Ver."..version.." (Update: "..lastUpdate..")"    
    
    reportMessageLines(messageLines,channel,who,callType)   
end


function doOnlyAffixReport(keyword,channel,who,callType)  
    
    local week=keyword
    local messageLines={}       
    local weekTitle=""
    
    if (week==0)then   
        weekTitle="이번주"
    elseif (week==1)then
        weekTitle="다음주" 
    elseif (week==-1)then 
        weekTitle="지난주"
    elseif (week<-1)then 
        weekTitle=week.."주전"
    elseif (week>1)then 
        weekTitle=week.."주뒤"        
    end     
    
    messageLines[1]="▶"..weekTitle.." 속성: "..GetAnyWeeksAffix(week) 
    
    reportMessageLines(messageLines,channel,who,callType)    
end




function doShortReport(chars,channel,who,callType)
    local messageLines={} 
    
    if chars~=nil then
        
        local charName,class,c=nil,nil,nil
        
        --중복직업 체크              
        local yourClass={}   
        
        for i=1,#chars do
            charName=chars[i][1]            
            class=chars[i][2] 
            yourClass[class]=(yourClass[class] or 0)+1             
        end
        local sameClass={}        
        
        for i=1,#chars do             
            charName=chars[i][1]     
            class=chars[i][2]              
            c=SavedInstancesDB.Toons[charName]           
            
            local keylink=c.MythicKey.link
            local keyName=c.MythicKey.name
            local level=c.MythicKey.level
            local best=c.MythicKeyBest.level            
            local online=""
            local classStatus=""
            
            local cutName=gsub(charName, "%s%-.+","")
            local shortName=strsub(cutName,1,9)
            
            
            if yourClass[class] and yourClass[class]>1 then
                sameClass[class]=(sameClass[class] or 0)+1                
                classStatus=class..sameClass[class]..":"..cutName                
            else                
                classStatus=class                
            end
            if charName==MY_NAME_IN_ADDON then
                online="◀접속중"
            end            
            
            --던전 이름 줄이기기
            keyName=getShortDungeonName(keyName)            
            
            local havekey,parking, parkingstar="","",""  
            if best and best ~=0 then                
                parkingstar=","..best             
                
            else 
                if callType=="parking" then
                    parkingstar=",X"                    
                else  
                    parkingstar=""            
                end       
            end            
            
            if keylink~=nil then
                havekey=keyName..level
            else
                havekey="돌 없음"
            end
            local message=""            
            
            if callType=="parking" then                 
                message=skull[class]..class.."("..havekey..parkingstar..")"..online
            elseif callType=="all" then
                message=skull[class]..havekey.."("..classStatus..")"
            elseif chars[i][3] and callType=="spell"then
                message=skull[class]..class.."("..havekey..")"..chars[i][3]..online
            elseif chars[i][3] and callType=="item"then
                message=skull[class]..havekey.."("..chars[i][3]..")"
            else
                message=skull[class]..havekey.."("..classStatus..")"..online
            end
            
            messageLines[i]=message 
        end        
        -- 한줄로 줄이기
        local oneLineMessage=""        
        for i=1,#messageLines do
            local space=""
            if i<#messageLines then
                space=" "                
            end
            oneLineMessage=oneLineMessage..messageLines[i]..space
        end
        messageLines={}
        messageLines[1]=oneLineMessage
    end    
    
    reportMessageLines(messageLines,channel,who,callType)       
end



--자세한 보고서 작성 및 출력
function doFullReport(chars,channel,who,callType)      
    
    local messageLines={} 
    
    if chars~=nil then        
        
        local charName,class,c=nil,nil,nil
        local forceprint=0 
        
        if (channel=="print") and (who==MY_NAME_IN_GAME) then 
            forceprint=1           
        end
        
        --중복직업 체크      
        local yourClass={}   
        
        for i=1,#chars do
            charName=chars[i][1]            
            class=chars[i][2] 
            yourClass[class]=(yourClass[class] or 0)+1             
        end
        local sameClass={}
        
        for i=1,#chars do             
            charName=chars[i][1]     
            class=chars[i][2]              
            c=SavedInstancesDB.Toons[charName]           
            
            local keylink=c.MythicKey.link
            local best=c.MythicKeyBest.level            
            
            local online=""
            
            local classStatus=""
            local headStar=""
            if charName==MY_NAME_IN_ADDON then
                online="◀접속중"
            end
            
            --
            local cutName=gsub(charName, "%s%-.+","")
            local shortName=strsub(cutName,1,9)            
            
            --같은 직업이 있을경우 뒤에 이름 붙이기
            if yourClass[class] and yourClass[class]>1 then
                sameClass[class]=(sameClass[class] or 0)+1
                classStatus=class..sameClass[class].."("..cutName..")"
            else
                if (callType=="parking") then  
                    classStatus=class.."("..shortName..")"
                elseif (callType=="dungeon")then
                    classStatus=class.."("..cutName..")"
                else
                    classStatus=class.."("..shortName..")"                    
                end                  
            end            
            
            
            local havekey,parking, parkingstar="","",""       
            if keylink~=nil then
                havekey=keylink
            else
                havekey="[쐐기돌 없음]"
            end
            if best and best ~=0 then
                parking=","..best
                parkingstar="▶"
            else
                parking=",X)"
                parkingstar="▷"            
            end
            if forceprint==1 then
                channel="print"
                headStar=parkingstar
            else
                headStar=skull[class]                
            end 
            --local extra=""
            local message=""
            if callType=="spell" and chars[i][3] then
                message=headStar..classStatus..chars[i][3]..": "..havekey..online
            elseif callType=="item" and chars[i][3] then
                message=headStar..classStatus..": "..havekey..chars[i][3] 
            else
                message=headStar..class.."("..shortName..parking..")"..": "..havekey..online
            end
            
            messageLines[i]=message 
        end
    end      
    
    --메세지 출력
    reportMessageLines(messageLines,channel,who,callType)    
end

function doWarningReport(channel,who,callType) 
    local messageLines={}
    if warning<=#warnMessage then
        messageLines[#messageLines+1]=warnMessage[warning]
        warning=warning+1
        channel="print"
    else return end  
    reportMessageLines(messageLines,channel,who,callType)
end


--메세지 출력
function reportMessageLines(messageLines,channel,who,callType)       
    if channel==nil then channel="print" end
    
    --최종적으로 귓말채널 반환
    if (channel=="WHISPER_IN") or (channel=="WHISPER_OUT")  then
        channel="WHISPER"
    end        
    
    for i=1,#messageLines do 
        if channel=="print"then
            C_Timer.After(0.2*(i-1), function()
                    if messageLines[i]~="" then
                        print(messageLines[i])
                    end
            end)  
        else
            C_Timer.After(0.2*(i-1), function()        
                    SendChatMessage(messageLines[i], channel,nil,who) 
            end)   
        end 
    end 
end




