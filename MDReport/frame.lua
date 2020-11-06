local MDRF = CreateFrame("Frame")

MDRF:RegisterEvent("CHAT_MSG_PARTY")
MDRF:RegisterEvent("CHAT_MSG_PARTY_LEADER") 
MDRF:RegisterEvent("CHAT_MSG_GUILD")
MDRF:RegisterEvent("CHAT_MSG_WHISPER")
MDRF:RegisterEvent("CHAT_MSG_WHISPER_INFORM")
MDRF:RegisterEvent("CHAT_MSG_SYSTEM")

MDRF:SetScript("OnEvent", function(self, event, ...)
        
        local msg=select(1, ...)      
        
        if (event=="CHAT_MSG_SYSTEM") then 
            MDRdice(msg)
            return
        end   
        
        --애드온에 의해 출력된 메시지는 무시
        if strfind(msg,"▶") or strfind(msg,"▷")then return end
        
        --!로시작하지않고 끝자리가 !가 아니면        
        if strsub(msg, 0,1)~="!" then 
            if  strfind(msg,"!") and strsub(msg, -1)~="!"then
                msg="!"..(MDRsplit(msg,"!")[2] or "") 
            else return end --!가 없으면 리턴
        end
        
        local channel
        
        if (event== "CHAT_MSG_PARTY") or (event == "CHAT_MSG_PARTY_LEADER") then
            channel="PARTY"
        elseif (event== "CHAT_MSG_GUILD") then
            channel="GUILD"
        elseif (event=="CHAT_MSG_OFFICER") then
            channel="OFFICER" 
        elseif (event=="CHAT_MSG_WHISPER_INFORM") then
            channel="WHISPER_OUT"            
        elseif (event=="CHAT_MSG_WHISPER") then
            channel="WHISPER_IN"            
        else return end
        
        local who=select(2, ...)
        
        if MDR["running"]==1 then 
            if MDR["meGame"]==who then
                local message
                if MDR["who"]~=who then
                    message="|cffff0000▶"..msg.."|r: "..MDRcolor("["..MDRsplit(MDR["who"],"-")[1].."]",-1).." 님의 요청을 먼저 처리하고 있습니다. "..MDRcolor("도적",0,MDR["cooltime"].."초").." 후 다시 시도하세요."
                else                    
                    message="|cffff0000▶"..msg.."|r: 검색 결과가 섞이지 않게 하기 위해 "..MDRcolor("도적",0,MDR["cooltime"].."초").."의 재사용 대기시간을 두고 있습니다. 잠시 후 다시 시도하세요."
                end
                print(message)
            end            
            return
        end
        
        --느낌표와 띄어쓰기 잘라냄
        local keyword=gsub(strsub(msg,2)," ","")        
        local keyIsNumber=tonumber(keyword)
        local ELC=strsub(keyword,1,-2)        
        local LOCT=strsub(keyword,-1)
        
        local level1,level2
        local onlyMe,onlyOnline,CharName,onlyYou
        local VALUES={} 
        
        local k={} 
        local callTypeT={}
        k[1]=keyword          
        
        --명령어가 이중인지 체크        
        if strfind(keyword,"!") then
            k=MDRsplit(keyword,"!")          
            
            --중간에 ~를 넣은 명령어면
        elseif strfind(keyword,"~") then
            
            local space="~"
            
            local before=MDRsplit(keyword,space)[1]
            local after=MDRsplit(keyword,space)[2]
            local num1=tonumber(before)
            local num2=tonumber(after)      
            
            --숫자만 입력했으면
            if num1~=nil and num2~=nil then
                k[1]="아무"
                level1=num1
                level2=num2
                
            else --던전명을 같이 넣었으면 
                local _,string,LN=MDRnumsplit(before)
                k[1]=string
                level1=LN or 2
                level2=num2 or 99
            end  
            
            --마지막이 +나 -면
        elseif strfind(LOCT,"+") or strfind(LOCT,"-") then
            -- +,-랑 숫자만 입력했으면
            if tonumber(ELC) then
                k[1]="아무"                
                level1=tonumber(ELC)                
            else                
                local _,string,LN=MDRnumsplit(ELC)
                --내나 지금만 붙였으면
                if string=="내" or string=="지금" then
                    string=string.."돌"
                end
                k[1]=string or "아무"                               
                level1=LN                
            end
            if LOCT=="+" then
                level2=99
            else
                level2=2
            end           
            
            --숫자만 입력한 경우
        elseif keyIsNumber then
            k[1]="아무"           
            level1=keyIsNumber
            --숫자와 단어의 조합이면
        else
            local KFN,Kstring,KLN=MDRnumsplit(keyword)
            k[1]=Kstring
            level1=KLN or KFN         
        end   
        
        --명령어 판독 시작
        if k[1]=="주사위" then
            MDRmakeDice(channel,who,k)
            MDR["running"]=1            
            return            
        end   
        
        local ct=1
        for i=1,#k do
            if getCallTypeTable(k[i]) then
                callTypeT[ct]=getCallTypeTable(k[i])
                ct=ct+1
            end            
        end        
        
        if callTypeT[1] and k[2]~="" and not getCallTypeTable(k[2]) then        
            onlyYou=k[2] 
        elseif callTypeT[1] and k[1]~="" and not getCallTypeTable(k[1]) then            
            onlyYou=k[1]            
        end        
        
        --명령어가 발견이 안되면
        if k[1] and not callTypeT[1] then
            local name=k[1]
            if strfind(k[1],"내") then             
                k[1]=gsub(k[1],"내","")
                onlyMe=1
            end            
            if strfind(k[1],"지금") then
                k[1]=gsub(k[1],"지금","")
                onlyOnline=1                
            end
            callTypeT[1]=getCallTypeTable(k[1])
            --내,지금을 잘라내고도 명령어를 못찾으면 이름검색시도
            if ((not callTypeT[1]) and name~="") then
                callTypeT[1]=getCallTypeTable("아무")
                CharName=name                
            end
            
        end
        
        --작은수가 먼저오게 조절
        if level1 and level2 then
            if level2<level1 then
                local level3=level1
                level1=level2
                level2=level3
            end            
        end               
        
        if callTypeT[1] then
            VALUES["callTypeT"]=callTypeT
            VALUES["level"]=level1
            VALUES["level2"]=level2     
            VALUES["channel"]=channel            
            VALUES["who"]=who   
            VALUES["onlyMe"]=onlyMe
            VALUES["onlyYou"]=onlyYou
            VALUES["onlyOnline"]=onlyOnline           
            VALUES["CharName"]=CharName
            
            filterVALUES(VALUES)
            MDR["who"]=who
            MDR["running"]=1
            --일치하는 명령어가 없으면 리턴
        else return end
end)

