local who,channel,level,level2,callTypeT,callType2,comb
local callType,keyword,extraKeyword
local callType2,keyword2,extraKeyword2

local dungeonTable={
    ["자유"]={
        "자유지대",
        {
            {"힘","양손도검"},
            {"힘","한손둔기"},
            {"민첩","단검"},
            {"민첩","한손도검"},
            {"민첩","총"},            
        }          
    },
    
    ["보랄"]={
        "보랄러스 공성전",
        {
            {"힘","장창"},
            {"힘","양손둔기"},
            {"힘","한손도검"},
            {"민첩","전투검"},
            {"민첩","한손둔기"},               
        }
    },
    
    ["세스"]={
        "세스랄리스 사원",
        {
            {"지능","지팡이"},
            {"민첩","장창"},
            {"힘","한손도검"},
            {"민첩","한손도검"},
            {"지능","한손둔기"}, 
            {"민첩","활"},              
            {"","방패"},           
        }
    },
    
    ["썩굴"]={
        "썩은굴",
        {
            {"힘","양손도끼"},
            {"민첩","장창"},
            {"민첩","장착무기"},
            {"지능","한손둔기"}, 
            {"민첩","단검"},              
            {"","방패"},           
        }
    },
    
    ["아탈"]={
        "아탈다자르",
        {
            {"민첩","장착무기"},
            {"민첩","단검"},   
            {"힘","한손둔기"},            
            {"민첩","활"},     
            {"지능","마법봉"},    
            {"","방패"},  
            {"지능","보조"},                 
        }
    },
    
    ["왕노"]={
        "왕노다지 광산!!",
        {
            {"힘","양손둔기"},
            {"지능","한손둔기"}, 
            {"민첩","총"},       
            {"","방패"},              
        }
    },
    
    ["왕안"]={
        "왕들의 안식처",
        {
            {"민첩","장창"},
            {"힘","양손도검"},
            {"민첩","단검"},     
            {"지능","한손도검"}, 
            {"지능","단검"},  
            {"민첩","총"},               
        }
    },
    
    ["웨이"]={
        "웨이크레스트 저택",
        {
            {"민첩","장창"},
            {"민첩","장착무기"},
            {"민첩","한손둔기"},     
            {"지능","단검"},  
            {"힘","한손도끼"},
            {"지능","보조"},               
        }
    },    
    
    ["고철"]={
        "작전명: 메카곤 - 고철장",
        {
            {"힘","양손둔기"},
            {"민첩","지팡이"},
            {"민첩","한손둔기"},  
            {"민첩","한손도끼"},    
            {"지능","한손도검"}, 
            {"민첩","단검"},  
            {"","방패"},   
            {"힘","한손도끼"},  
            {"민첩","총"},                
        }
    },
    
    ["작업"]={
        "작전명: 메카곤 - 작업장",
        {
            {"지능","한손둔기"}, 
            {"민첩","단검"},  
            {"지능","지팡이"},
            {"힘","한손도검"},            
        }
    },    
    
    ["톨다"]={
        "톨 다고르",
        {
            {"민첩","장창"},
            {"지능","지팡이"},
            {"민첩","전투검"},
            {"힘","한손둔기"},        
            {"민첩","단검"},  
            {"민첩","총"},     
            {"","방패"},   
            {"지능","보조"},                
        }
    },    
    
    ["폭사"]={
        "폭풍의 사원",
        {
            {"지능","지팡이"},
            {"민첩","단검"},  
            {"지능","한손도검"},             
        }
    },    
}

local specTable={
    ["기사"]={{"힘","지능"},{"한손도끼","양손도끼","한손둔기","양손둔기","장창","한손도검","양손도검","방패"}},
    ["보호"]={{"힘"},{"한손도끼","한손둔기","한손도검","방패"}},
    ["징벌"]={{"힘"},{"양손도끼","양손둔기","장창","양손도검"}},
    ["신성"]={{"지능"},{"한손도끼","한손둔기","한손도검","방패"}},
    
    ["드루"]={{"민첩","지능"},{"단검","장착무기","한손둔기","양손둔기","장창","지팡이","보조"}},
    ["조화"]={{"지능"},{"단검","장착무기","한손둔기","양손둔기","장창","지팡이","보조"}},
    ["야성"]={{"민첩"},{"양손둔기","장창","지팡이"}},
    ["수호"]={{"민첩"},{"양손둔기","장창","지팡이"}},
    ["회복"]={{"지능"},{"단검","장착무기","한손둔기","양손둔기","장창","지팡이","보조"}},
    
    ["수도"]={{"민첩","지능"},{"장창","지팡이","한손도끼","장착무기","한손둔기","한손도검","보조"}},
    ["양조"]={{"민첩"},{"장창","지팡이"}},
    ["운무"]={{"지능"},{"장창","지팡이","한손도끼","장착무기","한손둔기","한손도검","보조"}},
    ["풍운"]={{"민첩"},{"한손도끼","장착무기","한손둔기","한손도검"}},
    
    ["술사"]={{"민첩","지능"},{"한손도끼","양손도끼","단검","장착","한손둔기","양손둔기","지팡이","보조","방패"}},
    ["고양"]={{"민첩"},{"한손도끼","한손둔기"}},
    ["복원"]={{"지능"},{"한손도끼","양손도끼","단검","장착","한손둔기","양손둔기","지팡이","보조","방패"}},
    ["정기"]={{"지능"},{"한손도끼","양손도끼","단검","장착","한손둔기","양손둔기","지팡이","보조","방패"}},
    
    ["사제"]={{"지능"},{"단검","지팡이","한손둔기","마법봉","보조"}},
    
    ["법사"]={{"지능"},{"단검","지팡이","한손도검","마법봉","보조"}},
    
    ["흑마"]={{"지능"},{"단검","지팡이","한손도검","마법봉","보조"}},
    
    ["도적"]={{"민첩"},{"단검","장착무기","한손도끼","한손둔기","한손도검"}},
    ["무법"]={{"민첩"},{"단검","장착무기","한손도끼","한손둔기","한손도검"}},
    ["잠행"]={{"민첩"},{"단검"}},
    ["암살"]={{"민첩"},{"단검"}},
    
    ["전사"]={{"힘"},{"한손도끼","양손도끼","단검","장착무기","한손둔기","양손둔기","장창","지팡이","한손도검","양손도검","방패"}},
    ["방어"]={{"힘"},{"단검","한손도끼","한손둔기","한손도검","방패"}},
    ["무기"]={{"힘"},{"양손도끼","양손둔기","장창","지팡이","양손도검"}},
    ["분노"]={{"힘"},{"양손도끼","양손둔기","장창","지팡이","양손도검"}},
    
    ["죽기"]={{"힘"},{"한손도끼","양손도끼","한손둔기","양손둔기","장창","한손도검","양손도검"}},
    ["냉기"]={{"힘"},{"한손도끼","한손둔기","한손도검"}},
    ["부정"]={{"힘"},{"양손도끼","양손둔기","장창","양손도검"}},
    ["혈기"]={{"힘"},{"양손도끼","양손둔기","장창","양손도검"}},
    
    ["악사"]={{"민첩"},{"전투검","장착무기","한손도끼","한손도검"}},
    
    ["냥꾼"]={{"민첩"},{"활","석궁","총","장창","지팡이","양손도검","양손도끼"}},
    ["야수"]={{"민첩"},{"활","석궁","총"}},
    ["사격"]={{"민첩"},{"활","석궁","총"}},
    ["생존"]={{"민첩"},{"장창","지팡이","양손도검","양손도끼"}},
}

local categoryTable={
    ["양손장비"]={"장창","지팡이","양손도검","양손도끼","양손둔기"},
    ["한손장비"]={"단검","장착무기","한손도검","한손도끼","한손둔기","전투검"},
    ["근접장비"]={"단검","장착무기","한손도검","한손도끼","한손둔기","장창","지팡이","양손도검","양손도끼","양손둔기"},
    ["원거리장비"]={"활","총","석궁","마법봉"},
    
}
function getCategoryTable(category)
    for k,v in pairs(categoryTable) do
        if category==k then
            return v
        end        
    end 
end

function getFullDungeonName(dungeon)
    for k,v in pairs(dungeonTable) do
        if dungeon==k then
            return v[1]
        end        
    end 
end

function getShortDungeonName(dungeon)
    for k,v in pairs(dungeonTable) do
        if dungeon==v[1] then
            return k
        end        
    end      
end

function getDungeonDropTable(dungeon)
    for k,v in pairs(dungeonTable) do
        if dungeon==k then
            return v[2]
        end        
    end      
end

function getSpecStatTable(spec)
    for k,v in pairs(specTable) do
        if spec==k then
            return v[1]
        end        
    end      
end

function getSpecWeaponTable(spec)
    for k,v in pairs(specTable) do
        if spec==k then
            return v[2]
        end        
    end      
end

function checkDungeonHasItem(dungeon,spec,category)
    
    if dungeon==nil or spec==nil then return end
    local statTable=getSpecStatTable(spec)
    local weaponTable=getSpecWeaponTable(spec)
    if category~=nil then
        local wantWeaponTypeTable=getCategoryTable(category)
        local num=1
        local newWeaponTable={}
        for i=1,#weaponTable do
            for j=1,#wantWeaponTypeTable do
                if weaponTable[i]== wantWeaponTypeTable[j] then
                    newWeaponTable[num]=weaponTable[i]
                    num=num+1
                end                
            end            
        end 
        weaponTable=newWeaponTable
    end    
    
    local dropTable=getDungeonDropTable(dungeon)
    
    local yourWeaponTypeTable={}
    local num=1
    if statTable==nil or weaponTable==nil or dropTable==nil then return end
    
    for i=1,#statTable do
        for j=1,#weaponTable do        
            yourWeaponTypeTable[num]={}
            yourWeaponTypeTable[num][1]=statTable[i]
            yourWeaponTypeTable[num][2]=weaponTable[j]
            num=num+1
        end    
    end
    local thisDungeonHasItem=0
    local thisDungeonHas={}
    local itemNum=1
    local itemList=""
    for i=1,#yourWeaponTypeTable do
        local stat=yourWeaponTypeTable[i][1]
        local type=yourWeaponTypeTable[i][2]
        for j=1,#dropTable do
            if dropTable[j][1]==stat and dropTable[j][2]==type then
                if category~=nil then
                    local space=""
                    if dropTable[j][1]~="" then
                        space=" "
                    end                
                    thisDungeonHas[itemNum]=dropTable[j][1]..space..dropTable[j][2]
                else
                    thisDungeonHas[itemNum]=dropTable[j][2]
                end           
                thisDungeonHasItem=1
                itemNum=itemNum+1
            end            
        end       
    end
    for i=1,#thisDungeonHas do                    
        itemList=itemList..thisDungeonHas[i]
        if i<#thisDungeonHas then
            itemList=itemList..","
        end                    
    end
    if thisDungeonHasItem==1 then
        return itemList
    else
        return nil        
    end
end

function checkDungeonHasCategoryItem(dungeon,stat,category)
    
    local weaponTable=getCategoryTable(category)
    local dropTable=getDungeonDropTable(dungeon)
    
    local yourWeaponTypeTable={}
    local num=1
    
    if  weaponTable==nil or dropTable==nil then return end        
    
    for j=1,#weaponTable do        
        yourWeaponTypeTable[num]={}
        yourWeaponTypeTable[num][1]=stat
        yourWeaponTypeTable[num][2]=weaponTable[j]
        num=num+1
    end    
    
    local thisDungeonHasItem=0
    local thisDungeonHas={}
    local itemNum=1
    local itemList=""
    for i=1,#yourWeaponTypeTable do
        local stat=yourWeaponTypeTable[i][1]
        local type=yourWeaponTypeTable[i][2]
        for j=1,#dropTable do
            if dropTable[j][1]==stat and dropTable[j][2]==type then
                local space=""
                if dropTable[j][1]~="" then
                    space=" "
                end                
                thisDungeonHas[itemNum]=dropTable[j][1]..space..dropTable[j][2]
                thisDungeonHasItem=1
                itemNum=itemNum+1
            end            
        end       
    end
    for i=1,#thisDungeonHas do                    
        itemList=itemList..thisDungeonHas[i]
        if i<#thisDungeonHas then
            itemList=itemList..","
        end                    
    end
    
    if thisDungeonHasItem==1 then
        return itemList
    else
        return nil        
    end    
end


function checkDungeonHasSpecificItem(dungeon,stat,item)
    
    if dungeon==nil or item==nil then return end
    
    local dropTable=getDungeonDropTable(dungeon)
    local thisDungeonHasItem=0
    local thisDungeonHas={}
    local itemNum=1
    local itemList=""
    
    for j=1,#dropTable do
        if stat and item~="방패" then
            if dropTable[j][1]==stat and dropTable[j][2]==item then 
                local space=""
                if dropTable[j][1]~="" then
                    space=" "
                end          
                thisDungeonHas[itemNum]=dropTable[j][1]..space..dropTable[j][2]
                thisDungeonHasItem=1
                itemNum=itemNum+1
            end            
        else
            if dropTable[j][2]==item then 
                local space=""
                if dropTable[j][1]~="" then
                    space=" "
                end          
                thisDungeonHas[itemNum]=dropTable[j][1]..space..dropTable[j][2]
                thisDungeonHasItem=1
                itemNum=itemNum+1
            end      
        end        
    end
    
    for i=1,#thisDungeonHas do                    
        itemList=itemList..thisDungeonHas[i]
        if i<#thisDungeonHas then
            itemList=itemList..","
        end                    
    end
    if thisDungeonHasItem==1 then
        return itemList
    else
        return nil        
    end
end

--통합 아이템 찾기
function findCharAllItem(VALUES)
    
    if VALUES~=nil then
        who=VALUES["who"]
        channel=VALUES["channel"]
        callTypeT=VALUES["callTypeT"]
        callTypeT2=VALUES["callTypeT2"]
        level=VALUES["level"]
        level2=VALUES["level2"]         
        
        callType=callTypeT[1]
        keyword=callTypeT[2] 
        extraKeyword=callTypeT[3] 
        
        if callTypeT2 then
            callType2=callTypeT2[1]
            keyword2=callTypeT2[2] 
            extraKeyword2=callTypeT2[3]            
        end          
        comb=VALUES["comb"] 
    end
    
    local chars=GetHaveKeyCharInfo() 
    -- 콜타입을 아이템으로 강제 조정정
    local callType="item"
    
    local stat=keyword
    local spec=keyword
    local item=keyword2
    local category=keyword2       
    
    local findChars={}   
    local num=1        
    if chars~=nil then         
        
        for i=1,#chars do    
            local p=chars[i]["fullName"]
            local c=SavedInstancesDB.Toons[p]
            local mapName=c.MythicKey.name
            local dungeon=getShortDungeonName(mapName)
            local itemList
            
            if comb=="Stat_Specificitem" or comb=="Spec_Specificitem"then
                itemList=checkDungeonHasSpecificItem(dungeon,stat,item)                
            elseif comb=="Stat_Category" then
                itemList=checkDungeonHasCategoryItem(dungeon,stat,category) 
            elseif comb=="Spec_Category" then 
                itemList=checkDungeonHasItem(dungeon,spec,category)
            elseif comb=="Spec_Item" then  
                itemList=checkDungeonHasItem(dungeon,spec,nil)
            else
                print("잘못됐음")
            end                       
            
            if itemList then
                chars[i]["extraLink"]=itemList
                findChars[num]=chars[i]
                num=num+1
            end
        end    
    end          
    if channel=="GUILD" then
        
        doShortReport(findChars,channel,who,callType)         
    else        
        doFullReport(findChars,channel,who,callType)  
    end
end
