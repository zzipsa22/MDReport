local meGame,meAddon,krClass,className=MDR["meGame"],MDR["meAddon"],MDR["krClass"],MDR["className"]
local  _,_,_,classColor=GetClassColor(className)  
local playerName = UnitName("player")
local dices={}
local diceReportChannel
local diceNums={"①","②","③","④","⑤","⑥","⑦","⑧","⑨","⑩"}
MDR["diceWait"]=0

C_Timer.After(10, function()        
        local x = GetLocale()
        if x ~= "koKR" then -- XXX temp, Options/Locales needs updated
            print("|cFF33FF99MDReport|r can't support your locale: ", x, ". Sorry for your inconvenience.")
        else
            if not  SavedInstancesDB then
                doWarningReport(channel,who,"warning") 
                return
            end 
            if MDR["guide"]<5 then
                print("▶[|cFF33FF99쐐기돌 보고서 "..MDR["version"].."|r]: 이제 |c"..classColor.."!{닉네임}|r과 조합하여 (|cFF33FF99ex.|r"..MDRcolor(krClass,0,"!"..playerName)..") 명령어에 반응할 사람을 지정하거나 |cFF00ff00!장신구|r, |cFFaaaaaa!무기|r로도 쐐기돌을 검색할 수 있습니다.")                 
                print("▷도움말이 필요한 경우: |cffffff00/mdr|r 또는 |cffffff00/쐐|r, |cffffff00/Tho|r")
                MDR["guide"]=MDR["guide"]+1
            end
        end
end)

local classInfo={
    ["도적"]={        
        "FFF569",
        "도적",
        "암살",
        "무법",
        "잠행"
    },
    ["죽기"]={        
        "C41F3B",
        "죽음의 기사",
        "혈기",
        "부정",
        "냉기","냉죽"
    },    
    ["드루"]={        
        "FF7D0A",
        "드루이드",
        "조화","조드",
        "회복","회드",
        "야성","야드",
        "수호","수드",
    },
    ["전사"]={        
        "C79C6E",
        "전사",
        "방어","방전",
        "분노","분전",
        "무기","무전","모든 던전"
    },
    ["기사"]={        
        "F58CBA",
        "성기사",
        "징벌","징기",
        "신성","신기",
        "보호","보기",
    },
    ["술사"]={        
        "0070DE",
        "주술사",
        "고양","고술",
        "정기","정술",
        "복원","복술",
    },
    ["수도"]={        
        "00FF96",
        "수도사",
        "풍운",
        "운무",
        "양조"
    },
    ["냥꾼"]={        
        "A9D271",
        "사냥꾼",
        "사격","격냥",
        "생존","생냥",
        "야수","야냥",
    },
    ["사제"]={        
        "FFFFFF",
        "사제",
        "암흑","암사",
        "신사","수사",
        "수양","신사",
    },
    ["흑마"]={        
        "8787ED",
        "흑마법사",
        "고통","고흑",
        "파괴","파흑",
        "악마","악흑", "주차"
    },
    ["법사"]={        
        "40C7EB",
        "마법사",
        "화염","화법",
        "비전","비법",
        "냉법",        
    },
    ["악사"]={        
        "A330C9",
        "악마 사냥꾼",
        "파멸",
        "복수"
    },
    ["무기"]={"aaaaaa"},
    ["하늘"]={"80e7EB"},
    ["핑크"]={"F5aCdA" },
    ["빨강"]={"ff0000" },
    ["노랑"]={"ffff00"},   
    ["초록"]={"00ff00"},   
    ["파랑"]={"0000ff"},   
    ["보라"]={"00ffff"},       
    [""]={}
}

function MDRgetClassInfo(keyword)    
    return classInfo[keyword]
end

function MDRgetClassName(keyword)
    for k,v in pairs(classInfo) do
        for i=1,#v do
            if keyword==v[i]  or keyword==k then
                return v[1]
            end        
        end        
    end   
end

function MDRko(keyword,type)    
    if not keyword then return "" end
    local LC=strsub(gsub(keyword,"!",""),-3)
    local kwa,neun,eul,ro,ga
    local result=""
    local LCtable={
        "검","궁","활","총","봉","창", --무기
        "꾼","적", --직업
        "돌","원","상","전","장","택","굴","산", --격아던전
        "복","멸","통","양","성","운","살","법","행","정","염","격","존","벌",--전문화
    }
    local Batchim=0
    for i=1,#LCtable do
        if LC==LCtable[i] then
            Batchim=1
            break
        end
    end   
    
    if Batchim==1 then
        kwa,neun,eul,ro,ga="과","은","을","으로","이"
    else
        kwa,neun,eul,ro,ga="와","는","를","로","가"
    end
    if type=="과" or type=="와" then
        result=kwa
    elseif type=="은" or type=="는" then
        result=neun
    elseif type=="을" or type=="를" then
        result=eul
    elseif type=="으로" or type=="로" then
        result=ro
    elseif type=="이" or type=="가" then
        result=ga
    end    
    return result
end

function MDRcolor(keyword,type,keyword2)
    local text,color    
    for k,v in pairs(classInfo) do
        for i=1,#v do            
            if strfind(keyword,v[i]) or strfind(keyword,k) or type==-1 or type==-2 then
                color=v[1]                 
                if not type or type==1  then
                    text=v[2] -- 드루이드 
                elseif type==0 then
                    text=keyword2 or keyword --입력한대로
                elseif type==2 then
                    text=k -- 드루
                elseif type==-1 then --하늘색                    
                    color="80e7EB"
                    text=keyword
                elseif type==-2 then --핑크색
                    color="F5aCdA"
                    text=keyword
                elseif type==3 then --전문화 출력1
                    text=v[3]
                elseif type==4 then --전문화 출력2
                    text=v[5] or v[4]
                elseif type==5 then --색깔없이 직업만 출력                  
                    return v[2]
                elseif type==10 then --전문화+직업
                    text=keyword.." "..v[2]                    
                end               
            end            
        end        
    end    
    return "|cff"..(color or "F5aCdA")..(text or keyword or"?").."|r"        
end

function MDRmakeDice(channel,who,k)
    C_Timer.After(2, function()             
            MDR["running"]=0  
            MDR["diceAlert"]=0            
    end)    
    dices={}
    dicesB={}
    MDR["diceAlert"]=0    
    if #k<3 then return end
    local num=1
    for i=1,#k do
        local subject
        local subT=MDRsplit(k[i]," ") 
        for j=1,#subT do
            local space=" "
            if j==1 then
                space=""
            end            
            subject=(subject or "")..space..subT[j]
        end
        if not strfind(k[i],"주사위") then
            subject=getFullDungeonName(subject) or subject           
            dices[num]=subject
            dicesB[num]=k[i]          
            num=num+1            
        end
    end    
    
    if channel=="WHISPER_OUT" or #dices<2 then return end
    
    --나에게서 귓말이 들어오는 경우 프린트로 변경
    if (channel=="WHISPER_IN") and who==meGame then
        channel="print"
    end 
    diceReportChannel=channel
    local message="MDR ▶ "
    local messageLines={}    
    for i=1,#dices do
        local space=", "
        --print(dices[i])            
        if i==#dices then space="" end
        message=message..diceNums[i].." "..dices[i]..space
    end
    message=message.." : /주사위 "..#dices..""
    messageLines[1]=message
    
    if who==meGame then    
        reportMessageLines(messageLines,diceReportChannel,who,"dice")
        MDR["diceAlert"]=1        
    end 
    C_Timer.After(0.9, function() 
            if MDR["diceAlert"]~=1 and MDR["master"]==1 then
                --print("check")                
                reportMessageLines(messageLines,diceReportChannel,who,"dice")                
            end          
    end) 
    MDR["diceWait"]=1 
    C_Timer.After(1, function()            
            RandomRoll(1,#dices)
            MDR["running"]=0  
    end)    
end


function MDRdice(msg)
    if MDR["diceWait"]==0 then return end
    local resultNum
    local messageLines={}
    if playerName==strsub(msg,1,strlen(playerName)) then
        local num=MDRsplit(msg," ")[5]
        local n1=tonumber(strsub(num,1,1))
        local n2=tonumber(strsub(num,1,2))
        if n2 then resultNum=n2
        else
            resultNum=n1     
        end 
        messageLines[1]=diceNums[resultNum].." "..(dices[resultNum] or "알 수 없음")
        C_Timer.After(1.5, function()    
                reportMessageLines(messageLines,diceReportChannel,who,"dice")
                MDR["diceWait"]=0
        end) 
    else
        return        
    end       
end


function MDRCommands(msg, editbox)   
    local messageLines={}
    msg=gsub(msg,"!","") 
    messageLines[1]=" "
    local n1,n2,m1
    if strlen(playerName)>6 then
        n1=strsub(playerName,0,6)
        n2=strsub(playerName,-6)
        m1=MDRcolor(krClass,0,"!"..playerName)..","..MDRcolor(krClass,0,"!"..n1)..","..MDRcolor(krClass,0,"!"..n2).." 모두 가능."
    else
        n1=playerName
        n2=playerName
        m1=MDRcolor(krClass,0,"!"..playerName).." 입력."
    end   
    if not msg or msg=="" or msg=="도움말" or msg=="help"  then
        messageLines[#messageLines+1]="[  |cFF33FF99쐐기돌 보고서 "..MDR["version"].."|r 기본 명령어 목록  ]"
        messageLines[#messageLines+1]="▷이하 모든 명령어는 |cFF40ff40길드말|r과 |cFFaaaaff파티말|r, |cFFff80ff귓속말|r에 입력했을 때만 반응합니다."
        messageLines[#messageLines+1]="▷기본 명령어: |cffC79C6E!돌|r, |cff8787ED!주차|r, |cff40C7EB!던전명|r, |cffFF7D0A!직업명|r, |cffA9D271!닉네임|r, |cffC41F3B!속성|r, |cFFaaaaaa!무기|r, |cFF00ff00!장신구|r"
        messageLines[#messageLines+1]="▷각 |cffC79C6E명령어|r 별 사용법을 보시려면 |cffffff00/쐐|r |cffC79C6E명령어|r 입력. |cFF33FF99ex)|r |cffffff00/쐐|r |cffC79C6E돌|r"
        messageLines[#messageLines+1]="▷|cFF33FF99[1.5.0]|r+ |cffA9D271!{닉네임}|r 을 이용해 캐릭터를 검색할 수 있습니다. ▷|cffffff00/쐐|r |cffA9D271이름|r" 
        -- messageLines[#messageLines+1]="▷|cFF33FF99ex)|r |cffC79C6E!돌|r|c"..classColor.."!"..playerName.."|r, |cff8787ED!주차|r|c"..classColor.."!"..playerName.."|r: '|c"..classColor..playerName.."|r'라는 캐릭터를 소유한 '사람'의 출력을 유도." 
        messageLines[#messageLines+1]="▷|cFF33FF99[1.6.3]|r+ |cFF00ff00!장신구|r 로 장신구 드랍 던전을 검색할 수 있습니다. ▷|cffffff00/쐐|r |cff00ff00장신구|r"
        
        --messageLines[4]="▶보다 자세한 사용법은 |cffffff00트위치|r나 |cffffff00Curse|r에서 |cFF33FF99MDReport|r 페이지에 방문하여 확인해보세요."
    elseif msg=="돌" then     
        
        messageLines[#messageLines+1]="|cffC79C6E▶!돌|r : 소유한 모든 돌 정보를 요청합니다. 이하 대부분의 명령어들은 '|cff0070DE내|r'와 함께 조합하면 나만 출력, '|cffF58CBA지금|r'과 함께 조합하면 현재 접속중인 캐릭터만 출력, |cffffff00숫자|r와 함께 검색하면 해당 범위의 돌만 출력합니다. |cFF33FF99ex)|r |cffC79C6E!돌 !|r|cff0070DE내|r|cffC79C6E돌 !|r|cffF58CBA지금|r|cffC79C6E돌 !돌|r|cffffff0015~18|r |cffC79C6E!돌|r|cffffff0025+|r"
        
    elseif msg=="던전"or msg=="던전명" then
        messageLines[#messageLines+1]="|cff40C7EB▶!{던전명}|r : 던전 이름으로 |cffC79C6E쐐기돌|r 검색을 시도합니다. |cFF33FF99ex)|r |cff40C7EB!아탈다자르|r |cff40C7EB!아탈|r|cffffff0018|r |cff40C7EB!|r|cffF58CBA지금|r|cff40C7EB아탈|r"
        
    elseif msg=="직업" or msg=="직업명" then
        
        messageLines[#messageLines+1]="|cffFF7D0A▶!{직업명}|r : 직업 이름으로 |cffC79C6E쐐기돌|r 검색을 시도합니다. |cFF33FF99ex)|r |cffFF7D0A!드루 !드루|r|cffffff0015-|r |cffFF7D0A!|r|cff0070DE내|r|cffFF7D0A드루|r"
    elseif msg=="주차" then
        
        messageLines[#messageLines+1]="|cff8787ED▶!주차|r : 주차정보를 요청합니다. 주차를 못했거나 최대 보상을 받을 수 있는 단수(격아4시즌 기준 15단) 미만으로 주차한 경우 해당 캐릭터의 정보를 출력합니다. 소지한 쐐기돌이 있을 경우 쐐기돌 정보를, 돌이 없으나 적절한 템렙을 갖춘 경우 템레벨을 출력합니다. |cFF33FF99ex)|r |cff8787ED!주차 !|r|cff0070DE내|r|cff8787ED주차 !주차|r|cffffff0020|r : 특정 레벨을 지정할 경우(이 경우 20단) 해당 단수 이하 주차한 경우 검색결과에 포함"
        
    elseif msg=="닉네임" or msg=="이름" then
        local length=MDR["textLength"]
        local kLength=math.floor((length-1)/3+1)
        messageLines[#messageLines+1]="|cffA9D271▶!{닉네임}|r : |cffA9D271닉네임|r을 단독으로 입력하는 경우 |c"..classColor.."'캐릭터'|r 검색을 시도합니다. 일치하는 캐릭터가 있을 경우 모두 출력합니다. 한글은 최소 |cFFFFF569"..kLength.."|r글자 이상, 영문은 |cFFFFF569"..length.."|r자 이상 입력해야합니다. |cFF33FF99ex)|r 캐릭명이 '|c"..classColor..playerName.."|r' 일 경우 "..m1        
        messageLines[#messageLines+1]="|cffA9D271▷!{닉네임}|r을 |cffC79C6E!돌|r 이나 |cff8787ED!주차|r와 조합하면 명령어에 반응할 "..MDRcolor("초록",0,"'사람'").."을 지정할 수 있습니다. |cFF33FF99ex)|r |cffC79C6E!돌|r"..MDRcolor(krClass,0,"!"..n1)..", "..MDRcolor(krClass,0,"!"..n2).."|cff8787ED!주차|r. 부캐 이름으로도 가능합니다."        
        messageLines[#messageLines+1]="|cffA9D271▷!{닉네임}|r과 |cffFF7D0A!{직업명}|r 을 조합하면 캐릭터 이름을 몰라도 특정 |cffFF7D0A직업|r을 검색할 수 있습니다. |cFF33FF99ex)|r |cffFFF569!도적|r"..MDRcolor(krClass,0,"!"..n1)..": 닉네임에 '"..MDRcolor(krClass,0,n1).."'을/를 포함하는 캐릭터를 소유한 사람의 |cffFFF569도적|r 캐릭터를 검색."
    elseif msg=="속성"  then          
        messageLines[#messageLines+1]="|cffC41F3B▶!속성|r : 이번주 쐐기 속성을 출력합니다. '다음주' '다다음주' 등과 조합해서 사용할 수 있습니다. |cFF33FF99ex)|r |cffC41F3B!속성 !|r지난주|cffC41F3B속성 !|r다다음주|cffC41F3B속성|r"
        
    elseif msg=="무기"  then          
        messageLines[#messageLines+1]="▶|cFF80e7EB!전문화|r, |cFFFFF569!능력치|r와 |cFFaaaaaa!무기|r, |cFFF5aCdA!무기범주|r, |cffC79C6E!무기종류|r, |cff8787ED!던전이름|r 등을 조합하여 원하는 무기를 드랍하는 던전의 돌을 검색할 수 있습니다. |cFF33FF99ex|r) |cFF80e7EB!회드|r|cFFaaaaaa!무기|r, |cFFFFF569!지능|r|cffC79C6E!단검|r, |cffC79C6E!방패|r, |cFFFFF569!민첩|r|cFFF5aCdA!원거리|r, |cFFFFF569!힘|r|cFFF5aCdA!한손|r, |cFF80e7EB!고술|r|cff8787ED!아탈|r, |cFF80e7EB!양조|r|cffC79C6E!장창|r"
        
    elseif msg=="장신구"  then   
        messageLines[#messageLines+1]="▶|cFF00ff00!장신구|r와 |cFF80e7EB!역할|r, |cFFFFF569!능력치|r를 조합하면 특정 장신구를 드랍하는 던전의 돌을 검색할 수 있습니다. |cFF33FF99ex|r) |cFF80e7EB!힐러|r|cFF00ff00!장신구|r, |cFFFFF569!민첩|r|cFF00ff00!장신구|r"
        messageLines[#messageLines+1]="▷|cFFaaaaaa!무기|r는 "..MDRcolor(krClass,0,"!".."전문화").."와, |cFF00ff00!장신구|r는 |cFF80e7EB!역할|r과 조합 한다고 생각하시면 기억하기 쉽습니다."
    else
        return
    end
    
    if msg~="" then
        messageLines[#messageLines+1]="▷기타 명령어: |cffC79C6E!돌|r, |cff8787ED!주차|r, |cff40C7EB!던전명|r, |cffFF7D0A!직업명|r, |cffA9D271!닉네임|r, |cffC41F3B!속성|r, |cFFaaaaaa!무기|r, |cFF00ff00!장신구|r"
        --messageLines[#messageLines+1]="▷항목별 도움말: |cffffff00/쐐|r |cffC79C6E명령어|r 입력 |cFF33FF99ex)|r |cffffff00/쐐|r |cffC79C6E돌|r"
    end    
    
    --messageLines[#messageLines+1]=" "
    reportMessageLines(messageLines,"print","","help")
end

--명령어 등록
SLASH_MDReport1, SLASH_MDReport2, SLASH_MDReport3 = '/mdr', '/Tho','/쐐'
SlashCmdList["MDReport"] = MDRCommands 

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

function MDRtitleCase( first, rest )
    return first:upper()..rest:lower()
end

function MDRtitleLower( first, rest )
    return first:lower()..rest:lower()
end
