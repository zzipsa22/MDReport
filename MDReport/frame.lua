local MDR = CreateFrame("Frame")

MDR:RegisterEvent("CHAT_MSG_PARTY")
MDR:RegisterEvent("CHAT_MSG_PARTY_LEADER") 
MDR:RegisterEvent("CHAT_MSG_GUILD")
MDR:RegisterEvent("CHAT_MSG_WHISPER")
MDR:RegisterEvent("CHAT_MSG_WHISPER_INFORM")

MDR:SetScript("OnEvent", function(self, event, ...)
        local msg=select(1, ...)
        --메세지가 !로 시작하지 않을 경우 리턴
        if strsub(msg, 0,1)~="!" then 
        return end
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
        
        --키워드 앞뒤로 붙은 숫자 추출
        local LTCT=strsub(keyword,-2)
        local LOCT=strsub(keyword,-1)
        local FTCT=strsub(keyword,1,2)
        local FOCT=strsub(keyword,1,1)
        local LTCN=tonumber(LTCT)        
        local LOCN=tonumber(LOCT)      
        local FTCN=tonumber(FTCT)        
        local FOCN=tonumber(FOCT)
        local firstSixChar=strsub(keyword,1,6)
        
        local k1=keyword
        local k2,level1,level2,callTypeT1,callTypeT2
        local VALUES={}
        
        --명령어가 이중인지 체크        
        if strfind(keyword,"!") then
            k1=mysplit(keyword,"!")[1] 
            k2=mysplit(keyword,"!")[2]            
            
            --중간에 ~를 넣은 명령어면
        elseif strfind(keyword,"~")then
            
            local space="~"
            
            local before=mysplit(keyword,space)[1]
            local after=mysplit(keyword,space)[2]
            local num1=tonumber(before)
            local num2=tonumber(after)      
            
            --숫자만 입력했으면
            if num1~=nil and num2~=nil then
                k1="아무"
                level1=num1
                level2=num2
                
            else --던전명을 같이 넣었으면 
                local BLTCT=strsub(before,-2)
                local BLOCT=strsub(before,-1)
                local BLTCN=tonumber(BLTCT)
                local BLOCN=tonumber(BLOCT)
                if BLTCN then
                    k1=strsub(before,1,-3)
                    level1=BLTCN
                elseif BLOCN then
                    k1=strsub(before,1,-2)
                    level1=BLOCN                    
                end            
                level2=num2
            end  
            
            --마지막이 +면
        elseif strfind(LOCT,"+")then
            
            if (FTCN or FOCN) then                
                k1="아무"
                level1=tonumber(strsub(keyword,1,-2))
                level2=99
            elseif tonumber(firstSixChar)==nil then
                k1=firstSixChar
                level1=tonumber(strsub(keyword,7,-2))
                level2=99
            else return end
            
            --마지막이 -면
        elseif strfind(LOCT,"-")then
            
            if (FTCN or FOCN) then                
                k1="아무"
                level1=tonumber(strsub(keyword,1,-2))
                level2=2
            elseif tonumber(firstSixChar)==nil then                
                k1=firstSixChar
                level1=tonumber(strsub(keyword,7,-2))
                level2=2
            else return end            
            
            --숫자만 입력한 경우
        elseif keyIsNumber then
            k1="아무"           
            level1=keyIsNumber
            --뒤 두자가 숫자인 경우
        elseif LTCN then
            k1=strsub(keyword,1,-3)
            level1=LTCN
            --뒤 한자만 숫자인 경우
        elseif LOCN then
            k1=strsub(keyword,1,-2)
            level1=LOCN
            --앞 두자가 숫자인 경우            
        elseif FTCN then
            k1=strsub(keyword,3)
            level1=FTCN
            --앞 한자만 숫자인 경우
        elseif FOCN then
            k1=strsub(keyword,2)
            level1=FOCN      
        end        
        
        callTypeT1=getCallTypeTable(k1)
        callTypeT2=getCallTypeTable(k2) 
        
        
        --작은수가 먼저오게 조절절
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
            
            filterVALUES(VALUES)
            
            --print(callTypeT[1])
            
            --일치하는 명령어가 없으면 리턴
        else return end  
end)