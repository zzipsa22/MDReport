local who,channel,level,level2,callTypeT,callType2,comb
local callType,keyword,extraKeyword
local callType2,keyword2,extraKeyword2
local bonus="::::::::14:70::23:1:3524:1:28:1261:::"
local dungeonTable={
    ["자유"]={
        "자유지대",
        {
            {"힘","양손도검",159634},
            {"힘","한손둔기",159633},
            {"민첩","단검",159132},
            {"민첩","한손도검",159635},
            {"민첩","총",159130},            
        }          
    },
    
    ["보랄"]={
        "보랄러스 공성전",
        {
            {"힘","장창",159972},
            {"힘","양손둔기",159650},
            {"힘","한손도검",159649},
            {"민첩","전투검",159651},
            {"민첩","한손둔기",159973},               
        }
    },
    
    ["세스"]={
        "세스랄리스 사원",
        {
            {"지능","지팡이",159636},
            {"민첩","장창",158370},
            {"힘","한손도검",158373},
            {"민첩","한손도검",158714},
            {"지능","한손둔기",158369}, 
            {"민첩","활",159637},              
            {"","방패",159664},           
        }
    },
    
    ["썩굴"]={
        "썩은굴",
        {
            {"힘","양손도끼",159654},
            {"민첩","장창",159655},
            {"민첩","장착무기",159653},
            {"지능","한손둔기",159652}, 
            {"민첩","단검",159134},              
            {"","방패",159665},           
        }
    },
    
    ["아탈"]={
        "아탈다자르",
        {
            {"민첩","장착무기",160269},
            {"민첩","단검",158323},   
            {"힘","한손둔기",159632},            
            {"민첩","활",158711},     
            {"지능","마법봉",158321},    
            {"","방패",158713},  
            {"지능","보조",158322},                 
        }
    },
    
    ["왕노"]={
        "왕노다지 광산!!",
        {
            {"힘","양손둔기",159638},
            {"지능","한손둔기",159641}, 
            {"민첩","총",159639},       
            {"","방패",159663},              
        }
    },
    
    ["왕안"]={
        "왕들의 안식처",
        {
            {"민첩","장창",159642},
            {"힘","양손도검",159644},
            {"지능","한손도검",160216}, 
            {"지능","단검",159137},              
            {"민첩","한손둔기",159645},
            {"민첩","단검",159136},                 
            {"민첩","석궁",159643},      
            {"지능","보조",159667},                 
        }
    },
    
    ["웨이"]={
        "웨이크레스트 저택",
        {
            {"민첩","지팡이",159662},
            {"민첩","장착무기",159659},
            {"민첩","한손둔기",159661},     
            {"지능","단검",159133},  
            {"힘","한손도끼",159660},
            {"지능","보조",159669},               
        }
    },    
    
    ["고철"]={
        "작전명: 메카곤 - 고철장",
        {
            {"힘","양손둔기",169050},
            {"민첩","지팡이",169035},
            {"민첩","한손둔기",169052},  
            {"민첩","한손도끼",169058},    
            {"지능","한손도검",169062}, 
            {"민첩","단검",169066},  
            {"","방패",169068},   
            {"힘","한손도끼",168963},  
            {"민첩","총",169077},                
        }
    },
    
    ["작업"]={
        "작전명: 메카곤 - 작업장",
        {
            {"지능","한손둔기",168955}, 
            {"민첩","단검",168962},  
            {"지능","지팡이",168973},
            {"힘","한손도검",169608},            
        }
    },    
    
    ["톨다"]={
        "톨 다고르",
        {
            {"민첩","장창",159656},
            {"지능","지팡이",159129},
            {"민첩","전투검",160110},
            {"힘","한손둔기",159658},        
            {"민첩","단검",159131},  
            {"민첩","총",159657},     
            {"","방패",159666},   
            {"지능","보조",159668},                
        }
    },    
    
    ["폭사"]={
        "폭풍의 사원",
        {
            {"지능","지팡이",158371},
            {"민첩","단검",159135},  
            {"지능","한손도검",159646},             
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
    ["양조"]={{"민첩"},{"한손도끼","장착무기","한손둔기","한손도검","장창","지팡이"}},
    ["운무"]={{"지능"},{"장창","지팡이","한손도끼","장착무기","한손둔기","한손도검","보조"}},
    ["풍운"]={{"민첩"},{"한손도끼","장착무기","한손둔기","한손도검","장창","지팡이"}},
    
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
    ["냉기"]={{"힘"},{"한손도끼","한손둔기","한손도검","양손도끼","양손둔기","장창","양손도검"}},
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
    return dungeon
end

function getShortDungeonName(dungeon)
    if dungeon==nil then return end
    
    for k,v in pairs(dungeonTable) do
        if dungeon==v[1] then
            return k
        end        
    end
    local string
    if strfind(dungeon," ") then
        local t=MDRsplit(dungeon," ")
        local c1=strsub(t[1],1,3)
        local c2=strsub(t[2],1,3)
        string=c1..c2
    else
        string=strsub(dungeon,1,6)
    end       
    return string
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
                    if dropTable[j][3] then
                        _,thisDungeonHas[itemNum]=GetItemInfo("item:"..dropTable[j][3]..bonus)
                    else
                        thisDungeonHas[itemNum]=dropTable[j][1]..space..dropTable[j][2]
                    end                      
                else   
                    if dropTable[j][3] then
                        _,thisDungeonHas[itemNum]=GetItemInfo("item:"..dropTable[j][3]..bonus)
                    else
                        thisDungeonHas[itemNum]=dropTable[j][2]
                    end                                      
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
                if dropTable[j][3] then
                    _,thisDungeonHas[itemNum]=GetItemInfo("item:"..dropTable[j][3]..bonus)
                else
                    thisDungeonHas[itemNum]=dropTable[j][1]..space..dropTable[j][2]
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


function checkDungeonHasSpecificItem(dungeon,stat,item)
    
    if dungeon==nil or item==nil then return end
    
    local dropTable=getDungeonDropTable(dungeon)
    local thisDungeonHasItem=0
    local thisDungeonHas={}
    local itemNum=1
    local itemList=""    
    for j=1,#dropTable do
        if stat and dropTable[j][2]==item and ((item~="방패"and dropTable[j][1]==stat) or item=="방패")then 
            local space=""
            if dropTable[j][1]~="" then
                space=" "
            end   
            if dropTable[j][3] then
                _,thisDungeonHas[itemNum]=GetItemInfo("item:"..dropTable[j][3]..bonus)
            else
                thisDungeonHas[itemNum]=dropTable[j][1]..space..dropTable[j][2]
            end                 
            thisDungeonHasItem=1
            itemNum=itemNum+1            
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
    
    local stat, spec
    --주스탯 특정이 가능할 경우
    spec=keyword    
    if extraKeyword then        
        stat=extraKeyword
    else        
        stat=keyword
    end    
    local spec=keyword
    local item=keyword2
    local category=keyword2       
    --print("spec:"..spec)
    --print("stat:"..stat)
    
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
                --print("잘못됐음")
            end                     
        end    
    end   
    
    C_Timer.After(0.1, function()            
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
                        --print("잘못됐음")
                    end                       
                    
                    if itemList then
                        chars[i]["extraLink"]=itemList
                        findChars[num]=chars[i]
                        num=num+1
                    end
                end    
            end       
            
            if channel=="GUILD" or channel=="PARTY"then
                doFullReport(findChars,channel,who,callType)  
                --doShortReport(findChars,channel,who,callType)         
            else        
                doFullReport(findChars,channel,who,callType)  
            end    
    end)
end
