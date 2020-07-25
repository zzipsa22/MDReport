local searchingTip={0,0,0,0,0,0,0}
local howManyWarn=3
local warnMessage={
    [1]="▶ Saved Instances 애드온이 설치되어 있지 않아 쐐기돌 정보를 불러올 수 없습니다.",
    [2]="▶ 트위치나 인벤, 루리웹등에서 Saved Instances 를 다운받아 설치해주세요."    
}

local MY_NAME_IN_GAME=UnitName("player").."-"..GetRealmName()    
local MY_NAME_IN_ADDON=UnitName("player").." - "..GetRealmName()  

local who,channel,level,level2,callTypeT,callType2,comb,onlyOnline,onlyMe
local callType,keyword,extraKeyword
local callType2,keyword2,extraKeyword2
local SCL=120 -- 현 확팩 만렙렙

local DIL={ --단수별 허용레벨 / 드랍템 레벨
    [2]=80,--435,
    [3]=280,--435,
    [4]=375,--440,
    [5]=380,--445,
    [6]=385,--445,
    [7]=400,--450,
    [8]=405,--455,
    [9]=410,--455,
    [10]=425,--455,
    [11]=430,--460,
    [12]=435,--460,
    [13]=445,--460,
    [14]=450,--465,
    [15]=460,--465,
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

local RealmMap= {
    {
        "렉사르", -- [1]
        "와일드해머", -- [2]
        "윈드러너", -- [3]
    }, -- [1]
    {
        "데스윙", -- [1]
        "알렉스트라자", -- [2]
    }, -- [2]
    {
        "가로나", -- [1]
        "굴단", -- [2]
        "줄진", -- [3]
    }, -- [3]
    {
        "노르간논", -- [1]
        "달라란", -- [2]
        "말퓨리온", -- [3]
        "세나리우스", -- [4]
    }, -- [4]
    {
        "불타는 군단", -- [1]
        "스톰레이지", -- [2]        
    }, -- [5]
    ["렉사르"] = 1,
    ["와일드해머"] = 1,
    ["데스윙"] = 2,
    ["말퓨리온"] = 4,
    ["달라란"] = 4,
    ["굴단"] = 3,
    ["줄진"] = 3,
    ["윈드러너"] = 1,
    ["알렉스트라자"] = 2,
    ["가로나"] = 3,
    ["노르간논"] = 4,
    ["세나리우스"] = 4,
    ["불타는 군단"] = 5,
    ["스톰레이지"] = 5,
    ["아즈샤라"] = 6,
    ["하이잘"] = 7,
    ["듀로탄"] = 8,
    ["헬스크림"] = 9,
}

local clothClass={"법사","사제","흑마"}
local leatherClass={"드루","수도","도적","악사"}
local mailClass={"냥꾼","술사"}
local plateClass={"전사","죽기","기사"}
local shieldClass={"전사","기사","술사"}

function filterVALUES(VALUES) 
    
    --SavedInstance 체크
    if not SavedInstancesDB then
        doWarningReport(channel,who,"warning") 
        return
    end    
    
    if VALUES~=nil then
        who=VALUES["who"]
        channel=VALUES["channel"]
        callTypeT=VALUES["callTypeT"]
        callTypeT2=VALUES["callTypeT2"]
        level=VALUES["level"]
        level2=VALUES["level2"] 
        onlyMe=VALUES["onlyMe"]
        
        callType=callTypeT[1]
        keyword=callTypeT[2] 
        extraKeyword=callTypeT[3] 
        
        if callTypeT2 then
            callType2=callTypeT2[1]
            keyword2=callTypeT2[2] 
            extraKeyword2=callTypeT2[3]            
        end         
    end 
    -- "내"를 붙인 명령어를 다른사람이 입력했으면 리턴
    if onlyMe==1 and who~=MY_NAME_IN_GAME then
        return
    end
    
    if callType=="levelrange" and level2==nil then
        VALUES["level2"]=tonumber(keyword)
    end    
    
    --범위지정인데 범위값이 없으면 리턴
    if callType=="levelrange" and level==nil then
        return
    end  
    
    --내가 아닌 사람이 !속성을 요청하는 경우 리턴
    if who~=MY_NAME_IN_GAME and (callType=="affix")then
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
    
    --명령어가 !내돌or !지금내돌 인데 내가 보낸게 아니면 리턴
    if (callType=="mykey" or callType=="currentmykey") and who~=MY_NAME_IN_GAME and channel~="WHISPER_OUT" then 
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
    
    --조절값 입력
    VALUES["channel"]=channel    
    
    if callTypeT2 then --명령어가 2중이면             
        if (callType=="class" and callType2=="item") or (callType=="class" and callType2=="category")  or (callType=="class" and callType2=="specificitem")  then
            if keyword=="사제" or keyword=="흑마" or keyword=="법사" or keyword=="악사" then
                callType="spec"
            else
                if who==MY_NAME_IN_GAME then
                    if searchingTip[1]<=howManyWarn then
                        print("입력하신 직업은 전문화에 따라 착용가능한 아이템이 상이하여 전문화를 지정해야만 검색할 수 있습니다. (ex.!회복!한손 or !혈죽!무기)")
                        searchingTip[1]=searchingTip[1]+1
                    end
                end
                return
            end
        end                
        if (callType=="spec" and callType2=="item")then            
            VALUES["comb"]="Spec_Item"            
        elseif (callType=="stat" and callType2=="specificitem")then             
            VALUES["comb"]="Stat_Specificitem"            
        elseif (callType=="spec" and callType2=="specificitem")then            
            VALUES["comb"]="Spec_Specificitem"            
        elseif (callType=="stat" and callType2=="category")then             
            VALUES["comb"]="Stat_Category"                        
        elseif (callType=="spec" and callType2=="category")then             
            VALUES["comb"]="Spec_Category"            
        elseif (callType=="stat" and callType2=="item") then
            if who==MY_NAME_IN_GAME then
                if searchingTip[2]<=howManyWarn then
                    print("주능력치와"..'"'.."무기"..'"'.."는 함께 검색할 수 없습니다. 무기 유형(단검,지팡이)이나 종류(양손,한손)를 지정해주세요. (ex. !힘!양손 or !지능!단검)")
                    searchingTip[2]=searchingTip[2]+1
                end
            end
        else return            
        end
        findCharAllItem(VALUES)
        return
        
    else --!명령어가 단일일 경우
        if callType=="all" or callType=="mykey" or callType=="levelrange" or callType=="dungeon" or callType=="class" or callType=="currentmykey" or callType=="currentall" then 
            findCharAllKey(VALUES)            
        elseif callType=="parking" then        
            findCharNeedParking(channel,who,callType,keyword,level)             
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
                if searchingTip[6]<=howManyWarn then
                    print("특성을 단독으로 입력하여 착용가능한 모든 무기로 던전을 검색합니다. 특정 직업의 돌이 알고 싶을 경우 !직업(ex.!드루 or !사제)으로 검색하거나, 특정 무기를 지정하고 싶을 경우 무기종류,무기유형과 함께 검색해보세요.(ex.!회복!양손 or !풍운!장착)")
                    searchingTip[6]=searchingTip[6]+1
                end
            end
            VALUES["comb"]="Spec_Item"
            findCharAllItem(VALUES)
        elseif callType=="item" and callType2==nil then
            if who==MY_NAME_IN_GAME then
                if searchingTip[3]<=howManyWarn then
                    print("!무기는 단독으로 검색할 수 없습니다. 특성을 지정해주세요 (ex. !화염!무기)")
                    searchingTip[3]=searchingTip[3]+1
                end
            end  
        elseif callType=="stat" and callType2==nil then
            if who==MY_NAME_IN_GAME then
                if searchingTip[4]<=howManyWarn then
                    print("능력치는 단독으로 검색할 수 없습니다. 무기종류를 지정해주세요 (ex. !"..keyword.."!지팡이)")
                    searchingTip[4]=searchingTip[4]+1
                end
            end   
        elseif callType=="category" and callType2==nil then
            if who==MY_NAME_IN_GAME then
                if searchingTip[5]<=howManyWarn then
                    print("무기유형은 단독으로 검색할 수 없습니다. !한손도검 !양손둔기 처럼 무기의 종류를 지정하거나 !힘 !지능 등의 능력치와 함께 검색해주세요 (ex. !민첩!원거리장비: 총,활,석궁 검색)")
                    searchingTip[5]=searchingTip[5]+1
                end
            end     
        else return end     
    end    
end


function MDRspairs(t, order)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end
    
    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys 
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end
    
    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

--보유한 모든 돌 불러오기
function GetHaveKeyCharInfo(type,level)   
    if not SavedInstancesDB then  return end   
    if type=="hard" then level=2
    elseif type=="soft" then level=level-5
        if level<2 then level=2 end        
    elseif level==nil then level=15 end    
    local t=SavedInstancesDB.Toons
    local num=1
    local chars={}
    local faction=UnitFactionGroup("player")
    local realm=gsub(GetRealmName()," ","")
    local L=level
    if L>15 or L==nil then L=15;elseif L<2 then L=2;end
    local minLevel=DIL[L]  
    
    for k,v in pairs(t) do
        local charRealm=MDRsplit(gsub(k," ",""),"-")[2]
        if t[k].Faction==faction and RealmMap[realm]==RealmMap[charRealm] then
            if t[k].MythicKey.link then
                chars[num]={}
                chars[num]["fullName"]=k
                chars[num]["shortClass"]=getCallTypeTable(t[k].Class)[2]
                chars[num]["keyLink"]=t[k].MythicKey.link
                chars[num]["best"]=t[k].MythicKeyBest.level
                chars[num]["keyLevel"]=t[k].MythicKey.level   
                chars[num]["keyName"]=t[k].MythicKey.name            
                chars[num]["itemLevel"]=t[k].IL          
                num=num+1                
            elseif (t[k].Level==SCL and (t[k].IL>=minLevel or type=="hard")) then                 
                --허용가능레벨보다 높거나 force 인 경우 돌 없어도 포함
                chars[num]={}
                chars[num]["fullName"]=k
                chars[num]["shortClass"]=getCallTypeTable(t[k].Class)[2]
                chars[num]["itemLevel"]=t[k].IL
                chars[num]["keyLevel"]=0
                num=num+1
            end
        end        
    end
    local newChars={}
    local newChars2={}
    local charsNum=1
    for i=1,#chars do
        newChars[chars[i]]=chars[i]["keyLevel"]        
    end    
    for k,v in MDRspairs(newChars, function(t,a,b) return t[b] < t[a] end) do
        newChars2[charsNum]=k
        charsNum=charsNum+1
    end
    chars=newChars2
    return chars
end

--보유한 모든 돌 보고하기
function findCharAllKey(VALUES)    
    
    if VALUES~=nil then
        who=VALUES["who"]
        channel=VALUES["channel"]
        callTypeT=VALUES["callTypeT"]
        
        level=VALUES["level"]
        level2=VALUES["level2"]         
        
        callType=callTypeT[1]
        keyword=callTypeT[2]
        onlyOnline=VALUES["onlyOnline"]    
    end
    local type=nil
    if callType=="class" then
        type="hard"        
    end    
    local chars=GetHaveKeyCharInfo(type)    
    local forceToShort=0     
    
    if callType=="levelrange" then
        level2=keyword
    end    
    
    --!돌이나 !레벨범위를 길드혹은 파티로 요청한 경우 짧게 보고
    if (callType=="all"or callType=="levelrange") and ((channel=="GUILD") or (channel=="PARTY")) then
        forceToShort=1
    end 
    if callType=="currentall" or callType=="currentmykey" then
        onlyOnline=1
    end    
    
    --!내돌을 길드로 요청한 경우우 짧게 보고
    if callType=="mykey" and (channel=="GUILD") then
        forceToShort=1
    end 
    
    --!돌이고 레벨을 지정하지 않았으며 길드가 아닌 곳에서 요청했는데 키가 하나도 없을 경우
    if callType=="all" and (channel~="GUILD")  and (#chars==0) and (level==nil) then
        local messageLines={}
        messageLines[1]="▶저는 현재 갖고 있는 돌이 하나도 없습니다!" 
        reportMessageLines(messageLines,channel,who,callType)
        return
    end      
    
    -- "지금"이 붙은 경우 접속중인 캐릭터만 필터링
    if onlyOnline==1 then
        chars=filterCharsByFilter(chars,"name",nil,nil)
        --이캐릭 돌이 없으면 바로 보고하고 마무리, 길드면 생략
        if not chars and channel~="GUILD"then
            local messageLines={}
            messageLines[1]="▶이캐릭은 현재 갖고 있는 돌이 없습니다!" 
            reportMessageLines(messageLines,channel,who,callType)
            return
        end        
    end
    
    --던전이나 직업으로 필터링
    if callType=="dungeon" or callType=="class" then
        chars=filterCharsByFilter(chars,callType,keyword,nil)         
    end    
    
    --레벨을 지정한 경우 레벨로 한번더 필터링
    if level then 
        chars=filterCharsByFilter(chars,"level",level,level2)        
    end    
    
    if forceToShort==1 then        
        doShortReport(chars,channel,who,callType)  
    else
        doFullReport(chars,channel,who,callType) 
    end    
end

--돌이 있으나 주차 못한 캐릭 보고하기
function findCharNeedParking(channel,who,callType,keyword,level)
    if level==nil then level=15 end
    local chars=GetHaveKeyCharInfo(keyword,level)
    
    if channel==nil then channel="print" end   
    
    local findChars={}
    local parknum=1
    local bestnum=1
    local bestLevels={}
    local lowestLevel=0
    local highstLevel=0
    local parkingLevel=level--15단주차
    
    if chars~=nil then       
        
        for i=1,#chars do   
            local best=chars[i]["best"]
            if (best==nil) or (best<parkingLevel) then
                findChars[parknum]=chars[i]                
                parknum=parknum+1
            else
                bestLevels[bestnum]=best
                bestnum=bestnum+1
            end
        end
        
        --쐐기를 한번이라도 갔으면
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
            message="▶저는 이번주 주차 다했어요! ("..lowestLevel.."~"..highstLevel.."단)" 
        else
            message="▶저는 주차는 고사하고 현재 갖고 있는 돌이 하나도 없습니다!"             
        end    
        
        messageLines[1]=message
        reportMessageLines(messageLines,channel,who,callType)       
        
        return
    end       
    
    --!주차를 길드엔 짧게 보고
    if channel=="GUILD" or channel=="PARTY" then                
        doShortReport(findChars,channel,who,callType)                  
    else                
        doFullReport(findChars,channel,who,callType)            
    end            
    
end

--원하는 특징을 가진 돌 보고하기
function findCharSpell(class,channel,who,callType)
    
    local chars=GetHaveKeyCharInfo()
    
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
            local yourClass=chars[i]["shortClass"]
            local thisCharHaveTheSpell=0
            if hasSpellLink==1 then
                for j=1,#classTable do
                    if yourClass==classTable[j][1] then
                        thisCharHaveTheSpell=1
                        chars[i]["extraLink"]=classTable[j][2]
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
        if channel=="GUILD" or channel=="PARTY" then
            doShortReport(findChars,channel,who,callType)  
        else
            doFullReport(findChars,channel,who,callType)     
        end       
    end    
end

function filterCharsByFilter(chars,filter,f1,f2)
    if chars==nil then return end
    local findChars={}
    local num=1
    local target
    
    if filter=="level" then
        f1=tonumber(f1)
        f2=tonumber(f2)
        if f1 and f2 and f1>f2 then
            local big=f1; f1=f2;f2=big
        end        
    elseif filter=="dungeon" then
        f1=getFullDungeonName(f1) 
    elseif filter=="name" then
        f1=MY_NAME_IN_ADDON         
    end   
    
    for i=1,#chars do          
        if filter=="level"and f2~=nil  then            
            target=chars[i]["keyLevel"] or 0              
            if f1<=target and f2>=target then
                findChars[num]=chars[i]
                num=num+1                
            end             
        else 
            if filter=="level" then                
                target=chars[i]["keyLevel"]                  
            elseif filter=="class" then                
                target=chars[i]["shortClass"]   
            elseif filter=="dungeon" then
                target=chars[i]["keyName"]     
            elseif filter=="name" then
                target=chars[i]["fullName"]   
            end
            if f1==target then
                findChars[num]=chars[i]
                num=num+1                
            end
        end
    end 
    
    if #findChars>0 then
        return findChars
    else
        return nil
    end
end

function MDRsplit (inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

function MDRnumsplit(a)
    if a==nil then return end
    local FN,LN,SS,SE
    for i=1,string.len(a) do       
        if tonumber(string.sub(a,1,i))==nil then
            if i>1 then FN=tonumber(string.sub(a,1,i-1)) end
            SS=i; break
        end
    end
    for i=1,string.len(a) do
        if tonumber(string.sub(a,-i))==nil then
            if i>1 then LN=tonumber(string.sub(a,-i+1)) end 
            SE=-i; break
        end
    end       
    local str=string.sub(a,(SS or 0),(SE or 0))
    return FN,str,LN
end
