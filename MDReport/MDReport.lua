if not MDR then
    MDR={}
end

C_ChatInfo.RegisterAddonMessagePrefix("MDReport")

MDR["version"]="@project-version@"
MDR["lastUpdate"]="@project-date-iso@"
MDR["guide"]=0
MDR["cooltime"]=2
MDR["meGame"]=UnitName("player").."-"..GetRealmName() 
MDR["meAddon"]=UnitName("player").." - "..GetRealmName() 
MDR["krClass"],MDR["className"]=UnitClass("player")
MDR["lastSeen"]=4838400 --8주
MDR["maxChar"]=3
MDR["textLength"]=3
MDR["maxParking"]=15 --어둠땅 2시즌
MDR["SCL"]=60--어둠땅 만렙
MDR.DefaultDelay=15 --지연시간 기본값

local guildWarn=0
local tips={}
local warns=100
local meGame,meAddon,krClass,className=MDR["meGame"],MDR["meAddon"],MDR["krClass"],MDR["className"]
local who,channel,level,level2,callTypeT
local comb,onlyOnline,onlyMe,onlyYou,CharName,except
local callType,callTypeB,keyword,keyword2,keyword3={},{},{},{},{}
local DIL={}
DIL.min=210 --깡신
DIL.max=236 --15단
DIL.base=160 --기준템렙
DIL.gap=(DIL.max-DIL.min)/MDR["maxParking"]
for i=1,MDR["maxParking"] do
    DIL[i]=DIL.base + DIL.gap*i --단수별 허용레벨 / 드랍템 레벨
end
MDRconfig=MDRconfig or {}

C_Timer.After(3, function()
        C_MythicPlus.RequestMapInfo()
        C_MythicPlus.RequestRewards()
        LoadAddOn("Blizzard_WeeklyRewards") 
        if MDR.myMythicKey==nil then
            MDR.myMythicKey={}
        end
        MDRconfig=MDRconfig or {}
        if not MDRconfig.delay then
            MDRconfig.delay=MDR.DefaultDelay
        end
        tinsert(UISpecialFrames, "WeeklyRewardsFrame")
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

MDR.dungeonNameToID = {
    ["티르너"] = 375,
    ["죽상"] = 376,
    ["저편"] = 377,
    ["속죄"] = 378,
    ["역병"] = 379,
    ["핏심"] = 380,
    ["승천"] = 381,
    ["투기장"] = 382,  
}

local clothClass={"법사","사제","흑마"}
local leatherClass={"드루","수도","도적","악사"}
local mailClass={"냥꾼","술사"}
local plateClass={"전사","죽기","기사"}
local shieldClass={"전사","기사","술사"}

function filterVALUES(VALUES)  
    
    C_Timer.After(MDR["cooltime"], function()
            MDR["running"]=0
            MDR["who"]=nil
    end)  
    
    local who,channel,level,level2,callTypeT
    local onlyMe,onlyYou,onlyOnline,except,onlyForMe
    local callType,callTypeB,keyword,keyword2,keyword3={},{},{},{},{}
    
    if VALUES~=nil then
        who=VALUES["who"]
        channel=VALUES["channel"]
        level=VALUES["level"]
        level2=VALUES["level2"]  
        callTypeT=VALUES["callTypeT"]  
        onlyMe=VALUES["onlyMe"]
        onlyYou=VALUES["onlyYou"]
        onlyOnline=VALUES["onlyOnline"]  
        except=VALUES["except"]
        onlyForMe=VALUES["onlyForMe"]
        for i=1,#callTypeT do
            callTypeB[i]=callTypeT[i][1]   
            --print(i..":"..callTypeT[i][1])
            callType[callTypeT[i][1]]=1
            if callTypeT[i][1]=="dungeon" then 
                if not keyword["dungeon"] then
                    keyword["dungeon"]={}
                end
                if not tContains(keyword["dungeon"],callTypeT[i][2]) then
                    tinsert(keyword["dungeon"],callTypeT[i][2])    
                end   
            else
                
                keyword[callTypeT[i][1]]=callTypeT[i][2]
            end
            
            --print(callTypeT[i][2])
            --keyword[callTypeT[i][1]]=callTypeT[i][2]
            keyword2[callTypeT[i][1]]=callTypeT[i][3]
            keyword3[callTypeT[i][1]]=callTypeT[i][4]   
        end 
        CharName=VALUES["CharName"]   
        
    end  
    
    local length=MDR["textLength"]
    local kLength=math.floor((length-1)/3+1)
    
    -- 찾는 사람을 지정한 경우
    if onlyYou then 
        if who==meGame and channel~="ADDON_GUILD" and channel~="ADDON_PARTY" and channel~="ADDON_OFFICER" then 
            if strlen(onlyYou)<length then   
                print("|cffff0000▶|r"..MDRcolor(onlyYou,-2)..": 입력하신 문자열 길이가 너무 짧습니다. 찾고자 하는 대상의 이름을 좀 더 길게 입력해주세요. (한글 |cFFFFF569"..kLength.."|r글자 이상, 영문 |cFFFFF569"..length.."|r자 이상)")
                return --검색어가 짧으면 무시
            else
                local message,range="",""
                --print((level or"").."~"..(level2 or""))   
                if level==2 and level2 then
                    range=", "..MDRcolor("도적",0,level2.."단 이하")   
                elseif level and level2==99 then
                    range=", "..MDRcolor("도적",0,level.."단 이상")
                elseif level and not level2 then
                    range=", "..MDRcolor("도적",0,level.."단")
                elseif level and level2 then
                    range=", "..MDRcolor("도적",0,level.."~"..level2.."단")
                end
                
                local cmdLines,space="",", "
                local callTypes={}
                
                for i=1,#callTypeT do 
                    local type=0
                    local word=keyword[callTypeB[i]]
                    local what
                    if callTypeT[i][1]=="class" then
                        type=1
                        what=MDRcolor(word,type)
                    elseif callTypeT[i][1]=="dungeon" then   
                        word=getFullDungeonName(callTypeT[i][2])
                        if except==1 then
                            what=MDRcolor("회색",0,word)
                        else
                            what=MDRcolor("노랑",0,word)
                        end    
                    elseif callTypeT[i][1]=="spec" then
                        type=10
                        what=MDRcolor(word,type)
                    elseif CharName then
                        word=CharName
                        what=MDRcolor(word,type)
                    else
                        what=MDRcolor(word,type)
                    end 
                    if (not callTypes[callTypeB[i]] or callTypeT[i][1]=="dungeon") then
                        if (callTypeT[i][1]=="all" and not callType["dungeon"] and not callType["parking"]) or
                        callTypeT[i][1]~="all" then 
                            if not strfind(cmdLines,word) then
                                cmdLines=cmdLines..what..space
                                callTypes[callTypeB[i]]=1
                            end    
                        end
                    end    
                end
                if strsub(cmdLines,strlen(space)*-1)==space then
                    cmdLines=strsub(cmdLines,1,strlen(space)*-1-1)
                end
                
                --제외 색입히기
                local exc   
                if callTypes["dungeon"] and except==1 then
                    exc=MDRcolor("죽기",0," '제외'")
                end
                
                cmdLines=cmdLines..(exc or"")..range
                local CL=gsub(cmdLines,"|r","")
                local eul=MDRko(CL,"을")   
                
                message=" 님에게 "..cmdLines..eul.." 요청합니다."
                --end    
                print("|cff00ff00▶|r"..MDRcolor("["..onlyYou.."]",-1)..message)
            end  
        end  
        
    end 
    
    if CharName then
        if strlen(CharName)<length then
            if who==meGame then 
                print("|cffff0000▶|r"..MDRcolor(CharName,-2)..": 입력하신 문자열 길이가 너무 짧습니다. 찾고자 하는 대상의 이름을 좀 더 길게 입력해주세요. (한글 |cFFFFF569"..kLength.."|r글자 이상, 영문 |cFFFFF569"..length.."|r자 이상)")
            end  
        return end --검색어가 짧으면 무시 
    end
    
    if callType["levelrange"] and level2==nil then
        VALUES["level2"]=tonumber(keyword["levelrange"])  
    end 
    
    --범위지정인데 범위값이 없으면 리턴
    if callType["levelrange"] and level==nil then
        return
    end 
    
    --내가 길드로 요청하는 경우
    if channel=="GUILD" then
        
        if who==meGame then
            if guildWarn<2 then
                local msg=VALUES["msg"]
                if strfind(strsub(msg,1,2),"!") then
                    msg=strsub(msg,2,-1)
                end  
                print("▶|cFF40ff40길드채팅|r은 모두가 사용하는 공간입니다. 애드온을 사용하지 않는 분들을 위해 다음 명령어를 활용해보세요. |cffffff00/!|r "..MDRcolor(msg,0).." (애드온 사용자 간에만 메세지를 주고 받을 수 있습니다.)")
                guildWarn=guildWarn+1
            end
            local msg=VALUES["msg"]
            if strfind(strsub(msg,1,1),"!") then
                msg=strsub(msg,2,-1)
            end
            local m=MDRconfig.MannerMode or 0
            local at=""
            if m==1 then--매너모드
                if strfind(msg,"@") then
                    msg=gsub(msg,"@","")   
                else
                    at="@"  
                end  
            end 
            MDRsendAddonMessage("!"..at..msg,"GUILD",meGame)  
            return
        else --길드요청을 내가보낸게 아니면 리턴
            return
        end  
    end
    
    --파티고 무슨돌이 아니면
    if channel=="PARTY" and not callType["newkey"] then
        if who==meGame then
            MDRsendAddonMessage(VALUES["msg"],"PARTY",meGame)
            return
        else 
            return
        end
    end 
    
    --버전요청을 한 사람이 나일 경우 리턴
    if callType["forceversion"] and who==meGame then
        return
    end  
    
    --명령어가 !내돌or !지금내돌 인데 내가 보낸게 아니면 리턴
    if callType["mykey"] and who~=meGame and channel~="WHISPER_OUT" then 
        return 
    end  
    
    --내가 보낸 귓말이고, 나한테 보냈거나 !내돌/!지금내돌을 요청한게 아니면 리턴
    if (channel=="WHISPER_OUT") and (who==meGame or callType["mykey"]~=1 ) then
        return  
    end  
    
    --채널이 없으면 프린트로 변경
    if channel==nil then channel="print" end  
    
    local here,_=GetInstanceInfo()
    
    local coveHere=MDRgetCovenantID(getShortDungeonName(here))
    
    local coveName=MDRgetCovenantName(coveHere)
    
    --모든 성약단 찾는 경우
    if callType["covenantall"] then
        local covenant=C_Covenants.GetActiveCovenantID()
        local covenantIcon="{c"..covenant.."}"
        local messageLines={}  
        
        local type
        if channel=="ADDON_GUILD" or channel=="ADDON_OFFICER" or channel=="GUILD" then
            type="모든 성약단"
        elseif channel=="ADDON_PARTY" or channel=="PARTY" then
            if coveHere>0 then
                callTypeT={}
                callTypeT[1]=getCallTypeTable(coveName)
                callTypeT[1][1]="covenantnow"
                
                VALUES["callTypeT"]=callTypeT
                callType["covenantnow"]=1   
                keyword["covenantall"]=coveName
                type="일치하는 성약단"
            else
                if not onlyYou then                
                    onlyOnline=1
                end                
            end  
        end
    end 
    
    if (callType["covenant"] or callType["covenantnow"]) and coveHere>0 and (channel=="ADDON_PARTY" or channel=="PARTY") then
        onlyOnline=1 
    end 
    
    -- 귓말요청시 귓채널로 변경
    if onlyForMe==1 
    --and channel=="ADDON_GUILD"
    then
        channel="ADDON_WHISPER"
    end
    
    if (channel=="ADDON_PARTY" or channel=="ADDON_GUILD" or channel=="ADDON_WHISPER" or channel=="ADDON_OFFICER") and VALUES["msg"] then  
        local mdrcolor={
            ["ADDON_PARTY"]="|cFFaaaaffMDR▶|r ",
            ["ADDON_GUILD"]="|cFF33FF99MDR▶|r ",
            ["ADDON_WHISPER"]="|cFFF5aCdAMDR▶|r ",
            ["ADDON_OFFICER"]="|cFF40C040MDR▶|r ",   
        }
        local status=MDRgetCurrentStatus()
        local statusIcon=""
        
        local doDNDalert=0
        if channel=="ADDON_GUILD" and status~="" then
            doDNDalert=1
            statusIcon=MDR.statusIcons[status]
        end
        
        local name=MDRsplit(who,"-")[1]
        local message,range="",""
        if callType["parking"] and level then
            range=MDRcolor("도적",0,level.."단").." "
        elseif level==2 and level2 then
            range=", "..MDRcolor("도적",0,level2.."단 이하")   
        elseif level and level2==99 then
            range=", "..MDRcolor("도적",0,level.."단 이상")
        elseif level and not level2 then
            range=", "..MDRcolor("도적",0,level.."단")
        elseif level and level2 then
            range=", "..MDRcolor("도적",0,level.."~"..level2.."단")
        end
        
        local cmdLines,space="",", "
        local callTypes={}
        
        for i=1,#callTypeT do 
            local type=0
            local word=keyword[callTypeB[i]]
            local what,icon
            if callTypeT[i][1]=="all" then   
                icon="\124T525134:0:::-4\124t"
                what=icon..MDRcolor(word,type)
            elseif callTypeT[i][1]=="emote" then   
                if word=="얼라이언스를위하여" then
                    icon="|TInterface\\TargetingFrame\\UI-PVP-ALLIANCE:0:0:-4:-4:64:64:0:32:0:38|t"
                    what="외칩니다 : "..icon..MDRcolor("초록",0,"<얼 라 이 언 스>").."를 위하여!"
                else
                    what="감정표현입니다 : "..MDRcolor(word,type) 
                end   
            elseif callTypeT[i][1]=="class" then
                type=1
                icon=MDR.classIcon[callTypeT[i][2]]
                what=icon..MDRcolor(word,type)
            elseif callTypeT[i][1]=="parking" then
                icon="|TInterface\\GroupFrame\\UI-Group-MasterLooter:0:0:0:-4|t"
                if level then    
                    word="주차가 필요한 캐릭터"
                end 
                what=icon..MDRcolor(word,type) 
            elseif callTypeT[i][1]=="covenant" or callTypeT[i][1]=="covenantnow" then   
                icon=MDRgetCovenantIcon(callTypeT[i][2])
                what=icon..MDRcolor(word,type)
			elseif callTypeT[i][1]=="score" then
				icon="\124T463447:0:::-4\124t"
                what=icon..MDRcolor("계승",0,word)				
            elseif callTypeT[i][1]=="dungeon" then   
                word=getFullDungeonName(callTypeT[i][2])
                icon=MDRgetCovenantIcon(callTypeT[i][2])
                if except==1 then
                    what=icon..MDRcolor("회색",0,word)
                else
                    what=icon..MDRcolor("노랑",0,word)
                end  
            elseif callTypeT[i][1]=="spec" then
                type=10
                what=MDRcolor(word,type)
            elseif CharName then
                word=CharName
                what=MDRcolor(word,type)   
            else
                if callTypeT[i][1]=="affix" then
                    icon="|TInterface\\RaidFrame\\ReadyCheck-Waiting:0:0:0:-5|t"
                    local week=callTypeT[i][2]
                    local weekName=gsub(gsub(VALUES["msg"],"속성",""),"!","")
                    if week==0 then
                        word="이번주 속성"
                    elseif week=="all" then
                        word="다음 4주간의 속성"
                    else
                        word=weekName.." 속성"
                    end
                end   
                what=(icon or "")..MDRcolor(word,type)
            end 
            if (not callTypes[callTypeB[i]] or callTypeT[i][1]=="dungeon") then
                if (callTypeT[i][1]=="all" and not callType["dungeon"] and not callType["parking"]) or
                callTypeT[i][1]~="all" then 
                    if not strfind(cmdLines,word) then
                        cmdLines=cmdLines..what..space
                        callTypes[callTypeB[i]]=1
                    end    
                end
            end    
        end
        local exc
        if callTypes["dungeon"] and except==1 then
            exc=MDRcolor("죽기",0," '제외'")
        end
        
        if strsub(cmdLines,strlen(space)*-1)==space then
            cmdLines=strsub(cmdLines,1,strlen(space)*-1-1)
        end
        
        if callType["parking"] then
            cmdLines=range..cmdLines
        else
            cmdLines=cmdLines..(exc or "")..range 
        end  
        
        local msg=VALUES["msg"]
        local sur,chName="","" 
        
        if channel=="ADDON_PARTY" then
            sur=MDRcolor("파티",0,"/!! ")
            chName=MDRcolor("파티",0,"[파티]")
        elseif channel=="ADDON_GUILD" then  
            sur=MDRcolor("길드",0,"/! ")
            chName=MDRcolor("길드",0,"[길드]")  
        elseif channel=="ADDON_OFFICER" then
            sur=MDRcolor("관리자",0,"/@ ")
            chName=MDRcolor("관리자",0,"[관리자]") 
        elseif channel=="ADDON_WHISPER" and onlyForMe==1 then
            sur=MDRcolor("핑크",0,"/! ")
            chName=MDRgetModeName(1)
        else
            sur=MDRcolor("핑크",0,"/!! ")
            chName=MDRcolor("핑크",0,"[나에게만 보임]")  
        end 
        
        if msg and strfind(strsub(msg,1,1),"!") then  
            msg=strsub(msg,2,-1)
        end 
        
        if msg and not CharName then   
            msg="|cffaaaaaa ☞"..sur..msg.."|r "..chName
        else
            msg=MDRcolor(msg,0).." "..chName
        end
        
        local now=""
        if onlyOnline then
            if callType["covenantnow"] then
                if coveHere>0 and (channel=="ADDON_PARTY" or channel=="PARTY" ) then
                    
                    now=MDRcolor("노랑",0,getShortDungeonName(here)).." : "
                else
                    now=MDRcolor("핑크",0,"현재 접속중인 ")
                end
                
                cmdLines=now..cmdLines
            else
                now=", "..MDRcolor("핑크",0,"현재 접속중") 
                cmdLines=cmdLines..now
            end  
        end
        local whoIcon="|TInterface\\FriendsFrame\\UI-Toast-ToastIcons.tga:0:0:0:-4:128:64:2:29:34:61|t"
        local whoIcon2="|TInterface\\ChatFrame\\UI-ChatIcon-Battlenet:0:0:0:-4|t"
        name=whoIcon..name
        
        
        local CL=strsub(cmdLines,-5,-3)
        local eul=MDRko(CL,"을")  
        local eun=MDRko(CL,"은")
        
        local message
        if channel=="ADDON_WHISPER" and who==meGame and onlyForMe~=1 then
            message="["..cmdLines.."]"..msg
            if VALUES["msg"]=="!금고" then
                MDRVault ()      
            end  
        elseif onlyMe==1 and not CharName then            
            message=MDRcolor("핑크",0,"["..name.."]").." 님의 ["..cmdLines.."] "..eun.." 다음과 같습니다."..msg
            
        elseif onlyYou then   
            message=MDRcolor("["..name.."]",-1).." 님이 "..MDRcolor("핑크",0,"["..whoIcon..onlyYou.."]").." 님에게 "..cmdLines..eul.." 요청합니다."..msg
            
        elseif callType["affix"] then  
            message=MDRcolor("["..name.."]",-1).." 님이 ["..cmdLines.."]"..eul.." 알고 싶어합니다."..msg
            
        elseif callType["emote"] then 
            message=MDRcolor("["..name.."]",-1).." 님이 "..cmdLines
            
        elseif callType["score"] then
			local affixIcon,affix
			if isThisWeekHasSpecificAffix(9) then
				affixIcon="|T236401:0:::-4|t"
				affix="폭군"
			else
				affixIcon="|T463829:0:::-4|t"
				affix="경화"
			end	
			message=MDRcolor("["..name.."]",-1).." 님이 ["..cmdLines.."] "..eul.." 요청합니다. 이번주는 ["..affixIcon..affix.."] 입니다."..msg
		elseif callType["parking"] then 
            if (not level) and (#callTypeB==1) and (not onlyOnline) then   
                message=MDRcolor("["..name.."]",-1).." 님이 ["..MDRcolor("돌",0,"모든 캐릭터").."의 "..cmdLines.."] "..eul.." 요청합니다."..msg
            else
                message=MDRcolor("["..name.."]",-1).." 님이 ["..cmdLines.."] "..eul.." 찾습니다."..msg 
            end
        elseif CharName then   
            message=MDRcolor("["..name.."]",-1).." 님의 "..MDRcolor("핑크",0,"메세지").."입니다: "..msg
        else
			local affix_desc=""
			if callType["all"] then
				affix_desc=" 이번주 속성은 "..GetAnyWeeksAffix(0,channel).." 입니다."
			end
            message=MDRcolor("["..name.."]",-1).." 님이 ["..cmdLines.."] "..eul.." 찾습니다."..affix_desc..msg
        end 
        if not callType["forceversion"] then
            print(statusIcon..mdrcolor[channel]..message)
            if doDNDalert==1 and MDR.DNDalert~=1 then
                local message=""
                if status=="{D}" then
                    message=MDRcolor("수도",0,"MDR▶").."현재 "..MDRcolor("하늘",0,"["..statusIcon.."던전에 입장]").." 한 상태이므로 검색결과를 표시하지 않습니다."
                elseif status=="{R}" then
                    message=MDRcolor("수도",0,"MDR▶").."현재 "..MDRcolor("관리자",0,"["..statusIcon.."공격대에 합류]").." 중이므로 검색결과를 표시하지 않습니다."
                elseif status=="{T}" then
                    message=MDRcolor("수도",0,"MDR▶").."현재 "..MDRcolor("흑마",0,"["..statusIcon.."토르가스트에 입장]").." 한 상태이므로 검색결과를 표시하지 않습니다."
                elseif status=="{DND}" then
                    message=MDRcolor("수도",0,"MDR▶").."현재 "..MDRgetModeName(2).." 가 "..MDRcolor("초록",0,"[활성화]").." 되어 있어 검색결과를 표시하지 않습니다. "..MDRcolor("회색",0,"[비활성화]").." 하려면 "..MDRcolor("노랑",0,"'/! 방해'").." 를 입력하세요."
                end
                if message~="" then
                    print(message)
                    
                    MDR.DNDalert=1
                    C_Timer.After(1800, function()
                            MDR.DNDalert=0
                    end)
                end
            end
        end  
    end 
    
    --나에게서 귓말이 들어오는 경우 프린트로 변경
    if (channel=="WHISPER_IN" or channel=="ADDON_WHISPER") and onlyForMe~=1 and who==meGame then
        channel="print"
    end 
    
    --지정한 사람이 내가 아니면 리턴
    if onlyYou and not checkCallMe(onlyYou) then 
        return 
    end 
    
    --내가 아닌 사람이 !속성을 요청하는 경우 리턴
    if who~=meGame and callType["affix"] then
        return  
    end
    
    -- "내"를 붙인 명령어를 다른사람이 입력했으면 리턴
    if onlyMe==1 and who~=meGame then
        return
    end 
    
    --조절값 입력
    VALUES["channel"]=channel 
    VALUES["onlyOnline"]=onlyOnline
    
    if callType["score"] then        
        MDRreportScore(VALUES)
        
    elseif #callTypeB>1 and not callType["all"] and not callType["parking"] and not callType["covenant"] and not callType["covenantall"] and not callType["covenantnow"] and (callType["item"] or callType["trinket"] or callType["stat"] 
        --or callType["spec"] 
        --or callType["class"] 
        or callType["role"]) then --명령어가 2개이상이고 아이템검색을 요구하면  
        
        --무기 사용 가능 여부 체크
        if ((callType["spec"] or callType["class"]) and callType["specificitem"]) then 
            
            local spec=keyword["spec"]
            local class=keyword["class"] or keyword3["spec"]
            local specClass
            if spec then
                specClass=MDRcolor(spec,10)
            else
                specClass=MDRcolor(class)
            end  
            if checkSpecCanUseItem(spec or class,keyword["specificitem"]) then 
                
                VALUES["comb"]="Spec_Specificitem" 
            else 
                if who==meGame then    
                    
                    local neun=MDRko(MDRcolor(spec or class,5),"는")
                    local eul=MDRko(keyword["specificitem"],"을")
                    print("|cFFff0000▶|r"..specClass..neun.." "..MDRcolor(keyword["specificitem"],-2)..eul.." 사용할 수 없습니다. 다른 아이템으로 다시 시도해보세요.")    
                end   
                return 
            end 
        end
        
        --직업과 조합해서 검색시
        if callType["class"] and (callType["item"] or callType["category"] or callType["specificitem"] or callType["dungeon"]) then   
            
            if keyword["class"]=="사제" or keyword["class"]=="흑마" or keyword["class"]=="법사" or keyword["class"]=="악사" then
                
                VALUES["comb"]="Class_Something" 
                
            else 
                if who==meGame then    
                    
                    local neun=MDRko(MDRcolor(keyword["class"],5),"는")
                    
                    print("|cFFff0000▶|r"..MDRcolor(keyword["class"])..neun.." "..MDRcolor("전문화",-1).."에 따라 착용가능 아이템 범주가 달라 "..MDRcolor("전문화",-1).."로 검색해야만합니다. (|cFF33FF99ex|r.!"..MDRcolor(keyword["class"],3).."!무기 or !"..MDRcolor(keyword["class"],4).."!한손)")
                    
                end
                return
            end   
            
            --전문화+무기
        elseif (callType["spec"] and callType["item"]) then  
            VALUES["comb"]="Spec_Item" 
            --장신구와 던전 조합 거절  
        elseif callType["trinket"] and callType["dungeon"] and #callTypeB==2 then
            if who==meGame then
                print("|cFFff0000▶장신구|r는 |cff8787ED!던전이름|r과 단독으로 조합할 수 없습니다. "..MDRcolor("도적",0,"능력치").."나 "..MDRcolor("역할",-1).."을 지정해주세요. (|cFF33FF99ex|r."..MDRcolor("도적",0,"!힘").."|cff8787ED!"..keyword["dungeon"].."|r or "..MDRcolor("!힐러",-1).."|cff8787ED!"..keyword["dungeon"].."|r)")   
            end 
            
            --장신구 검색
        elseif (
            (callType["trinket"] and (callType["role"] or callType["stat"])) or
            (callType["stat"] and callType["dungeon"] and not callType["category"]) or
            (callType["role"] and callType["dungeon"])  
        )then  
            
            if keyword["role"]=="힐러"then 
                if not tips[1] or tips[1]<warns then
                    if who==meGame and callType["trinket"] and not callType["dungeon"] then
                        print("|cFF00ff00▶|r"..MDRcolor("힐러",-1).." [수양/신성, "..MDRcolor("운무",0)..", "..MDRcolor("회복",0)..", "..MDRcolor("징벌",0,"신기")..", "..MDRcolor("복원",0).."] 로 획득 가능한 모든 |cff00ff00장신구|r를 검색합니다. |cffa335ee[아이템 링크]|r를 보시려면 "..MDRcolor("!힐러",-1).."|cff8787ED!던전이름|r으로 검색해보세요.")
                    end
                    tips[1]=(tips[1] or 0)+1
                end
                
            elseif keyword["role"]=="탱커" then   
                if keyword2["role"]=="힘/민첩" and not keyword["stat"] then
                    if not tips[2] or tips[2]<warns then    
                        if who==meGame and callType["trinket"] and not callType["dungeon"] then
                            print("|cFF00ff00▶|r"..MDRcolor("탱커 전용",-1).." |cff00ff00장신구|r를 검색합니다. "..MDRcolor("탱커",-1).."로 사용 가능한 "..MDRcolor("모든 장신구",-2).."를 검색하시려면 "..MDRcolor("도적",0,"힘").."이나 "..MDRcolor("도적",0,"민첩").."과 함께 검색해보세요. |cFF33FF99ex)|r "..MDRcolor("!힘탱",-1).."|cff00ff00!장신구|r, "..MDRcolor("!탱커",-1).."|cff00ff00!장신구|r"..MDRcolor("도적",0,"!민첩"))  
                        end
                        tips[2]=(tips[2] or 0)+1
                    end
                elseif callType["stat"] or keyword2["role"]~="힘/민첩" then 
                    if not tips[3] or tips[3]<warns then    
                        if who==meGame and callType["trinket"] and not callType["dungeon"] then    
                            local message,role
                            local stat=keyword["stat"] or keyword2["role"]
                            if stat=="힘" then
                                role=MDRcolor("보호",0)..", "..MDRcolor("혈기",0)..", "..MDRcolor("방어",0)
                            else
                                role=MDRcolor("수호",0)..", "..MDRcolor("양조",0)..", "..MDRcolor("복수",0)     
                            end    
                            message="|cFF00ff00▶|r"..MDRcolor("도적",0,stat).."을 사용하는 "..MDRcolor("탱커",-1).." ["..role.."] 로 획득 가능한 |cff00ff00장신구|r를 검색합니다. |cffa335ee[아이템 링크]|r를 보시려면 "..MDRcolor("도적",0,"!"..stat..keyword["role"]).."|cff8787ED!던전이름|r으로 검색해보세요."
                            print(message) 
                        end 
                        tips[3]=(tips[3] or 0)+1
                    end
                end   
                
            elseif not callType["stat"] then 
                if not tips[4] or tips[4]<warns then
                    if who==meGame and callType["trinket"] and not callType["dungeon"] then
                        print("|cFFff0000▶|r"..MDRcolor("딜러",-1).." |cff00ff00장신구|r를 검색하려면 "..MDRcolor("도적",0,"능력치").."를 지정해야합니다. |cFF33FF99ex)|r "..MDRcolor("도적",0,"!민첩").."|cff00ff00!장신구|r") 
                    end 
                    tips[4]=(tips[4] or 0)+1
                end   
                return
                
            elseif not callType["role"] then 
                if not tips[5] or tips[5]<warns then    
                    if who==meGame and callType["trinket"] and not callType["dungeon"] then
                        local message,role
                        if keyword["stat"]=="힘" then
                            role=MDRcolor("무기",0,"무기/분노")..", "..MDRcolor("냉죽",0,"냉기/부정")..", "..MDRcolor("징벌",0)     
                        elseif keyword["stat"]=="지능" then     
                            role=MDRcolor("마법사")..", "..MDRcolor("흑마법사")..", "..MDRcolor("암흑",0)..", "..MDRcolor("조화",0)..", "..MDRcolor("정기",0)
                        elseif keyword["stat"]=="민첩" then     
                            role=MDRcolor("도적")..", "..MDRcolor("사냥꾼")..", "..MDRcolor("풍운",0)..", "..MDRcolor("야성",0)..", "..MDRcolor("고양",0)..", "..MDRcolor("파멸",0)
                        end     
                        message="|cFF00ff00▶|r"..MDRcolor("도적",0,keyword["stat"]).."을 사용하는 "..MDRcolor("딜러",-1).." ["..role.."] 로 획득 가능한 |cff00ff00장신구|r를 검색합니다. |cffa335ee[아이템 링크]|r를 보시려면 "..MDRcolor("도적",0,"!"..keyword["stat"]).."|cff8787ED!던전이름|r으로 검색해보세요."
                        print(message) 
                    end 
                    tips[5]=(tips[5] or 0)+1
                end   
            end
            --print("검색 조건 충분")
            VALUES["comb"]="Trinket" 
            
            --던전+스펙
        elseif (callType["spec"] and callType["dungeon"]) then 
            VALUES["comb"]="Spec_Dungeon" 
            
            --직업+스탯  
        elseif (callType["class"] and callType["stat"]) then 
            local class,stat=keyword["class"],keyword["stat"]  
            if checkSpecCanUseStat(class,stat) then
                if class=="전사" or (class=="기사" and stat=="힘") or class=="도적" or class=="냥꾼" or class=="죽기" then
                    if who==meGame then    
                        
                        local neun=MDRko(MDRcolor(keyword["class"],5),"는")
                        
                        print("|cFFff0000▶|r"..MDRcolor(class)..neun.." "..MDRcolor("전문화",-1).."에 따라 착용할 수 있는 아이템이 달라 |cFFFFF569"..stat.." 능력치|r와 함께 검색할 수 없습니다. "..MDRcolor("전문화",-1).."를 지정해서 검색해보세요.")
                        
                    end 
                    return
                else 
                    VALUES["comb"]="Class_Stat"
                end   
            else
                if who==meGame then    
                    
                    local neun=MDRko(MDRcolor(keyword["class"],5),"는")
                    
                    print("|cFFff0000▶|r"..MDRcolor(class)..neun.." |cFFFFF569"..keyword["stat"].."|r 아이템을 사용할 수 없습니다. 다른 |cFFFFF569능력치|r로 다시 시도해보세요.")
                    
                end   
                return 
            end
            
            --전문화+스탯
        elseif (callType["spec"] and callType["stat"]) then 
            local spec=keyword["spec"]
            local stat=keyword["stat"]
            local class=keyword3["spec"]
            if checkSpecCanUseStat(spec,stat) then
                VALUES["comb"]="Spec_Stat" 
            else
                if who==meGame then    
                    
                    local neun=MDRko(MDRcolor(keyword["spec"],5),"는")
                    
                    print("|cFFff0000▶|r"..MDRcolor(spec,0).." "..MDRcolor(class)..neun.." |cFFFFF569"..keyword["stat"].."|r 아이템을 사용할 수 없습니다. 다른 |cFFFFF569능력치|r로 다시 시도해보세요.")
                    
                end   
                return 
            end
            --스탯+무기종류
        elseif (callType["stat"] and callType["specificitem"])then   
            VALUES["comb"]="Stat_Specificitem"   
            
            --스탯+무기범주
        elseif (callType["stat"] and callType["category"])then   
            VALUES["comb"]="Stat_Category" 
            --전문화+범주
        elseif (callType["spec"] and callType["category"])then   
            VALUES["comb"]="Spec_Category"  
            --스탯+무기
        elseif (callType["stat"] and callType["item"]) then
            if who==meGame then
                
                print("|cFFff0000▶|r|cFFFFF569능력치|r와 "..MDRcolor("무기",-2).."는 함께 검색할 수 없습니다. "..MDRcolor("무기 유형(단검,지팡이)",-2).."이나 "..MDRcolor("종류(양손,한손)",-1).."를 지정해주세요. (|cFF33FF99ex|r. |cFFFFF569!힘|r"..MDRcolor("!양손",-1).." or |cFFFFF569!지능|r"..MDRcolor("!단검",-2)..")")
                
            end
            return   
        end
        if VALUES["comb"] then
            findCharAllItem(VALUES)  
        end  
        return
        
    else --!명령어가 단일일 경우
        if (callType["all"] or 
            callType["mykey"] or 
            callType["levelrange"] or 
            callType["dungeon"] or 
            callType["class"] or 
            callType["newkey"] or 
            callType["currentall"] or 
            callType["currentdungeon"] or 
            callType["charname"] or
            callType["covenantall"] or
            callType["covenantnow"] or
            callType["covenant"] ) then  
            
            findCharAllKey(VALUES)  
            
        elseif callType["achievement"] then
            MDRcheckAchievement(level,channel,who)
        elseif callType["emote"] then  
            MDRdoEmote(channel,who,keyword["emote"])
        elseif callType["parking"] then  
            findCharNeedParking(VALUES)  
        elseif callType["spell"] and #callTypeB==1 then  
            findCharSpell(keyword["spell"],channel,who,"spell")  
        elseif callType["forceversion"] and #callTypeB==1 then  
            doCheckVersion(channel,who,callType) 
        elseif callType["affix"] and #callTypeB==1 then  
            doOnlyAffixReport(keyword["affix"],channel,who,"affix")   
        elseif callType["invite"] and (checkCallMe(onlyYou) or chennel=="WHISPER_IN")then  
            MDRrequestInvite(channel,who)
        elseif callType["specificitem"] then 
            --!주스탯이 고정인 무기종류는 검색통과
            if keyword["specificitem"]=="보조장비" or keyword["specificitem"]=="마법봉" or keyword["specificitem"]=="석궁" or keyword["specificitem"]=="활" or keyword["specificitem"]=="총" or keyword["specificitem"]=="전투검" or keyword["specificitem"]=="방패" then
                VALUES["comb"]="Spec_Specificitem"  
                findCharAllItem(VALUES)   
            else
                if who==meGame then
                    
                    local neun=MDRko(keyword["specificitem"],"는")  
                    print("|cFFff0000▶|r"..MDRcolor(keyword["specificitem"],-2)..neun.." 단독으로 검색할 수 없습니다. "..MDRcolor("전문화",-1).."나 |cFFFFF569능력치|r를 함께 입력해주세요. (|cFF33FF99ex|r. "..MDRcolor(krClass,0,"!")..MDRcolor(krClass,3)..MDRcolor("!"..keyword["specificitem"],-2)..", |cFFFFF569!힘|r"..MDRcolor("!"..keyword["specificitem"],-2)..")")    
                    
                end  
            end  
            --!전문화만 단독 검색시 직업으로 보여주고 무기검색법 알려주기
        elseif callType["spec"] then
            if who==meGame then
                local spec=keyword["spec"]   
                local class=getCallTypeTable(spec)[4] or getCallTypeTable(spec)[2] 
                local neun=MDRko(MDRcolor(class,5),"는")
                local ga=MDRko(MDRcolor(class,5),"가")
                local ro=MDRko(class,"로")      
                
                print("|cFFffff00▶|r"..MDRcolor(class,0,"전문화").."를 단독으로 입력한 경우 전문화 대신 "..MDRcolor(class,0,"직업").." 정보를 요청합니다. ("..MDRcolor(class,0,"!"..class)..")")
                
                print("|cFFffff00▷|r"..MDRcolor(spec,10)..ro.." 사용 가능한 |cffaaaaaa무기|r를 검색하고 싶은 경우 "..MDRcolor(spec,0,"!"..spec).."|cffaaaaaa!무기|r 로 검색해보세요.")
                print("▷도움말이 필요한 경우: |cffffff00/쐐|r, |cffffff00/쐐|r |cFFaaaaaa무기|r")
                
            end
            VALUES["callTypeT"][1]=getCallTypeTable(keyword3["spec"])
            findCharAllKey(VALUES)   
            --VALUES["comb"]="Spec_Item"
            --findCharAllItem(VALUES)
            
            --!무기만 단독검색시
        elseif callType["item"] then
            if who==meGame then
                
                print("|cFFff0000▶|r|cFFaaaaaa무기|r는 단독으로 검색할 수 없습니다. 특성을 지정해주세요. (|cFF33FF99ex|r."..MDRcolor(krClass,0,"!")..MDRcolor(krClass,3).."|cFFaaaaaa!"..(keyword["trinket"] or keyword["item"] ).."|r)")
                print("▷도움말이 필요한 경우: |cffffff00/쐐|r |cFFaaaaaa무기|r")
                
            end 
            --!장신구만 단독검색시
        elseif callType["trinket"] then
            if who==meGame then
                
                print("|cFFff0000▶|r|cFF00ff00장신구|r는 단독으로 검색할 수 없습니다. "..MDRcolor("도적",0,"능력치").."나 "..MDRcolor("역할",-1).."을 지정해주세요 (|cFF33FF99ex|r."..MDRcolor("도적",0,"!힘").."|cFF00ff00!장신구|r or "..MDRcolor("!힐러",-1).."|cFF00ff00!장신구|r)") 
                print("▷도움말이 필요한 경우: |cffffff00/쐐|r |cFF00ff00장신구|r")
                
            end   
            
            --스탯만 단독검색시  
        elseif callType["stat"] then
            if who==meGame then
                
                print("|cFFff0000▶|r|cFFFFF569능력치|r는 단독으로 검색할 수 없습니다. 무기종류를 지정해주세요. (|cFF33FF99ex|r. !|cFFFFF569"..keyword["stat"].."|r!지팡이)")
                print("▷도움말이 필요한 경우: |cffffff00/쐐|r |cFFaaaaaa무기|r")   
            end 
            
            --스탯지정없이 무기범주만 단독검색시
        elseif callType["category"] then
            if who==meGame then
                
                print("|cFFff0000▶|r"..MDRcolor("무기범주",-1).."(한손,양손,근접,원거리)는 단독으로 검색할 수 없습니다. "..MDRcolor(krClass,0,"전문화").."나 |cFFFFF569능력치|r를 함께 입력해주세요. (|cFF33FF99ex|r. |cFFFFF569!힘|r"..MDRcolor("!"..keyword["category"],-1)..", "..MDRcolor(krClass,0,"!")..MDRcolor(krClass,3)..MDRcolor("!석궁",-2)..")")
                print("▷도움말이 필요한 경우: |cffffff00/쐐|r |cFFaaaaaa무기|r")   
                
            end  
        else return end  
    end 
end

--찾는사람 체크
function checkCallMe(onlyYou) 
    if not onlyYou then return end 
    local t=MDRconfig.Char
    local faction=UnitFactionGroup("player")
    local realm=gsub(GetRealmName()," ","")
    local findYou=false
    for k,v in pairs(t) do
        local charRealm=MDRsplit(gsub(k," ",""),"-")[2]
        local name=gsub(k, "%s%-.+","") 
        onlyYou=string.gsub(onlyYou, "(%a)([%w_']*)", MDRtitleLower)
        name=string.gsub(name, "(%a)([%w_']*)", MDRtitleLower)
        if strfind(name,onlyYou) and t[k].Faction==faction and RealmMap[realm]==RealmMap[charRealm] then
            findYou=true  
        end
    end
    return findYou
end


--보유한 모든 돌 불러오기
function GetHaveKeyCharInfo(type,level)
    
    --돌 불러오기전에 새로고침 한번
    MDRrefreshRunHistory()
    
    if type=="만렙만" then level=2
    elseif type=="soft" then level=level-5
    elseif level==nil then level=MDR["maxParking"] end 
    if level<2 then level=2 end 
    local t=MDRconfig.Char
    local num=1
    local chars={}
    local faction=UnitFactionGroup("player")
    local realm=gsub(GetRealmName()," ","") 
    local minLevel=DIL[level] or DIL[MDR["maxParking"]]
    
    for k,v in pairs(t) do
        local charRealm=MDRsplit(gsub(k," ",""),"-")[2]
        if t[k].Faction==faction and RealmMap[realm]==RealmMap[charRealm] then
            local level=t[k].Level or t[k].level
            local IL=t[k].IL or 0
            local thisCharIncluded=0
            if type=="성약단" then --만렙이면서 성약단으을 선택한 경우만 포함
                if t[k].Covenant and t[k].Covenant~="" and level==MDR["SCL"] then
                    thisCharIncluded=1
                end     
            else   
                if t[k].MythicKey.link then
                    thisCharIncluded=1  
                elseif (type~="쐐기돌보유자만" and (
                        (level==MDR["SCL"] and (IL>=minLevel or type=="만렙만")) or 
                        (type=="레벨제한없음" and level<=MDR["SCL"]) or 
                        (type=="50렙이상만" and level>=50) or
                        (tonumber(type) and level>=type)
                )) then     
                    --허용가능레벨보다 높거나 force 인 경우 돌 없어도 포함
                    thisCharIncluded=1
                end
            end 
            if thisCharIncluded==1 then
                chars[num]={}
                chars[num]["fullName"]=k
                chars[num]["cutName"]=gsub(k, "%s%-.+","")
                chars[num]["shortClass"]=MDRcolor(t[k].Class,6)   
                chars[num]["best"]=t[k].reward1 or 0   
                chars[num]["best4"]=t[k].reward4 or 0
                chars[num]["best10"]=t[k].reward10 or 0
                chars[num]["runs"]=t[k].runs or 0
                chars[num]["keyLink"]=t[k].MythicKey.link  
                chars[num]["keyLevel"]=t[k].MythicKey.level or 0
                chars[num]["keyName"]=t[k].MythicKey.name   
                chars[num]["itemLevel"]=t[k].IL or 0
                chars[num]["equipLevel"]=t[k].ILe or 0   
                chars[num]["lastSeen"]=t[k].LastSeen or time() 
                chars[num]["charLevel"]=t[k].Level or MDR.SCL    
                chars[num]["covenant"]=t[k].Covenant or ""
				chars[num]["score"]=t[k].Score or ""
                num=num+1 
            end  
        end   
    end
    local newChars={}
    local newChars2={}
    local charsNum=1
    for i=1,#chars do
        if chars[i]["keyLevel"] >0 then
            newChars[chars[i]]=chars[i]["keyLevel"]*10000
        elseif chars[i]["itemLevel"] then
            newChars[chars[i]]=chars[i]["itemLevel"]*10
        else
            newChars[chars[i]]=chars[i]["charLevel"]
        end  
    end 
    for k,v in MDRspairs(newChars, function(t,a,b) return t[b] < t[a] end) do
        newChars2[charsNum]=k
        charsNum=charsNum+1
    end
    chars=newChars2
    return chars
end

--점수 보고하기
function MDRreportScore(VALUES) 
    local who,channel,level,level2,callTypeT
    local onlyMe,onlyYou,onlyOnline,except,onlyForMe
    local callType,callTypeB,keyword,keyword2,keyword3={},{},{},{},{}
    
    channel="print"
    if VALUES~=nil then
        who=VALUES["who"]
        channel=VALUES["channel"]
        callTypeT=VALUES["callTypeT"]
        
        level=VALUES["level"]
        level2=VALUES["level2"]  
        
        onlyOnline=VALUES["onlyOnline"] 
        onlyYou=VALUES["onlyYou"]
        onlyMe=VALUES["onlyMe"]
        except=VALUES["except"]
        onlyForMe=VALUES["onlyForMe"]  
        CharName=VALUES["CharName"]
        
        for i=1,#callTypeT do
            callTypeB[i]=callTypeT[i][1]
            callType[callTypeT[i][1]]=1
            
            if callTypeT[i][1]=="dungeon" then 
                if not keyword["dungeon"] then
                    keyword["dungeon"]={}
                end
                if not tContains(keyword["dungeon"],callTypeT[i][2]) then
                    tinsert(keyword["dungeon"],callTypeT[i][2])    
                end   
            else
                
                keyword[callTypeT[i][1]]=callTypeT[i][2]
            end            
            
            keyword2[callTypeT[i][1]]=callTypeT[i][3]
            keyword3[callTypeT[i][1]]=callTypeT[i][4]   
        end   
    end
    
    local type
    if channel=="ADDON_GUILD" or channel=="ADDON_OFFICER" or channel=="GUILD" then
        type="scoreOnly"
    else
        type="full"
    end
    
    local scoreT=MDRconfig.Char[meAddon].Score
	if scoreT["종합점수"] == 0 then return end
	
	local messageLines={}
    if callType["dungeon"] then   -- !점수!역병
        --275,225,188,125		
        local dungeon=keyword["dungeon"][1]    
        local score=scoreT[dungeon]["점수"]
        local tyr_level=scoreT[dungeon]["폭군"]["level"] or 0	
		local tyr_clear=scoreT[dungeon]["폭군"]["overTime"] and "|cffff0000-|r" or "|cff00ff00+|r"
		local tyr_score=scoreT[dungeon]["폭군"]["score"] or 0
		local for_level=scoreT[dungeon]["경화"]["level"] or 0
		local for_clear=scoreT[dungeon]["경화"]["overTime"] and "|cffff0000-|r" or "|cff00ff00+|r"
		local for_score=scoreT[dungeon]["경화"]["score"] or 0
		
		score=tonumber(score)
		local color,tyr_color,for_color
		
		if score>=275 then
			color="{CL}"
		elseif score>=225 then
			color="{CE}"
		elseif score>=188 then
			color="{CR}"
		elseif score>=125 then
			color="{CC}"
		else
			color="{CN}"
		end
		
		if tyr_score>137 then
			tyr_color="{CW}"
		elseif tyr_score>=125 then
			tyr_color="{CA}"
		elseif tyr_score>=120 then
			tyr_color="{CL}"
		elseif tyr_score>=110 then
			tyr_color="{CE}"
		elseif tyr_score>=100 then
			tyr_color="{CR}"
		elseif tyr_score>=80 then
			tyr_color="{CC}"
		elseif tyr_score==0 then
			tyr_color="{CG}"
		else
			tyr_color="{CN}"
		end
		
		if for_score>137 then
			for_color="{CW}"
		elseif for_score>=125 then
			for_color="{CA}"
		elseif for_score>=120 then
			for_color="{CL}"
		elseif for_score>=110 then
			for_color="{CE}"
		elseif for_score>=100 then
			for_color="{CR}"
		elseif for_score>=80 then
			for_color="{CC}"
		elseif for_score==0 then
			for_color="{CG}"
		else
			for_color="{CN}"
		end
		
        messageLines[1]=dungeon..": "..color..score.."{CX}점 [{폭군}"..tyr_color..tyr_level.."{CX}"..tyr_clear.." {경화}"..for_color..for_level.."{CX}"..for_clear.."]"
        
    else -- !점수
        local total=scoreT["종합점수"]  
		--2200,1800,1500,1000		
		total=tonumber(total)
		local shortClass=MDRcolor(krClass,6)
		local color
		if total>=2200 then
			color="{CL}"
		elseif total>=1800 then
			color="{CE}"
		elseif total>=1500 then
			color="{CR}"
		elseif total>=1000 then
			color="{CC}"
		else
			color="{CN}"
		end		
		
		local name=meAddon
		local tyr_desc=MDRgetDungeonScore(name,"폭군")
		local for_desc=MDRgetDungeonScore(name,"경화")
		
        messageLines[1]="{"..shortClass.."} "..color..total.."{CX}점 ["..tyr_desc.." / "..for_desc.."]"
    end
    
    reportMessageLines(messageLines,channel,who,callType)
    return    
end

function MDRgetDungeonScore(name,affix)
	local scoreT=MDRconfig.Char[name].Score
	local dungeonTable={
        [1]={"핏","핏심"},
        [2]={"속","속죄"},
        [3]={"승","승천"},
        [4]={"죽","죽상"},
        [5]={"고","투기장"},
        [6]={"역","역병"},
        [7]={"티","티르너"},
        [8]={"저","저편"}, 
	}
	for i=1,#dungeonTable do
			if i==1 then dungeonHistory="{"..affix.."} " end
			local d=dungeonTable[i][1]
			local dungeon=dungeonTable[i][2]
			--local icon=","
			local color
			local score=scoreT[dungeon][affix]["score"] or 0	
			if score>137 then
				color="{CW}"			
			elseif score>=125 then
				color="{CA}"			
			elseif score>=120 then
				color="{CL}"
			elseif score>=110 then
				color="{CE}"
			elseif score>=100 then
				color="{CR}"
			elseif score>=80 then
				color="{CC}"
			elseif score==0 then
				color="{CG}"
			else
				color="{CN}"
			end

			dungeonHistory=dungeonHistory..color..d.."{CX}"
	end
	return dungeonHistory
end


--보유한 모든 돌 보고하기
function findCharAllKey(VALUES) 
    
    local who,channel,level,level2,callTypeT
    local onlyMe,onlyYou,onlyOnline,except,onlyForMe
    local callType,callTypeB,keyword,keyword2,keyword3={},{},{},{},{}
    
    channel="print"
    if VALUES~=nil then
        who=VALUES["who"]
        channel=VALUES["channel"]
        callTypeT=VALUES["callTypeT"]
        
        level=VALUES["level"]
        level2=VALUES["level2"]  
        
        --callType=callTypeT[1][1]
        --keyword=callTypeT[1][2]
        onlyOnline=VALUES["onlyOnline"] 
        onlyYou=VALUES["onlyYou"]
        onlyMe=VALUES["onlyMe"]
        except=VALUES["except"]
        onlyForMe=VALUES["onlyForMe"]  
        CharName=VALUES["CharName"]
        
        for i=1,#callTypeT do
            callTypeB[i]=callTypeT[i][1]
            --print(i..":"..callTypeT[i][1])
            callType[callTypeT[i][1]]=1
            
            if callTypeT[i][1]=="dungeon" then 
                if not keyword["dungeon"] then
                    keyword["dungeon"]={}
                end
                if not tContains(keyword["dungeon"],callTypeT[i][2]) then
                    tinsert(keyword["dungeon"],callTypeT[i][2])    
                end   
            else
                
                keyword[callTypeT[i][1]]=callTypeT[i][2]
            end
            
            --keyword[callTypeT[i][1]]=callTypeT[i][2]
            keyword2[callTypeT[i][1]]=callTypeT[i][3]
            keyword3[callTypeT[i][1]]=callTypeT[i][4]   
        end   
    end
    local type=nil 
    
    if (CharName and CharName~="" ) then callType="charname" end 
    
    if CharName then
        type="레벨제한없음"
    elseif (callType["class"] and (checkCallMe(onlyYou) or onlyMe==1)) then
        type="50렙이상만"
    elseif callType["class"] then
        type="만렙만"
    elseif callType["covenant"] or callType["covenantall"] or callType["covenantnow"] then
        type="성약단" 
    else type="쐐기돌보유자만"
    end 
    local chars=GetHaveKeyCharInfo(type) 
    local forceToShort=0
    
    if callType["newkey"] then
        if not MDR.myMythicKey then return end
        local start=MDR.myMythicKey.start or MDR.myMythicKey.onLoad
        local finish=MDR.myMythicKey.finish
        if start==nil or finish==nil then return end
        if start.level==finish.level and start.name==finish.name then
            return
        else
            onlyOnline=1  
        end  
    end 
    
    if callType["currentdungeon"] then
        local here,_=GetInstanceInfo()
        local mapID = C_ChallengeMode.GetActiveChallengeMapID()
        local level, _ = C_ChallengeMode.GetActiveKeystoneInfo()
        local name
        local onLoad=MDR.myMythicKey.onLoad
        local start=MDR.myMythicKey.start
        local headStar=MDR.skull[MDRcolor(krClass,6)]
        local messageLines={}  
        
        if mapID~=nil and mapID>0 then --쐐기중이면
            if start==nil or onLoad==nil then return end  
            name, _= C_ChallengeMode.GetMapUIInfo(mapID) 
            if name==start.name and level==onLoad.level and level==start.level+1 then   
                messageLines[1]=headStar..getShortDungeonName(onLoad.name)..onLoad.level..": "..onLoad.link.." {OP}진행중" 
                if channel=="ADDON_GUILD" or channel=="ADDON_PARTY" or channel=="ADDON_OFFICER" or channel=="GUILD" then
                    reportAddonMessage(messageLines,channel,who,callType)
                else  
                    reportMessageLines(messageLines,channel,who,callType) 
                end    
            end  
            return  
        end   
        callType["dungeon"]=1
        keyword["dungeon"]={}
        keyword["dungeon"][1]=getShortDungeonName(here)
        onlyOnline=1
    end 
    
    if callType["levelrange"] then
        level2=keyword
    end  
    
    --!돌이나 !레벨범위를 길드혹은 파티로 요청한 경우 짧게 보고
    if (
        (callType["all"]   
            or callType["currentall"] 
            or callType["covenant"] 
            or callType["covenantall"] 
            or callType["covenantnow"] 
            or callType["levelrange"]
        ) or (
            (callType["mykey"] or callType["dungeon"]) 
            and not callType["currentdungeon"] 
        and onlyOnline~=1)
    ) and (
        channel=="GUILD" 
        or channel=="PARTY" 
        or channel=="ADDON_GUILD" 
        or channel=="ADDON_PARTY" 
        or channel=="ADDON_OFFICER"
        or (channel=="ADDON_WHISPER" and onlyForMe==1 )
    ) then
        forceToShort=1
    end 
    
    if callType["currentall"] then
        onlyOnline=1
    end  
    
    --!돌이고 레벨을 지정하지 않았으며 길드가 아닌 곳에서 요청했는데 키가 하나도 없을 경우
    if callType["all"] and (channel~="GUILD") and (#chars==0) and (level==nil) then
        local messageLines={}
        messageLines[1]="▶저는 현재 갖고 있는 돌이 하나도 없습니다!" 
        reportMessageLines(messageLines,channel,who,callType)
        return
    end 
    
    -- "지금"이 붙은 경우 접속중인 캐릭터만 필터링
    if onlyOnline==1 then
        chars=filterCharsByFilter(chars,"name",nil,nil)
        --이캐릭 돌이 없으면 바로 보고하고 마무리, 길드면 생략
        if not chars and channel~="GUILD" and channel~="ADDON_GUILD" and channel~="ADDON_PARTY" and channel~="ADDON_OFFICER" and callType["all"] then
            local messageLines={}
            messageLines[1]="▶이캐릭은 현재 갖고 있는 돌이 없습니다!" 
            reportMessageLines(messageLines,channel,who,callType)
            return
        end  
    end
    
    --던전이나 직업으로 필터링
    if callType["dungeon"] then
        if except==1 then
            chars=filterCharsByFilter(chars,"except",keyword["dungeon"],nil) 
        else  
            chars=filterCharsByFilter(chars,"dungeon",keyword["dungeon"],nil) 
        end  
    end 
    
    if callType["class"] then
        chars=filterCharsByFilter(chars,"class",keyword["class"],nil)  
    end 
    
    --성약단으로 필터링
    if callType["covenant"] or callType["covenantnow"] then
        chars=filterCharsByFilter(chars,"covenant",keyword["covenant"] or keyword["covenantnow"],nil)    
    end  
    
    --레벨을 지정한 경우 레벨로 한번더 필터링
    if level then 
        chars=filterCharsByFilter(chars,"level",level,level2)  
    end 
    
    --캐릭터이름을 지정한 경우 필터링
    if CharName then
        chars=filterCharsByFilter(chars,"CharName",CharName,nil)
        if chars then
            local maxChar=MDR["maxChar"]
            local charsNum=#chars
            if #chars>maxChar then  
                for i=1,#chars do
                    if i>(maxChar-1) then
                        chars[i]=nil 
                    end   
                end 
                local messageLines={}
                messageLines[1]="▶["..CharName.."]: 일치하는 검색결과 [ 총"..charsNum.."개 ] 캐릭터를 특정하려면 !{직업}과 함께 검색해보세요." 
                C_Timer.After(#chars*0.5, function()
                        reportMessageLines(messageLines,channel,who,callType)
                end)
            end 
        end  
    end  
    
    if forceToShort==1 then  
        doShortReport(chars,channel,who,callType) 
    else
        doFullReport(chars,channel,who,callType) 
    end 
end

--돌이 있으나 주차 못한 캐릭 보고하기
function findCharNeedParking(VALUES)
    local who,channel,level
    local onlyMe,onlyOnline,onlyForMe
    
    if VALUES~=nil then
        who=VALUES["who"]
        channel=VALUES["channel"]
        level=VALUES["level"] 
        onlyMe=VALUES["onlyMe"]
        onlyForMe=VALUES["onlyForMe"]
        onlyOnline=VALUES["onlyOnline"]  
    end  
    
    if level==nil then level=99
    elseif level<2 then level=2 end
    
    local chars=GetHaveKeyCharInfo("레벨제한없음",level)
    if onlyOnline==1 then 
        chars=filterCharsByFilter(chars,"name",nil,nil)
    else
        local newChars={}
        local newChars2={}
        local charsNum=1
        for i=1,#chars do
            newChars[chars[i]]=(chars[i]["best"] or 0)*100+(chars[i]["runs"] or 0) 
        end 
        for k,v in MDRspairs(newChars, function(t,a,b) return t[b] < t[a] end) do
            newChars2[charsNum]=k
            charsNum=charsNum+1
        end
        chars=newChars2
    end
    if channel==nil then channel="print" end 
    
    local findChars={}
    local parknum=1
    local bestnum=1
    local bestLevels={}
    local lowestLevel=0
    local highstLevel=0
    local parkingLevel=level
    local bestCharLevel=0
    local bestCharName,bestCharClass="",""
    
    local minLevel=DIL[level] or DIL[MDR["maxParking"]]
    
    if chars~=nil then  
        
        for i=1,#chars do 
            if chars[i]["charLevel"]<=MDR["SCL"] then --확팩만렙보다 고레벨은 무시
                local best=chars[i]["best"]   
                if ((best==nil) or (best<parkingLevel)) and chars[i]["charLevel"]==MDR["SCL"] and minLevel<chars[i]["itemLevel"] then
                    findChars[parknum]=chars[i]   
                    parknum=parknum+1
                elseif best and best>=parkingLevel then   
                    bestLevels[bestnum]=best
                    bestnum=bestnum+1
                end
                if chars[i]["charLevel"]>bestCharLevel then
                    bestCharLevel=chars[i]["charLevel"]
                    bestCharName=chars[i]["cutName"]
                    bestCharClass=MDRgetClassName(chars[i]["shortClass"])
                end 
            end  
        end
        
        --요청 단수이상 주차한 캐릭이 있으면
        if bestnum>1 then
            table.sort(bestLevels)
            lowestLevel=bestLevels[1]
            highstLevel=bestLevels[#bestLevels]    
        end  
    end
    
    --주차안한 캐릭이 없으면 보고서 없이 한줄 출력으로 마무리
    if #findChars==0 then
        
        --!주차를 내가 보낸 경우 리턴
        if (channel=="WHISPER_OUT") then return end
        
        local messageLines={}
        local message=""
        local delay=0
        if bestnum>1 then
            if onlyOnline==1 then
                message="▶"..parkingLevel.."단 주차 완료 ("..highstLevel.."단)" 
            else
                message="▶["..parkingLevel.."단] 주차 완료 ("..lowestLevel.."~"..highstLevel.."단)" 
            end
            delay=1
        elseif bestCharLevel<MDR["SCL"] then
            message="▶저는 현재 만렙 캐릭터가 하나도 없습니다! [최고 레벨: "..bestCharName..", Lv."..bestCharLevel.." "..bestCharClass.."]"
        else  
            message="▶저는 현재 "..parkingLevel.."단을 주차할 수 있는 캐릭터가 없습니다!" 
        end
        
        messageLines[1]=message
        C_Timer.After(delay, function()
                reportMessageLines(messageLines,channel,who,"parking")  
        end)  
        return
    end  
    
    --!주차를 길드엔 짧게 보고
    if channel=="GUILD" or 
    channel=="PARTY" or 
    channel=="ADDON_GUILD" or 
    channel=="ADDON_PARTY" or 
    channel=="ADDON_OFFICER" or 
    (channel=="ADDON_WHISPER" and onlyForMe==1) then   
        doShortReport(findChars,channel,who,"parking")   
    else   
        doFullReport(findChars,channel,who,"parking")  
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
    
    --나머지는 길드엔 숏, 나머진 풀 리포트
    if channel=="GUILD" or channel=="PARTY" or channel=="ADDON_GUILD" or channel=="ADDON_PARTY"then
        doShortReport(findChars,channel,who,callType) 
    else
        doFullReport(findChars,channel,who,callType)  
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
    elseif filter=="dungeon" or filter=="except" then  
        --f1=f1[1]
        --print(f1)
    elseif filter=="name" then
        f1=meAddon 
    end 
    
    for i=1,#chars do
        local lastSeen=time()-chars[i]["lastSeen"] 
        if filter=="level"and f2~=nil then  
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
            elseif filter=="covenant" then   
                target=chars[i]["covenant"]
            elseif filter=="dungeon" or filter=="except" then
                target=getShortDungeonName(chars[i]["keyName"])   
            elseif filter=="name" then
                target=chars[i]["fullName"] 
            elseif filter=="CharName" then
                target=string.gsub(chars[i]["fullName"], "(%a)([%w_']*)", MDRtitleLower)
                f1=string.gsub(f1, "(%a)([%w_']*)", MDRtitleLower)
            end
            if (filter=="CharName" and strfind(target,f1) and lastSeen<MDR["lastSeen"]) or 
            ((filter~="except" and filter~="dungeon") and f1==target) then
                findChars[num]=chars[i]
                num=num+1
            elseif (filter=="dungeon" or filter=="except") then   
                
                for j=1,#f1 do
                    if filter~="except" then
                        if f1[j]==target then
                            findChars[num]=chars[i]
                            num=num+1     
                        end 
                    else
                        if f1[j]==target then
                            chars[i]=nil     
                        end 
                    end  
                end    
            end  
        end
    end  
    
    if filter=="except" then
        for k,v in pairs(chars) do
            findChars[num]=v
            num=num+1 
        end    
    end
    
    if #findChars>0 then
        return findChars
    else
        return nil
    end
end
