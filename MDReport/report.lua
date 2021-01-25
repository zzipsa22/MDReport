local meGame,meAddon,krClass=MDR["meGame"],MDR["meAddon"],MDR["krClass"]
local warns={}
local warning=3

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
local classIcon={--    Classes
    ["전사"]="|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:0:0:0:-4:256:256:0:64:0:64|t",
    ["법사"]="|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:0:0:0:-4:256:256:64:128:0:64|t",
    ["도적"]="|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:0:0:0:-4:256:256:128:192:0:64|t",
    ["드루"]="|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:0:0:0:-4:256:256:192:256:0:64|t",
    ["냥꾼"]="|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:0:0:0:-4:256:256:0:64:64:128|t",
    ["술사"] ="|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:0:0:0:-4:256:256:64:128:64:128|t",
    ["사제"]="|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:0:0:0:-4:256:256:128:192:64:128|t",
    ["흑마"]="|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:0:0:0:-4:256:256:192:256:64:128|t",
    ["기사"]="|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:0:0:0:-4:256:256:0:64:128:192|t",
    ["죽기"]="|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:0:0:0:-4:256:256:64:128:128:192|t",
    ["수도"]="|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:0:0:0:-4:256:256:128:192:128:192|t",
    ["악사"] ="|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:0:0:0:-4:256:256:192:256:128:192|t",        
}     
local classColor={
    ["술사"]="0070DE",
    ["법사"]="40C7EB",
    ["수도"]="00FF96",
    ["냥꾼"]="A9D271",
    ["도적"]="FFF569",
    ["드루"]="FF7D0A",
    ["전사"]="C79C6E",
    ["악사"]="A330C9",
    ["흑마"]="8787ED",
    ["기사"]="F58CBA",
    ["사제"]="FFFFFF",
    ["죽기"]="C41F3B",
}

MDR.skull=skull
MDR.classColor=classColor
MDR.classIcon=classIcon

local skullP={}
for i=1,8 do
    skullP["rt"..i]="\124TInterface/TargetingFrame/UI-RaidTargetingIcon_"..i..":12:::-4\124t"
end

local classNames={
    "술사","법사","수도","냥꾼","도적","드루","전사","악사","흑마","기사","사제","죽기",
}

function doCheckVersion(channel,who,callType)
    
    local messageLines={}   
    messageLines[1]="▶[쐐기돌 보고서] "..MDR["version"].." (Update: "..MDR["lastUpdate"]..")"  
    if callType["forceversion"]==1 then
        channel="ADDON_GUILD"
    end
    reportMessageLines(messageLines,channel,who,callType)   
end

function doOnlyAffixReport(keyword,channel,who,callType)  
    local messageLines={}      
    if tonumber(keyword) then
        local week=keyword       
        local weekTitle=""
        local affixText=GetAnyWeeksAffix(week,channel)
        if affixText==nil then return end
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
        messageLines[1]="▶"..weekTitle.." 속성: "..affixText         
    elseif keyword=="all"then
        messageLines[1]="▶다음주 속성: "..GetAnyWeeksAffix(1,channel) 
        messageLines[2]="▷2주뒤 속성: "..GetAnyWeeksAffix(2,channel)
        messageLines[3]="▷3주뒤 속성: "..GetAnyWeeksAffix(3,channel)
        messageLines[4]="▷4주뒤 속성: "..GetAnyWeeksAffix(4,channel)        
    else        
        messageLines=GetAffixFullDescription(keyword,channel)
    end
    reportMessageLines(messageLines,channel,who,callType)    
end

function reportAddonMessage(messageLines,channel,who,callType)
    
    if channel=="ADDON_PARTY" then
        channel="PARTY"
    elseif channel=="ADDON_GUILD" then
        channel="GUILD"
    elseif channel=="ADDON_OFFICER" then
        channel="OFFICER"
    elseif channel=="ADDON_WHISPER" then
        channel="WHISPER"
    end
    
    for i=1,#messageLines do 
        if channel=="print"then            
            for j=1,8 do
                messageLines[i]=gsub(messageLines[i],"{rt"..j.."}",skullP["rt"..j])
            end
            C_Timer.After(0.2*(i-1), function()
                    if messageLines[i]~="" then
                        print(messageLines[i])
                    end
            end)  
        else
            C_Timer.After(0.2*(i-1), function()
                    --if channel=="ADDON" then channel="GUILD" end 
                    if callType["forceversion"] then channel="WHISPER" end
                    C_ChatInfo.SendAddonMessage("MDReport", MDRcolor(krClass,6).."_"..messageLines[i], channel,who)
            end)               
        end 
    end 
end

function MDRsendAddonMessage(args,channel,who)
    C_ChatInfo.SendAddonMessage("MDReport", args, channel, who)
end

function MDRcolorizeForPrint(message)
    --print(message)    
    local icon_class={}
    local icon={}
    local icon_colon={} 
    local icon_color={}
    local icon_class_arrow={}
    local color_class={}
    for i=1,#classNames do
        local c=classNames[i]
        icon_class[skull[c]..c]=classIcon[c].."|cff"..classColor[c]..c
        icon[skull[c]..c]=classIcon[c]    
        icon_colon[skull[c]..c..":"]=classIcon[c].."|cff"..classColor[c]..":|r"  
        icon_color[skull[c]..c]=classIcon[c].."|cff"..classColor[c]
        icon_class_arrow[skull[c]..c.."▶%["]=" ["..classIcon[c].."|cff"..classColor[c]..":|r"
        color_class[c]="|cff"..classColor[c]..c.."|r"     
    end 
    --주차정보를 포함하는 경우
    if strfind(message,"/") or strfind(message,"Χ") then
        if strfind(message,"▶") then -- 이름, 던전등 개별 캐릭터의 fullReport
            for k,v in pairs(icon_color) do
                if strfind(message,k) then
                    message=gsub(message,k,v)
                    message=gsub(message,"▶","|cff"..classColor[strsub(k,6,-1)].."▶|r")
                end            
            end            
            local m1=strsub(message,1,strfind(message,"▶")-1)
            local m2=strsub(message,strfind(message,"▶"),strlen(message))          
            m1=gsub(m1,"%(","|r%(")
            message=m1..m2
        else -- 주차 shortReport
            for k,v in pairs(icon_colon) do
                if strfind(message,k) then
                    message=gsub(message,k,v)
                end            
            end             
        end
        --쪼렙의 경우
    elseif strfind(message,"아님") then
        for k,v in pairs(icon_color) do 
            if strfind(message,k) then
                message=gsub(message,k,v)
                message=gsub(message,"▶","▶|r")  
            end            
        end        
    else --주차정보가 없는 경우 : 나머지 shortReport
        for k,v in pairs(icon_class_arrow) do            
            message=gsub(message,k,v)          
        end
        if strfind(message,"쐐기돌") then            
        end        
    end    
    
    --성약단
    if strfind(message,"{c") then
        for i=1,4 do
            local target="{c"..i.."}"
            if strfind(message,target) then
                message=gsub(message,target,MDRgetCovenantIcon(i))
            end            
        end		
        for k,v in pairs(color_class) do
            message=gsub(message,k,v)
        end        
		message=gsub(message,"{c0}","")
    end	
    
    if strfind(strsub(message,1,1)," ") then 
        message=strsub(message,2,-1)
    end
    
    --징표
    for j=1,8 do
        message=gsub(message,"{rt"..j.."}",skullP["rt"..j])
    end
    
    --혹시 모를 두칸 띄어어쓰기 줄이기
    message=gsub(message,"   ","  ")
    message=gsub(message,"  ▶"," ▶")    
    message=gsub(message,"%] %[","%]  %[")    
    
    --주사위 색입히기
    message=gsub(message,"MDR ▶","|cFF33FF99MDR ▶|r")
    message=gsub(message,"결과 ▶","|cFF33FF99결과 ▶|r")
    local diceNums=MDR.diceNums
    for k,v in pairs(diceNums) do
        message=gsub(message,v,MDRcolor("사제",0,v))        
    end         
    
    --주차단수 색입히기
    local park1={}
    local park4={}
    local park10={}
    local keyL={}
    local keyL2={}
    
    local mL=40
    for i=1,mL do
        tinsert(park1,(mL-i).."/")
        tinsert(park4,"/"..(mL-i).."/")
        tinsert(park10,"/"..(mL-i))
        tinsert(keyL,(mL-i).."[")
        tinsert(keyL2,(mL-i).."]")        
    end
    message=gsub(message,"Χ",MDRcolor("빨강",0,"Χ"))
    for i=1,#park1 do
        local c1="고급"        
        if i==(mL-0) then 
            c1="회색"
        elseif i<=(mL-14) then
            c1="유물"        
        elseif i<=(mL-12) then
            c1="전설"        
        elseif i<=(mL-10) then
            c1="영웅"           
        elseif i<=(mL-8) then
            c1="희귀"
        elseif i<=(mL-6) then
            c1="고급"
        end         
        message=gsub(message,park4[i],"/"..MDRcolor(c1,0,gsub(park1[i],"/","")).."/")
        message=gsub(message,park10[i],"/"..MDRcolor(c1,0,gsub(park1[i],"/","")))       
        message=gsub(message,park1[i],MDRcolor(c1,0,gsub(park1[i],"/","")).."/")      
    end    
    
    --던전 색입히기
    local dungeonNames=MDR.dungeonNames
    local dungeonNamesFull=MDR.dungeonNamesFull
    if not strfind(message,"쐐기돌") then
        for i=1,#dungeonNamesFull do            
            message=gsub(message,dungeonNamesFull[i],MDRcolor("노랑",0,dungeonNamesFull[i]))
        end  
        for i=1,#dungeonNames do            
            message=gsub(message,dungeonNames[i],MDRgetCovenantIcon(dungeonNames[i])..MDRcolor("노랑",0,dungeonNames[i]))
        end 
    end 
    return message
end


function MDRprintAddonMessage(...)   
    local message=select(2,...)
    local channel=select(3,...)    
    local WHO=select(4,...)
    local channelColor={
        ["GUILD"]="|cFF88ff88",
        ["PARTY"]="|cFFaaaaff",
        ["WHISPER"]="|cFFF5aCdA",
        ["OFFICER"]="|cFF40C040",        
    }    
    who=strsub(MDRsplit(WHO, "-")[1],1,9)
    
    local ch
    if channel=="GUILD" then
        ch=channelColor[channel].."G"
    elseif channel=="PARTY" then
        ch=channelColor[channel].."P"
    elseif channel=="OFFICER" then
        ch=channelColor[channel].."O"
    else
        ch=""
    end    
    
    local class
    for i=1,#classNames do
        if strfind(strsub(message,1,6),classNames[i]) then           
            class=MDRsplit(message,"_")[1]
            message=MDRsplit(message,"_")[2]
        end
    end
    --색입히기
    message=MDRcolorizeForPrint(message)    
    
    if channel=="WHISPER" and WHO==meGame then
        print(message)
    elseif class then
        print(ch..MDRcolor(class,0,"["..who.."]")..": "..message)
    else
        print(ch..channelColor[channel].."["..who.."]:|r "..message)
    end    
end


function doShortReport(chars,channel,who,callType)
    local messageLines={} 
    local isAddonMessage
    
    if channel=="ADDON_GUILD" or channel=="ADDON_PARTY" or channel=="ADDON_OFFICER" or channel=="ADDON_WHISPER" or channel=="print" then
        isAddonMessage=1
    else
        isAddonMessage=0
    end
    
    if chars~=nil then
        
        local charName,class=nil,nil
        
        --중복직업 체크 및 돌 순서대로 정렬             
        local yourClass={}
        
        for i=1,#chars do         
            class=chars[i]["shortClass"] 
            yourClass[class]=(yourClass[class] or 0)+1  
        end   
        
        local sameClass={}
        local mNum=1
        for i=1,#chars do             
            charName=chars[i]["fullName"]      
            class=chars[i]["shortClass"]            
            
            local keyLink=chars[i]["keyLink"]
            local keyName=chars[i]["keyName"]
            local level=chars[i]["keyLevel"]
            local best=chars[i]["best"]
            local best4=chars[i]["best4"]
            local best10=chars[i]["best10"]
            local covenant=chars[i]["covenant"]
            local itemLevel=chars[i]["itemLevel"]            
            local equipLevel=chars[i]["equipLevel"]
            local online=""
            local classStatus=""            
            local cutName=gsub(charName, "%s%-.+","")
            local shortName=strsub(cutName,1,9)
            local shorterName=strsub(cutName,1,6)
            
            if yourClass[class] and yourClass[class]>1 then
                sameClass[class]=(sameClass[class] or 0)+1                
                classStatus=class..sameClass[class]..","..shorterName                
            else                
                classStatus=class                
            end
            if charName==meAddon then
                online="◀접속중"
            end            
            
            --던전 이름 줄이기
            keyName=getShortDungeonName(keyName)            
            
            local havekey,parking, parkingstar="","",""  
            if best and best ~=0 then 
                if callType=="parking" then
                    parkingstar=":"..best..(best4 and ("/"..best4) or "")..(best10 and ("/"..best10) or "")
                else  
                    parkingstar=","..best..(best4 and ("/"..best4) or "")..(best10 and ("/"..best10) or "")
                end                   
            else 
                if callType=="parking" then
                    parkingstar=":Χ"                    
                else  
                    parkingstar=""            
                end       
            end            
            
            if keyLink~=nil then
                havekey=keyName..level
            else
                local E=math.floor(equipLevel)
                local H=math.floor(itemLevel)
                if E==H then
                    H=""
                else
                    H="("..H..")"
                end
                havekey="템렙"..E..H
            end
            local message=""          
            local sameCheck
            
            
            if callType=="parking" then                 
                message="["..skull[class]..classStatus..parkingstar.."]"
            elseif callType=="all" then                
                message=skull[class].."["..havekey.."]:"..classStatus  
            elseif chars[i]["extraLink"] and callType=="spell"then
                message=skull[class]..classStatus.."["..havekey.."]"..chars[i]["extraLink"]
            elseif chars[i]["extraLink"] and callType=="item"then
                sameCheck=tonumber(strsub(chars[i]["extraLink"],0,1))                
                if sameCheck then                   
                    message=skull[class]..havekey
                else                    
                    message=skull[class]..havekey.."▶["..chars[i]["extraLink"].."]"
                end
            elseif callType["covenant"] then
                if isAddonMessage==1 then
                    message="[{c"..MDRgetCovenantID(covenant).."}"..classStatus..":"..havekey.."]" 
                else
                    message=skull[class]..havekey.."("..classStatus..")"
                end           
            else
                if isAddonMessage==1 then
                    message=skull[class]..classStatus.."▶["..havekey.."]"                         
                else
                    message=skull[class]..havekey.."("..classStatus..")"
                end           
            end
            
            if sameCheck and messageLines[sameCheck] then                 
                messageLines[sameCheck]=gsub(messageLines[sameCheck],"▶",message.."▶")
            else
                messageLines[mNum]=message
                mNum=mNum+1
            end     
            
        end        
        -- 한줄로 줄이기        
        local oneLineMessage={}
        local num=1
        local maxNum=8
        local lineNum=math.ceil(#messageLines/maxNum)
        local charPerLine=math.ceil(#messageLines/lineNum)    
        --print("총"..#messageLines.."캐릭/한줄당 "..charPerLine.."개/총 "..lineNum.."줄")
        for i=1,#messageLines do
            local space=""
            if i<#messageLines then
                space=" "                
            end           
            if #messageLines>maxNum then
                num=math.floor((i-1)/charPerLine)+1                
            end            
            oneLineMessage[num]=(oneLineMessage[num] or "")..messageLines[i]..space
        end
        --메세지라인 리셋셋
        messageLines=oneLineMessage
    end    
    --메세지 출력
    if channel=="ADDON_GUILD" or channel=="ADDON_PARTY"  or channel=="ADDON_OFFICER" or channel=="GUILD" then
        reportAddonMessage(messageLines,channel,who,callType)
    else
        --reportAddonMessage(messageLines,channel,who,callType)
        reportMessageLines(messageLines,channel,who,callType)    
    end        
end

--자세한 보고서 작성 및 출력
function doFullReport(chars,channel,who,callType)          
    
    local messageLines={}     
    local isAddonMessage
    
    if channel=="ADDON_GUILD" or channel=="ADDON_PARTY" or channel=="ADDON_OFFICER" or channel=="ADDON_WHISPER" or channel=="print" then
        isAddonMessage=1
    else
        isAddonMessage=0
    end
    
    if chars~=nil then      
        local charName,class=nil,nil       
        
        --중복직업 체크              
        local yourClass={}   
        
        for i=1,#chars do         
            class=chars[i]["shortClass"] 
            yourClass[class]=(yourClass[class] or 0)+1             
        end   
        
        local sameClass={}
        local mNum=1
        for i=1,#chars do             
            charName=chars[i]["fullName"]      
            class=chars[i]["shortClass"]            
            
            local keyLink=chars[i]["keyLink"]
            local keyName=chars[i]["keyName"]
            local level=chars[i]["keyLevel"]
            local best=chars[i]["best"]
            local best4=chars[i]["best4"]
            local best10=chars[i]["best10"]            
            local covenant=chars[i]["covenant"]   
            local itemLevel=chars[i]["itemLevel"]
            local equipLevel=chars[i]["equipLevel"]
            local charLevel=chars[i]["charLevel"]
            local online=""            
            local classStatus=""
            local headStar=""
            
            if charName==meAddon then
                online="◀접속중"
            end
            
            local covenantIcon=""
            if covenant and covenant~="" and covenant ~=0 then
                covenantIcon="{c"..MDRgetCovenantID(covenant).."}"
            end 
            
            local dungeonIcon="{c"..MDRgetCovenantID(getShortDungeonName(keyName)).."}"
            
            local cutName=gsub(charName, "%s%-.+","")
            local shortName
            if (callType=="charname") or (callType and callType["class"]) then                
                shortName=cutName
            else
                shortName=strsub(cutName,1,9)
            end           
            
            local havekey,parking, parkingstar="","",""    
            
            if keyLink~=nil then
                if callType=="item" then
                    keyName=getShortDungeonName(keyName)                      
                    havekey=keyName..level
                else
                    havekey=keyLink
                end                
            else
                if charLevel==MDR["SCL"] then
                    local E=math.floor(equipLevel)
                    local H=math.floor(itemLevel)
                    if E==H then
                        H=""
                    else
                        H="("..H..")"
                    end
                    havekey="[{rt7}쐐기돌 없음: 템렙"..E..H.."]"
                else
                    havekey="[{rt8}만렙 아님: "..charLevel.."레벨]"
                end                
            end
            
            if best and best~=0 then
                if isAddonMessage==1 then
                    parking="("..best..(best4 and ("/"..best4) or "")..(best10 and ("/"..best10) or "")..")"
                else
                    parking=","..best..(best4 and ("/"..best4) or "")..(best10 and ("/"..best10) or "")
                    parkingstar="▶"
                end
                
            else
                if charLevel==MDR["SCL"] then
                    if isAddonMessage==1 then
                        parking="(Χ)"  
                    else
                        parking=",Χ"                    
                    end
                    
                else
                    parking=""                    
                end   
                parkingstar="▷"             
            end
            
            --같은 직업이 있을경우 뒤에 이름 붙이기
            if yourClass[class] and yourClass[class]>1 then
                sameClass[class]=(sameClass[class] or 0)+1               
            end            
            
            if isAddonMessage==1 then
                classStatus=class..shortName.." "..parking               
            else
                classStatus=class.."("..shortName..parking..")"
            end
            
            headStar=skull[class]            
            
            local message=""
            local sameCheck
            
            local s=MDR.myMythicKey.start
            local f=MDR.myMythicKey.finish            
            
            if callType=="spell" and chars[i]["extraLink"] then
                message=headStar..classStatus..": "..chars[i]["extraLink"].." "..havekey..online
            elseif callType=="item" and chars[i]["extraLink"] then                
                sameCheck=tonumber(strsub(chars[i]["extraLink"],0,1))
                if sameCheck then                   
                    message=","..headStar..havekey
                else      
                    message=headStar..havekey.."▶"..chars[i]["extraLink"] 
                end 
            elseif callType and callType["newkey"] then                
                local up=""
                if f.level=="nil" or s.level=="nil" then return end
                if f.level > s.level then
                    up="△"..(f.level-(s.level+1)).."상"
                else
                    up="▽시간초과"
                end                
                message=headStar.."새 돌: ["..getShortDungeonName(s.name)..(s.level+1).."] ▶ ["..getShortDungeonName(f.name)..f.level.."] ("..up..") : "..(f and f.link  or keyLink)
                
            elseif callType and callType["currentdungeon"] then  
                local now=" (준비중)"                
                message=headStar..getShortDungeonName(keyName)..level..": "..keyLink..now
            else                
                message=covenantIcon..headStar..classStatus.." ▶ "..dungeonIcon..havekey..online
            end           
            
            if sameCheck then                 
                messageLines[sameCheck]=gsub(messageLines[sameCheck],"▶",message.."▶")
            else
                messageLines[mNum]=message
                mNum=mNum+1
            end            
        end
    end      
    
    --메세지 출력
    if channel=="ADDON_GUILD" or channel=="ADDON_PARTY" or channel=="ADDON_OFFICER" or channel=="GUILD" then
        reportAddonMessage(messageLines,channel,who,callType)
    else        
        reportMessageLines(messageLines,channel,who,callType)    
    end    
end

--메세지 출력
function reportMessageLines(messageLines,channel,who,callType)   
    
    -- 애드온 메세지는 애드온 채널로 전송
    if channel=="ADDON_PARTY" then
        reportAddonMessage(messageLines,"PARTY",who,callType)
        return
    elseif channel=="ADDON_GUILD" then
        reportAddonMessage(messageLines,"GUILD",who,callType)
        return
    elseif channel=="ADDON_OFFICER" then
        reportAddonMessage(messageLines,"OFFICER",who,callType)
        return
    elseif channel=="ADDON_WHISPER" then
        if callType=="dice" then
            who=meGame
            reportAddonMessage(messageLines,"WHISPER",who,callType)
            return
        else
            channel="print"
        end        
    end
    
    if channel==nil or (channel=="PARTY" and not IsInGroup()) then channel="print" end
    
    --최종적으로 귓말채널 반환
    if (channel=="WHISPER_IN") or (channel=="WHISPER_OUT")  then
        channel="WHISPER"
    end    
    
    for i=1,#messageLines do 
        if channel=="print"then 
            
            if callType~="help" and callType~="vault" and callType~="onLoad" then
                --도움말 제외 색입히기
                messageLines[i]=MDRcolorizeForPrint(messageLines[i]) 
            end
            
            C_Timer.After(0.1*(i-1), function()
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
