local MDR = CreateFrame("Frame")

MDR:RegisterEvent("CHAT_MSG_PARTY")
MDR:RegisterEvent("CHAT_MSG_PARTY_LEADER") 
MDR:RegisterEvent("CHAT_MSG_GUILD")
MDR:RegisterEvent("CHAT_MSG_WHISPER")
MDR:RegisterEvent("CHAT_MSG_WHISPER_INFORM")

MDR:SetScript("OnEvent", function(self, event, ...)
        local msg=select(1, ...)
        
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
        
        --느낌표와 띄어쓰기 잘라냄
        local keyword=gsub(strsub(msg,2)," ","")        
        local keyIsNumber=tonumber(keyword)
        local ELC=strsub(keyword,1,-2)        
        local LOCT=strsub(keyword,-1)
        
        local k1=keyword
        local k2,level1,level2,callTypeT1,callTypeT2
        local onlyMe,onlyOnline,CharName
        local VALUES={}        
        
        --명령어가 이중인지 체크        
        if strfind(keyword,"!") then
            k1=MDRsplit(keyword,"!")[1] 
            k2=MDRsplit(keyword,"!")[2]            
            
            --중간에 ~를 넣은 명령어면
        elseif strfind(keyword,"~")then
            
            local space="~"
            
            local before=MDRsplit(keyword,space)[1]
            local after=MDRsplit(keyword,space)[2]
            local num1=tonumber(before)
            local num2=tonumber(after)      
            
            --숫자만 입력했으면
            if num1~=nil and num2~=nil then
                k1="아무"
                level1=num1
                level2=num2
                
            else --던전명을 같이 넣었으면 
                local _,string,LN=MDRnumsplit(before)
                k1=string
                level1=LN or 2
                level2=num2 or 99
            end  
            
            --마지막이 +나 -면
        elseif strfind(LOCT,"+") or strfind(LOCT,"-") then
            -- +,-랑 숫자만 입력했으면
            if tonumber(ELC) then
                k1="아무"                
                level1=tonumber(ELC)                
            else                
                local _,string,LN=MDRnumsplit(ELC)
                --내나 지금만 붙였으면
                if string=="내" or string=="지금" then
                    string=string.."돌"
                end
                k1=string or "아무"                               
                level1=LN                
            end
            if LOCT=="+" then
                level2=99
            else
                level2=2
            end           
            
            --숫자만 입력한 경우
        elseif keyIsNumber then
            k1="아무"           
            level1=keyIsNumber
            --숫자와 단어의 조합이면
        else
            local KFN,Kstring,KLN=MDRnumsplit(keyword)
            k1=Kstring
            level1=KLN or KFN         
        end        
        
        callTypeT1=getCallTypeTable(k1)
        callTypeT2=getCallTypeTable(k2)  
        
        --명령어가 발견이 안되면
        if k1 and not callTypeT1 then
            local name=k1
            if strfind(k1,"내") then             
                k1=gsub(k1,"내","")
                onlyMe=1
            end            
            if strfind(k1,"지금") then
                k1=gsub(k1,"지금","")
                onlyOnline=1                
            end
            callTypeT1=getCallTypeTable(k1)
            --내,지금을 잘라내고도 명령어를 못찾으면 이름검색시도
            if ((not callTypeT1) and name~="") then
                callTypeT1=getCallTypeTable("아무")
                CharName=name
                --print(CharName)
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
        
        --명령어 조합인 경우 순서 바꾸기
        if callTypeT1~=nil and (callTypeT1[1]=="item" or callTypeT1[1]=="specificitem" or callTypeT1[1]=="category") and callTypeT2~=nil then
            local callTypeT3=callTypeT1
            callTypeT1=callTypeT2
            callTypeT2=callTypeT3
        end              
        
        if callTypeT1 then
            VALUES["callTypeT"]=callTypeT1
            VALUES["callTypeT2"]=callTypeT2 
            VALUES["level"]=level1
            VALUES["level2"]=level2     
            VALUES["channel"]=channel            
            VALUES["who"]=who   
            VALUES["onlyMe"]=onlyMe
            VALUES["onlyOnline"]=onlyOnline           
            VALUES["CharName"]=CharName
            
            filterVALUES(VALUES)
            
            --일치하는 명령어가 없으면 리턴
        else return end
end)
