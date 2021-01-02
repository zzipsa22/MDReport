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
MDR["maxParking"]=14 --어둠땅 1시즌
MDR["SCL"]=60--어둠땅 만렙

local guildWarn=0
local tips={}
local warns=100
local meGame,meAddon,krClass,className=MDR["meGame"],MDR["meAddon"],MDR["krClass"],MDR["className"]
local who,channel,level,level2,callTypeT
local comb,onlyOnline,onlyMe,onlyYou,CharName,except
local callType,callTypeB,keyword,keyword2,keyword3={},{},{},{},{}
local DIL={}
DIL.min=184  --깡신
DIL.max=210  --15단
DIL.base=135 --기준템렙
DIL.gap=(DIL.max-DIL.min)/MDR["maxParking"]
for i=1,MDR["maxParking"] do
    DIL[i]=DIL.base + DIL.gap*i  --단수별 허용레벨 / 드랍템 레벨
end

C_Timer.After(3, function()  
        if MDR.myMythicKey==nil then
            MDR.myMythicKey={}
        end    
        MDRbackupMythicKey("start")     
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
    if not SavedInstancesDB and VALUES["callTypeT"][1][1]~="affix" then
        doWarningReport(channel,who,"warning") 
        return
    end    
    
    C_Timer.After(MDR["cooltime"], function()
            MDR["running"]=0
            MDR["who"]=nil
    end)        
    
    callType,callTypeB,keyword,keyword2,keyword3={},{},{},{},{}
    
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
        if who==meGame and channel~="ADDON" then  
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
                        what=MDRcolor("노랑",0,word)
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
                
                local exc                
                if callTypes["dungeon"] and except==1 then
                    exc=MDRcolor("죽기",0," '제외'")
                end
                
                cmdLines=cmdLines..range..(exc or"")
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
        return end  --검색어가 짧으면 무시 
    end
    
    
    --[[
    if  onlyYou  then        
        print("찾는사람:"..onlyYou)
    end    
    ]]
    if callType["levelrange"] and level2==nil then
        VALUES["level2"]=tonumber(keyword["levelrange"])        
    end    
    
    --범위지정인데 범위값이 없으면 리턴
    if callType["levelrange"]  and level==nil then
        return
    end  
    
    --내가 아닌 사람이 !속성을 요청하는 경우 리턴
    if who~=meGame and callType["affix"] then
        return        
    end
    
    --내가 길드로 요청하는 경우
    if who==meGame and channel=="GUILD" then
        if guildWarn<2 then
            local msg=VALUES["msg"]
            if strfind(strsub(msg,1,2),"!") then
                msg=strsub(msg,2,-1)
            end            
            print("▶|cFF40ff40길드채팅|r은 모두가 사용하는 공간입니다. 애드온을 사용하지 않는 분들을 위해 다음 명령어를 활용해보세요. |cffffff00/!|r "..MDRcolor(msg,0).." (애드온 사용자 간에만 메세지를 주고 받을 수 있습니다.)")
            guildWarn=guildWarn+1
        end        
    end    
    
    --버전요청을 한 사람이 나일 경우 리턴
    if callType["forceversion"] and who==meGame then
        return
    end  
    
    --버전체크를 한 사람이 내가 아닐 경우 리턴
    if callType["version"]  and who~=meGame then
        return
    end      
    
    --명령어가 !내돌or !지금내돌 인데 내가 보낸게 아니면 리턴
    if callType["mykey"] and who~=meGame and channel~="WHISPER_OUT" then 
        return 
    end       
    
    --내가 보낸 귓말이고, 나한테 보냈거나 !내돌/!지금내돌을 요청한게 아니면 리턴
    if (channel=="WHISPER_OUT") and (who==meGame or callType["mykey"]~=1 )  then
        return       
    end        
    
    --채널이 없으면 프린트로 변경
    if channel==nil then channel="print" end  
    
    --나에게서 귓말이 들어오는 경우 프린트로 변경
    if (channel=="WHISPER_IN") and who==meGame then
        channel="print"
    end       
    
    --버전체크 채널 강제 조정
    if callType["version"] then
        channel="print"
    elseif callType["forceversion"] then
        --channel="WHISPER"        
    end 
    
    --조절값 입력
    VALUES["channel"]=channel    
    
    if channel=="ADDON" then       
        
        local name=MDRsplit(who,"-")[1]
        local message,range="",""
        
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
                what=MDRcolor("노랑",0,word)
            elseif callTypeT[i][1]=="spec" then
                type=10
                what=MDRcolor(word,type)
            elseif CharName then
                word=CharName
                what=MDRcolor(word,type)                
            else
                if callTypeT[i][1]=="affix" then
                    word=VALUES["msg"]
                end                
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
        local exc
        if callTypes["dungeon"] and except==1 then
            exc=MDRcolor("죽기",0," '제외'")
        end
        
        if strsub(cmdLines,strlen(space)*-1)==space then
            cmdLines=strsub(cmdLines,1,strlen(space)*-1-1)
        end
        
        cmdLines=cmdLines..range..(exc or "")      
        
        local CL=gsub(cmdLines,"|r","")
        local eul=MDRko(CL,"을")    
        
        local message
        if onlyMe==1 and not CharName then
            if callTypes["dungeon"] then
                message=MDRcolor("핑크",0,"["..name.."]").." 님이 소유한 "..cmdLines.." 입니다."
            else
                message=MDRcolor("핑크",0,"["..name.."]").." 님의 "..cmdLines.." 정보입니다."
            end
        elseif onlyYou then
            local eul=MDRko(CL,"을")             
            message=MDRcolor("["..name.."]",-1).." 님이 "..MDRcolor("핑크",0,"["..onlyYou.."]").." 님에게 "..cmdLines..eul.." 요청합니다."
        else
            local now=""
            if onlyOnline then
                now=", "..MDRcolor("핑크",0,"현재 접속중")
            end
            local request=""
            if callType["affix"] then
                request=MDRcolor("핑크",0,"메세지")
            else
                request=MDRcolor("회색",0,"요청")
            end
            
            message=MDRcolor("["..name.."]",-1).." 님의 "..request.."입니다: "..cmdLines..now
            
        end 
        if not callType["forceversion"] then
            print("|cFF33FF99MDR▶|r"..message)
        end
        
    end   
    
    --지정한 사람이 내가 아니면 리턴
    if onlyYou and not checkCallMe(onlyYou) then 
        return 
    end 
    
    -- "내"를 붙인 명령어를 다른사람이 입력했으면 리턴
    if onlyMe==1 and who~=meGame then
        return
    end    
    
    if #callTypeB>1 and not callType["all"] and not callType["parking"] and (callType["item"] or callType["trinket"] or callType["stat"] or callType["spec"] or callType["class"] or callType["role"]) then --명령어가 2개이상이고 아이템검색을 요구하면         
        
        --무기 사용 가능 여부 체크
        if ((callType["spec"] or callType["class"])  and callType["specificitem"]) then 
            
            local spec=keyword["spec"]
            local class=keyword["class"] or keyword3["spec"]
            local specClass
            if spec then
                specClass=MDRcolor(spec,10)
            else
                specClass=MDRcolor(class)
            end            
            if  checkSpecCanUseItem(spec or class,keyword["specificitem"]) then 
                
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
        if callType["class"] and (callType["item"] or  callType["category"]  or callType["specificitem"]  or  callType["dungeon"]) then           
            
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
                if keyword2["role"]=="힘/민첩" and not keyword["stat"]  then
                    if not tips[2] or tips[2]<warns then                        
                        if who==meGame and callType["trinket"] and not callType["dungeon"] then
                            print("|cFF00ff00▶|r"..MDRcolor("탱커 전용",-1).." |cff00ff00장신구|r를 검색합니다. "..MDRcolor("탱커",-1).."로 사용 가능한 "..MDRcolor("모든 장신구",-2).."를 검색하시려면 "..MDRcolor("도적",0,"힘").."이나 "..MDRcolor("도적",0,"민첩").."과 함께 검색해보세요. |cFF33FF99ex)|r "..MDRcolor("!힘탱",-1).."|cff00ff00!장신구|r, "..MDRcolor("!탱커",-1).."|cff00ff00!장신구|r"..MDRcolor("도적",0,"!민첩"))     
                        end
                        tips[2]=(tips[2] or 0)+1
                    end
                elseif callType["stat"] or keyword2["role"]~="힘/민첩" then 
                    if not tips[3] or tips[3]<warns then                        
                        if who==meGame and callType["trinket"] and not callType["dungeon"]  then                    
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
                if class=="전사" or (class=="기사" and stat=="힘")  or class=="도적" or class=="냥꾼" or class=="죽기" then
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
            callType["charname"] )  then           
            
            findCharAllKey(VALUES)            
        elseif callType["parking"] then        
            findCharNeedParking(channel,who,"parking",keyword["parking"],level,onlyMe)             
        elseif callType["spell"] and #callTypeB==1 then        
            findCharSpell(keyword["spell"],channel,who,"spell")     
        elseif (callType["version"] or callType["forceversion"]) and #callTypeB==1 then        
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
    if type=="만렙만" then level=2
    elseif type=="soft" then level=level-5
    elseif level==nil then level=MDR["maxParking"] end  
    if level<2 then level=2 end  
    local t=SavedInstancesDB.Toons
    local num=1
    local chars={}
    local faction=UnitFactionGroup("player")
    local realm=gsub(GetRealmName()," ","")    
    local minLevel=DIL[level] or DIL[MDR["maxParking"]]
    
    for k,v in pairs(t) do
        local charRealm=MDRsplit(gsub(k," ",""),"-")[2]
        if t[k].Faction==faction and RealmMap[realm]==RealmMap[charRealm] then
            if t[k].MythicKey.link then
                chars[num]={}
                chars[num]["fullName"]=k
                chars[num]["cutName"]=gsub(k, "%s%-.+","")
                chars[num]["shortClass"]=getCallTypeTable(t[k].Class)[2]
                chars[num]["keyLink"]=t[k].MythicKey.link
                chars[num]["best"]=t[k].MythicKeyBest[1] or 0                
                chars[num]["best4"]=t[k].MythicKeyBest[2] or 0
                chars[num]["best10"]=t[k].MythicKeyBest[3] or 0
                chars[num]["keyLevel"]=t[k].MythicKey.level   
                chars[num]["keyName"]=t[k].MythicKey.name            
                chars[num]["itemLevel"]=t[k].IL
                chars[num]["equipLevel"]=t[k].ILe                    
                chars[num]["lastSeen"]=t[k].LastSeen
                chars[num]["charLevel"]=t[k].Level                    
                num=num+1                
            elseif (type~="쐐기돌보유자만" and (
                    (t[k].Level==MDR["SCL"] and (t[k].IL>=minLevel or type=="만렙만")) or 
                    (type=="레벨제한없음" and t[k].Level<=MDR["SCL"]) or 
                    (type=="50렙이상만" and t[k].Level>=50)
            )) then                           
                --허용가능레벨보다 높거나 force 인 경우 돌 없어도 포함
                chars[num]={}
                chars[num]["fullName"]=k
                chars[num]["cutName"]=gsub(k, "%s%-.+","")                
                chars[num]["shortClass"]=getCallTypeTable(t[k].Class)[2]                
                chars[num]["itemLevel"]=t[k].IL
                chars[num]["equipLevel"]=t[k].ILe                
                chars[num]["charLevel"]=t[k].Level               
                chars[num]["keyLevel"]=0
                chars[num]["lastSeen"]=t[k].LastSeen                
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

--보유한 모든 돌 보고하기
function findCharAllKey(VALUES)    
    
    callType,callTypeB,keyword,keyword2,keyword3={},{},{},{},{}    
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
    elseif callType["class"]  then
        type="만렙만"        
    else type="쐐기돌보유자만"
    end   
    local chars=GetHaveKeyCharInfo(type)    
    local forceToShort=0
    
    if callType["newkey"] then
        if not MDR.myMythicKey then return end
        local start=MDR.myMythicKey.start
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
        callType["dungeon"]=1
        keyword["dungeon"]={}
        keyword["dungeon"][1]=getShortDungeonName(here)
        onlyOnline=1
    end    
    
    if callType["levelrange"] then
        level2=keyword
    end        
    
    --!돌이나 !레벨범위를 길드혹은 파티로 요청한 경우 짧게 보고
    if (callType["all"] or callType["levelrange"])  and 
    (not callType["class"] and not callType["dungeon"]) and
    (channel=="GUILD" or channel=="PARTY"  or channel=="ADDON") then
        forceToShort=1
    end 
    if callType["currentall"] then
        onlyOnline=1
    end    
    
    --!내돌을 길드로 요청한 경우 짧게 보고
    if (callType["mykey"] or callType["dungeon"]) and (channel=="GUILD" or channel=="ADDON") then
        forceToShort=1
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
        if not chars and channel~="GUILD" and channel~="ADDON" and callType["all"] then
            local messageLines={}
            messageLines[1]="▶이캐릭은 현재 갖고 있는 돌이 없습니다!" 
            reportMessageLines(messageLines,channel,who,callType)
            return
        end        
    end
    
    --던전이나 직업으로 필터링
    if callType["dungeon"]  then
        if except==1 then
            chars=filterCharsByFilter(chars,"except",keyword["dungeon"],nil)  
        else            
            chars=filterCharsByFilter(chars,"dungeon",keyword["dungeon"],nil)   
        end        
    end    
    
    if  callType["class"] then
        chars=filterCharsByFilter(chars,"class",keyword["class"],nil)         
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
function findCharNeedParking(channel,who,callType,keyword,level,onlyMe)
    if level==nil then level=99
    elseif level<2 then level=2 end
    if onlyMe==1 or channel=="print" then 
        LoadAddOn("Blizzard_WeeklyRewards"); WeeklyRewardsFrame:Show()
    end
    local chars=GetHaveKeyCharInfo("레벨제한없음",level)
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
        if bestnum>1 then            
            message="▶저는 이번주 "..parkingLevel.."단 주차는 다했어요! ("..lowestLevel.."~"..highstLevel.."단)" 
        elseif bestCharLevel<MDR["SCL"] then
            message="▶저는 현재 만렙 캐릭터가 하나도 없습니다! [최고 레벨: "..bestCharName..", Lv."..bestCharLevel.." "..bestCharClass.."]"
        else       
            message="▶저는 현재 "..parkingLevel.."단을 주차할 수 있는 캐릭터가 없습니다!"  
        end
        
        messageLines[1]=message
        reportMessageLines(messageLines,channel,who,callType)       
        
        return
    end       
    
    --!주차를 길드엔 짧게 보고
    if channel=="GUILD" or channel=="PARTY"  or channel=="ADDON"then                
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
        if channel=="GUILD" or channel=="PARTY" or channel=="ADDON" then
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
    elseif filter=="dungeon" or filter=="except" then        
        --f1=f1[1]
        --print(f1)
    elseif filter=="name" then
        f1=meAddon   
    end   
    
    for i=1,#chars do
        local lastSeen=time()-chars[i]["lastSeen"]  
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
