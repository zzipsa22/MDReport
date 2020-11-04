MDR={}
MDR["version"]="@project-version@"
MDR["lastUpdate"]="@project-date-iso@"
MDR["guide"]=0
local meGame=UnitName("player").."-"..GetRealmName()    
local meAddon=UnitName("player").." - "..GetRealmName()  
local krClass,className=UnitClass("player")
local who,channel,level,level2,callTypeT
local comb,onlyOnline,onlyMe,onlyYou,CharName
local callType,callTypeB,keyword,extraKeyword={},{},{},{}
local SCL=50 -- 현 확팩 만렙

local DIL={ --단수별 허용레벨 / 드랍템 레벨
    [2]=30,--435,
    [3]=30,--435,
    [4]=40,--440,
    [5]=45,--445,
    [6]=50,--445,
    [7]=55,--450,
    [8]=60,--455,
    [9]=65,--455,
    [10]=70,--455,
    [11]=75,--460,
    [12]=80,--460,
    [13]=85,--460,
    [14]=90,--465,
    [15]=95,--465,
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
        "데스윙", -- [4]
        "알렉스트라자", -- [5]
    }, -- [1]
    {
        "가로나", -- [1]
        "굴단", -- [2]
        "줄진", -- [3]        
        "노르간논", -- [4]
        "달라란", -- [5]
        "말퓨리온", -- [6]
        "세나리우스", -- [7]
        "헬스크림",-- [8]
        "하이잘",-- [9]
    }, -- [2]
    {
        "불타는 군단", -- [1]
        "스톰레이지", -- [2]
        "듀로탄",-- [3]
    }, -- [3]
    
    ["렉사르"] = 1,
    ["와일드해머"] = 1,
    ["데스윙"] = 1,
    ["윈드러너"] = 1,
    ["알렉스트라자"] = 1,    
    
    ["말퓨리온"] = 2,
    ["달라란"] = 2,
    ["굴단"] = 2,
    ["줄진"] = 2,
    ["하이잘"] = 2,    
    ["헬스크림"] = 2,
    ["가로나"] = 2,
    ["노르간논"] = 2,
    ["세나리우스"] = 2,
    
    ["듀로탄"] = 1,
    ["불타는 군단"] = 3,
    ["스톰레이지"] = 3,
    
    ["아즈샤라"] = 4,
    
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
    
    callType,callTypeB,keyword,extraKeyword={},{},{},{}
    
    if VALUES~=nil then
        who=VALUES["who"]
        channel=VALUES["channel"]
        callTypeT=VALUES["callTypeT"]
        level=VALUES["level"]
        level2=VALUES["level2"] 
        onlyMe=VALUES["onlyMe"]
        onlyYou=VALUES["onlyYou"]
        for i=1,#callTypeT do
            callTypeB[i]=callTypeT[i][1]
            --print(i..":"..callTypeT[i][1])
            callType[callTypeT[i][1]]=1
            keyword[callTypeT[i][1]]=callTypeT[i][2]
            extraKeyword[callTypeT[i][1]]=callTypeT[i][3]            
        end   
        CharName=VALUES["CharName"]               
        
    end 
    -- "내"를 붙인 명령어를 다른사람이 입력했으면 리턴
    if onlyMe==1 and who~=meGame then
        return
    end
    
    -- 찾는 사람을 지정한 경우
    if onlyYou then
        if strlen(onlyYou)<4 then
            if who==meGame then    
                print("▶"..MDRcolor(onlyYou,-2)..": 입력하신 문자열 길이가 너무 짧습니다. 찾고자 하는 대상의 이름을 좀 더 길게 입력해주세요. (한글 |cFFFFF5692|r글자 이상, 영문 |cFFFFF5694|r자 이상)")
            end            
        return end  --검색어가 짧으면 무시
        
        --지정한 사람이 내가 아니면 리턴
        if not checkCallMe(onlyYou) then return end 
    end    
    
    if CharName then
        if strlen(CharName)<4 then
            if who==meGame then    
                print("▶"..MDRcolor(CharName,-2)..": 입력하신 문자열 길이가 너무 짧습니다. 찾고자 하는 대상의 이름을 좀 더 길게 입력해주세요. (한글 |cFFFFF5692|r글자 이상, 영문 |cFFFFF5694|r자 이상)")
            end            
        return end  --검색어가 짧으면 무시 
    end
    
    
    --[[
    if  onlyYou  then        
        print("찾는사람:"..onlyYou)
    end    
    ]]
    if callType["levelrange"]==1 and level2==nil then
        VALUES["level2"]=tonumber(keyword["levelrange"])        
    end    
    
    --범위지정인데 범위값이 없으면 리턴
    if callType["levelrange"]==1  and level==nil then
        return
    end  
    
    --내가 아닌 사람이 !속성을 요청하는 경우 리턴
    if who~=meGame and callType["affix"]==1 then
        return        
    end   
    
    --버전요청을 한 사람이 나일 경우 리턴
    if callType["forceversion"]==1 and who==meGame then
        return
    end  
    
    --버전체크를 한 사람이 내가 아닐 경우 리턴
    if callType["version"]==1  and who~=meGame then
        return
    end      
    
    --명령어가 !내돌or !지금내돌 인데 내가 보낸게 아니면 리턴
    if (callType["mykey"]==1 or callType["currentmykey"]==1) and who~=meGame and channel~="WHISPER_OUT" then 
        return 
    end       
    
    --내가 보낸 귓말이고, 나한테 보냈거나 !내돌/!지금내돌을 요청한게 아니면 리턴
    if (channel=="WHISPER_OUT") and ((who==meGame) or (callType["mykey"]~=1 or callType["currentmykey"]~=1) )  then
        return       
    end        
    
    --채널이 없으면 프린트로 변경
    if channel==nil then channel="print" end  
    
    --나에게서 귓말이 들어오는 경우 프린트로 변경
    if (channel=="WHISPER_IN") and who==meGame then
        channel="print"
    end       
    
    --버전체크 채널 강제 조정
    if callType["version"]==1 then
        channel="print"
    elseif callType["forceversion"]==1 then
        channel="WHISPER"        
    end 
    
    --조절값 입력
    VALUES["channel"]=channel    
    
    if callTypeT[2] then --명령어가 2중이면   
        --직업과 조합해서 검색시
        if callType["class"]==1 and (callType["item"]==1 or  callType["category"]==1  or callType["specificitem"]==1  or  callType["dungeon"]==1) then
            
            if keyword["class"]=="사제" or keyword["class"]=="흑마" or keyword["class"]=="법사" or keyword["class"]=="악사" then
                
                VALUES["comb"]="Class_Something" 
                
                --print("class_item")
                ---callType="spec"
                --VALUES["callTypeT"][1]=getCallTypeTable(classInfo[keyword["class"]][3])
            else                
                if who==meGame then                    
                    
                    local neun="는"
                    if keyword["class"]=="도적" or keyword["class"]=="냥꾼"  or class=="악사" then
                        neun="은"
                    end                       
                    print("▶"..MDRcolor(keyword["class"])..neun.." "..MDRcolor("전문화",-1).."에 따라 착용가능 아이템 범주가 달라 "..MDRcolor("전문화",-1).."로 검색해야만합니다. (|cFF33FF99ex|r.!"..MDRcolor(keyword["class"],3).."!무기 or !"..MDRcolor(keyword["class"],4).."!한손)")
                    
                end
                return
            end
        end        
        
        --전문화+무기
        if (callType["spec"]==1 and callType["item"]==1)then            
            VALUES["comb"]="Spec_Item" 
            
        elseif callType["trinket"]==1 and (callType["role"]==1 or callType["stat"]==1)then
            if keyword["role"]=="힐러"then           
                print("공용,힐러용 다 보여줌")
                
            elseif keyword["role"]=="탱커" then                
                if extraKeyword["role"]=="힘/민첩" and not keyword["stat"]  then
                    print("탱전용만 보여줌,힘/민과 같이검색하세요")     
                elseif callType["stat"]==1 or extraKeyword["role"]~="힘/민첩" then 
                    print((keyword["stat"] or extraKeyword["role"]).." 탱커 장신구 보여줌")                  
                end              
                
            elseif not callType["stat"] then            
                print("스탯을 지정해야함") 
                return
                
            elseif not callType["role"] then              
                print(keyword["stat"].." 딜러로 설정함") 
            end
            --print("검색 조건 충분")
            VALUES["comb"]="Trinket" 
            
            --던전+스펙
        elseif (callType["spec"]==1 and callType["dungeon"]==1) then  
            VALUES["comb"]="Spec_Dungeon"    
            
            --직업+스탯            
        elseif (callType["class"]==1 and callType["stat"]==1) then  
            local class,stat=keyword["class"],keyword["stat"]            
            if checkSpecCanUseStat(class,stat) then
                if class=="전사" or (class=="기사" and stat=="힘")  or class=="도적" or class=="냥꾼" or class=="죽기" then
                    if who==meGame then                    
                        
                        local neun="는"
                        if class=="도적" or class=="냥꾼" then
                            neun="은"
                        end
                        local eul="을"                        
                        print("▶"..MDRcolor(class)..neun.." "..MDRcolor("전문화",-1).."에 따라 착용할 수 있는 아이템이 상이해 |cFFFFF569"..stat.." 능력치|r와 함께 검색할 수 없습니다. "..MDRcolor("전문화",-1).."를 지정해서 검색해보세요.")
                        
                    end  
                    return
                else 
                    VALUES["comb"]="Class_Stat"
                end                
            else
                if who==meGame then                    
                    
                    local neun="는"
                    if class=="도적" or class=="냥꾼" or class=="악사" then
                        neun="은"
                    end
                    local eul="을"                        
                    print("▶"..MDRcolor(class)..neun.." |cFFFFF569"..keyword["stat"].."|r 아이템을 사용할 수 없습니다. 다른 |cFFFFF569능력치|r로 다시 시도해보세요.")
                    
                end                
                return 
            end
            
            --전문화+스탯
        elseif (callType["spec"]==1 and callType["stat"]==1) then  
            local spec,stat,class=keyword["spec"],keyword["stat"],callTypeT[1][4]
            if checkSpecCanUseStat(spec,stat) then
                VALUES["comb"]="Spec_Stat"   
            else
                if who==meGame then                    
                    
                    local neun="는"
                    if class=="도적" or class=="냥꾼" or class=="악사" then
                        neun="은"
                    end
                    local eul="을"                        
                    print("▶"..MDRcolor(spec,0).." "..MDRcolor(class)..neun.." |cFFFFF569"..keyword["stat"].."|r 아이템을 사용할 수 없습니다. 다른 |cFFFFF569능력치|r로 다시 시도해보세요.")
                    
                end                
                return 
            end
            --스탯+무기종류
        elseif (callType["stat"]==1 and callType["specificitem"]==1)then             
            VALUES["comb"]="Stat_Specificitem"  
            
            --전문화+무기종류
        elseif (callType["spec"]==1 and callType["specificitem"]==1)then 
            local spec,class=keyword["spec"], callTypeT[1][4]
            if checkSpecCanUseItem(spec,keyword["specificitem"]) then            
                VALUES["comb"]="Spec_Specificitem" 
            else 
                if who==meGame then                    
                    
                    local neun="는"
                    if class=="도적" or class=="냥꾼" or class=="악사" then
                        neun="은"
                    end
                    local eul="를"
                    if keyword["specificitem"]=="장창" or keyword["specificitem"]=="단검" or keyword["specificitem"]=="한손도검" or keyword["specificitem"]=="양손도검" or keyword["specificitem"]=="마법봉" or keyword["specificitem"]=="석궁"  or keyword["specificitem"]=="활"  or keyword["specificitem"]=="총"  then
                        eul="을"
                    end   
                    print("▶"..MDRcolor(spec,10)..neun.." "..keyword["specificitem"]..eul.." 사용할 수 없습니다. 다른 아이템으로 다시 시도해보세요.")
                    
                end                
                return 
            end            
            --스탯+무기범주
        elseif (callType["stat"]==1 and callType["category"]==1)then             
            VALUES["comb"]="Stat_Category"  
            --전문화+범주
        elseif (callType["spec"]==1 and callType["category"]==1)then             
            VALUES["comb"]="Spec_Category"            
            --스탯+무기
        elseif (callType["stat"]==1 and callType["item"]==1) then
            if who==meGame then
                
                print("▶|cFFFFF569능력치|r와"..'"'.."무기"..'"'.."는 함께 검색할 수 없습니다. 무기 유형(단검,지팡이)이나 종류(양손,한손)를 지정해주세요. (|cFF33FF99ex|r. !|cFFFFF569힘|r!양손 or !|cFFFFF569지능|r!단검)")
                
            end
            return           
        end
        if VALUES["comb"] then
            findCharAllItem(VALUES)
        end        
        return
        
    else --!명령어가 단일일 경우
        if callType["all"]==1 or 
        callType["mykey"]==1 or 
        callType["levelrange"]==1 or 
        callType["dungeon"]==1 or 
        callType["class"]==1 or 
        callType["currentmykey"]==1 or 
        callType["currentall"]==1 or         
        callType["charname"]==1 then            
            
            findCharAllKey(VALUES)            
        elseif callType["parking"]==1 then        
            findCharNeedParking(channel,who,"parking",keyword["parking"],level)             
        elseif callType["spell"]==1 then        
            findCharSpell(keyword["spell"],channel,who,"spell")     
        elseif callType["version"]==1 or callType["forceversion"]==1 then        
            doCheckVersion(channel,who,callType)    
        elseif callType["affix"]==1 then        
            doOnlyAffixReport(keyword["affix"],channel,who,"affix")  
        elseif callType["specificitem"]==1 then 
            --!주스탯이 고정인 무기종류는 검색통과
            if keyword["specificitem"]=="보조" or keyword["specificitem"]=="마법봉" or keyword["specificitem"]=="석궁" or keyword["specificitem"]=="활" or keyword["specificitem"]=="총" or keyword["specificitem"]=="전투검" or keyword["specificitem"]=="방패" then
                VALUES["comb"]="Spec_Specificitem"       
                findCharAllItem(VALUES)                
            else
                if who==meGame then
                    
                    local neun="는"
                    if keyword["specificitem"]=="장창" or keyword["specificitem"]=="단검" or keyword["specificitem"]=="한손도검" or keyword["specificitem"]=="양손도검" then
                        neun="은"
                    end                        
                    print("▶!"..MDRcolor(keyword["specificitem"],-2)..neun.." 단독으로 검색할 수 없습니다. "..MDRcolor("전문화",-1).."나 |cFFFFF569능력치|r를 함께 입력해주세요. (|cFF33FF99ex|r. !|cffC79C6E분노|r!"..MDRcolor(keyword["specificitem"],-2)..", !|cFFFFF569힘|r!"..MDRcolor(keyword["specificitem"],-2)..")")                        
                    
                end     
            end            
            --!전문화로만 검색시 !무기검색으로 유도
        elseif callType["spec"]==1 and #callTypeB==1 then
            if who==meGame then
                
                local class=getCallTypeTable(keyword["spec"])[4] or getCallTypeTable(keyword["spec"])[2] 
                
                local neun,ga,ro="는","가","로"                   
                if class=="도적" or class=="냥꾼" then
                    neun,ga,ro="은","이","으로"
                elseif  class=="악사" then
                    neun,ga,ro="은","이","로"                        
                end                         
                
                print("▶"..MDRcolor(class,0,"전문화").."를 단독으로 입력한 경우 해당 전문화가 착용가능한 모든 무기로 던전을 검색합니다. (=!"..MDRcolor(class,0,keyword["spec"]).."!무기) "..MDRcolor(class)..ga.." 소지한 돌이 알고 싶을 경우 !"..MDRcolor(class,2)..ro.." 검색하거나, 특정 무기를 지정하고 싶을 경우 "..MDRcolor(class,0,"전문화").."와 무기종류,무기범주를 함께 검색해보세요.(|cFF33FF99ex|r.!"..MDRcolor(class,3).."!양손 or !"..MDRcolor(class,4).."!장착)")
                
            end
            VALUES["comb"]="Spec_Item"
            findCharAllItem(VALUES)
            
            --!무기or 장신구만 단독검색시
        elseif (callType["item"]==1 or callType["trinket"]==1)and #callTypeB==1 then
            if who==meGame then
                
                print("▶|cFFaaaaaa"..(keyword["trinket"] or keyword["item"] ).."|r는 단독으로 검색할 수 없습니다. 특성을 지정해주세요 (|cFF33FF99ex|r. !"..MDRcolor(krClass,3).."|cFFaaaaaa!"..(keyword["trinket"] or keyword["item"] ).."|r)")
                
            end  
            
            --스탯만 단독검색시            
        elseif callType["stat"]==1 and #callTypeB==1 then
            if who==meGame then
                
                print("▶|cFFFFF569능력치|r는 단독으로 검색할 수 없습니다. 무기종류를 지정해주세요 (|cFF33FF99ex|r. !|cFFFFF569"..keyword["stat"].."|r!지팡이)")
                
            end   
            
            --스탯지정없이 무기범주만 단독검색시
        elseif callType["category"]==1 and #callTypeB==1 then
            if who==meGame then
                
                print("▶"..MDRcolor("무기범주",-1).."(한손,양손,근접,원거리)는 단독으로 검색할 수 없습니다. "..MDRcolor("!한손도검",-2).." "..MDRcolor("!양손둔기",-2).." 처럼 무기의 종류를 지정하거나 |cFFFFF569!힘|r |cFFFFF569!지능|r 등의 능력치와 함께 검색해주세요 (|cFF33FF99ex|r. |cFFFFF569!힘|r"..MDRcolor("!"..keyword["category"],-1)..", |cFFFFF569!민첩|r"..MDRcolor("!한손도검",-2)..")")
                
            end     
        else return end     
    end    
end

--찾는사람 체크
function checkCallMe(onlyYou)    
    if not SavedInstancesDB or not onlyYou then  return end   
    local t=SavedInstancesDB.Toons
    local faction=UnitFactionGroup("player")
    local realm=gsub(GetRealmName()," ","")
    local findYou=false
    for k,v in pairs(t) do
        local charRealm=MDRsplit(gsub(k," ",""),"-")[2]
        local name=gsub(k, "%s%-.+","") 
        if strfind(name,onlyYou) and t[k].Faction==faction and RealmMap[realm]==RealmMap[charRealm] then
            findYou=true            
        end
    end
    return findYou
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
                chars[num]["cutName"]=gsub(k, "%s%-.+","")
                chars[num]["shortClass"]=getCallTypeTable(t[k].Class)[2]
                chars[num]["keyLink"]=t[k].MythicKey.link
                chars[num]["best"]=t[k].MythicKeyBest.level
                chars[num]["keyLevel"]=t[k].MythicKey.level   
                chars[num]["keyName"]=t[k].MythicKey.name            
                chars[num]["itemLevel"]=t[k].IL          
                num=num+1                
            elseif (type~="haveKeyOnly" and ((t[k].Level==SCL and (t[k].IL>=minLevel or type=="hard")) or type=="superhard")) then                           
                --허용가능레벨보다 높거나 force 인 경우 돌 없어도 포함
                chars[num]={}
                chars[num]["fullName"]=k
                chars[num]["cutName"]=gsub(k, "%s%-.+","")                
                chars[num]["shortClass"]=getCallTypeTable(t[k].Class)[2]
                if t[k].Level==SCL then
                    chars[num]["itemLevel"]=t[k].IL
                else
                    chars[num]["charLevel"]=t[k].Level                
                end                
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
        
        callType=callTypeT[1][1]
        keyword=callTypeT[1][2]
        onlyOnline=VALUES["onlyOnline"]   
        CharName=VALUES["CharName"]
        
    end
    local type=nil
    
    if (CharName and CharName~="" ) then callType="charname" end   
    
    if callType=="class" then
        type="hard"
    elseif callType=="charname" then
        type="superhard"
    else type="haveKeyOnly"
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
    
    --캐릭터이름을 지정한 경우 필터링
    if CharName then
        chars=filterCharsByFilter(chars,"CharName",CharName,nil)
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
        f1=meAddon   
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
            elseif filter=="CharName" then
                target=string.gsub(chars[i]["fullName"], "(%a)([%w_']*)", MDRtitleLower)
                f1=string.gsub(f1, "(%a)([%w_']*)", MDRtitleLower)
            end
            if f1==target or (filter=="CharName" and strfind(target,f1)) then
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

