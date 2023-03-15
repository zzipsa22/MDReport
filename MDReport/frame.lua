MDR.frame = CreateFrame("Frame")

MDR.frame:RegisterEvent("ADDON_LOADED")
MDR.frame:RegisterEvent("CHALLENGE_MODE_COMPLETED")
MDR.frame:RegisterEvent("CHALLENGE_MODE_START")
MDR.frame:RegisterEvent("CHAT_MSG_PARTY")
MDR.frame:RegisterEvent("CHAT_MSG_PARTY_LEADER") 
MDR.frame:RegisterEvent("CHAT_MSG_GUILD")
MDR.frame:RegisterEvent("CHAT_MSG_WHISPER")
MDR.frame:RegisterEvent("CHAT_MSG_WHISPER_INFORM")
MDR.frame:RegisterEvent("CHAT_MSG_SYSTEM")
MDR.frame:RegisterEvent("CHAT_MSG_ADDON")
MDR.frame:RegisterEvent("PLAYER_ENTERING_WORLD")
MDR.frame:RegisterEvent("BAG_UPDATE_DELAYED")
MDR.frame:RegisterEvent("ITEM_CHANGED")
MDR.frame:RegisterEvent("COVENANT_CHOSEN")

MDR.frame:SetScript("OnEvent", function(self, event, ...)		
        if event== "ADDON_LOADED" then            
            local addonName=select(1, ...)            
            if addonName ~= ADDON_NAME then
                return;
            end
            MDR.frame:UnregisterEvent("ADDON_LOADED");  
            MDRconfig = MDRconfig or {};
            return    
        elseif event=="BAG_UPDATE_DELAYED" then
			MDRbackupMythicKey("bagupdate")
            return
		elseif event=="ITEM_CHANGED" then
			local key=select(1, ...)
			if string.match(key, "180653") then				
				C_Timer.After(0.9, function() 
					MDRbackupMythicKey("newkey")
				end)
			end
            return
        elseif event == "CHAT_MSG_ADDON" then
            local prefix=select(1, ...)
            local message=select(2,...)
            if prefix~="MDReport" then return end			
            if prefix=="MDReport" and not strfind(strsub(message,0,1),"!") then
                MDRprintAddonMessage(...)
                --return                
            end         
            
        elseif event == "PLAYER_ENTERING_WORLD" then			
            local isInitialLogin, isReloadingUi = ...
            if isInitialLogin or isReloadingUi then                
                C_ChatInfo.RegisterAddonMessagePrefix("MDReport")
                
                C_Timer.After(5, function()
                        MDRbackupMythicKey("onLoad")
                end)
                
                MDRconfig=MDRconfig or {}
                
                local delay = MDRconfig.delay or MDR.DefaultDelay
                
                C_Timer.After(delay, function()
                        MDR.itsOKtoRefresh=1
                        MDRrefreshRunHistory()
                end)                
                return
            else
                MDRrefreshRunHistory()
            end       
            return
            -- 쐐기 완료시  
        elseif (event=="CHALLENGE_MODE_COMPLETED") then     
            C_Timer.After(3, function()  
                    MDRbackupMythicKey("finish")     
            end)            
            return
            
            -- 쐐기 시작시            
        elseif (event=="CHALLENGE_MODE_START")  then            
            MDRbackupMythicKey("start") 
            return
			
			-- 성약 변경시
        elseif (event=="COVENANT_CHOSEN")  then            
            MDRgetHistory("covenant") 
            return           
        end 			         
        
        local msg,who   
        
        if event == "CHAT_MSG_ADDON" then
            msg=select(2, ...)    
            who=select(4, ...)   			
        elseif event == "PLAYER_ENTERING_WORLD" then
            return 
        else
            msg=select(1, ...)    
            who=select(2, ...)				
        end		
        --느낌표 스팸이면 무시
        if strfind(msg,"!!!") then return end
        
        if (event=="CHAT_MSG_SYSTEM") then 
            MDRdice(msg)
            return
        end       
        
        if (MDR["youMakeDice"] or MDR["master"]) and MDR["dices"] then
            MDRcollectDices(msg)            
        end               
        
        --애드온에 의해 출력된 메시지는 무시        
        if strfind(msg,"▶") or strfind(msg,"▷")then
            --주사위 안내말이 뜨는지 체크
            if strfind(msg,"MDR ▶") and MDR["meGame"]~=who then
                --print("MDR임")
                MDR["diceAlert"]=1
            else
                return 
            end            
        end        
        
        if strsub(msg, 0,1)~="!" then 
            return 
        end--!로 시작하지 않으면 리턴
        
        local channel
        
        if (event== "CHAT_MSG_PARTY") or (event == "CHAT_MSG_PARTY_LEADER") then
            channel="PARTY"
        elseif (event== "CHAT_MSG_ADDON") then
            channel=select(3, ...)
            if channel=="PARTY" then
                channel="ADDON_PARTY"            
            elseif channel=="WHISPER" then
                channel="ADDON_WHISPER" 
            elseif channel=="OFFICER" then
                channel="ADDON_OFFICER"                
            else
                channel="ADDON_GUILD"            
            end           
        elseif (event== "CHAT_MSG_GUILD") then			
            channel="GUILD"
        elseif (event=="CHAT_MSG_OFFICER") then
            channel="OFFICER" 
        elseif (event=="CHAT_MSG_WHISPER_INFORM") then
            channel="WHISPER_OUT"            
        elseif (event=="CHAT_MSG_WHISPER") then
            channel="WHISPER_IN"            
        else return end
        --[[
        if channel=="PARTY" or channel=="ADDON_PARTY" then
			who=who.."-"..GetRealmName() 
		end
		]]
        if MDR["running"]==1 then 
            if MDR["meGame"]==who and channel~="WHISPER_OUT" then
                local message
                if MDR["who"] and MDR["who"]~=who then
                    message="|cffff0000▶"..msg.."|r: "..MDRcolor("["..MDRsplit(MDR["who"],"-")[1].."]",-1).." 님의 요청을 먼저 처리하고 있습니다. "..MDRcolor("도적",0,MDR["cooltime"].."초").." 후 다시 시도하세요."
                else                    
                    message="|cffff0000▶"..msg.."|r: 검색 결과가 섞이지 않게 하기 위해 "..MDRcolor("도적",0,MDR["cooltime"].."초").."의 재사용 대기시간을 두고 있습니다. 잠시 후 다시 시도하세요."
                end
                print(message)
            end  
            MDR["running"]=0                         
            return
        end
        
        --느낌표와 띄어쓰기 잘라냄
        --local keyword=gsub(msg," ","")        
        
        local level1,level2
        local onlyMe,onlyOnline,CharName,onlyYou,except,onlyForMe
        local VALUES={} 
        
        local k={} 
        local callTypeT={}
        --k[1]=keyword          
        
        --명령어가 이중인지 체크
        
        if strfind(msg,"!") then
            k=MDRsplit(msg,"!")     
        end        
        
        for i=1,#k do  

			if strfind(k[i],"@") then
                k[i]=gsub(k[i],"@","")
				if channel=="ADDON_GUILD" or channel=="GUILD" then
					onlyForMe=1                
				end
            end
            
            if strfind(k[i],"주사위") or strfind(k[i],"?") and             MDR["diceWait"]~=1 and not strfind(k[#k],"?") then
                MDRmakeDice(channel,who,k)
                MDR["running"]=1   
                return
			end			
            
            --k[i]=gsub(k[i]," ","")             
			
            local keyIsNumber=tonumber(k[i])
            local ELC=strsub(k[i],1,-2)        
            local LOCT=strsub(k[i],-1)
            
            --중간에 ~를 넣은 명령어면            
            if strfind(k[i],"~") then              
                local space="~"                     
                local before=MDRsplit(k[i],space)[1]
                local after=MDRsplit(k[i],space)[2]
                local num1=tonumber(before)
                local num2=tonumber(after)      
                
                --숫자만 입력했으면
                if num1~=nil and num2~=nil then
                    k[i]="아무"                       
                    level1=num1
                    level2=num2
                    
                else --던전명을 같이 넣었으면 
                    local _,string,LN=MDRnumsplit(before)
                    k[i]=string
                    level1=LN or 2
                    level2=num2 or 99
                end  
                
                --마지막이 +나 -면
            elseif strfind(LOCT,"+") or strfind(LOCT,"-") then
                -- +,-랑 숫자만 입력했으면
                if tonumber(ELC) then
                    k[i]="아무"                
                    level1=tonumber(ELC)                
                else                
                    local _,string,LN=MDRnumsplit(ELC)
                    --내나 지금만 붙였으면
                    if string=="내" or string=="지금" then
                        string=string.."돌"
                    end
                    k[i]=string or "아무"                               
                    level1=LN                
                end
                if LOCT=="+" then
                    level2=99
                else
                    level2=2
                end           
                
                --숫자만 입력한 경우
            elseif keyIsNumber then
                k[i]="아무"                   
                level1=keyIsNumber
                --숫자와 단어의 조합이면
            elseif tonumber(LOCT) then
                local KFN,Kstring,KLN=MDRnumsplit(k[i])
                k[i]=Kstring
                level1=KLN or KFN                  
            end   
        end
        
        --명령어 판독 시작        
        
        local ct=1
        for i=1,#k do
            
            if getCallTypeTable(k[i]) then
                --print(k[i],"명령어 찾음")
                callTypeT[ct]=getCallTypeTable(k[i])
                ct=ct+1
            else
                local name=gsub(k[i],"@","")
                if strfind(k[i],"내") then             
                    k[i]=gsub(k[i],"내","")
                    onlyMe=1
                end            
                if strfind(k[i],"지금") then
                    k[i]=gsub(k[i],"지금","")
                    onlyOnline=1                
                end
				
				--내, 지금 부터 잘라내고 명령어가 일치하는지 검증
				if getCallTypeTable(k[i]) then
                    callTypeT[ct]=getCallTypeTable(k[i])
                    ct=ct+1
				else				
					if strfind(k[i],"노") then
						k[i]=gsub(k[i],"노","")
						except=1                
					end                
					if strfind(k[i],"제외") then
						k[i]=gsub(k[i],"제외","")
						except=1                
					end 
					if getCallTypeTable(k[i]) then
						callTypeT[ct]=getCallTypeTable(k[i])
						ct=ct+1
						
						--내,지금을 잘라내고도 명령어를 못찾으면 이름검색시도
					elseif (not getCallTypeTable(k[i]) and k[i]~="" and name~=""  and name~="?") then					
						if #k==1 then
							callTypeT[ct]=getCallTypeTable("아무")
							ct=ct+1                         
							CharName=name
						else
							onlyYou=name
							--CharName=name
						end                    
					end    					
                end				
            end            
        end
        
        --if headerRemoved==1 and #k==1 and not getCallTypeTable(k[1])then return end
        
        --작은수가 먼저오게 조절
        if level1 and level2 then
            if level2<level1 then
                local level3=level1
                level1=level2
                level2=level3
            end            
        end    
        --print((level1 or"").."~"..(level2 or""))

			if ct>1 then
				VALUES["onlyYou"]=onlyYou
			end		
            VALUES["callTypeT"]=callTypeT
            VALUES["level"]=level1
            VALUES["level2"]=level2     
            VALUES["channel"]=channel            
            VALUES["who"]=who   
            VALUES["onlyMe"]=onlyMe
            VALUES["except"]=except  
            VALUES["onlyForMe"]=onlyForMe    
            VALUES["onlyOnline"]=onlyOnline           
			VALUES["CharName"]=CharName
                        
            VALUES["msg"]=msg
            
            filterVALUES(VALUES)
            MDR["who"]=who
            if (channel=="ADDON_GUILD" and onlyForMe~=1) or channel=="ADDON_PARTY" then
                MDR["running"]=1
            end           

end)
