local _,className=UnitClass("player")
local  _,_,_,classColor=GetClassColor(className)  
local playerName = UnitName("player")
local MY_NAME_IN_GAME=UnitName("player").."-"..GetRealmName()    
local dices={}
local diceReportChannel
local diceWait=0

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
            if MDRguide<1 then
                print("▶[|cFF33FF99쐐기돌 보고서 "..MDRversion.."|r]: 이제 |c"..classColor.."!캐릭터이름|r과 조합하여 명령어에 반응할 사람을 지정할 수 있습니다. (도움말이 필요한 경우: |cffffff00/mdr|r 또는 |cffffff00/쐐|r, |cffffff00/Tho|r)")                               
                MDRguide=MDRguide+1
            end
        end
end)

function MDRmakeDice(channel,who,...)
    dices={}
    for i = 1, select('#', ...) do
        dices[i]=select(i, ...)
    end 
    if channel=="WHISPER_OUT" or #dices<2 then return end
    
    --나에게서 귓말이 들어오는 경우 프린트로 변경
    if (channel=="WHISPER_IN") and who==MY_NAME_IN_GAME then
        channel="print"
    end 
    diceReportChannel=channel
    diceWait=1
    RandomRoll(1,#dices)    
end


function MDRdice(msg)
    if diceWait==0 then return end
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
        messageLines[1]=resultNum.."번 "..(dices[resultNum] or "알 수 없음").." 한 표."
        
        reportMessageLines(messageLines,diceReportChannel,who,"dice")
        diceWait=0
    else
        return        
    end       
end


function MDRCommands(msg, editbox)   
    local messageLines={}
    msg=gsub(msg,"!","") 
    messageLines[1]=" "
    if not msg or msg=="" then
        messageLines[#messageLines+1]="[  |cFF33FF99쐐기돌 보고서 "..MDRversion.."|r 기본 명령어 목록  ]"
        messageLines[#messageLines+1]="▷이하 모든 명령어는 |cFF40ff40길드말|r과 |cFFaaaaff파티말|r, |cFFff80ff귓속말|r에 입력했을 때만 반응합니다."
        messageLines[#messageLines+1]="▷기본 명령어: |cffC79C6E!돌|r, |cff8787ED!주차|r, |cff40C7EB!던전명|r, |cffFF7D0A!직업명|r, |cffA9D271!닉네임|r, |cffC41F3B!속성|r, |cFFaaaaaa!무기|r"
        messageLines[#messageLines+1]="▷각 |cffC79C6E명령어|r 별 사용법을 보시려면 |cffffff00/쐐|r |cffC79C6E명령어|r 입력. |cFF33FF99ex)|r |cffffff00/쐐|r |cffC79C6E돌|r"
        messageLines[#messageLines+1]="▷이제 |cffA9D271!{닉네임}|r 을 이용해 명령어에 반응할 '사람'을 지정할 수 있습니다." 
        messageLines[#messageLines+1]="▷|cFF33FF99ex)|r |cffC79C6E!돌|r|c"..classColor.."!"..playerName.."|r, |cff8787ED!주차|r|c"..classColor.."!"..playerName.."|r: '|c"..classColor..playerName.."|r'라는 캐릭터를 소유한 '사람'의 출력을 유도." 
        --messageLines[4]="▶보다 자세한 사용법은 |cffffff00트위치|r나 |cffffff00Curse|r에서 |cFF33FF99MDReport|r 페이지에 방문하여 확인해보세요."
    elseif msg=="돌" then     
        
        messageLines[#messageLines+1]="▶|cffC79C6E!돌|r : 소유한 모든 돌 정보를 요청합니다. 이하 대부분의 명령어들은 '|cff0070DE내|r'와 함께 조합하면 나만 출력, '|cffF58CBA지금|r'과 함께 조합하면 현재 접속중인 캐릭터만 출력, |cffffff00숫자|r와 함께 검색하면 해당 범위의 돌만 출력합니다. |cFF33FF99ex)|r |cffC79C6E!돌 !|r|cff0070DE내|r|cffC79C6E돌 !|r|cffF58CBA지금|r|cffC79C6E돌 !돌|r|cffffff0015~18|r |cffC79C6E!돌|r|cffffff0025+|r"
        
    elseif msg=="던전"or msg=="던전명" then
        messageLines[#messageLines+1]="▶|cff40C7EB!{던전명}|r : 던전 이름으로 검색을 시도합니다. |cFF33FF99ex)|r |cff40C7EB!아탈|r |cff40C7EB!아탈|r|cffffff0018|r |cff40C7EB!|r|cffF58CBA지금|r|cff40C7EB아탈|r"
        
    elseif msg=="직업" or msg=="직업명" then
        
        messageLines[#messageLines+1]="▶|cffFF7D0A!{직업명}|r : 직업 이름으로 검색을 시도합니다. |cFF33FF99ex)|r |cffFF7D0A!드루 !드루|r|cffffff0015-|r |cffFF7D0A!|r|cff0070DE내|r|cffFF7D0A드루|r"
    elseif msg=="주차" then
        
        messageLines[#messageLines+1]="▶|cff8787ED!주차|r : 주차정보를 요청합니다. 주차를 못했거나 최대 보상을 받을 수 있는 단수(격아4시즌 기준 15단) 미만으로 주차한 경우 해당 캐릭터의 정보를 출력합니다. 소지한 쐐기돌이 있을 경우 쐐기돌 정보를, 돌이 없으나 적절한 템렙을 갖춘 경우 템레벨을 출력합니다. |cFF33FF99ex)|r |cff8787ED!주차 !|r|cff0070DE내|r|cff8787ED주차 !주차|r|cffffff0020|r : 특정 레벨을 지정할 경우(이 경우 20단) 해당 단수 이하 주차한 경우 검색결과에 포함"
        
    elseif msg=="닉네임" or msg=="이름" then
        messageLines[#messageLines+1]="▶|cffA9D271!{닉네임}|r : 닉네임으로 단일 '캐릭터' 검색을 시도합니다. 일치하는 캐릭터가 있을 경우 모두 출력합니다. 한글은 최소 |cFFFFF5692|r글자 이상, 영문은 |cFFFFF5694|r자 이상 입력해야합니다. |cFF33FF99ex)|r 캐릭명이 '|cffFF7D0A늘푸른나무|r' 일 경우 |cffFF7D0A!늘푸른나무|r,|cffFF7D0A!늘푸른|r,|cffFF7D0A!나무|r 모두 가능."        
        messageLines[#messageLines+1]="▷|cffA9D271!{닉네임}|r을 |cffC79C6E!돌|r 이나 |cff8787ED!주차|r와 조합하면 명령어에 반응할 '사람'을 지정할 수 있습니다. |cFF33FF99ex)|r |cffC79C6E!돌|r|cffFF7D0A!늘푸른|r, |cffFF7D0A!나무|r|cff8787ED!주차|r. 부캐 이름으로도 가능합니다."        
        messageLines[#messageLines+1]="▷|cffA9D271!{닉네임}|r과 |cffFF7D0A!{직업명}|r 을 조합하면 캐릭터 이름을 몰라도 특정 클래스를 검색할 수 있습니다. |cFF33FF99ex)|r |cffFFF569!도적|r|cffFF7D0A!늘푸른|r: 닉네임에 '|cffFF7D0A늘푸른|r'을 포함하는 캐릭터를 소유한 사람의 |cffFFF569도적|r 캐릭터를 검색."
    elseif msg=="속성"  then          
        messageLines[#messageLines+1]="▶|cffC41F3B!속성|r : 이번주 쐐기 속성을 출력. '다음주' '다다음주' 등과 조합해서 사용할 수 있습니다. |cFF33FF99ex)|r |cffC41F3B!속성 !|r지난주|cffC41F3B속성 !|r다다음주|cffC41F3B속성|r"
        
    elseif msg=="무기"  then          
        messageLines[#messageLines+1]="▶|cFF80e7EB!전문화|r, |cFFFFF569!능력치|r와 |cFFaaaaaa!무기|r, |cFFF5aCdA!무기범주|r, |cffC79C6E!무기종류|r, |cff8787ED!던전이름|r 등을 조합하여 원하는 무기를 드랍하는 던전의 돌을 보유하고 있을 경우 불러올 수 있습니다. |cFF33FF99ex|r) |cFF80e7EB!회드|r|cFFaaaaaa!무기|r, |cFFFFF569!지능|r|cffC79C6E!단검|r, |cffC79C6E!방패|r, |cFFFFF569!민첩|r|cFFF5aCdA!원거리|r, |cFFFFF569!힘|r|cFFF5aCdA!한손|r, |cFF80e7EB!고술|r|cff8787ED!아탈|r, |cFF80e7EB!양조|r|cffC79C6E!장창|r"
        
    else
        return
    end
    
    if msg~="" then
        messageLines[#messageLines+1]="▷기타 명령어: |cffC79C6E!돌|r, |cff8787ED!주차|r, |cff40C7EB!던전명|r, |cffFF7D0A!직업명|r, |cffA9D271!닉네임|r, |cffC41F3B!속성|r, |cFFaaaaaa!무기|r"
        --messageLines[#messageLines+1]="▷항목별 도움말: |cffffff00/쐐|r |cffC79C6E명령어|r 입력 |cFF33FF99ex)|r |cffffff00/쐐|r |cffC79C6E돌|r"
    end    
    
    --messageLines[#messageLines+1]=" "
    reportMessageLines(messageLines,"print","","help")
end

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
