local meGame,meAddon,krClass=MDR["meGame"],MDR["meAddon"],MDR["krClass"]
local warns={}
local warning=3

local skull={
    ["술사"]="{rt6}",--네모(파랑)
    ["법사"]="{rt6}",--네모(파랑)
    ["수도"]="{rt4}",--역삼(역삼)
    ["냥꾼"]="{rt4}",--역삼(역삼)
	["기원"]="{rt4}",--역삼(역삼)
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
	["기원"]="|T4574311:0:::-5|t",
	["드루"]="|T625999:0:::-5|t",
	["죽기"]="|T135771:0:::-5|t",
	["악사"]="|T1260827:0:::-5|t",
	["냥꾼"]="|T626000:0:::-5|t",
	["법사"]="|T626001:0:::-5|t",
	["수도"]="|T626002:0:::-5|t",
	["기사"]="|T626003:0:::-5|t",
	["사제"]="|T626004:0:::-5|t",
	["도적"]="|T626005:0:::-5|t",
	["술사"]="|T626006:0:::-5|t",
	["흑마"]="|T626007:0:::-5|t",
	["전사"]="|T626008:0:::-5|t",
	--[[
    ["전사"]="|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:0:0:0:-5:256:256:0:64:0:64|t",
    ["법사"]="|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:0:0:0:-5:256:256:64:128:0:64|t",
	["기원"]="|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:0:0:0:-5:256:256:0:64:192:256|t",	
    ["도적"]="|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:0:0:0:-5:256:256:128:192:0:64|t",
    ["드루"]="|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:0:0:0:-5:256:256:192:256:0:64|t",
    ["냥꾼"]="|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:0:0:0:-5:256:256:0:64:64:128|t",
    ["술사"]="|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:0:0:0:-5:256:256:64:128:64:128|t",
    ["사제"]="|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:0:0:0:-5:256:256:128:192:64:128|t",
    ["흑마"]="|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:0:0:0:-5:256:256:192:256:64:128|t",
    ["기사"]="|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:0:0:0:-5:256:256:0:64:128:192|t",
    ["죽기"]="|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:0:0:0:-5:256:256:64:128:128:192|t",
    ["수도"]="|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:0:0:0:-5:256:256:128:192:128:192|t",
    ["악사"]="|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:0:0:0:-5:256:256:192:256:128:192|t",  
	]]	
}   

local classColor={
    ["술사"]="0070DE",
    ["법사"]="40C7EB",
	["기원"]="33937f",
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

local statusIcons={
    ["{DND}"]="|TInterface\\AddOns\\MDReport\\icon\\mode_DND.tga:0:0:-1:-4|t",
    ["{T}"]="|TInterface\\AddOns\\MDReport\\icon\\torghast.tga:0:0:-1:-4|t",
    ["{D}"]="|TInterface\\AddOns\\MDReport\\icon\\dungeon.tga:0:0:-1:-4|t",
    ["{R}"]="|TInterface\\AddOns\\MDReport\\icon\\raid.tga:0:0:-1:-4|t",
    
} 

local colorT={}
local maxP=MDR["maxParking"]

for i=1,40 do
    local c="1eff00"	
	if maxP==20 then
		if i>=20 then
			c="de57a3"        
		elseif i>=18 then
			c="e6cc80"        
		elseif i>=15 then			
			c="fe7f00"
		elseif i>=13 then
			c="a234ed"
		elseif i>=10 then
			c="006fdc"
		else
			c="1eff00"
		end 
	else
		if i>=15 then
			c="e6cc80"        
		elseif i>=14 then
			c="ff8000"        
		elseif i>=12 then
			c="a335ee"           
		elseif i>=10 then
			c="0070dd"
		elseif i>=8 then
			c="1eff00"
		else
			c="1eff00"
		end 
	end
    colorT[i]="|cff"..c..i.."|r"        
end

MDR.statusIcons=statusIcons
MDR.skull=skull
MDR.classColor=classColor
MDR.classIcon=classIcon

local skullP={}
for i=1,8 do
    skullP["rt"..i]="\124TInterface/TargetingFrame/UI-RaidTargetingIcon_"..i..":12:::-4\124t"
end

local classNames={
    "술사","법사","수도","냥꾼","기원","도적","드루","전사","악사","흑마","기사","사제","죽기",
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
        local affixs={}
        for i=1,4 do
            local header=""
            affixs[i]=GetAnyWeeksAffix(i,channel)
            if not affixs[i] then break end
            if i==1 then 
                header="▶다음주"
            else
                header="▷"..i.."주뒤"
            end
            messageLines[i]=header.." 속성: "..affixs[i]
        end
        --[[
        messageLines[1]="▶다음주 속성: "..GetAnyWeeksAffix(1,channel) 
        messageLines[2]="▷2주뒤 속성: "..GetAnyWeeksAffix(2,channel)
        messageLines[3]="▷3주뒤 속성: "..GetAnyWeeksAffix(3,channel)
        messageLines[4]="▷4주뒤 속성: "..GetAnyWeeksAffix(4,channel)        
        ]]
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
    elseif channel=="print" then
        reportMessageLines(messageLines,channel,who,callType) 
        return
    end 
    
    local status=MDRgetCurrentStatus()
    local delay=0
    if status~="" and channel~="PARTY" then delay=0.5 end
    
    for i=1,#messageLines do 
        C_Timer.After(delay+0.2*(i-1), function()                
                if callType["forceversion"] then channel="WHISPER" end
                --print(strlen(messageLines[i]))
                C_ChatInfo.SendAddonMessage("MDReport", MDRcolor(krClass,6).."_"..MDRgetCurrentStatus()..messageLines[i], channel,who)
        end)             
        
    end 
end

function MDRsendAddonMessage(args,channel,who)	
	if strfind(args,"금고") or strfind(args,"기록") or strfind(args,"도움말") then
		MDRCommands(args, editbox)
	else
		C_ChatInfo.SendAddonMessage("MDReport", args, channel, who)
	end
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
        icon_class[skull[c]..c]=classIcon[c]
        icon["{"..c.."}"]=classIcon[c]    
        icon_colon[skull[c]..c..":"]=classIcon[c].."|cff"..classColor[c]..":|r"  
        icon_color[skull[c]..c]=classIcon[c].."|cff"..classColor[c]
        icon_class_arrow[skull[c]..c.."▶%["]=" ["..classIcon[c].."|cff"..classColor[c]..":|r"
        color_class[c]="|cff"..classColor[c]..c.."|r"     
    end 
    --주차정보를 포함하는 경우
    if strfind(message,"#") or strfind(message,"/") or strfind(message,"Χ") then
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
        for k,v in pairs(icon_class) do            
            message=gsub(message,k,v)          
        end
        if strfind(message,"쐐기돌") then            
        end        
    end   
    --직업 아이콘 반환
    
    for k,v in pairs(icon) do
        message=gsub(message,k,v) 
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
    
    
    --온라인
    local on_green="|TInterface\\AddOns\\MDReport\\icon\\on_g.tga:0:0.5:-1:-5|t" 
    local on_pink="|TInterface\\AddOns\\MDReport\\icon\\on_p.tga:0:0.5:-1:-5|t" 
    message=gsub(message,"{OG}",on_green)
    message=gsub(message,"{OP}",on_pink)
    message=gsub(message,"접속중","|cff48ff00접속중|r")
    message=gsub(message,"준비중","|cff00ccff준비중|r")
    message=gsub(message,"진행중","|cffff00b4진행중|r")    
    
    if strfind(strsub(message,1,1)," ") then 
        message=strsub(message,2,-1)
    end
    
    --징표    
    message=gsub(message,"{(rt%d)}",function(a) return skullP[a] end)    
    
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
    message=gsub(message,"Χ",MDRcolor("빨강",0,"Χ")) 
    
    message=gsub(message,"(%d+)([/#])", function(a,b) return (colorT[tonumber(a)] or a)..b end)
    
    --완,미완 변환
    message=gsub(message,"{완}","|TInterface\\RaidFrame\\ReadyCheck-Ready:0:0.6:0:-5|t")
    message=gsub(message,"{미완}","|TInterface\\RaidFrame\\ReadyCheck-NotReady:0:0.6:0:-5|t")
    message=gsub(message,"{물}","|TInterface\\RaidFrame\\ReadyCheck-Waiting:0:0.6:0:-5|t")
    
    --폭군,경화    
    message=gsub(message,"{폭}","|T236401:0:::-5|t")
    message=gsub(message,"{경}","|T463829:0:::-5|t")    
    
    --색깔 코드
    message=gsub(message,"{CT}","|cffed004e")
	message=gsub(message,"{CW}","|cffde57a3")
    message=gsub(message,"{CA}","|cffe6cc80")    
    message=gsub(message,"{CL}","|cfffe7f00")
    message=gsub(message,"{CE}","|cFFa234ed")
    message=gsub(message,"{CR}","|cFF006fdc")
    message=gsub(message,"{CC}","|cFF1dfe00")
    message=gsub(message,"{CN}","|cFFe7e7e7")
    message=gsub(message,"{CG}","|cFF6d6d6d")
    message=gsub(message,"{CX}","|r")
    
    --아이템 보너스
	if strfind(message,"{iH") then	
 		message=MDRcolorizeForItem(message)
    end
	
    --던전 색입히기
    local dungeonNames=MDR.dungeonNames
    local dungeonNamesFull=MDR.dungeonNamesFull
    if not strfind(message,"쐐기돌") and not strfind(message,"단 ") then
        for i=1,#dungeonNamesFull do            
            message=gsub(message,dungeonNamesFull[i],MDRcolor("노랑",0,dungeonNamesFull[i]))
        end  
        for i=1,#dungeonNames do            
            message=gsub(message,dungeonNames[i],MDRgetCovenantIcon(dungeonNames[i])..MDRcolor("노랑",0,dungeonNames[i]))
        end 
    end 
    return message
end

function MDRcolorizeForItem(message)
	local CM="|cffff8800치|r|cffbb88ff특|r"
	local CH="|cffff8800치|r|cffffff00가|r"
	local CV="|cffff8800치|r|cff88bbff유|r"
	local HV="|cffffff00가|r|cff88bbff유|r"
	local HM="|cffffff00가|r|cffbb88ff특|r"
	local HC="|cffffff00가|r|cffff8800치|r"
	local VM="|cff88bbff유|r|cffbb88ff특|r"
	local VH="|cff88bbff유|r|cffffff00가|r"
	local VC="|cff88bbff유|r|cffff8800치|r"
	local MC="|cffbb88ff특|r|cffff8800치|r"
	local MH="|cffbb88ff특|r|cffffff00가|r"
	local MV="|cffbb88ff특|r|cff88bbff유|r"
	message=gsub(message,"치특",CM)
	message=gsub(message,"치가",CH)
	message=gsub(message,"치유",CV)
	message=gsub(message,"가유",HV)
	message=gsub(message,"가특",HM)
	message=gsub(message,"가치",HC)
	message=gsub(message,"유특",VM)
	message=gsub(message,"유치",VC)
	message=gsub(message,"유가",VH)
	message=gsub(message,"특치",MC)
	message=gsub(message,"특가",MH)
	message=gsub(message,"특유",MV)
	
	message=gsub(message,"특화","|cffbb88ff특화|r")
	message=gsub(message,"유연","|cff88bbff유연|r")
	message=gsub(message,"가속","|cffffff00가속|r")
	message=gsub(message,"치명","|cffff8800치명|r")
	message=gsub(message,"사효","|cffdb24b2사효|r")
	message=gsub(message,"착효","|cffe6cc80착효|r")	
	
	message=gsub(message,"양손도검","|T135349:0:::-5|t")
	message=gsub(message,"양손둔기","|T133053:0:::-5|t")
	message=gsub(message,"양손도끼","|T132400:0:::-5|t")	
	
	message=gsub(message,"단검","|T135650:0:::-5|t")
	message=gsub(message,"도검","|T135351:0:::-5|t")
	message=gsub(message,"둔기","|T133054:0:::-5|t")
	message=gsub(message,"도끼","|T132408:0:::-5|t")	
	message=gsub(message,"전투검","|T3084656:0:::-5|t")
	message=gsub(message,"장착무기","|T132938:0:::-5|t")	
	
	message=gsub(message,"지팡이","|T3461503:0:::-5|t")
	message=gsub(message,"장창","|T3054897:0:::-5|t")
	
	message=gsub(message,"방패","|T3482400:0:::-5|t")
	message=gsub(message,"보조장비","|T3488376:0:::-5|t")
	message=gsub(message,"마법봉","|T135477:0:::-5|t")
	
	message=gsub(message,"활","|T135496:0:::-5|t")
	message=gsub(message,"석궁","|T135537:0:::-5|t")
	message=gsub(message,"총","|T135615:0:::-5|t")
		
	message=gsub(message,"{iH}","|cffa335ee|Hitem:")
	message=gsub(message,"{iHL}","|cfffe7f00|Hitem:")
	
	message=gsub(message,"{iB}","::::::::60::::3:1605:6807:6646:|h[") --기본값
	message=gsub(message,"{iBDF}","::::::::60:102::23:1:3524:1:28:2157:::::|h[") --용군단
	message=gsub(message,"{iBS}","::::::::60::::3:1605:6807:6646:|h[") --어둠땅	
	message=gsub(message,"{iBB}","::::::::60::::2:3139:1472:4779:|h[") --격아
	message=gsub(message,"{iBL}","::::::::60::::3:3138:1501:6646:|h[") --군단
	message=gsub(message,"{iBD}","::::::::60::::2:3173:6646:|h[") --드레노어
	
	message=gsub(message,"{iE}","]|h|r")   
	return message
end

function MDRprintAddonMessage(...) 
    local yourStatus=MDRgetCurrentStatus()
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
    
    local status=""      
    for k,v in pairs(MDR.statusIcons) do
        if strfind(message,k) then
            message=gsub(message,k,"")            
            status=v            
        end        
    end
    
    local ch
    local statusIcon=status
	local inLockdown = InCombatLockdown()
    if channel=="GUILD" then
        if yourStatus~="" and inLockdown then return end
        ch=channelColor[channel].."G"        
    elseif channel=="PARTY" then
        ch=channelColor[channel].."P"
        statusIcon=""
    elseif channel=="OFFICER" then
        ch=channelColor[channel].."O"
    elseif channel=="WHISPER" then
        ch=channelColor[channel].."W"
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
    
    if class then
        print(ch..statusIcon..MDRcolor(class,0,"["..who.."]")..": "..message)
    else
        print(ch..statusIcon..channelColor[channel].."["..who.."]:|r "..message)
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
            local bestLevelCompleted=chars[i]["bestLevelCompleted"]
			local scoreLink=chars[i]["scoreLink"]
            local runs=chars[i]["runs"]            
            local covenant=chars[i]["covenant"]
            local covenantID=MDRgetCovenantID(covenant)
            local itemLevel=chars[i]["itemLevel"]            
            local equipLevel=chars[i]["equipLevel"]
            local charLevel=chars[i]["charLevel"]
            local online,onC,onR,parkC="","","",""
            local classStatus=""            
            local cutName=gsub(charName, "%s%-.+","")
            local shortName=strsub(cutName,1,9)
            local shorterName=strsub(cutName,1,6)
            
            if yourClass[class] and yourClass[class]>1 then
                sameClass[class]=(sameClass[class] or 0)+1                
                classStatus="{"..class.."}"..shorterName
            else                
                classStatus="{"..class.."}"                
            end       
            local CompletedIcon=""
            if bestLevelCompleted=="now" then                
                CompletedIcon="{물}"
            elseif bestLevelCompleted then
                CompletedIcon="{완}"
            elseif not bestLevelCompleted then
                CompletedIcon="{미완}"                    
            end
            
            if charName==meAddon then                
                if channel=="ADDON_PARTY" then
                    onC=" |cff48ff00"
                    online="{OG}"
                else
                    onC=" |cffff00b4"
                    online="{OP}"
                end
                onR="|r "
                parkC="|cff48ff00"
            else
                parkC="|cff00ccff"
            end            
            
            --던전 이름 줄이기
            keyName=getShortDungeonName(keyName)            
            
            local havekey,parking, parkingstar="","",""  
            if best and best ~=0 then 
                if callType=="parking" then
                    parkingstar=":"..CompletedIcon..best..(best4>0 and ("/"..best4) or "")..(best10>0 and ("/"..best10) or "")..(runs>0 and "#"..parkC..runs.."회|r" or "")                   
                else  
                    parkingstar=","..CompletedIcon..best..(best4 and ("/"..best4) or "")..(best10 and ("/"..best10) or "")
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
            elseif charLevel==MDR.SCL then
                local E=math.floor(equipLevel)
                local H=math.floor(itemLevel)
                if E==H then
                    H=""
                else
                    H="("..H..")"
                end
                havekey="템렙"..E..H
            else
                havekey=charLevel.."레벨"
            end
            local message=""          
            local sameCheck
            
            if callType=="parking" then                 
                message=onC.."["..online..classStatus..parkingstar.."]"..onR
            elseif callType=="all" then                
                message=online..classStatus.."["..havekey.."]:"..classStatus                  
            elseif chars[i]["extraLink"] and callType=="spell"then
                message="["..online.."{"..classStatus.."}:"..havekey.."]"..chars[i]["extraLink"]
            elseif chars[i]["extraLink"] and callType=="item"then
                sameCheck=tonumber(strsub(chars[i]["extraLink"],0,1))                
                if sameCheck then                   
                    message=", "..online..classStatus..":"..havekey
                else                    
                    message="["..online..classStatus..":"..havekey.."]▶"..chars[i]["extraLink"]
                end                
            elseif callType["covenant"] or callType["covenantnow"] or callType["covenantall"] then
                local coveName
                if channel=="ADDON_PARTY" and #chars<2 then -- 성약단 풀네임
                    coveName=MDRcolor(covenant)                    
					--coveName=MDRcolor(covenant,0,getShortDungeonName(covenant))
                else -- 그 외
                    coveName=MDRcolor(covenant,0,getShortDungeonName(covenant))
                end    
                
                message=onC.."["..online..classStatus..":{c"..covenantID.."}"..coveName.."]"..onR
			elseif callType["scorelink"] then
				print("dd")
				message=scoreLink
            else
                if isAddonMessage==1 then
                    message=onC.."["..online..classStatus..":"..havekey.."]"..onR
                else
                    message=online..skull[class]..havekey.."("..classStatus..")"
                end           
            end
            
            if sameCheck and messageLines[sameCheck] then                 
                messageLines[sameCheck]=gsub(messageLines[sameCheck],"]▶",message.."]▶")
            else
                messageLines[mNum]=message
                mNum=mNum+1
            end                 
        end       
        
        -- 한줄로 줄이기        
        local oneLineMessage={}
        local num=1
        local maxNum=6       
        
        local length=0
        for i=1,#messageLines do
            local message=messageLines[i]
            length=length+strlen(message)
            if length>=240 then
                maxNum=i-1
                break
            end                
        end          
        
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
    if isAddonMessage==1 then
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
            local bestLevelCompleted=chars[i]["bestLevelCompleted"]            
            local runs=chars[i]["runs"]            
            local scoreT=chars[i]["score"]
			local scoreLink=chars[i]["scoreLink"]
            local covenant=chars[i]["covenant"] 
            local covenantID=MDRgetCovenantID(covenant)            
            local itemLevel=chars[i]["itemLevel"]
            local equipLevel=chars[i]["equipLevel"]
            local charLevel=chars[i]["charLevel"]
            local online,classStatus,headStar,score_desc="","","",""            
            
            if charName==meAddon then
                online=" {OG}접속중"
            end
            
            local CompletedIcon=""
            if bestLevelCompleted=="now" then                
                CompletedIcon="{물}"
            elseif bestLevelCompleted then
                CompletedIcon="{완}"
            elseif not bestLevelCompleted then
                CompletedIcon="{미완}"                    
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
            
            if charLevel==MDR["SCL"] then
                local affix
				local howManyDungeons=#MDR.dungeonNameToID or 8
                if isThisWeekHasSpecificAffix(9) then
                    affix="폭군"
                else
                    affix="경화"
                end
                local total=scoreT["종합점수"] or 0                
                total=tonumber(total)
                
                local color
                if total>=275*MDR.DNum then
                    color="{CL}"
                elseif total>=225*MDR.DNum then
                    color="{CE}"
                elseif total>=187.5*MDR.DNum then
                    color="{CR}"
                elseif total>=125*MDR.DNum then
                    color="{CC}"
                else
                    color="{CN}"
                end    

				score_desc=" ["..color..total.."|r점"..MDRgetAffixIcon(affix)..MDRgetDungeonScore(charName,affix).."]"
            end
            
            if best and best~=0 then
                if isAddonMessage==1 then
                    parking="("..CompletedIcon..best..(best4>0 and ("/"..best4) or "")..(best10>0 and ("/"..best10) or "")..(runs>0 and "#|cff00ccff"..runs.."회|r" or "")..")"
                else
                    parking=","..CompletedIcon..best..(best4>0 and ("/"..best4) or "")..(best10>0 and ("/"..best10) or "")
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
                if callType=="item" then
                    classStatus=class
                else
                    classStatus=class..shortName.." "..parking
                end
                
            else
                classStatus=class.."("..shortName..parking..")"
            end
            
            headStar=skull[class]
            
            local message=""
            local sameCheck
            
            --local s=MDR.myMythicKey.start or MDR.myMythicKey.onLoad
            --local f=MDR.myMythicKey.finish or MDR.myMythicKey.newkey
			
			local MythicKeyB=MDRconfig.Char[meAddon].MythicKeyB or {}
			local MythicKey=MDRconfig.Char[meAddon].MythicKey or {}
            
            local on=""
            if channel=="ADDON_PARTY" then
                on="{OG}"
            else
                on="{OP}"                    
            end  
            
            if callType=="spell" and chars[i]["extraLink"] then
                message=headStar..classStatus..": "..chars[i]["extraLink"].." "..havekey..online
            elseif callType=="item" and chars[i]["extraLink"] then                
                sameCheck=tonumber(strsub(chars[i]["extraLink"],0,1))
                if sameCheck then                   
                    message=", "..headStar..classStatus..":"..havekey
                else      
                    message=on..headStar..classStatus..":"..havekey.."▶"..chars[i]["extraLink"] 						
                end 
            elseif callType and callType["newkey"] then								
				if not MythicKey.level or not MythicKeyB.level then return end				
                local up,upg="",""
				
				local startLevel=MythicKeyB.level				
				if (MythicKeyB.event=="start" or MythicKeyB.event=="finish") and MythicKeyB.level~=2 then
					startLevel=startLevel+1					
				end
				
                if MythicKeyB.event=="finish" and MythicKey.level > startLevel then --새로 받은 돌의 단수가 올라가면
                    up="|cff48ff00▲"..(MythicKey.level-startLevel).."상|r"
					upg="▲"..(MythicKey.level-startLevel).."상"
				elseif MythicKeyB.event=="newkey" and MythicKey.level==MythicKeyB.level and MythicKey.name~=MythicKeyB.name then -- 돌 바꿈
					up="|cffffff00돌 바꿈|r"					
					upg="돌 바꿈"
				elseif MythicKeyB.event=="newkey" and MythicKey.level~=MythicKeyB.level and MythicKey.name==MythicKeyB.name then -- 단수 낮춤
					up="|cffffff00▼단수 낮춤|r"
					upg="▼단수 낮춤"
				elseif MythicKeyB.event=="finish" and MythicKey.name~=MythicKeyB.name then -- 시간초과
					up="|cffff00b4▼시간초과|r"
					upg="▼시간초과"
				elseif MythicKeyB.event=="start" and MythicKey.level<startLevel and not C_ChallengeMode.GetActiveChallengeMapID()then -- 중도포기
					up="|cffff00b4▼중도포기|r"
					upg="▼중도포기"
					startLevel=MythicKeyB.level
				else
					return
				end

                local before=getShortDungeonName(MythicKeyB.name)
                local after=getShortDungeonName(MythicKey.name)
                local coveIconBefore="{c"..MDRgetCovenantID(before).."}"
                local coveIconAfter="{c"..MDRgetCovenantID(after).."}"
                
				local InGuildParty=InGuildParty()
				if MythicKeyB.event=="finish" and channel=="ADDON_GUILD" and InGuildParty then
					isAddonMessage=0
					channel="GUILD"
					message="MDR ▶ ["..before..(startLevel).."] ▶ ["..after..MythicKey.level.."] ("..upg..") : "..(MythicKey and MythicKey.link or keyLink)
				else
					message="새 돌: ["..coveIconBefore..before..(startLevel).."] ▶ ["..coveIconAfter..after..MythicKey.level.."] ("..up..") : "..(MythicKey and MythicKey.link or keyLink)
				end
            elseif callType and callType["currentdungeon"] then                
                local now=" "..on.."준비중"
                local covenant=MDRgetCovenantID(getShortDungeonName(keyName))
                local coveIcon="{c"..covenant.."}"
                message=coveIcon..getShortDungeonName(keyName)..level..": "..keyLink..now
            elseif callType["covenantall"] then
                message=headStar..classStatus.." ▶{c"..covenantID.."}"..MDRcolor(covenant)
			elseif callType["scorelink"] then				
				message=scoreLink
				isAddonMessage=0
				channel="PARTY"
            else                
                message=covenantIcon..headStar..classStatus.."▶"..(keyLink and getShortDungeonName(keyName)..level or dungeonIcon..havekey)..score_desc
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
    if isAddonMessage==1 then
        reportAddonMessage(messageLines,channel,who,callType)
    else        
        reportMessageLines(messageLines,channel,who,callType)    
    end    
end

--메세지 출력
function reportMessageLines(messageLines,channel,who,callType)

	if channel==nil or ((channel=="PARTY" or channel=="ADDON_PARTY") and not IsInGroup()) then channel="print" end 
	
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
        end        
        reportAddonMessage(messageLines,"WHISPER",who,callType)
        return 
    end
    
    --최종적으로 귓말채널 반환
    if (channel=="WHISPER_IN") or (channel=="WHISPER_OUT")  then
        channel="WHISPER"
    end   
    
    local status=MDRgetCurrentStatus()
    local delay=0
    if (status~="" and channel~="PARTY" and channel~="print") then delay=0.5 end
    
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
            C_Timer.After(delay+0.2*(i-1), function()
					--print(messageLines[i])
                    SendChatMessage(messageLines[i], channel,nil,who) 
            end)   
        end 
    end 
end

