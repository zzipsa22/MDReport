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
        
        --느낌표 잘라냄
        local keyword=strsub(msg,2) 
        
        --키워드 앞뒤로 붙은 숫자 추출
        local LTCT=strsub(keyword,-2)
        local LOCT=strsub(keyword,-1)
        local FTCT=strsub(keyword,1,2)
        local FOCT=strsub(keyword,1,1)
        local LTCN=tonumber(LTCT)        
        local LOCN=tonumber(LOCT)      
        local FTCN=tonumber(FTCT)        
        local FOCN=tonumber(FOCT)
        
        local k1=keyword
        local k2=nil               
        
        --명령어가 이중인지 체크        
        if strfind(keyword,"!") then
            k1=mysplit(keyword,"!")[1] 
            k2=mysplit(keyword,"!")[2]            
            
            --중간에 ~를 넣은 명령어면
        elseif strfind(keyword,"~")then
            
            local space="~"
            
            local num1=tonumber(mysplit(keyword,space)[1])
            local num2=tonumber(mysplit(keyword,space)[2])      
            
            --둘다 숫자일 경우에만 반응            
            if num1~=nil and num2~=nil then
                local levelTable={}  
                levelTable[1]=num1
                levelTable[2]=num2
                k1="아무"
                k2=levelTable
            else return end  
            
            --첫 두자가 숫자가 아니고 마지막 글자가 +면
        elseif not FTCN and not FOCN and strfind(LOCT,"+")then
            local firstSixChar=strsub(keyword,1,6)
            
            --첫두자에 한글이 섞여있으면
            if tonumber(firstSixChar)==nil then                
                local level=tonumber(strsub(keyword,7,-2))
                k1=firstSixChar
                k2={level,99}                   
            end   
            
            --첫 두자가 숫자가 아니고 마지막 글자가 -면
        elseif not FTCN and not FOCN and strfind(LOCT,"-")then
            local firstSixChar=strsub(keyword,1,6)
            
            --첫두자에 한글이 섞여있으면
            if tonumber(firstSixChar)==nil then                
                local level=tonumber(strsub(keyword,7,-2))
                k1=firstSixChar
                k2={2,level}                   
            end                     
            
            --숫자만 입력한 경우
        elseif (LTCN~=nil and LTCN==FTCN) or  (LOCN~=nil and LOCN==FOCN)then
            k1="아무"           
            k2=keyword
            --뒤 두자가 숫자인 경우
        elseif LTCN then
            k1=strsub(keyword,1,-3)
            k2=LTCN
            --뒤 한자만 숫자인 경우
        elseif LOCN then
            k1=strsub(keyword,1,-2)
            k2=LOCN
            --앞 두자가 숫자인 경우            
        elseif FTCN then
            k1=strsub(keyword,3)
            k2=FTCN
            --앞 한자만 숫자인 경우
        elseif FOCN then
            k1=strsub(keyword,2)
            k2=FOCN      
        end        
        
        local callTypeT=getCallTypeTable(k1)
        
        --명령어 조합인 경우 순서 바꾸기
        if callTypeT~=nil and (callTypeT[1]=="item" or callTypeT[1]=="specificitem" or callTypeT[1]=="category") and k2~=nil then
            callTypeT=getCallTypeTable(k2)
            k2=k1
        end                
        
        if callTypeT then
            filterCallType(callTypeT,channel,who,k2)
            
            --print(callTypeT[1])
            
            --일치하는 명령어가 없으면 리턴
        else return end   
end)