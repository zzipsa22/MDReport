local meGame,meAddon,krClass,className=MDR["meGame"],MDR["meAddon"],MDR["krClass"],MDR["className"]
local _,_,_,classColor=GetClassColor(className) 
local playerName = UnitName("player")
--MDR["dices"]={}
local diceReportChannel
local diceNums={"①","②","③","④","⑤","⑥","⑦","⑧","⑨","⑩"}
--local C_MythicPlus_GetRunHistory = C_MythicPlus.GetRunHistory
MDR["diceNums"]=diceNums
MDR["diceWait"]=0

C_Timer.After(10, function()    
        local x = GetLocale()
        if x ~= "koKR" then 
            print("▶|cFF33FF99MDReport|r can't support your locale: ", x, ". Sorry for your inconvenience.")
        else
            if MDR["guide"]<50 then
                print("|cFF33FF99▶쐐기돌 보고서|r ["..MDRcolor("노랑",0,MDR["version"]).."]|r "..MDRcolor("하늘",0,"간편 확인").." 명령어: |cffffff00'/돌'|r |cffffff00'/금고'|r |cffffff00'/기록'|r")
                
                print(MDRcolor("수도",0,"▶")..MDRcolor("계승",0,"쐐기돌 평점").." 기능에 "..MDRcolor("계승",0,"점수 예측").." 기능을 추가하였습니다. 자세한 사용법을 알아보세요! |cff9d9d9d [도움말: |cffffff00'/! @ 점수'|r]|r")
                
                print(MDRcolor("수도",0,"▶").."도움이 필요하신가요? |cff9d9d9d [도움말 호출: |cffffff00'/! @'|r 또는 |cffffff00'/! 도움말'|r]|r")
                
                MDRtoggleMode()
                
                MDR["guide"]=MDR["guide"]+1
            end
        end
end)

local classInfo={
    ["악사"]={    
        "A330C9",
        "악마사냥꾼",
        "파멸",
        "복수"
    },
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
        "무기","무전","모든 던전","돌"
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
    ["회색"]={"9d9d9d","무기"},
    ["하늘"]={"80e7EB","속성"},
    ["핑크"]={"F5aCdA","분홍" },
    ["빨강"]={"ff0000" },
    ["노랑"]={"ffff00","노란"},  
    ["초록"]={"00ff00","장신구"},  
    ["파랑"]={"4444ff", "파란"},  
    ["보라"]={"aa33ff"},
    ["파티"]={"aaaaff"},
    ["길드"]={"80ff80"},
    ["관리자"]={"40C040"},  
    ["고급"]={"1eff00"},
    ["희귀"]={"0070dd"},
    ["영웅"]={"a335ee"},
    ["전설"]={"ff8000"},
    ["유물"]={"e6cc80"},
    ["계승"]={"00ccff"},
    ["강령군주"]={"32a478"},
    ["나이트 페이"]={"2549ff"},
    ["키리안"]={"8fd1d8"},
    ["성약단"]={"8fd1d8"},  
    ["성약"]={"8fd1d8"},  
    ["벤티르"]={"910f14"},
    [""]={}
}


function MDRrequestInvite(channel,who)
    print("테스트 중인 기능입니다.")
end

function MDRgetClassInfo(keyword)  
    return classInfo[keyword]
end

function MDRgetClassName(keyword)
    for k,v in pairs(classInfo) do
        for i=1,#v do
            if keyword==v[i] or keyword==k then
                return v[2]
            end    
        end    
    end  
end

function MDRbackupMythicKey(type)  
    if not MDR.myMythicKey then
        MDR.myMythicKey={}
    end
    MDRconfig=MDRconfig or {}
    MDRconfig.Char=MDRconfig.Char or {}
    MDRconfig.Char[meAddon]=MDRconfig.Char[meAddon] or {}
    
    --주간 리셋시 지난주 정보 초기화
    if type=="onLoad" then
        for k, v in pairs(MDRconfig.Char) do
            if v.MythicKey and (v.MythicKey.ResetTime or 0) < time() then
                v.runHistory = {}
                v.MythicKey = {}
                v.reward1=nil
                v.reward4=nil
                v.reward10=nil
            end
        end
        --쐐기 시작시 피니시 정보 초기화
    elseif type=="start" then
        MDRclearHistory()
    end  
    
    local name,level,link  
    for bagID = 0, 4 do
        for invID = 1, GetContainerNumSlots(bagID) do
            local itemID = GetContainerItemID(bagID, invID)
            if itemID and itemID == 180653 then
                local keyLink = GetContainerItemLink(bagID, invID)
                local KeyInfo = {strsplit(':', keyLink)}
                local mapID = tonumber(KeyInfo[3])
                local mapLevel = tonumber(KeyInfo[4])
                name = C_ChallengeMode.GetMapUIInfo(mapID)
                level = mapLevel
                link = keyLink
            end
        end
    end
    
    --쐐기돌 정보 초기화 및 새로 입력
    MDRconfig.Char[meAddon].MythicKey={}
    
    if link then 
        MDR.thisCharHasKey=1
        MDRconfig.Char[meAddon].MythicKey.level=level
        MDRconfig.Char[meAddon].MythicKey.name=name
        MDRconfig.Char[meAddon].MythicKey.link=link
        MDRconfig.Char[meAddon].MythicKey.ResetTime=time() + C_DateAndTime.GetSecondsUntilWeeklyReset()    
    else 
        MDR.thisCharHasKey=0 
    end
    
    local t={}  
    local tempL,_= C_ChallengeMode.GetActiveKeystoneInfo()
    t.currentMapID= C_ChallengeMode.GetActiveChallengeMapID()
    t.currentLevel= tempL>0 and tempL  
    t.level=level
    t.name=name
    t.link=link
    t.mapID=mapID  
    
    if type=="finish" then        
        MDR.myMythicKey.finish=t
        MDR.myMythicKey.onLoad=t    
        local VALUES={}
        local callTypeT={}
        C_Timer.After(1, function() 
                callTypeT[1]=getCallTypeTable("무슨돌")
                VALUES["who"]=meGame
                VALUES["callTypeT"]=callTypeT    
                VALUES["channel"]="ADDON_PARTY"    
                filterVALUES(VALUES)
        end)
    elseif type=="bagupdate" then    
        return
    else    
        MDR.myMythicKey[type]=t 
        MDR.myMythicKey.finish=nil    
    end    
    
    --쐐기 기록 저장
    MDRgetHistory(type)
end

function MDRko(keyword,type)  
    if not keyword then return "" end
    local LC=strsub(gsub(keyword,"!",""),-3)
    local kwa,neun,eul,ro,ga
    local result=""
    local LCtable={
        "검","궁","활","총","봉","창", --무기
        "꾼","적", --직업
        "돌","단","원","상","전","장","택","굴","산", --격아던전
        "연","당","탑","편","흔", --어둠땅 던전
        "복","멸","통","양","성","운","살","법","행","정","염","격","존","벌",--전문화
        "중","안","업","점",        
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
    if not keyword then return end
    for k,v in pairs(classInfo) do    
        for i=1,#v do
            if type==6 then
                if k==keyword or keyword==v[i] then          
                    return k
                end 
            end      
            if not strfind(keyword,"%[") and (strfind(keyword,v[i]) or strfind(keyword,k) or type==-1 or type==-2) then
                color=v[1]         
                if not type or type==1 then
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
    --print(type, text)
    return "|cff"..(color or "F5aCdA")..(text or keyword or"?").."|r"    
end

function MDRmakeDice(channel,who,k)
    C_Timer.After(2, function()       
            MDR["running"]=0 
            --MDR["diceAlert"]=0       
    end)
    if MDR["diceWait"]==1 then return end
    MDR["dices"]={}
    MDR["dicesB"]={}
    MDR["diceAlert"]=0 
    MDR["youMakeDice"]=nil
    MDR["diceResult"]={}
    local question
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
        if strsub(subject,-1)=="?" then
            question=subject
        end    
        if subject~="주사위" and subject~= question then
            subject=getFullDungeonName(subject) or subject      
            MDR["dices"][num]=diceNums[num].." "..subject
            MDR["diceResult"][num]={}
            MDR["diceResult"][num]["subject"]=diceNums[num].." "..subject
            MDR["dicesB"][num]=k[i]      
            num=num+1      
        end
    end
    local h1
    if question then
        question=gsub(question,"?","").."?"  
    end
    if question and question~="?" then
        MDR["question"]=question
        h1=question.." "
    else
        MDR["question"]="결과"
        h1=""
    end
    
    --if question then question=question.." " end  
    
    if channel=="WHISPER_OUT" or #MDR["dices"]<2 then return end
    
    --나에게서 귓말이 들어오는 경우 프린트로 변경
    if (channel=="WHISPER_IN") and who==meGame then
        channel="print"
    end   
    diceReportChannel=channel
    
    local message="MDR ▶ "..(h1 or "")
    local messageLines={}  
    for i=1,#MDR["dices"] do
        local space=", "
        --print(dices[i])      
        if i==#MDR["dices"] then space="" end
        message=message..MDR["dices"][i]..space
    end
    message=message.." : /주사위 "..#MDR["dices"]..""
    messageLines[1]=message
    
    
    --내가 입력한 주사위면 시작멘트
    if who==meGame then  
        reportMessageLines(messageLines,diceReportChannel,who,"dice")
        MDR["diceAlert"]=1 
        MDR["youMakeDice"]=meGame    
    end
    
    --애드온미설치자가 입력한거면 대신 시작멘트
    C_Timer.After(0.9, function() 
            if MDR["diceAlert"]~=1 and MDR["master"]==1 then
                --print("check")        
                reportMessageLines(messageLines,diceReportChannel,who,"dice")        
            end     
    end) 
    
    --주사위 굴림
    MDR["diceWait"]=1 
    C_Timer.After(1, function()      
            RandomRoll(1,#MDR["dices"])
            MDR["running"]=0 
    end)  
    
    --결과 보고하기
    
    C_Timer.After(5, function() 
            if MDR["youMakeDice"]==meGame or (MDR["diceAlert"]~=1 and MDR["master"]==1) then        
                local result=MDR["diceResult"]
                local newResult={}
                local newResult2={}
                local resultNum=1
                for i=1,#result do          
                    newResult[result[i]]=result[i]["vote"]
                end  
                for k,v in MDRspairs(newResult, function(t,a,b) return t[b] < t[a] end) do
                    newResult2[resultNum]=k
                    resultNum=resultNum+1
                end
                result=newResult2        
                local message=(MDR["question"] or "").." ▶ "
                local medals={"{rt1}","{rt5}","{rt2}"} --메달
                local first,second,third,medal
                for i=1,#result do
                    if i==1 then
                        first=result[i]["vote"]
                    end          
                    if result[i]["vote"]==first then medal=medals[1] 
                    elseif not second or result[i]["vote"]==second then
                        second=result[i]["vote"]
                        medal=medals[2]
                    elseif not third or result[i]["vote"]==third then
                        third=result[i]["vote"]
                        medal=medals[3]
                    end          
                    message=message..result[i]["subject"].." ("..medal..","..result[i]["vote"].."표)"
                    if i~=#result then
                        message=message..", "
                    end          
                end        
                
                local messageLines={}
                messageLines[1]=message        
                reportMessageLines(messageLines,diceReportChannel,who,"dice") 
                MDR["diceWait"]=0        
            end 
    end)   
end

function MDRcollectDices(msg)
    
    for i=1,#MDR["diceResult"] do
        if not strfind(msg,"MDR") and strfind(msg,MDR["diceResult"][i]["subject"]) then
            MDR["diceResult"][i]["vote"]=(MDR["diceResult"][i]["vote"] or 0)+1
            --print(msg.."+1")
        end 
        --print(MDR["dices"][i])
    end  
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
        messageLines[1]=(MDR["dices"][resultNum] or "알 수 없음")
        C_Timer.After(1.5, function()
                reportMessageLines(messageLines,diceReportChannel,who,"dice")
        end)     
        C_Timer.After(6, function()  
                MDR["diceWait"]=0
                MDR["youMakeDice"]=nil
                MDR["diceResult"]={}
        end)     
    else
        return    
    end    
end

function MDRParking()
    MDRgetHistory("parking") 
end

function MDRVault ()
    C_MythicPlus.RequestMapInfo()
    C_MythicPlus.RequestRewards()
    LoadAddOn("Blizzard_WeeklyRewards"); WeeklyRewardsFrame:Show()  
    MDRgetHistory("vault")  
end

function MDRMykey()
    MDRsendAddonMessage("!돌","WHISPER",meGame) 
    --findCharAllKey()
end

function MDRalts()
    local VALUES={}
    VALUES.runHistory=nil
    VALUES.main=nil
    VALUES.alt=1
    VALUES.includeMain=nil
    VALUES.type="alts"
    VALUES.onlyMain=nil
    VALUES.detail=1
    MDRdoReportHistory(VALUES)  
end

function MDRhistory(msg, editbox)
    local cmd, args= MDRsplit(msg," ")[1],MDRsplit(msg," ")[2]
    if cmd=="삭제" then
        MDRremoveCharInfo(args)
    elseif cmd=="지연시간" or cmd=="delay" then
        if tonumber(args) then
            MDRconfig.delay=tonumber(args)
            print("|cFF33FF99▶|r 기록 지연 시간이 "..MDRcolor("하늘",0,"'"..args.."초'").." 로 설정 되었습니다. (기본값: "..MDRcolor("노랑",0,MDR.DefaultDelay).."초)")
        else
            MDRconfig.delay=MDR.DefaultDelay
            print("|cFF33FF99▶|r 기록 지연 시간이 "..MDRcolor("하늘",0,"'기본값 ("..MDR.DefaultDelay.."초)'").." 으로 설정 되었습니다.")
        end
    else
        local VALUES={}
        VALUES.runHistory=nil
        VALUES.main=1        
        VALUES.alt=nil
        VALUES.includeMain=nil
        VALUES.type="history"
        VALUES.onlyMain=1
        VALUES.detail=nil
        VALUES.charName=msg
        MDRdoReportHistory(VALUES)  
    end
end

function MDRCommandsParty(msg, editbox)   
    if not msg then return end 
    if strfind(strsub(msg,1,1),"!") then
        msg=strsub(msg,2,-1)
    end 
    if msg=="금고" then
        MDRVault ()
        return
    end
    if IsInGroup() then
        MDRsendAddonMessage("!"..msg,"PARTY",meGame)    
    else
        MDRsendAddonMessage("!"..msg,"WHISPER",meGame)
    end  
    return     
end

function MDRCommandsOfficer(msg, editbox) 
    if not msg then return end 
    if strfind(strsub(msg,1,1),"!") then
        msg=strsub(msg,2,-1)
    end 
    if msg=="금고" then
        MDRVault ()
        return
    end
    MDRsendAddonMessage("!"..msg,"OFFICER",meGame)      
    return    
end

function MDRCommands(msg, editbox)  
    local messageLines={}
    -- msg=gsub(msg,"!","")
    local cmd, args= MDRsplit(msg," ")[1],MDRsplit(msg," ")[2]
    messageLines[1]=" "
    local helpHead="|cFF33FF99▼ 쐐기돌 보고서|r 도움말 : "      
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
    local cmdList="|cffC79C6E돌|r, |cff8787ED주차|r, |cff40C7EB던전|r, |cffFF7D0A직업|r, |cffA9D271닉네임|r, |cffC41F3B속성|r, "..MDRcolor("하늘",0,"주사위")..", "..MDRcolor("성약")..", "..MDRcolor("핑크",0,"모드")..", "..MDRcolor("계승",0,"점수")
    if not cmd or cmd=="도움말" or cmd=="!도움말" or cmd=="도움" or cmd=="!도움" or cmd=="help" or cmd=="" or cmd=="?" or cmd=="@"then
        
        local length=MDR["textLength"]
        local kLength=math.floor((length-1)/3+1)
        local G=MDRcolor("길드",0,"/! ")
        local GG=MDRcolor("길드",0,"길드")
        local P=MDRcolor("파티",0,"/!! ")
        local PP=MDRcolor("파티",0,"파티")
        local E="|cFF33FF99ex)|r "
        local ME="|cff0070DE내|r"
        local WW=MDRcolor("핑크",0,"귓속말")
        
        if args=="" or not args or args=="도움말" then      
            messageLines[#messageLines+1]="|cFF33FF99▶ 쐐기돌 보고서 (MDReport)|r ["..MDRcolor("노랑",0,MDR["version"]).."]|r : 전체 도움말 "
            
            messageLines[#messageLines+1]="▷|cFF33FF99[1.9.0]|r+ 개인 확인용 슬래시 (/) 명령어 추가 ▷|cffffff00/돌|r, |cffffff00/주차|r, |cffffff00/금고|r "
            messageLines[#messageLines+1]="▷|cFF33FF99[2.0.0]|r+ |cffffff00'/!'|r 로 |cFF40ff40길드채널|r 명령어 전송을 대신할 수 있습니다. (|cffffff00/!|r |cffC79C6E돌|r = |cFF40ff40/g|r |cffC79C6E!돌|r) "       
            
            messageLines[#messageLines+1]="▷|cFF33FF99[2.1.0]|r+ |cffffff00'/!!'|r 로 |cFFaaaaff파티|r중일 땐 |cFFaaaaff파티채널|r 전송을, |cffF5aCdA혼자|r일 땐 |cffF5aCdA본인|r에게 전송을 대신 할 수 있습니다. (|cffffff00/!!|r |cffC79C6E돌|r = |cFFaaaaff/p|r |cffC79C6E!돌|r, |cFFff80ff/w |r"..MDRcolor(krClass,0,playerName).." |cffC79C6E!돌|r) "
            
            messageLines[#messageLines+1]="▷|cFF33FF99[2.7.0]|r+ "..MDRgetModeName(1).." 와 "..MDRgetModeName(2).." 를 추가하였습니다."
            
            --messageLines[#messageLines+1]="▷|cFF33FF99[2.8.0]|r+ "..MDRcolor("돌",0,"위업").." ("..MDRcolor("영웅",0,"10단").."/"..MDRcolor("전설",0,"15단")..") 확인 기능을 추가하였습니다."                      
            
            messageLines[#messageLines+1]="▷|cFF33FF99[2.9.0]|r+ "..MDRcolor("계승",0,"쐐기돌 평점").." 확인 기능을 추가하였습니다."    
            
            messageLines[#messageLines+1]="|cffffffff▷도움말 목록: |r"..cmdList
            messageLines[#messageLines+1]="▷각 |cffC79C6E명령어|r 별 도움말을 보시려면 |cffffff00/! @|r |cffC79C6E명령어|r 입력. "..E.."|cffffff00/! @|r |cffC79C6E돌|r"
            
        elseif args=="돌" then  
            messageLines[#messageLines+1]=helpHead..MDRcolor("돌",0,"'돌'")
            messageLines[#messageLines+1]="|cffC79C6E▶돌|r : 소유한 모든 돌 정보를 요청합니다. 이하 대부분의 명령어들은 '"..ME.."'와 함께 조합하면 나만 출력, '|cffF58CBA지금|r'과 함께 조합하면 현재 접속중인 캐릭터만 출력, |cffffff00숫자|r와 함께 검색하면 해당 범위의 돌만 출력합니다. "..E..G.."|cffC79C6E돌|r, "..G..ME.."|cffC79C6E돌|r, "..P.."|cffF58CBA지금|r|cffC79C6E돌|r, "..G.."|cffC79C6E돌|r|cffffff0015~18|r, "..G.."|cffC79C6E돌|r|cffffff0025+|r"      
            
        elseif args=="던전"or args=="던전명" then
            messageLines[#messageLines+1]=helpHead..MDRcolor("마법사",0,"'던전'")
            messageLines[#messageLines+1]="|cff40C7EB▷{던전명}|r : 던전 이름으로 |cffC79C6E쐐기돌|r 검색을 시도합니다. 던전 여러개를 같이 검색할 수 있습니다. "..E..G.."|cff40C7EB핏심|r, "..G.."|cff40C7EB티르너|r|cffffff0018|r, "..P.."|cffF58CBA지금|r|cff40C7EB투기장|r, "..G.."|cff40C7EB티르!속죄|r"
            
            messageLines[#messageLines+1]="|cff40C7EB▷|r "..MDRcolor("죽기",0,"'노'").."나 "..MDRcolor("죽기",0,"'제외'").."를 던전명과 함께 입력하면 해당 던전을 "..MDRcolor("죽기",0,"제외").."한 검색결과를 요청할 수도 있습니다. "..E..P..MDRcolor("죽기",0,"노").."|cff40C7EB핏심!역몰|r"..MDRcolor("죽기",0,"제외")
            
        elseif args=="직업" or args=="직업명" then
            
            messageLines[#messageLines+1]=helpHead..MDRcolor("드루",0,"'직업'")
            
            messageLines[#messageLines+1]="|cffFF7D0A▷{직업명}|r : 직업 이름으로 |cffC79C6E쐐기돌|r 검색을 시도합니다. "..E..G.."|cffFF7D0A드루|r, "..G.."|cffFF7D0A드루|r|cffffff0015-|r, "..P..ME.."|cffFF7D0A드루|r"
        elseif args=="주차" then
            
            messageLines[#messageLines+1]=helpHead..MDRcolor("주차",0,"'주차'")
            messageLines[#messageLines+1]="|cff8787ED▷주차|r : 주차정보를 요청합니다. 주차를 못했거나 최대 보상을 받을 수 있는 단수(어둠땅1시즌 기준 14단) 미만으로 주차한 경우 해당 캐릭터의 정보를 출력합니다. 소지한 쐐기돌이 있을 경우 쐐기돌 정보를, 돌이 없으나 적절한 템렙을 갖춘 경우 템레벨을 출력합니다. "..E..G.."|cff8787ED주차|r, "..P..ME.."|cff8787ED주차|r, "..G.."|cff8787ED주차|r|cffffff0020|r : 특정 레벨을 지정할 경우(이 경우 20단) 해당 단수 이하 주차한 경우 검색결과에 포함"
            
        elseif args=="닉네임" or args=="이름" then
            
            messageLines[#messageLines+1]=helpHead..MDRcolor("사냥꾼",0,"'닉네임'")      
            
            messageLines[#messageLines+1]="|cffA9D271▷{닉네임}|r : |cffA9D271닉네임|r을 단독으로 입력하는 경우 |c"..classColor.."'캐릭터'|r 검색을 시도합니다. 일치하는 캐릭터가 있을 경우 모두 출력합니다. 한글은 최소 |cFFFFF569"..kLength.."|r글자 이상, 영문은 |cFFFFF569"..length.."|r자 이상 입력해야합니다. "..E.."캐릭명이 '|c"..classColor..playerName.."|r' 일 경우 "..m1
            
            messageLines[#messageLines+1]="|cffA9D271▷{닉네임}|r을 |cffC79C6E!돌|r 이나 |cff8787ED!주차|r와 조합하면 명령어에 반응할 "..MDRcolor("초록",0,"'사람'").."을 지정할 수 있습니다. "..E..G.."|cffC79C6E돌|r"..MDRcolor(krClass,0,"!"..n1)..", "..P..MDRcolor(krClass,0,n2).."|cff8787ED!주차|r. 부캐 이름으로도 가능합니다." 
            
            messageLines[#messageLines+1]="|cffA9D271▷{닉네임}|r과 |cffFF7D0A!{직업명}|r 을 조합하면 캐릭터 이름을 몰라도 특정 |cffFF7D0A직업|r을 검색할 수 있습니다. "..E..G..MDRcolor(krClass,0,n1).."|cffFFF569!도적|r"..": 닉네임에 '"..MDRcolor(krClass,0,n1).."'을/를 포함하는 캐릭터를 소유한 사람의 |cffFFF569도적|r 캐릭터를 검색."
        elseif args=="속성" then       
            messageLines[#messageLines+1]=helpHead..MDRcolor("죽기",0,"'속성'")      
            
            messageLines[#messageLines+1]="|cffC41F3B▶!속성|r : 이번주 쐐기 속성을 출력합니다. '다음주' '다다음주' 등과 조합해서 사용할 수 있습니다. "..E..G.."|cffC41F3B속성|r, "..P.."지난주|cffC41F3B속성|r, "..G.."다다음주|cffC41F3B속성|r"
            messageLines[#messageLines+1]="|cffC41F3B▶!다음속성|r : 다가올 4주 동안의 쐐기 속성을 출력합니다."
        elseif args=="무기" then      
            messageLines[#messageLines+1]=helpHead..MDRcolor("회색",0,"'무기'")  
            
            messageLines[#messageLines+1]="▶|cFF80e7EB!전문화|r, |cFFFFF569!능력치|r와 |cFFaaaaaa!무기|r, |cFFF5aCdA!무기범주|r, |cffC79C6E!무기종류|r, |cff8787ED!던전이름|r 등을 조합하여 원하는 무기를 드랍하는 던전의 돌을 검색할 수 있습니다. "..E..G.."|cFF80e7EB!회드|r|cFFaaaaaa!무기|r, |cFFFFF569!지능|r|cffC79C6E!단검|r, |cffC79C6E!방패|r, |cFFFFF569!민첩|r|cFFF5aCdA!원거리|r, |cFFFFF569!힘|r|cFFF5aCdA!한손|r, |cFF80e7EB!고술|r|cff8787ED!아탈|r, |cFF80e7EB!양조|r|cffC79C6E!장창|r"
            
        elseif args=="장신구" then 
            messageLines[#messageLines+1]=helpHead..MDRcolor("초록",0,"'장신구'")      
            
            messageLines[#messageLines+1]="▶|cFF00ff00!장신구|r와 |cFF80e7EB!역할|r, |cFFFFF569!능력치|r를 조합하면 특정 장신구를 드랍하는 던전의 돌을 검색할 수 있습니다. "..E.."|cFF80e7EB!힐러|r|cFF00ff00!장신구|r, |cFFFFF569!민첩|r|cFF00ff00!장신구|r"
            messageLines[#messageLines+1]="▷|cFFaaaaaa!무기|r는 "..MDRcolor(krClass,0,"!".."전문화").."와, |cFF00ff00!장신구|r는 |cFF80e7EB!역할|r과 조합 한다고 생각하시면 기억하기 쉽습니다."
            
        elseif args=="?" or args=="주사위" then  
            messageLines[#messageLines+1]=helpHead..MDRcolor("하늘",0,"'주사위'")   
            
            messageLines[#messageLines+1]="▶"..MDRcolor("하늘",0,"'?'").."뒤에 '!'와 주사위 굴릴 항목들을 2개 이상 입력하면 |cFF33FF99MDReport|r 에서 자동으로 주사위를 굴려주고 결과 또한 채팅으로 알려줍니다. "
            messageLines[#messageLines+1]="▷"..MDRcolor("하늘",0,"'?'").."는 단독으로 입력해도 되지만, "..MDRcolor("하늘",0,"'?'").." 앞에 내용을 입력하면 주사위의 제목으로 인식합니다. "..E..G..MDRcolor("하늘",0,"어디갈까?!자유!아탈!세스")..", "..P..MDRcolor("하늘",0,"뭘먹을까?!짬뽕!짜장면")..", 혹은 "..MDRcolor("하늘",0,"?").." 만 단독으로 "..G..MDRcolor("하늘",0,"?!기사!악사!전사").." 로 입력해도 됩니다."      
            
        elseif args=="성약" or args=="성약단" then  
            messageLines[#messageLines+1]=helpHead..MDRcolor("성약단",0,"'성약단'")
            
            messageLines[#messageLines+1]="▶"..MDRcolor("성약단",0,"'성약단'").." 을 요청하면 상황에 맞게 "..MDRcolor("성약단",0,"성약단 정보").."를 출력해줍니다. "..MDRcolor("초록",0,"① ")..MDRcolor("길드",0,"길드채널").."의 경우 "..MDRcolor("전사",0,"모든 만렙 캐릭터 (부캐 포함)").."의 "..MDRcolor("성약단").." 정보를, "..MDRcolor("초록",0,"② ")..MDRcolor("파티",0,"파티채널").."의 경우 현재 "..MDRcolor("핑크",0,"접속중").."인 캐릭터의 "..MDRcolor("성약단").." 정보를, "..MDRcolor("초록",0,"③ ")..MDRcolor("노랑",0,"던전 내").."에서 "..MDRcolor("파티",0,"파티채널").."로 요청하는 경우엔 "..MDRcolor("핑크",0,"현재 캐릭터").."가 "..MDRcolor("노랑",0,"해당던전").."에 필요한 "..MDRcolor("성약단",0,"성약단의 구성원일 경우").."에만 정보를 출력합니다. "..E..G..MDRcolor("성약")..", "..P..MDRcolor("성약단") 
            
            messageLines[#messageLines+1]="▷"..MDRgetCovenantIcon(3)..MDRcolor("나이트 페이")..", "..MDRgetCovenantIcon(1)..MDRcolor("키리안")..", "..MDRgetCovenantIcon(2)..MDRcolor("벤티르")..", "..MDRgetCovenantIcon(4)..MDRcolor("강령군주").." 등의 개별 성약단 이름으로도 검색할 수 있습니다. "..E..G..MDRcolor("벤티르")..", "..P..MDRcolor("나이트 페이",0,"나페")
        elseif args=="모드" or args=="매너" or args=="방해" then    
            messageLines[#messageLines+1]=helpHead..MDRcolor("핑크",0,"'모드'")..MDRcolor("길드",0," (길드채널 전용)")
            
            messageLines[#messageLines+1]=MDRcolor("핑크",0,"▶")..MDRgetModeName(1)..": "..MDRcolor("노랑",0,"'/! 매너'")
            messageLines[#messageLines+1]="▷활성화 되어있는 동안 "..MDRcolor("핑크",0,"본인").."이 "..MDRcolor("길드",0,"길드채널").."로 요청한 검색 결과를 "..MDRcolor("핑크",0,"'귓속말'").."로 받아볼 수 있습니다. 즉, "..MDRcolor("하늘",0,"다른 사람").."에겐 검색 결과가 "..MDRcolor("죽기",0,"보이지 않습니다. ")..MDRgetModeName(1).." 를 켜지 않고 "..MDRcolor("노랑",0,"일회성").."으로 사용하고자 할 경우 "..MDRcolor("길드",0,"길드").."로 요청할 메세지에 "..MDRcolor("노랑",0,"'@'").." 을 함께 입력하면 같은 효과를 볼 수 있습니다. 반대로 "..MDRgetModeName(1).." 가 "..MDRcolor("초록",0,"[활성화]").."되어 있을 때 "..MDRcolor("노랑",0,"'@'").." 을 이용하면 "..MDRgetModeName(1).."를 우회하여 "..MDRcolor("길드",0,"길드채널").."로 메세지를 전송할 수 있습니다. "..E..G..MDRcolor("노랑",0,"@")..MDRcolor("전사",0,"돌").." (띄어쓰기 없이)"
            
            messageLines[#messageLines+1]=MDRcolor("하늘",0,"▶")..MDRgetModeName(2)..": "..MDRcolor("노랑",0,"'/! 방해'")
            messageLines[#messageLines+1]="▷활성화 되어있는 동안 "..MDRcolor("길드",0,"길드채널").."로 전송되는 "..MDRcolor("죽기",0,"모든 메세지").."를 출력하지 않습니다. 단, "..MDRgetModeName(1).."와 함께 사용 중인 경우 "..MDRcolor("핑크",0,"본인").."이 요청한 검색결과는 "..MDRcolor("핑크",0,"귓속말").."로 받게 되므로 "..MDRgetModeName(2).."가 켜져있어도 볼 수 있습니다."
            
            messageLines[#messageLines+1]="▶현재 "..MDRcolor("초록",0,"[활성화]").." 된 모드 확인: "..MDRcolor("노랑",0,"'/! 모드'")
            
        elseif args=="위업" then    
            messageLines[#messageLines+1]=helpHead..MDRcolor("돌",0,"'위업'")
            
            messageLines[#messageLines+1]="▶"..MDRcolor("돌",0,"위업").." : "..MDRcolor("돌",0,"쐐기돌").." 위업 진행 상황을 요청합니다. 단수를 지정하지 않으면 ("..E..G..MDRcolor("돌",0,"위업")..") "..MDRcolor("영웅",0,"10단").."과 "..MDRcolor("전설",0,"15단").." 위업을 모두 체크하며, "..MDRcolor("노랑",0,"위업10, 위업15").." 처럼 단수를 지정할 경우 "..MDRcolor("하늘",0,"[해당 단수]").."의 위업만 체크합니다. "
            
        elseif args=="점수" then    
            local S=MDRcolor("계승",0,"점수")
            local S2=MDRcolor("계승",0,"!점수")
            messageLines[#messageLines+1]=helpHead..MDRcolor("계승",0,"'쐐기돌 평점'")
            
            messageLines[#messageLines+1]="|cffffffff▶"..S..": 현재 "..MDRcolor("핑크",0,"접속중").." 인 캐릭터의 "..MDRcolor("계승",0,"쐐기돌 평점").." 을 요청합니다. 각 |cff8fd1d8던전별|r 최고 기록을 |T236401:0:::-4|t"..MDRcolor("죽기",0,"폭군").."과 |T463829:0:::-4|t"..MDRcolor("죽기",0,"경화").."를 구분하여 색깔로 표시해 줍니다.|r "..E..G..S
            messageLines[#messageLines+1]="|cffffffff▶"..ME..S.."를 입력하면 본인이 소유한 "..MDRcolor("노랑",0,"'모든' 만렙 캐릭터").."의 점수를 출력합니다.|r "..E..P..ME..S
            messageLines[#messageLines+1]="|cffffffff▶"..S.."를 |cff8fd1d8!{던전명}|r 과 함께 입력하면 |cff8fd1d8해당 던전|r의 세부점수와 기록을 출력할 수 있습니다.|r"
            messageLines[#messageLines+1]="  -'"..G..S.."|cff8fd1d8!티르너|r".."' ▶ "..MDRcolor("길드",0,"길드원").." 모두의 |cff8fd1d8티르너|r 점수를 요청."
            messageLines[#messageLines+1]="|cffffffff▶"..S.."를 |cffA9D271!{닉네임}|r 과 함께 입력하면 |cffA9D271특정 캐릭터|r의 "..MDRcolor("계승",0,"총점")..", 혹은 |cff8fd1d8던전별|r 점수를 요청할 수 있습니다.|r"
            messageLines[#messageLines+1]="  -'"..P..S..MDRcolor(krClass,0,"!"..n1).."' ▶ "..MDRcolor(krClass,0,n1).."님의 총점을 "..PP.."로 요청."
            messageLines[#messageLines+1]="  -'"..G..S..MDRcolor(krClass,0,"!"..n1).."|cff8fd1d8!티르너|r".."' ▶ "..MDRcolor(krClass,0,n1).."님의 |cff8fd1d8티르너|r 점수를 "..GG.."로 요청."
            messageLines[#messageLines+1]="|cffffffff▶"..S.."를 |cff8fd1d8!{던전명}|r 과 함께 입력할 때 특정 "..MDRcolor("노랑",0,"단수").."를 지정하면 |cff8fd1d8해당 던전|r 을 이번주에 "..MDRcolor("노랑",0,"해당 단수").."로 클리어 했을 때 얻을 수 있는 점수를 "..MDRcolor("계승",0,"'예측'").."해볼 수 있습니다.|r"
            messageLines[#messageLines+1]="  -'"..P..S.."|cff8fd1d8!속죄|r"..MDRcolor("노랑",0,"16").."' ▶ |cff8fd1d8속죄|r"..MDRcolor("노랑",0,"16").."을 시클시 예상 점수를 |cFFaaaaff파티원|r 모두에게 요청."
            messageLines[#messageLines+1]="  -'"..G..S.."|cff8fd1d8!죽상|r"..MDRcolor("노랑",0,"15")..MDRcolor(krClass,0,"!"..n1).."' ▶ "..MDRcolor(krClass,0,n1).."님에게 |cff8fd1d8죽상|r"..MDRcolor("노랑",0,"15").."를 시클시 예상 점수를 "..GG.."로 요청."
            messageLines[#messageLines+1]="  -'"..P..ME..S.."|cff8fd1d8!역몰|r"..MDRcolor("노랑",0,"18").."' ▶ "..ME..MDRcolor("노랑",0," 모든 캐릭터").."가 |cff8fd1d8역몰|r"..MDRcolor("노랑",0,"18").."을 시클시 예상 점수를 "..PP.." 혹은 "..WW.."로 출력."
            --messageLines[#messageLines+1]="▷".."부캐의 정보를 알고자 할 경우, |cFF33FF99[2.9.0]|r+ 부터 |cffA9D271{닉네임}|r 혹은 |cffFF7D0A{직업명}|r 검색결과에 "..S.." 가 포함되도록 변경되었으므로 해당 기능을 이용하시면 됩니다. "..E..G..MDRcolor(krClass,0,n1)..", "..P.."|cffFFF569도적|r"
            
        else
            return
        end    
        if args and args~="" and args~="도움말"then
            messageLines[#messageLines+1]="▷ 다른 도움말: |cffffff00/! @ |r"..cmdList      
        end
    elseif cmd=="방해금지" or cmd=="방해" or cmd=="dnd" or cmd=="DND" then
        if not args then
            MDRtoggleMode(2)
        elseif args=="끄기" or args=="off" then
            MDRtoggleMode(2,0)
        elseif args=="켜기" or args=="on" then
            MDRtoggleMode(2,1)
        end
        return
    elseif cmd=="매너모드" or cmd=="매너" then
        if not args then
            MDRtoggleMode(1)
        elseif args=="끄기" or args=="off" then
            MDRtoggleMode(1,0)
        elseif args=="켜기" or args=="on" then
            MDRtoggleMode(1,1)
        end
        return
    elseif cmd=="모드" then
        MDRtoggleMode("tip")
        return
    else
        if strfind(strsub(msg,1,1),"!") then
            msg=strsub(msg,2,-1)
        end
        if msg=="금고" then
            MDRVault ()
            return
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
        --print("!"..at..msg)
        MDRsendAddonMessage("!"..at..msg,"GUILD",meGame)    
        return      
    end 
    for i=3,#messageLines do
        if i<#messageLines then
            messageLines[i]="|cffadadad"..messageLines[i].."|r"
        end    
    end  
    reportMessageLines(messageLines,"print","","help")
end

--명령어 등록
SLASH_MDReport1, SLASH_MDReport2, SLASH_MDReport3, SLASH_MDReport4 = '/mdr', '/Tho','/쐐',"/!"
SLASH_MDRparty1="/!!"
SLASH_MDRofficer1="/@"
SLASH_MDRalts1,SLASH_MDRalts2="/부캐","/qnzo"
SLASH_MDRhistory1,SLASH_MDRhistory2="/기록","/rlfhr"
SLASH_MDRVault1,SLASH_MDRVault2="/금고","/rmarh"
SLASH_MDRParking1,SLASH_MDRParking2="/주차","/wnck"
SLASH_MDRMykey1,SLASH_MDRMykey2,SLASH_MDRMykey3,SLASH_MDRMykey4="/돌","/내돌","/ehf","/soehf"
SlashCmdList["MDReport"] = MDRCommands 
SlashCmdList["MDRVault"] = MDRVault
SlashCmdList["MDRParking"] = MDRParking
SlashCmdList["MDRMykey"] = MDRMykey
SlashCmdList["MDRparty"] = MDRCommandsParty
SlashCmdList["MDRofficer"] = MDRCommandsOfficer
SlashCmdList["MDRalts"] = MDRalts
SlashCmdList["MDRhistory"] = MDRhistory

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

function MDRrefreshRunHistory()
    MDRconfig=MDRconfig or {}
    MDRconfig.Char=MDRconfig.Char or {}  
    MDRconfig.Char[meAddon]=MDRconfig.Char[meAddon] or {}
    
    local runHistory=C_MythicPlus.GetRunHistory(false, true);
    
    if MDR.itsOKtoRefresh~=1 then return end
    
    if MDR.runHistory and MDR.runHistory.finish then
        if #MDR.runHistory.finish > #runHistory then
            runHistory=MDR.runHistory.finish
        elseif #MDR.runHistory.finish == #runHistory then
            MDRclearHistory()            
        end  
    end
    
    MDRconfig.Char[meAddon].runHistory=runHistory  
    
    MDRconfig.Char[meAddon].Score={}
    MDRconfig.Char[meAddon].Score["종합점수"]=C_ChallengeMode.GetOverallDungeonScore()  --총점
    
    for d,n in pairs(MDR.dungeonNameToID)do  -- 던전별 점수
        local desc,total=C_MythicPlus.GetSeasonBestAffixScoreInfoForMap(n)
        MDRconfig.Char[meAddon].Score[d]={}
        MDRconfig.Char[meAddon].Score[d]["점수"]=total
        for i=1,2 do
            local affix
            local affixTable=desc[i]
            if affixTable then 
                affix=affixTable["name"]                
            end
            if affix then            
                MDRconfig.Char[meAddon].Score[d][affix]=affixTable or {}            
            end
        end        
    end
    
    
    if MDR.runHistory then
        MDR.runHistory.onLoad=runHistory
    end
    
    local comparison = function(entry1, entry2)
        if ( entry1.level == entry2.level ) then
            return entry1.mapChallengeModeID < entry2.mapChallengeModeID;
        else
            return entry1.level > entry2.level;
        end
    end
    table.sort(runHistory, comparison)
    
    local clearedLevels={}
    if runHistory and #runHistory>0 then
        for i=1,#runHistory do
            local level=runHistory[i].level
            local completed=runHistory[i].completed
            if (not clearedLevels[level]) or (clearedLevels[level]=="now" and completed) then
                clearedLevels[level]=completed
            end
        end
    end
    MDRconfig.Char[meAddon].reward1=runHistory[1] and runHistory[1].level or nil
    local bestLevel=MDRconfig.Char[meAddon].reward1
    if bestLevel then        
        MDRconfig.Char[meAddon].bestLevelCompleted=clearedLevels[bestLevel]
    end    
    MDRconfig.Char[meAddon].reward4=runHistory[4] and runHistory[4].level or nil
    MDRconfig.Char[meAddon].reward10=runHistory[10] and runHistory[10].level or nil
    MDRconfig.Char[meAddon].runs=#runHistory
    
    --print("MDRrefreshRunHistory",#MDRconfig.Char[meAddon].runHistory)
    
end

function MDRclearHistory()
    if not MDR.runHistory then
        MDR.runHistory={}
    end
    MDR.runHistory.finish=nil
end

function MDRgetHistory(type)  
    if not MDR.runHistory then
        MDR.runHistory={}
    end
    
    local meAddon=UnitName("player").." - "..GetRealmName()
    
    --런히스토리 새로고침
    MDRrefreshRunHistory()
    
    local k=MDRconfig.Char[meAddon]
    
    local runHistory = k.runHistory or {}  
    --print("MDRgetHistory",type)
    --print("runHistory",#runHistory)
    if type=="onLoad" then
        MDR.runHistory[type]=runHistory    
    elseif type=="start" then    
        MDR.runHistory[type]=runHistory
        MDRclearHistory()
    elseif type=="finish" then
        if (not MDR.runHistory.start) then
            MDR.runHistory.start=MDR.runHistory.onLoad
        end
        if (not MDR.myMythicKey.start) then
            MDR.myMythicKey.start=MDR.myMythicKey.onLoad
        end 
        local tempL,_=C_ChallengeMode.GetActiveKeystoneInfo()
        local t={}
        t.completed="now"
        t.mapChallengeModeID=MDR.myMythicKey.start.currentMapID
        t.level=MDR.myMythicKey.start.currentLevel
        t.thisWeek=true
        local tempTable=MDR.runHistory.start
        tempTable[#tempTable+1]=t    
        if t.mapChallengeModeID then
            MDR.runHistory.finish=tempTable
            MDR.runHistory.onLoad=tempTable        
            k.runHistory=tempTable
            k.runs=#tempTable
            local VALUES={}
            VALUES.runHistory=MDR.runHistory.finish
            VALUES.main=1
            VALUES.alt=1
            VALUES.includeMain=1
            VALUES.type=type
            VALUES.onlyMain=1
            VALUES.detail=1
            MDRdoReportHistory(VALUES)
        end
    elseif type=="vault" or type=="parking" then
        local VALUES={}    
        if type=="vault" then        
            VALUES.main=nil        
            VALUES.alt=1
            VALUES.includeMain=1            
        else
            VALUES.main=nil
            VALUES.alt=1
            VALUES.includeMain=1            
        end           
        --type="onLoad"    
        VALUES.type=type
        VALUES.onlyMain=nil
        VALUES.detail=nil
        
        if MDR.runHistory and MDR.runHistory.finish then
            VALUES.runHistory=MDR.runHistory.finish        
        else      
            VALUES.runHistory=MrunHistory            
        end      
        
        MDRdoReportHistory(VALUES)    
    end
    
    k.class=nil
    k.level=nil    
    
    k.Class=krClass
    k.Level=UnitLevel("player")  
    k.name=meAddon
    k.Faction=UnitFactionGroup("player")
    k.LastSeen = time()
    k.Covenant=MDRgetCovenantName(C_Covenants.GetActiveCovenantID())
    
    local IL,ILe = GetAverageItemLevel()
    if IL and tonumber(IL) and tonumber(IL) > 0 then
        k.IL, k.ILe = tonumber(IL), tonumber(ILe)
    end
    
    local kName,kLevel,kLink  
    for bagID = 0, 4 do
        for invID = 1, GetContainerNumSlots(bagID) do
            local itemID = GetContainerItemID(bagID, invID)
            if itemID and itemID == 180653 then
                local keyLink = GetContainerItemLink(bagID, invID)
                local KeyInfo = {strsplit(':', keyLink)}
                local mapID = tonumber(KeyInfo[3])
                local mapLevel = tonumber(KeyInfo[4])
                kName = C_ChallengeMode.GetMapUIInfo(mapID)
                kLevel = mapLevel
                kLink = keyLink
            end
        end
    end
    k.MythicKey={}
    k.MythicKey.level=kLevel
    k.MythicKey.name=kName
    k.MythicKey.link=kLink
    if kLink then
        k.MythicKey.ResetTime = time() + C_DateAndTime.GetSecondsUntilWeeklyReset()
    end
    
    k.keyLink=nil
    
    if MDR.runHistory.finish then 
        k.runHistory=MDR.runHistory.finish
    elseif (MDR.thisCharHasKey==1 or runHistory) then
        k.runHistory=MDR.runHistory[type] or runHistory  
    end
    local newRunHistory=k.runHistory
    local comparison = function(entry1, entry2)
        if ( entry1.level == entry2.level ) then
            return entry1.mapChallengeModeID < entry2.mapChallengeModeID;
        else
            return entry1.level > entry2.level;
        end
    end
    table.sort(newRunHistory, comparison)
    
    k.reward1=newRunHistory[1] and newRunHistory[1].level or nil
    k.reward4=newRunHistory[4] and newRunHistory[4].level or nil
    k.reward10=newRunHistory[10] and newRunHistory[10].level or nil
    
    MDRconfig.Char[meAddon]=k
end  

function MDRremoveCharInfo(args)
    if args=="" or not args then 
        print(MDRcolor("빨강",0,"▶ ").."삭제하고자 하는 캐릭터의 이름을 입력해주세요.")
        print(MDRcolor("빨강",0,"▶ ").."|cFF33FF99ex)|r "..MDRcolor("노랑",0,"/기록")..MDRcolor("빨강",0," 삭제")..MDRcolor("핑크",0," 캐릭터이름 (정확히 일치)"))
        return
    end
    for k,v in pairs (MDRconfig.Char) do
        local name=string.gsub(MDRsplit(k," - ")[1], "(%a)([%w_']*)", MDRtitleLower)
        local target=string.gsub(args, "(%a)([%w_']*)", MDRtitleLower)
        if name==target then
            MDRconfig.Char[k]=nil
            print(MDRcolor("빨강",0,"▶ ")..MDRcolor(v.Class or v.class or "핑크",0,"["..k.."]").." 의 저장된 정보가 삭제되었습니다.")
            return      
        end
    end
    print(MDRcolor("빨강",0,"▶ ")..MDRcolor("핑크",0,"["..charName.."]").." 을/를 포함하는 캐릭터를 찾을 수 없습니다.")      
    return
end

function MDRdoReportHistory(VALUES) 
    
    local runHistory=VALUES.runHistory
    local main=VALUES.main
    local alt=VALUES.alt
    local includeMain=VALUES.includeMain
    local type=VALUES.type
    local onlyMain=VALUES.onlyMain
    local detail=VALUES.detail
    local charName=VALUES.charName
    
    local messageLines={}
    local comm=""
    if type=="finish" then
        comm=MDRcolor("핑크",0,"[쐐기 완료]").." "
    elseif type=="start" then
        comm=MDRcolor("핑크",0,"[쐐기 시작]").." "
    elseif type=="vault" or type=="onLoad" then
        comm=MDRcolor("유물",0,"[금고]").." "
    elseif type=="alts" then
        comm=MDRcolor("계승",0,"[부캐]").." "
    elseif type=="history" then
        comm=MDRcolor("핑크",0,"[기록]").." "
    elseif type=="parking" then
        comm=MDRcolor("흑마",0,"[주차]").." "
    end  
    
    if MDR.runHistory and MDR.runHistory.finish then
        runHistory=MDR.runHistory.finish
    end  
    local classColor=MDR.classColor
    local classIcon=MDR.classIcon
    
    local class,_=UnitClass("player")
    local name=UnitName("player")
    
    if not runHistory and (not charName or charName=="") then
        MDRrefreshRunHistory()    
        runHistory = MDRconfig.Char[meAddon].runHistory  
    elseif charName and charName~="" then
        local toons=MDRconfig.Char
        local findChar,isFullLevel=0,0
        local altName=""
        for k,v in pairs (toons) do
            local class=v.Class or v.class
            local shortClass=MDRcolor(class,6)
            local level=v.Level or v.level
            if (strfind(k,charName) or strfind(class,charName) or strfind(shortClass,charName)) then
                findChar=findChar+1
                if level==MDR.SCL then
                    charName=k
                    isFullLevel=1
                else
                    altName=MDRsplit(k," - ")[1]
                    altClass=MDRcolor(v.Class or v.class,6)
                end
            end      
        end
        
        if findChar>0 and isFullLevel==0 then
            print(MDRcolor("빨강",0,"▶ ")..classIcon[altClass].."|cff"..classColor[altClass].."["..altName.."]|r".." 은/는 만렙이 아닙니다.")
            return
        elseif not MDRconfig.Char[charName] then 
            print(MDRcolor("빨강",0,"▶ ")..MDRcolor("핑크",0,"["..charName.."]").." 을/를 포함하는 캐릭터를 찾을 수 없습니다.")
            return
            
        end
        runHistory=MDRconfig.Char[charName].runHistory
        class=MDRconfig.Char[charName].Class or MDRconfig.Char[charName].class
        name=MDRsplit(MDRconfig.Char[charName].name," - ")[1]   
    end    
    
    local rewardLevel_season_two={ 
        [2]=223,    
        [3]=226,
        [4]=229,
        [5]=233,
        [6]=236,
        [7]=236,
        [8]=239,
        [9]=239,
        [10]=242,
        [11]=242,
        [12]=246,
        [13]=246,
        [14]=249,
        [15]=252,
    }
    --[[
    local maxreward=C_MythicPlus.GetRewardLevelFromKeystoneLevel(15)
    ]]
    local rewardLevel  
    rewardLevel=rewardLevel_season_two
    
    for i=16,40 do
        rewardLevel[i]=rewardLevel[15]
    end
    
    local toons=MDRconfig.Char      
    local howManyToons=0
    local newtoons={}
    for k,v in pairs( toons) do
        if (k~=meAddon or (includeMain and k==meAddon)) and v.runHistory and (v.Level==MDR.SCL or v.level==MDR.SCL) then  
            v["runs"]=#v.runHistory
            v["name"]=k
            
            tinsert(newtoons,v)
            table.sort(newtoons, function(a,b)
                    return a.runs > b.runs or a.runs == b.runs and a.runs < b.runs
            end)
            howManyToons=howManyToons+1        
        end      
    end     
    
    local guide=""
    local mainIcon=classIcon[MDRcolor(class,6)]
    if type=="finish" then
        guide=" |cff9d9d9d(다른 캐릭터를 보시려면 |cffffff00'/주차'|r 입력)|r"
    elseif type=="alts" then
        guide=""
    end
    
    local guideHistory="|cFF33FF99▶|r |cff9d9d9d"..mainIcon..MDRcolor(class,0,"["..name.."]").." 님의 "..MDRcolor("하늘",0,"[이번주 기록]").." 을 보시려면 |cffffff00'/기록'|r 입력." 
    local guideAlts="|cFF33FF99▶|r |cff9d9d9d"..MDRcolor("계승",0,"[다른 캐릭터]").." 의 기록을 보시려면 |cffffff00'/기록 "..MDRcolor("핑크",0,"캐릭명").." 또는 "..MDRcolor(class,0,"직업명").."'|r 입력.|r"
    local guideFinish="|cFF33FF99▶|r |cff9d9d9d"..MDRcolor("계승",0,"[세부 기록]").." 을 보시려면 |cffffff00'/기록'|r 입력." 
    local guideDelete=MDRcolor("빨강",0,"▶ ").."|cff9d9d9d"..MDRcolor("유물",0,"[저장된 기록]").." 을 "..MDRcolor("빨강",0,"삭제").."하시려면 "..MDRcolor("노랑",0,"'/기록")..MDRcolor("빨강",0," 삭제")..MDRcolor("노랑",0,"'").." 입력."
    local guideB,tipB="",""
    if main then
        if #runHistory > 0 then    
            local comparison = function(entry1, entry2)
                if ( entry1.level == entry2.level ) then
                    return entry1.mapChallengeModeID < entry2.mapChallengeModeID;
                else
                    return entry1.level > entry2.level;
                end
            end
            table.sort(runHistory, comparison);
            
            messageLines[#messageLines+1]="|cFF33FF99MDR▶|r "..comm.."이번주 "..mainIcon..MDRcolor(class,0,"["..name.."]").." 님의 쐐기 기록은 총 |cffF5aCdA["..#runHistory.."회]|r 입니다."
            
            if not alt or (alt and not onlyMain) then
                for i = 1, #runHistory do
                    local runInfo = runHistory[i];
                    local name = C_ChallengeMode.GetMapUIInfo(runInfo.mapChallengeModeID);
                    local coveIcon=MDRgetCovenantIcon(MDRgetCovenantID(getShortDungeonName(name)))
                    local timed=runInfo.completed        
                    if timed==true then
                        timed="|TInterface\\RaidFrame\\ReadyCheck-Ready:0:0:0:-5|t"
                    elseif timed=="now" then          
                        timed="|TInterface\\RaidFrame\\ReadyCheck-Waiting:0:0:0:-5|t"          
                    else
                        timed="|TInterface\\RaidFrame\\ReadyCheck-NotReady:0:0:0:-5|t"
                    end
                    
                    local color1,color2,color3,tip,reward,level
                    if i==1 or i==4 or i==10 then
                        level=runInfo.level
                        if level>15 then level=15 end
                        color1="전설"
                        color2="초록"
                        color3="노랑"
                        reward=" ▶ [|TInterface\\GroupFrame\\UI-Group-MasterLooter:0:0:0:-4|t"..i.."회 보상: "..rewardLevel[level].." 레벨".."]"
                    else
                        color1="사제"
                        color2="회색" 
                        color3="회색" 
                        reward=""       
                    end     
                    if i<=10 then 
                        local space=""
                        if runInfo.level<10 then 
                            space=" "
                        end
                        message=" "..timed..MDRcolor(color2,0,"["..i.."] ")..MDRcolor(color1,0,space..runInfo.level.."단").." "..coveIcon..MDRcolor(color2,0,name)..MDRcolor(color3,0,reward)
                        messageLines[#messageLines+1]=message
                    end     
                end
            end
            
            if #runHistory <4 then
                tip=MDRcolor("빨강",0,"▶ ").."다음주 "..MDRcolor("하늘",0,"[4회 보상]").."을 개방하려면 쐐기를 |cffffff00'"..(4-#runHistory).."회'|r 더 가야 합니다."..(howManyToons>1 and guide or "")
            elseif #runHistory <10 then
                tip=MDRcolor("빨강",0,"▶ ").."다음주 "..MDRcolor("하늘",0,"[10회 보상]").."을 개방하려면 쐐기를 |cffffff00'"..(10-#runHistory).."회'|r 더 가야 합니다."..(howManyToons>1 and guide or "")
            else
                tip=nil
            end
            if tip then
                if not onlyMain then
                    messageLines[#messageLines+1]=tip                
                else
                    tipB=tip
                end
            end
        else
            if UnitLevel("player") == MDR.SCL then
                messageLines[#messageLines+1]="|cFF33FF99MDR▶|r "..comm.."이번주 "..MDRcolor(class,0,"["..name.."]").." 님은 아직 쐐기 기록이 없습니다. |cffF5aCdA[나에게만 보임]|r" 
            else
                messageLines[#messageLines+1]="|cFF33FF99MDR▶|r "..comm..MDRcolor(class,0,"["..name.."]").." 님은 아직 만렙이 아닙니다. |cffF5aCdA[나에게만 보임]|r" 
            end
        end
    end  
    if alt or onlyMain then
        --부캐정보    
        if howManyToons>=0 then
            local allOrAlt=""
            if not onlyMain then
                if includeMain then
                    allOrAlt=MDRcolor("유물",0,"모든 만렙 캐릭터")    
                else
                    allOrAlt=MDRcolor("계승",0,"다른 만렙 캐릭터")    
                end
                messageLines[#messageLines+1]="|cFF33FF99MDR▶|r "..comm..mainIcon..MDRcolor(class,0,"["..UnitName("player").."]").." 님의 "..allOrAlt..": "..MDRcolor("핑크",0,"[총 "..howManyToons.."개]") 
            end
            
            for _,v in pairs(newtoons) do
                if ((not onlyMain and (v["name"]~=meAddon or (includeMain and v["name"]==meAddon))) or (onlyMain and v["name"]==meAddon))
                and v.runHistory and (v.level==MDR.SCL or v.Level==MDR.SCL) then
                    
                    local altName=MDRsplit(v["name"]," - ")[1]
                    local class=v.Class or v.class 
                    local levels,rewards="",""
                    local icon=classIcon[MDRcolor(class,6)]
                    local comparison = function(entry1, entry2)
                        if ( entry1.level == entry2.level ) then
                            return entry1.mapChallengeModeID < entry2.mapChallengeModeID;
                        else
                            return entry1.level > entry2.level;
                        end
                    end
                    table.sort(v.runHistory, comparison);
                    for j=1,#v.runHistory do
                        if j==1 or j==4 or j==10 then
                            levels=levels.."|cff00ff00"..v.runHistory[j].level.."|r, "
                            rewards=rewards.."|cffffff00"..rewardLevel[v.runHistory[j].level].."레벨|r, " 
                            MDRconfig.Char[v["name"]]["reward"..j]=v.runHistory[j].level
                        else            
                            levels=levels.."|cff9d9d9d"..v.runHistory[j].level.."|r, "
                        end         
                    end
                    if strsub(levels,-2,-1)==", " then
                        levels=strsub(levels,1,-3)
                    end 
                    if strsub(rewards,-2,-1)==", " then
                        rewards=strsub(rewards,1,-3)
                    end   
                    if rewards~="" then
                        rewards=" [|TInterface\\GroupFrame\\UI-Group-MasterLooter:0:0:0:-4|t보상: "..rewards.."]"
                    end          
                    if #v.runHistory==0 then 
                        levels=MDRcolor("유물",0,"이번주 기록이 없습니다.")
                    end
                    messageLines[#messageLines+1]="  "..MDRcolor("하늘",0,"["..#v.runHistory.."회]").." "..icon..MDRcolor(class,0,"["..altName.."]")..": "..levels..rewards
                    --print("  "..MDRcolor("하늘",0,"["..#v.runHistory.."회]"),MDRcolor(class,0,"["..altName.."]")..":",levels)
                end        
            end 
        end 
        if onlyMain then
            messageLines[#messageLines+1]=tipB
        end
        if UnitLevel("player") == MDR.SCL and not main then
            messageLines[#messageLines+1]=guideHistory
        end
        if type=="finish" then
            messageLines[#messageLines+1]=guideFinish
        elseif howManyToons>1 then
            messageLines[#messageLines+1]=guideAlts    
        end
    end
    if type=="alts" or type=="parking" then
        messageLines[#messageLines+1]=guideDelete
    end
    reportMessageLines(messageLines,nil,nil,"vault")  
end

local dungeonCovenant={
    ["승천"]=1,
    ["죽상"]=1,
    ["키리안"]=1,
    
    ["속죄"]=2,
    ["핏심"]=2,
    ["벤티르"]=2,
    
    ["티르너"]=3,
    ["저편"]=3,
    ["나이트 페이"]=3,
    
    ["역병"]=4,
    ["투기장"]=4,
    ["강령군주"]=4,        
}

function MDRgetCovenantIcon(covenantID)
    
    local iconSize=0
    local covenantMap = {
        [1] = "kyrian",
        [2] = "venthyr",
        [3] = "night_fae",
        [4] = "necrolord",
    }
    
    local covenant  
    
    if not covenantID then
        return ""    
    elseif tonumber(covenantID) and covenantID > 0 and covenantID < 5 then 
        covenant=covenantMap[covenantID] 
    elseif dungeonCovenant[covenantID] then      
        covenant=covenantMap[dungeonCovenant[covenantID]] 
    end   
    return "|T".."Interface\\AddOns\\MDReport\\icon\\"..covenant..".tga:"..iconSize..":"..iconSize..":0:-5|t"    
end

function MDRgetCovenantName(covenantID)
    local covenant = {
        [1] = "키리안",
        [2] = "벤티르",
        [3] = "나이트 페이",
        [4] = "강령군주",
    }
    return covenant[covenantID]
end

function MDRgetDungeonCovenant(dungeon)
    for k,v in pairs(dungeonCovenant) do
        if covenantID==v then
            return k
        end
    end
end

function MDRgetCovenantID(keyword)
    for k,v in pairs(dungeonCovenant) do
        if keyword==k then
            return v
        end
    end
    return 0
end

function MDRdoEmote(channel,who,keyword)
    local emote={
        ["얼라이언스를위하여"]="forthealliance",
    }  
    local delay=0
    if who~=meGame then    
        delay=2
    end
    if emote[keyword] then
        C_Timer.After(delay, function()
                DoEmote(emote[keyword])
        end)     
    end  
end

function MDRtoggleMode(mode,toggle)
    
    MDRconfig=MDRconfig or {}
    
    local modeName,toggleType    
    
    local toggleOn=MDRcolor("초록",0,"[활성화]")
    local toggleOff=MDRcolor("회색",0,"[비활성화]")
    
    if mode==1 then
        mode="MannerMode"    
        modeName=MDRgetModeName(1)
    elseif mode==2 then
        mode="DNDMode" 
        modeName=MDRgetModeName(2)
    else
        local activeMode,message,tip="","",""
        if MDRconfig.MannerMode==1 then 
            activeMode=activeMode..MDRgetModeName(1)
            tip="|cffffff00'/! 매너'|r"
        end
        if MDRconfig.DNDMode==1 then       
            activeMode=activeMode..(activeMode=="" and "" or ", ")..MDRgetModeName(2)
            tip=tip..(tip=="" and "" or ", ").."|cffffff00'/! 방해'|r"      
        end    
        if activeMode~="" then 
            if mode=="tip" then        
                tip="|cff9d9d9d [비활성화: "..tip.."]|r"     
            else 
                tip=""
            end
            message=MDRcolor("수도",0,"▶").."현재 "..activeMode.." 가 "..toggleOn.." 되어 있습니다. "..tip      
        else
            if mode=="tip" then         
                message=MDRcolor("수도",0,"MDR▶").."현재 "..toggleOn.." 된 모드가 없습니다."
            else
                return        
            end       
        end
        print(message)
        return
    end
    
    local current=MDRconfig[mode] or 0
    
    local switch  
    
    if toggle=="on" or toggle==1 then
        switch=1
    elseif toggle=="off" or toggle==0 then
        switch=0
    else
        if current==0 then
            switch=1
        else
            switch=0
        end    
    end  
    if switch==1 then
        toggleType=toggleOn
    else
        toggleType=toggleOff
    end  
    print(MDRcolor("수도",0,"MDR▶")..modeName.." 가 "..toggleType.." 되었습니다.")
    MDRconfig[mode]=switch   
end

function MDRgetModeName(mode)
    local MMicon="|TInterface\\AddOns\\MDReport\\icon\\mode_manner.tga:0:0:-1:-5|t"
    local DNDicon="|TInterface\\AddOns\\MDReport\\icon\\mode_DND.tga:0:0:-1:-5|t"  
    local DNDname=MDRcolor("하늘",0,"["..DNDicon.."방해 금지 모드]")
    local MMname=MDRcolor("핑크",0,"["..MMicon.."매너 모드]")
    if mode==1 then 
        return MMname
    else
        return DNDname
    end
end

function MDRgetCurrentStatus()  
    local status=""
    local here,_,_,_,_,_,_,ID=GetInstanceInfo()  
    local coveHere=MDRgetCovenantID(getShortDungeonName(here))
    if coveHere >0 then
        status="{D}"
    elseif IsInRaid() then    
        status="{R}"
    elseif ID==2162 then
        status="{T}"
    elseif MDRconfig.DNDMode==1 then
        status="{DND}"
    end
    return status
end

function MDRcheckAchievement(level,channel,who)    
    local colorTable={}
    colorTable["전설"]="|cffff8000"
    colorTable["영웅"]="|cffa335ee"
    colorTable["회색"]="|cff9d9d9d"
    colorTable[5]=colorTable["회색"]
    colorTable[0]=colorTable["회색"]
    
    if level==15 then
        colorTable[15]=colorTable["전설"]
        colorTable[10]=colorTable["회색"]       
        colorTable["헤더"]=colorTable["전설"]
    elseif level==10 then
        colorTable[15]=colorTable["영웅"]
        colorTable[10]=colorTable["영웅"]
        colorTable["헤더"]=colorTable["영웅"]
    else
        colorTable[15]=colorTable["전설"]
        colorTable[10]=colorTable["영웅"]
        colorTable["헤더"]=""
    end
    
    local dungeonTable={
        [1]="핏",
        [2]="속",
        [3]="승",
        [4]="죽",
        [5]="고",
        [6]="역",
        [7]="티",
        [8]="저",        
    }
    
    local table={}
    
    for crit=1,8 do 
        local d,_,c15 = GetAchievementCriteriaInfo(14532, crit~=13 and crit or 14);
        local d,_,c10 = GetAchievementCriteriaInfo(14531, crit~=13 and crit or 14);        
        d=strsub(d,1,3)             
        if c15 then    
            table[d]=15
        elseif c10 then
            table[d]=10
        else
            table[d]=0
        end    
    end
    
    local dungeonHistory=""
    local color=""
    local colorB=""
    local cleared={}
    for i=1,#dungeonTable do
        local d=dungeonTable[i]
        colorB=color
        if table[d]==15 then
            color=colorTable[15]
            cleared[15]=(cleared[15] or 0)+1
            cleared[10]=(cleared[10] or 0)+1
        elseif table[d]==10 then
            color=colorTable[10]
            cleared[10]=(cleared[10] or 0)+1
        else
            color=colorTable[0]
        end
        if colorB==color then            
            color="" 
        else
            if d~="핏" then
                color="|r"..color                
            end            
        end
        local icon=","
        if d=="핏" then
            icon="{c2}"
        elseif d=="승" then
            icon="{c1}"
        elseif d=="고" then
            icon="{c4}"
        elseif d=="티" then
            icon="{c3}"
        end
        dungeonHistory=dungeonHistory..icon..color..d
    end
    --dungeonHistory=MDRcolorizeForPrint(dungeonHistory)
    
    local message=""
    local header=""
    if level and cleared[level] then       
        header=colorTable["헤더"]..level.."단|r "..cleared[level].."/"..#dungeonTable.." 완료"
    else 
        local progress10,progress15="",""
        if cleared[10]==#dungeonTable then
            progress10="{완}, "
        else
            progress10="{미완}, "
        end
        if cleared[15]==#dungeonTable then
            progress15="{완}"
        else
            progress15="{미완}"
        end
        header=colorTable["영웅"].."10단|r"..progress10..colorTable["전설"].."15단|r"..progress15
    end
    
    if cleared[level]==#dungeonTable then
        message="["..header.."{완}]"
    elseif not level and cleared[15]==#dungeonTable then
        message="["..header.."]"
    else
        message="["..header..": "..dungeonHistory.."|r]"
    end
    local messageLines={}
    messageLines[1]=message
    reportAddonMessage(messageLines,channel,who,"achievement")
end
