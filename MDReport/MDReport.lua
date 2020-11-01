local version="@project-version@"
local lastUpdate="@project-date-iso@"
local searchingTip={0,0,0,0,0,0,0,0,0,0,0,0,0}
local howManyWarn=10
MDRwarnMessage={
    [1]="▶[|cFF33FF99쐐기돌 보고서 "..version.."|r] Saved Instances 애드온이 설치되어 있지 않아 쐐기돌 정보를 불러올 수 없습니다.",
    [2]="▶[|cFF33FF99쐐기돌 보고서 "..version.."|r] 트위치나 인벤, 루리웹등에서 Saved Instances 를 다운받아 설치해주세요."    
}

local MY_NAME_IN_GAME=UnitName("player").."-"..GetRealmName()    
local MY_NAME_IN_ADDON=UnitName("player").." - "..GetRealmName()  

local who,channel,level,level2,callTypeT,callTypeT2,comb,onlyOnline,onlyMe,CharName
local callType,keyword,extraKeyword
local callType2,keyword2,extraKeyword2
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

local classInfo={
    ["도적"]={"도적","FFF569","암살","무법"},
    ["죽기"]={"죽음의 기사","C41F3B","혈기","부정"},    
    ["드루"]={"드루이드","FF7D0A","조화","회복"},
    ["전사"]={"전사","C79C6E","방어","분노"},
    ["기사"]={"성기사","F58CBA","징기","신기"},
    ["술사"]={"주술사","0070DE","고술","정술"},
    ["수도"]={"수도사","00FF96","풍운","운무"},
    ["냥꾼"]={"사냥꾼","A9D271","사격","생존"},
    ["사제"]={"사제","FFFFFF","암흑","수양"},
    ["흑마"]={"흑마법사","8787ED","고통","파괴"},
    ["법사"]={"마법사","40C7EB","화법","냉법"},
    ["악사"]={"악마 사냥꾼","A330C9","파멸","복수"}, 
    [""]={}
}

function MDRcolor(keyword,num,text)
    
    local color=classInfo[keyword][2]
    local class=classInfo[keyword][1]
    
    if not num or num==1 then
        return "|cff"..color..class.."|r"
    elseif num==-1 then
        return "|cff".."80e7EB"..text.."|r"        
    elseif num==-2 then
        return "|cff".."F5aCdA"..text.."|r"        
    elseif num==0 and text then
        return "|cff"..color..text.."|r"        
    else        
        return "|cff"..color..classInfo[keyword][num].."|r"
    end    
end


--명령어 입력시 실행할 함수
function MDRCommands(msg, editbox)   
    
    print("▶[|cFF33FF99쐐기돌 보고서 "..version.."|r] 기본 명령어 목록")
    print("  ▷이하 모든 명령어는 |cFF40ff40길드말|r과 |cFFaaaaff파티말|r, |cFFff80ff귓속말|r에 입력했을 때만 반응합니다.")    
    print("  ▷|cffC79C6E!돌|r : 소유한 모든 돌 정보를 검색. 이하 대부분의 명령어들은 '|cff0070DE내|r'와 함께 조합하면 나만 출력, '|cffF58CBA지금|r'과 함께 조합하면 현재 접속중인 캐릭터만 출력, |cffffff00숫자|r와 함께 검색하면 해당 범위의 돌만 출력합니다. |cFF33FF99ex)|r !|cffC79C6E돌|r !|cff0070DE내|r|cffC79C6E돌|r !|cffF58CBA지금|r|cffC79C6E돌|r !|cffC79C6E돌|r|cffffff0015~18|r !|cffC79C6E돌|r|cffffff0025+|r")
    print("  ▷|cff40C7EB!던전명|r : 던전 이름으로 검색. |cFF33FF99ex)|r !|cff40C7EB아탈|r !|cff40C7EB아탈|r|cffffff0018|r !|cffF58CBA지금|r|cff40C7EB아탈|r")
    print("  ▷|cffFF7D0A!직업명|r : 직업 이름으로 검색. |cFF33FF99ex)|r !|cffFF7D0A드루|r !|cffFF7D0A드루|r|cffffff0015-|r !|cff0070DE내|r|cffFF7D0A드루|r")
    print("  ▷|cff8787ED!주차|r : 주차정보 검색. 주차를 못했거나 최대 보상을 받을 수 있는 단수(격아4시즌 기준 15단) 미만으로 주차한 경우 해당 캐릭터의 정보를 출력합니다. 소지한 쐐기돌이 있을 경우 쐐기돌 정보를, 돌이 없으나 적절한 템렙을 갖춘 경우 템레벨을 출력합니다. |cFF33FF99ex)|r !|cff8787ED주차|r !|cff0070DE내|r|cff8787ED주차|r !|cff8787ED주차|r|cffffff0020|r : 특정 레벨을 지정할 경우(이 경우 20단) 해당 단수 이하 주차한 경우 검색결과에 포함")
    print("  ▷|cffA9D271!캐릭터이름|r : 캐릭터 이름으로 검색. 뒷글자는 생략가능하나 앞부분은 일치해야합니다. |cFF33FF99ex)|r 캐릭명이 '아무개' 일 경우 !|cffA9D271아무개|r,!|cffA9D271아무|r,!|cffA9D271아|r = |cFF40ff40가능|r, !|cffA9D271무개|r !|cffA9D271개|r 는 |cffC41F3B불가능|r.")
    print("  ▷|cffC41F3B!속성|r : 이번주 쐐기 속성을 출력. '다음주' '다다음주' 등과 조합해서 사용할 수 있습니다. |cFF33FF99ex)|r !|cffC41F3B속성|r !지난주|cffC41F3B속성|r !다다음주|cffC41F3B속성|r")
    print("  ▷!|cFF80e7EB전문화|r, !|cFFFFF569능력치|r와 !|cFFaaaaaa무기|r, !|cFFF5aCdA무기범주|r, !|cff8787ED무기종류|r 등을 조합하여 원하는 무기를 드랍하는 던전의 돌을 보유하고 있을 경우 불러올 수 있습니다. |cFF33FF99ex|r) !|cFF80e7EB회드|r!|cFFaaaaaa무기|r, !|cFFFFF569지능|r!|cff8787ED단검|r, !|cff8787ED방패|r, !|cFFFFF569민첩|r!|cFFF5aCdA근접|r, !|cFFFFF569힘|r!|cFFF5aCdA한손|r, !|cFF80e7EB고술|r!|cFFaaaaaa무기|r, !|cFF80e7EB양조|r!|cFFF5aCdA양손|r" )
    print("▶보다 자세한 사용법은 |cffffff00트위치|r나 |cffffff00Curse|r에서 |cFF33FF99MDReport|r 페이지에 방문하여 확인해보세요.")
    
end

--명령어 등록
SLASH_MDReport1, SLASH_MDReport2, SLASH_MDReport3 = '/mdr', '/Tho','/쐐'
SlashCmdList["MDReport"] = MDRCommands 


C_Timer.After(10, function()        
        local x = GetLocale()
        if x ~= "koKR" then -- XXX temp, Options/Locales needs updated
            print("|cFF33FF99MDReport|r can't support your locale: ", x, ". Sorry for your inconvenience.")
        else
            if not  SavedInstancesDB then
                doWarningReport(channel,who,"warning") 
                return
            end 
            print("▶[|cFF33FF99쐐기돌 보고서 "..version.."|r]: 이제 '캐릭터이름'과 '무기'로도 쐐기돌을 검색할 수 있습니다. (도움말이 필요한 경우: |cffffff00/mdr|r 또는 |cffffff00/쐐|r, |cffffff00/Tho|r)")    
        end
end)


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
    
    ["듀로탄"] = 3,
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
        else
            callType2,keyword2,extraKeyword2=nil,nil,nil
        end         
    end 
    -- "내"를 붙인 명령어를 다른사람이 입력했으면 리턴
    if onlyMe==1 and who~=MY_NAME_IN_GAME then
        return
    end
    
    --[[
    if callType then
        print("callType:"..callType)
    end
    if callType2 then
        print("callType2:"..callType2)
    end
    ]]
    
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
                        local neun="는"
                        if keyword=="도적" or keyword=="냥꾼"  or class=="악사" then
                            neun="은"
                        end                       
                        print("▶"..MDRcolor(keyword)..neun.." "..MDRcolor(keyword,-1,"전문화").."에 따라 착용가능 아이템 범주가 달라 "..MDRcolor(keyword,-1,"전문화").."로 검색해야만합니다. (|cFF33FF99ex|r.!"..MDRcolor(keyword,3).."!무기 or !"..MDRcolor(keyword,4).."!한손)")
                        searchingTip[1]=searchingTip[1]+1
                    end
                end
                return
            end
        end        
        
        if (callType=="spec" and callType2=="item")then            
            VALUES["comb"]="Spec_Item" 
            
        elseif (callType=="class" and callType2=="stat") then  
            local class,stat=keyword,keyword2
            if checkSpecCanUseStat(class,stat) then
                if class=="전사" or (class=="기사" and stat=="힘")  or class=="도적" or class=="냥꾼" or class=="죽기" then
                    if who==MY_NAME_IN_GAME then                    
                        if searchingTip[11]<=howManyWarn then
                            local neun="는"
                            if class=="도적" or class=="냥꾼" then
                                neun="은"
                            end
                            local eul="을"                        
                            print("▶"..MDRcolor(class)..neun.." "..MDRcolor(keyword,-1,"전문화").."에 따라 착용할 수 있는 아이템이 상이해 |cFFFFF569"..stat.." 능력치|r와 함께 검색할 수 없습니다. "..MDRcolor(keyword,-1,"전문화").."를 지정해서 검색해보세요.")
                            searchingTip[11]=searchingTip[11]+1                        
                        end
                    end  
                    return
                else 
                    VALUES["comb"]="Class_Stat"
                end                
            else
                if who==MY_NAME_IN_GAME then                    
                    if searchingTip[9]<=howManyWarn then
                        local neun="는"
                        if class=="도적" or class=="냥꾼" or class=="악사" then
                            neun="은"
                        end
                        local eul="을"                        
                        print("▶"..MDRcolor(class)..neun.." |cFFFFF569"..keyword2.."|r 아이템을 사용할 수 없습니다. 다른 |cFFFFF569능력치|r로 다시 시도해보세요.")
                        searchingTip[9]=searchingTip[9]+1                        
                    end
                end                
                return 
            end
            
        elseif (callType=="spec" and callType2=="stat") then  
            local spec,stat,class=keyword,keyword2,callTypeT[4]
            if checkSpecCanUseStat(spec,stat) then
                VALUES["comb"]="Spec_Stat"   
            else
                if who==MY_NAME_IN_GAME then                    
                    if searchingTip[10]<=howManyWarn then
                        local neun="는"
                        if class=="도적" or class=="냥꾼" or class=="악사" then
                            neun="은"
                        end
                        local eul="을"                        
                        print("▶"..MDRcolor(class,0,spec).." "..MDRcolor(class)..neun.." |cFFFFF569"..keyword2.."|r 아이템을 사용할 수 없습니다. 다른 |cFFFFF569능력치|r로 다시 시도해보세요.")
                        searchingTip[10]=searchingTip[10]+1                        
                    end
                end                
                return 
            end
            
        elseif (callType=="stat" and callType2=="specificitem")then             
            VALUES["comb"]="Stat_Specificitem"            
        elseif (callType=="spec" and callType2=="specificitem")then 
            local class=callTypeT[4] or keyword
            if checkSpecCanUseItem(class,keyword2) then            
                VALUES["comb"]="Spec_Specificitem"       
            else 
                if who==MY_NAME_IN_GAME then                    
                    if searchingTip[8]<=howManyWarn then
                        local neun="는"
                        if class=="도적" or class=="냥꾼" or class=="악사" then
                            neun="은"
                        end
                        local eul="를"
                        if keyword2=="장창" or keyword2=="단검" or keyword2=="한손도검" or keyword2=="양손도검" or keyword2=="마법봉" then
                            eul="을"
                        end   
                        print("▶"..MDRcolor(class)..neun.." "..keyword2..eul.." 사용할 수 없습니다. 다른 아이템으로 다시 시도해보세요.")
                        searchingTip[8]=searchingTip[8]+1                        
                    end
                end                
                return 
            end            
        elseif (callType=="stat" and callType2=="category")then             
            VALUES["comb"]="Stat_Category"                        
        elseif (callType=="spec" and callType2=="category")then             
            VALUES["comb"]="Spec_Category"            
        elseif (callType=="stat" and callType2=="item") then
            if who==MY_NAME_IN_GAME then
                if searchingTip[2]<=howManyWarn then
                    print("▶|cFFFFF569능력치|r와"..'"'.."무기"..'"'.."는 함께 검색할 수 없습니다. 무기 유형(단검,지팡이)이나 종류(양손,한손)를 지정해주세요. (|cFF33FF99ex|r. !|cFFFFF569힘|r!양손 or !|cFFFFF569지능|r!단검)")
                    searchingTip[2]=searchingTip[2]+1
                end
            end
        else return            
        end
        findCharAllItem(VALUES)
        return
        
    else --!명령어가 단일일 경우
        if callType=="all" or callType=="mykey" or callType=="levelrange" or callType=="dungeon" or callType=="class" or callType=="currentmykey" or callType=="currentall" or callType=="charname" then             
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
            --!주스탯이 고정인 무기종류는 검색통과
            if keyword=="보조" or keyword=="마법봉" or keyword=="석궁" or keyword=="활" or keyword=="총" or keyword=="전투검" or keyword=="방패" then
                VALUES["comb"]="Spec_Specificitem"       
                findCharAllItem(VALUES)                
            else
                if who==MY_NAME_IN_GAME then
                    if searchingTip[7]<=howManyWarn then 
                        local neun="는"
                        if keyword=="장창" or keyword=="단검" or keyword=="한손도검" or keyword=="양손도검" then
                            neun="은"
                        end                        
                        print("▶!"..MDRcolor("",-2,keyword)..neun.." 단독으로 검색할 수 없습니다. "..MDRcolor("",-1,"전문화").."나 |cFFFFF569능력치|r를 함께 입력해주세요. (|cFF33FF99ex|r. !|cffC79C6E분노|r!"..MDRcolor("",-2,keyword)..", !|cFFFFF569힘|r!"..MDRcolor("",-2,keyword)..")")                        
                        searchingTip[7]=searchingTip[7]+1                    
                    end
                end     
            end            
            --!전문화로만 검색시 !무기검색으로 유도
        elseif callType=="spec" and callType2==nil then
            if who==MY_NAME_IN_GAME then
                if searchingTip[6]<=howManyWarn then
                    local class=getCallTypeTable(keyword)[4] or getCallTypeTable(keyword)[2] 
                    
                    local neun,ga,ro="는","가","로"                   
                    if class=="도적" or class=="냥꾼" then
                        neun,ga,ro="은","이","으로"
                    elseif  class=="악사" then
                        neun,ga,ro="은","이","로"                        
                    end                         
                    
                    print("▶"..MDRcolor(class,-1,"전문화").."를 단독으로 입력한 경우 해당 전문화가 착용가능한 모든 무기로 던전을 검색합니다. (=!"..MDRcolor(class,0,keyword).."!무기) "..MDRcolor(class)..ga.." 소지한 돌이 알고 싶을 경우 !"..MDRcolor(class,0,class)..ro.." 검색하거나, 특정 무기를 지정하고 싶을 경우 "..MDRcolor(class,-1,"전문화").."와 무기종류,무기범주를 함께 검색해보세요.(|cFF33FF99ex|r.!"..MDRcolor(class,3).."!양손 or !"..MDRcolor(class,4).."!장착)")
                    searchingTip[6]=searchingTip[6]+1
                end
            end
            VALUES["comb"]="Spec_Item"
            findCharAllItem(VALUES)
            
            --!무기만 단독검색시
        elseif callType=="item" and callType2==nil then
            if who==MY_NAME_IN_GAME then
                if searchingTip[3]<=howManyWarn then
                    print("▶!무기는 단독으로 검색할 수 없습니다. 특성을 지정해주세요 (|cFF33FF99ex|r. !"..MDRcolor("",-1,"화염").."!무기)")
                    searchingTip[3]=searchingTip[3]+1
                end
            end  
            
            --스탯만 단독검색시            
        elseif callType=="stat" and callType2==nil then
            if who==MY_NAME_IN_GAME then
                if searchingTip[4]<=howManyWarn then
                    print("▶|cFFFFF569능력치|r는 단독으로 검색할 수 없습니다. 무기종류를 지정해주세요 (|cFF33FF99ex|r. !|cFFFFF569"..keyword.."|r!지팡이)")
                    searchingTip[4]=searchingTip[4]+1
                    --print(searchingTip[4])
                end
            end   
            
            --스탯지정없이 무기범주만 단독검색시
        elseif callType=="category" and callType2==nil then
            if who==MY_NAME_IN_GAME then
                if searchingTip[5]<=howManyWarn then
                    print("▶"..MDRcolor("",-1,"무기범주").."(한손,양손,근접,원거리)는 단독으로 검색할 수 없습니다. !"..MDRcolor("",-2,"한손도검").." !"..MDRcolor("",-2,"양손둔기").." 처럼 무기의 종류를 지정하거나 !|cFFFFF569힘|r !|cFFFFF569지능|r 등의 능력치와 함께 검색해주세요 (|cFF33FF99ex|r. !|cFFFFF569힘|r!"..MDRcolor("",-1,keyword)..", !|cFFFFF569민첩|r!"..MDRcolor("",-2,"한손도검")..")")
                    searchingTip[5]=searchingTip[5]+1
                    --print(searchingTip[5])
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
        
        callType=callTypeT[1]
        keyword=callTypeT[2]
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
            elseif filter=="CharName"  then
                target=strsub(chars[i]["cutName"],0,strlen(f1))
                f1=string.gsub(f1, "(%a)([%w_']*)", MDRtitleCase)
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


function MDRtitleCase( first, rest )
    return first:upper()..rest:lower()
end
