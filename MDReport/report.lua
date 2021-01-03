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

local skullP={}
for i=1,8 do
    skullP["rt"..i]="\124TInterface/TargetingFrame/UI-RaidTargetingIcon_"..i..":12\124t"
end

local classNames={
    "술사","법사","수도","냥꾼","도적","드루","전사","악사","흑마","기사","사제","죽기",
}

function doCheckVersion(channel,who,callType)
    
    local messageLines={}   
    messageLines[1]="▶[쐐기돌 보고서] Ver."..MDR["version"].." (Update: "..MDR["lastUpdate"]..")"  
    if callType["forceversion"]==1 then
        channel="ADDON"
    end
    reportMessageLines(messageLines,channel,who,callType)   
end

function doWarningReport(channel,who,callType) 
    local messageLines={}
    if not warns[1] or warns[1] < warning then
        messageLines[1]="▶[|cFF33FF99쐐기돌 보고서 "..MDR["version"].."|r]: SavedInstances 애드온이 설치되어 있지 않아 쐐기돌 관련 기능이 제한됩니다."
        messageLines[2]="▶"..MDRcolor("노랑",0,"Curseforge")..", "..MDRcolor("보라",0,"Twitch")..", "..MDRcolor("초록",0,"인벤")..", "..MDRcolor("파랑",0,"루리웹").." 등에서 SavedInstances 애드온을 다운받아 설치해주세요."       
        warns[1]=(warns[1] or 0)+1
        channel="print"
    else return end  
    reportMessageLines(messageLines,channel,who,callType)
end

function doOnlyAffixReport(keyword,channel,who,callType)  
    local messageLines={}      
    if tonumber(keyword) then
        local week=keyword       
        local weekTitle=""
        local affixText=GetAnyWeeksAffix(week)
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
        messageLines[1]="▶다음주 속성: "..GetAnyWeeksAffix(1) 
        messageLines[2]="▷2주뒤 속성: "..GetAnyWeeksAffix(2)
        messageLines[3]="▷3주뒤 속성: "..GetAnyWeeksAffix(3)
        messageLines[4]="▷4주뒤 속성: "..GetAnyWeeksAffix(4)        
    else        
        messageLines=GetAffixFullDescription(keyword)
    end  
    reportMessageLines(messageLines,channel,who,callType)    
end

function reportAddonMessage(messageLines,channel,who,callType)
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
                    if channel=="ADDON" then channel="GUILD" end 
                    if callType["forceversion"] then channel="WHISPER" end
                    C_ChatInfo.SendAddonMessage("MDReport", MDRcolor(krClass,6).."_"..messageLines[i], channel,who)
            end)               
        end 
    end 
end

function MDRsendAddonMessage(args,channel,who)
    C_ChatInfo.SendAddonMessage("MDReport", args, channel, who)
end

function MDRprintAddonMessage(...)   
    local message=select(2,...)
    local channel=select(3,...)    
    local who=select(4,...)
    local channelColor={
        ["GUILD"]="|cFF88ff88",
        ["PARTY"]="|cFFaaaaff",
        ["WHISPER"]="|cFFff80ff",
    }    
    who=strsub(MDRsplit(who, "-")[1],1,9)
    
    local class
    for i=1,#classNames do
        if strfind(strsub(message,1,6),classNames[i]) then           
            class=MDRsplit(message,"_")[1]
            message=MDRsplit(message,"_")[2]
        end
    end
    
    for j=1,8 do
        message=gsub(message,"{rt"..j.."}",skullP["rt"..j])
    end
    for i=1,#classNames do        
        message=gsub(message,classNames[i],MDRcolor(classNames[i],0))
    end
    
    --주사위 색입히기
    message=gsub(message,"MDR ▶","|cFF33FF99MDR ▶|r")
    message=gsub(message,"결과 ▶","|cFF33FF99결과 ▶|r")
    local diceNums=MDR.diceNums
    for k,v in pairs(diceNums) do
        message=gsub(message,v,MDRcolor("노랑",0,v))
        
    end         
    
    --주차단수 색입히기
    local park1={}
    local park4={}
    local park10={}
    for i=1,20 do
        tinsert(park1,(i-1).."/")
        tinsert(park4,"/"..(i-1).."/")
        tinsert(park10,"/"..(i-1))
    end
    message=gsub(message,"Χ",MDRcolor("빨강",0,"Χ"))    
    for i=1,#park1 do
        local c1,c4,c10="초록","핑크","하늘"
        if i==1 then 
            c1,c4,c10="회색","회색","회색"            
        end
        message=gsub(message,park4[i],"/"..MDRcolor(c4,0,gsub(park1[i],"/","")).."/")
        message=gsub(message,park10[i],"/"..MDRcolor(c10,0,gsub(park1[i],"/","")))       
        message=gsub(message,park1[i],MDRcolor(c1,0,gsub(park1[i],"/","")).."/")        
    end    
    
    local dungeonNames=MDR.dungeonNames
    if not strfind(message,"쐐기돌") then
        for i=1,#dungeonNames do
            message=gsub(message,dungeonNames[i],MDRcolor("노랑",0,dungeonNames[i]))
        end  
    end 
    if class then
        print(" "..MDRcolor(class,0,"["..who.."]")..": "..message)
    else
        print(" "..channelColor[channel].."["..who.."]:|r "..message)
    end    
end


function doShortReport(chars,channel,who,callType)
    local messageLines={} 
    
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
                havekey="템렙"..math.floor(equipLevel).."/"..math.floor(itemLevel)
            end
            local message=""          
            local sameCheck
            
            if callType=="parking" then                 
                message=skull[class]..classStatus.."["..havekey.."]"..parkingstar
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
            else
                message=skull[class]..havekey.."("..classStatus..")"
            end
            
            if sameCheck then                 
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
    if channel=="ADDON" or channel=="GUILD" then
        reportAddonMessage(messageLines,channel,who,callType)
    else
        --reportAddonMessage(messageLines,channel,who,callType)
        reportMessageLines(messageLines,channel,who,callType)    
    end        
end

--자세한 보고서 작성 및 출력
function doFullReport(chars,channel,who,callType)          
    
    local messageLines={} 
    if chars~=nil then      
        local charName,class=nil,nil
        
        --프린트인 경우 스컬대신 아이콘을 표기하기 위해 체크
        local forceprint=0 
        
        if (channel=="print") and (who==meGame) then 
            forceprint=1           
        end
        
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
            local itemLevel=chars[i]["itemLevel"]
            local equipLevel=chars[i]["equipLevel"]
            local charLevel=chars[i]["charLevel"]
            local online=""            
            local classStatus=""
            local headStar=""
            
            if charName==meAddon then
                online="◀접속중"
            end
            
            local cutName=gsub(charName, "%s%-.+","")
            local shortName
            if callType=="charname"then
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
                    havekey="[{rt7}쐐기돌 없음: 템렙"..math.floor(equipLevel).."/"..math.floor(itemLevel).."]"
                else
                    havekey="[{rt8}만렙 아님: "..charLevel.."레벨]"
                end                
            end
            
            if best and best~=0 then
                parking=","..best..(best4 and ("/"..best4) or "")..(best10 and ("/"..best10) or "")
                parkingstar="▶"
            else
                if charLevel==MDR["SCL"] then
                    parking=",Χ"                    
                else
                    parking=""                    
                end   
                parkingstar="▷"             
            end
            
            --같은 직업이 있을경우 뒤에 이름 붙이기
            if yourClass[class] and yourClass[class]>1 then
                sameClass[class]=(sameClass[class] or 0)+1
                classStatus=class..sameClass[class].."("..shortName..parking..")"
            else                
                classStatus=class.."("..shortName..parking..")"
            end            
            
            if forceprint==1 then
                channel="print"
                headStar=skull[class] 
            else
                headStar=skull[class]                
            end             
            
            local message=""
            local sameCheck
            
            local s=MDR.myMythicKey.start
            local f=MDR.myMythicKey.finish
            
            if callType=="spell" and chars[i]["extraLink"] then
                message=headStar..classStatus..chars[i]["extraLink"]..": "..havekey..online
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
                message=headStar..getShortDungeonName(keyName)..level..": "..keyLink
            else                
                message=headStar..classStatus..": "..havekey..online
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
    if channel=="ADDON" or channel=="GUILD" then
        reportAddonMessage(messageLines,channel,who,callType)
    else        
        reportMessageLines(messageLines,channel,who,callType)    
    end    
end

--메세지 출력
function reportMessageLines(messageLines,channel,who,callType)   
    
    -- 애드온 메세지는 애드온 채널로 전송
    if channel=="ADDON" then
        reportAddonMessage(messageLines,channel,who,callType)
        return
    end   
    
    if channel==nil or (channel=="PARTY" and not IsInGroup()) then channel="print" end
    
    --최종적으로 귓말채널 반환
    if (channel=="WHISPER_IN") or (channel=="WHISPER_OUT")  then
        channel="WHISPER"
    end    
    
    for i=1,#messageLines do 
        if channel=="print"then            
            for j=1,8 do
                messageLines[i]=gsub(messageLines[i],"{rt"..j.."}",skullP["rt"..j])
            end
            for j=1,#classNames do
                messageLines[i]=gsub(messageLines[i],classNames[j],MDRcolor(classNames[j],0))
            end
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
