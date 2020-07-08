local MY_NAME_IN_GAME=UnitName("player").."-"..GetRealmName()    
local MY_NAME_IN_ADDON=UnitName("player").." - "..GetRealmName()    

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

local MY_NAME_IN_GAME=UnitName("player").."-"..GetRealmName()    
local MY_NAME_IN_ADDON=UnitName("player").." - "..GetRealmName()    

function doCheckVersion(channel,who,callType)
    
    local messageLines={}   
    messageLines[1]="▶[쐐기돌 보고서] Ver."..version.." (Update: "..lastUpdate..")"    
    
    reportMessageLines(messageLines,channel,who,callType)   
end


function doOnlyAffixReport(keyword,channel,who,callType)  
    
    local week=keyword
    local messageLines={}       
    local weekTitle=""
    
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
    
    messageLines[1]="▶"..weekTitle.." 속성: "..GetAnyWeeksAffix(week) 
    
    reportMessageLines(messageLines,channel,who,callType)    
end

function doShortReport(chars,channel,who,callType)
    local messageLines={} 
    
    if chars~=nil then
        
        local charName,class,c=nil,nil,nil
        
        --중복직업 체크              
        local yourClass={}   
        
        for i=1,#chars do
            charName=chars[i][1]            
            class=chars[i][2] 
            yourClass[class]=(yourClass[class] or 0)+1             
        end
        local sameClass={}        
        
        for i=1,#chars do             
            charName=chars[i][1]     
            class=chars[i][2]              
            c=SavedInstancesDB.Toons[charName]           
            
            local keylink=c.MythicKey.link
            local keyName=c.MythicKey.name
            local level=c.MythicKey.level
            local best=c.MythicKeyBest.level            
            local online=""
            local classStatus=""
            
            local cutName=gsub(charName, "%s%-.+","")
            local shortName=strsub(cutName,1,9)
            
            
            if yourClass[class] and yourClass[class]>1 then
                sameClass[class]=(sameClass[class] or 0)+1                
                classStatus=class..sameClass[class]..":"..cutName                
            else                
                classStatus=class                
            end
            if charName==MY_NAME_IN_ADDON then
                online="◀접속중"
            end            
            
            --던전 이름 줄이기기
            keyName=getShortDungeonName(keyName)            
            
            local havekey,parking, parkingstar="","",""  
            if best and best ~=0 then                
                parkingstar=","..best             
                
            else 
                if callType=="parking" then
                    parkingstar=",X"                    
                else  
                    parkingstar=""            
                end       
            end            
            
            if keylink~=nil then
                havekey=keyName..level
            else
                havekey="돌 없음"
            end
            local message=""            
            
            if callType=="parking" then                 
                message=skull[class]..class.."("..havekey..parkingstar..")"..online
            elseif callType=="all" then
                message=skull[class]..havekey.."("..classStatus..")"
            elseif chars[i][3] and callType=="spell"then
                message=skull[class]..class.."("..havekey..")"..chars[i][3]..online
            elseif chars[i][3] and callType=="item"then
                message=skull[class]..havekey.."("..chars[i][3]..")"
            else
                message=skull[class]..havekey.."("..classStatus..")"..online
            end
            
            messageLines[i]=message 
        end        
        -- 한줄로 줄이기
        local oneLineMessage=""        
        for i=1,#messageLines do
            local space=""
            if i<#messageLines then
                space=" "                
            end
            oneLineMessage=oneLineMessage..messageLines[i]..space
        end
        messageLines={}
        messageLines[1]=oneLineMessage
    end    
    
    reportMessageLines(messageLines,channel,who,callType)       
end


--자세한 보고서 작성 및 출력
function doFullReport(chars,channel,who,callType)      
    
    local messageLines={} 
    
    if chars~=nil then        
        
        local charName,class,c=nil,nil,nil
        local forceprint=0 
        
        if (channel=="print") and (who==MY_NAME_IN_GAME) then 
            forceprint=1           
        end
        
        --중복직업 체크      
        local yourClass={}   
        
        for i=1,#chars do
            charName=chars[i][1]            
            class=chars[i][2] 
            yourClass[class]=(yourClass[class] or 0)+1             
        end
        local sameClass={}
        
        for i=1,#chars do             
            charName=chars[i][1]     
            class=chars[i][2]              
            c=SavedInstancesDB.Toons[charName]           
            
            local keylink=c.MythicKey.link
            local best=c.MythicKeyBest.level            
            
            local online=""
            
            local classStatus=""
            local headStar=""
            if charName==MY_NAME_IN_ADDON then
                online="◀접속중"
            end
            
            --
            local cutName=gsub(charName, "%s%-.+","")
            local shortName=strsub(cutName,1,9)            
            
            --같은 직업이 있을경우 뒤에 이름 붙이기
            if yourClass[class] and yourClass[class]>1 then
                sameClass[class]=(sameClass[class] or 0)+1
                classStatus=class..sameClass[class].."("..cutName..")"
            else
                if (callType=="parking") then  
                    classStatus=class.."("..shortName..")"
                elseif (callType=="dungeon")then
                    classStatus=class.."("..cutName..")"
                else
                    classStatus=class.."("..shortName..")"                    
                end                  
            end            
            
            
            local havekey,parking, parkingstar="","",""       
            if keylink~=nil then
                havekey=keylink
            else
                havekey="[쐐기돌 없음]"
            end
            if best and best ~=0 then
                parking=","..best
                parkingstar="▶"
            else
                parking=",X)"
                parkingstar="▷"            
            end
            if forceprint==1 then
                channel="print"
                headStar=parkingstar
            else
                headStar=skull[class]                
            end 
            --local extra=""
            local message=""
            if callType=="spell" and chars[i][3] then
                message=headStar..classStatus..chars[i][3]..": "..havekey..online
            elseif callType=="item" and chars[i][3] then
                message=headStar..classStatus..": "..havekey..chars[i][3] 
            else
                message=headStar..class.."("..shortName..parking..")"..": "..havekey..online
            end
            
            messageLines[i]=message 
        end
    end      
    
    --메세지 출력
    reportMessageLines(messageLines,channel,who,callType)    
end

local warning=1

function doWarningReport(channel,who,callType) 
    local messageLines={}
    if warning<=#warnMessage then
        messageLines[#messageLines+1]=warnMessage[warning]
        warning=warning+1
        channel="print"
    else return end  
    reportMessageLines(messageLines,channel,who,callType)
end


--메세지 출력
function reportMessageLines(messageLines,channel,who,callType)       
    if channel==nil then channel="print" end
    
    --최종적으로 귓말채널 반환
    if (channel=="WHISPER_IN") or (channel=="WHISPER_OUT")  then
        channel="WHISPER"
    end        
    
    for i=1,#messageLines do 
        if channel=="print"then
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
