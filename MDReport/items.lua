local who,channel,level,level2,callTypeT,comb
local callType,callTypeB,keyword,extraKeyword={},{},{},{}
local meGame=UnitName("player").."-"..GetRealmName()
local krClass,className=UnitClass("player")
local tips={}
local warns=100
local bonus="::::::::14:70::23:1:3524:1:28:1261:::"
local bonus1="::::::::50:65::16:4:6536:6513:1533:4786::::" ;--일반
local bonus2="::::::::50:65::16:5:6536:6516:6513:1514:4786::::" ;--메카
local dungeonTable={
    ["자유"]={
        "자유지대",
        {
            {"힘","양손도검",159634},
            {"힘","한손둔기",159633},
            {"민첩","단검",159132},
            {"민첩","한손도검",159635},
            {"민첩","총",159130}, 
            {"민첩","장신구",155881,"딜러/탱커"},                 
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
            {"민첩","장신구",159623,"딜러/탱커"},  
            {"지능","장신구",159622,"딜러"},  
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
            {"힘/지능","방패",159664},    
            {"민첩","장신구",158374,"딜러/탱커"},     
            {"힘","장신구",158367,"딜러/탱커"},                         
            {"지능","장신구",158368,"힐러"},                 
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
            {"힘/지능","방패",159665}, 
            {"힘/민첩","장신구",159626,"탱커"},         
            {"힘","장신구",159625,"딜러/탱커"},                 
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
            {"힘/지능","방패",158713},  
            {"지능","보조",158322},              
            {"지능","장신구",159610,"딜러"},             
            {"힘","장신구",158712,"딜러/탱커"},             
            {"민첩","장신구",158319,"딜러/탱커"},             
            {"지능","장신구",158320,"힐러"},             
        }
    },
    
    ["왕노"]={
        "왕노다지 광산!!",
        {
            {"힘","양손둔기",159638},
            {"지능","한손둔기",159641}, 
            {"민첩","총",159639},       
            {"힘/지능","방패",159663},     
            {"힘","장신구",159611,"딜러/탱커"},             
            {"민첩","장신구",159612,"딜러/탱커"},                 
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
            {"민첩","장신구",159617,"딜러/탱커"},             
            {"힘/민첩","장신구",159618,"탱커"},                 
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
            {"지능","장신구",159631,"힐러/딜러"},      
            {"지능","장신구",159630,"힐러/딜러"},     
            {"힘","장신구",159616,"딜러/탱커"},                 
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
            {"힘/지능","방패",169068},   
            {"힘","한손도끼",168963},  
            {"민첩","총",169077},     
            {"힘/민첩","장신구",169769,"딜러"},                     
        }
    },
    
    ["작업"]={
        "작전명: 메카곤 - 작업장",
        {
            {"지능","한손둔기",168955}, 
            {"민첩","단검",168962},  
            {"지능","지팡이",168973},
            {"힘","한손도검",169608},      
            {"힘/민첩","장신구",168965,"탱커"},     
            {"지능","장신구",169344,"힐러"},             
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
            {"힘/지능","방패",159666},   
            {"지능","보조",159668},    
            {"지능","장신구",159615,"힐러/딜러"},             
            {"힘","장신구",159627,"딜러/탱커"},             
            {"민첩","장신구",159628,"딜러/탱커"},             
        }
    },    
    
    ["폭사"]={
        "폭풍의 사원",
        {
            {"지능","지팡이",158371},
            {"민첩","단검",159135},  
            {"지능","한손도검",159646},       
            {"민첩","장신구",159614,"딜러/탱커"},    
            {"힘","장신구",159619,"딜러/탱커"},    
            {"지능","장신구",159620,"힐러/딜러"},                
        }
    },    
}

local specTable={
    ["기사"]={{"힘","지능"},{"한손도끼","양손도끼","한손둔기","양손둔기","장창","한손도검","양손도검","방패"}},
    ["보호"]={{"힘"},{"한손도끼","한손둔기","한손도검","방패"}},
    ["징벌"]={{"힘"},{"양손도끼","양손둔기","장창","양손도검"}},
    ["신기"]={{"지능"},{"한손도끼","한손둔기","한손도검","방패"}},
    
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
    ["암흑"]={{"지능"},{"단검","지팡이","한손둔기","마법봉","보조"}},
    ["수양"]={{"지능"},{"단검","지팡이","한손둔기","마법봉","보조"}},
    ["신성"]={{"지능"},{"단검","지팡이","한손둔기","마법봉","보조"}},
    
    ["법사"]={{"지능"},{"단검","지팡이","한손둔기","마법봉","보조"}},    
    ["화염"]={{"지능"},{"단검","지팡이","한손도검","마법봉","보조"}},    
    ["냉법"]={{"지능"},{"단검","지팡이","한손도검","마법봉","보조"}},    
    ["비전"]={{"지능"},{"단검","지팡이","한손도검","마법봉","보조"}},
    
    ["흑마"]={{"지능"},{"단검","지팡이","한손둔기","마법봉","보조"}},    
    ["파괴"]={{"지능"},{"단검","지팡이","한손도검","마법봉","보조"}},
    ["고통"]={{"지능"},{"단검","지팡이","한손도검","마법봉","보조"}},    
    ["악마"]={{"지능"},{"단검","지팡이","한손도검","마법봉","보조"}},    
    
    
    ["도적"]={{"민첩"},{"단검","장착무기","한손도끼","한손둔기","한손도검"}},
    ["무법"]={{"민첩"},{"장착무기","한손도끼","한손둔기","한손도검"}},
    ["잠행"]={{"민첩"},{"단검"}},
    ["암살"]={{"민첩"},{"단검"}},
    
    ["전사"]={{"힘"},{"한손도끼","양손도끼","단검","장착무기","한손둔기","양손둔기","장창","지팡이","한손도검","양손도검","방패"}},
    ["방어"]={{"힘"},{"단검","한손도끼","한손둔기","한손도검","방패"}},
    ["무기"]={{"힘"},{"양손도끼","양손둔기","장창","지팡이","양손도검"}},
    ["분노"]={{"힘"},{"한손도끼","양손도끼","단검","장착무기","한손둔기","양손둔기","장창","지팡이","한손도검","양손도검"}},
    
    ["죽기"]={{"힘"},{"한손도끼","양손도끼","한손둔기","양손둔기","장창","한손도검","양손도검"}},
    ["냉기"]={{"힘"},{"한손도끼","한손둔기","한손도검","양손도끼","양손둔기","장창","양손도검"}},
    ["부정"]={{"힘"},{"양손도끼","양손둔기","장창","양손도검"}},
    ["혈기"]={{"힘"},{"양손도끼","양손둔기","장창","양손도검"}},
    
    ["악사"]={{"민첩"},{"전투검","장착무기","한손도끼","한손도검"}},
    ["파멸"]={{"민첩"},{"전투검","장착무기","한손도끼","한손도검"}},
    ["복수"]={{"민첩"},{"전투검","장착무기","한손도끼","한손도검"}},
    
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

function checkSpecCanUseItem(spec,item)
    local weapons=getSpecWeaponTable(spec)    
    local can=false
    for i=1,#weapons do
        if item==weapons[i] then
            can=true
        end      
    end    
    return can
end

function checkSpecCanUseStat(class,stat)
    local stats=getSpecStatTable(class)   
    local can=false
    for i=1,#stats do
        if stat==stats[i] then
            can=true
        end      
    end    
    return can
end

function getBonusIDs(dungeon)
    local bonus
    if dungeon then
        if dungeon=="작업" or dungeon=="고철"  then
            bonus=bonus2
        else 
            bonus=bonus1             
        end         
    end
    return bonus
end

function checkDungeonHasTrinket(VALUES)
    local dungeon,spec,stat,category,link,item,sameDungeon,role,filter
    if VALUES~=nil then
        dungeon=VALUES["dungeon"]
        spec=VALUES["spec"]
        stat=VALUES["stat"]
        category=VALUES["category"]
        link=VALUES["link"]              
        item=VALUES["item"] 
        role=VALUES["role"]  
        sameDungeon=VALUES["sameDungeon"]
        filter=VALUES["filter"]
    end  
    
    local bonus=getBonusIDs(dungeon)    
    local dropTable=getDungeonDropTable(dungeon)
    
    local thisDungeonHasItem=0
    local thisDungeonHas={}
    local itemNum=1
    local itemList=""
    
    local weaponTable
    local yourWeaponTypeTable={}
    local num=1    
    --print(filter)
    --전문화와 조합한 경우 스탯 가져오기
    if not stat and spec then
        print("전문화로부터 스펙 가져오기")        
        stat=getSpecStatTable(spec)[1]
    end
    
    if  dropTable==nil then return end            
    
    --스탯+무기범주를 찾는 경우
    if filter=="category" and category and stat then
        weaponTable=getCategoryTable(category)
        for j=1,#weaponTable do        
            yourWeaponTypeTable[num]={}
            yourWeaponTypeTable[num][1]=stat
            yourWeaponTypeTable[num][2]=weaponTable[j]
            num=num+1        
        end              
        for i=1,#yourWeaponTypeTable do
            local stat=yourWeaponTypeTable[i][1]
            local type=yourWeaponTypeTable[i][2]
            for j=1,#dropTable do
                if strfind(dropTable[j][1],stat) and strfind(dropTable[j][2],type) then
                    local header=""
                    if category~=nil then
                        header=dropTable[j][1].." "
                    end           
                    if sameDungeon then
                        thisDungeonHas[itemNum]=sameDungeon
                    else                
                        if link==1 then
                            _,thisDungeonHas[itemNum]=GetItemInfo("item:"..dropTable[j][3]..bonus)
                        else
                            thisDungeonHas[itemNum]=header..dropTable[j][2]
                        end
                    end                           
                    thisDungeonHasItem=1
                    itemNum=itemNum+1
                end            
            end       
        end        
        
        --전문화를 지정한 경우
    elseif filter=="spec" and spec then                
        
        weaponTable=getSpecWeaponTable(spec)
        
        --전문화에 무기범주까지 지정한 경우
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
            --print("지정된 무기종류 지정")
            weaponTable=newWeaponTable
        end            
        
        for j=1,#weaponTable do        
            yourWeaponTypeTable[num]={}
            yourWeaponTypeTable[num][1]=stat
            yourWeaponTypeTable[num][2]=weaponTable[j]          
            num=num+1
        end            
        
        for i=1,#yourWeaponTypeTable do
            local stat=yourWeaponTypeTable[i][1]
            local type=yourWeaponTypeTable[i][2]
            for j=1,#dropTable do
                if strfind(dropTable[j][1],stat) and strfind(dropTable[j][2],type) then
                    local header=""
                    if category~=nil then
                        --header=dropTable[j][1].." "
                    end           
                    if sameDungeon then
                        thisDungeonHas[itemNum]=sameDungeon
                    else                
                        if link==1 then
                            _,thisDungeonHas[itemNum]=GetItemInfo("item:"..dropTable[j][3]..bonus)
                        else
                            thisDungeonHas[itemNum]=header..dropTable[j][2]
                        end
                    end                            
                    thisDungeonHasItem=1
                    itemNum=itemNum+1
                end            
            end       
        end           
        
        --특정아이템을 지정한 경우
    elseif filter=="specificitem" and item and stat then
        
        for j=1,#dropTable do
            if stat and strfind(dropTable[j][2],item) and strfind(dropTable[j][1],stat) then 
                local header=""
                if category~=nil then
                    header=dropTable[j][1].." "
                end
                if sameDungeon then
                    thisDungeonHas[itemNum]=sameDungeon
                    --print(sameDungeon)
                else                
                    if link==1 then
                        _,thisDungeonHas[itemNum]=GetItemInfo("item:"..dropTable[j][3]..bonus)
                    else
                        thisDungeonHas[itemNum]=header..dropTable[j][2]
                    end
                end            
                thisDungeonHasItem=1
                itemNum=itemNum+1            
            end        
        end 
        
        --장신구를 찾는 경우
    elseif filter=="trinket" then        
        for j=1,#dropTable do
            if dropTable[j][2]=="장신구" and (
                (strfind(dropTable[j][1],stat) and strfind(dropTable[j][4],role)) 
                --or --스탯과 역할이 일치
                --(strfind(dropTable[j][1],stat) and role=="탱커")  --스탯이 일치하는 탱커          
            ) then            
                local header
                if dropTable[j][4]=="탱커"and role=="탱커" then
                    header="탱"
                elseif strfind(dropTable[j][4],"탱") and role=="탱커" then
                    header=stat
                elseif dropTable[j][4]=="힐러" and role=="힐러" then
                    header="힐"
                elseif strfind(dropTable[j][4],"힐") and role=="힐러" then
                    header="지능"
                elseif strfind(dropTable[j][4],"딜러") and role=="딜러" then
                    header=stat
                end            
                
                if sameDungeon then
                    thisDungeonHas[itemNum]=sameDungeon
                else                
                    if link==1 then
                        _,thisDungeonHas[itemNum]=GetItemInfo("item:"..dropTable[j][3]..bonus)
                    else
                        thisDungeonHas[itemNum]=(header or "?").." "..dropTable[j][2]
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

--통합 아이템 분류류
function findCharAllItem(VALUES)
    local callType,callTypeB,keyword,extraKeyword,doubleExtraKeyword={},{},{},{},{}
    
    if VALUES~=nil then
        who=VALUES["who"]
        channel=VALUES["channel"]
        callTypeT=VALUES["callTypeT"]
        level=VALUES["level"]
        level2=VALUES["level2"]                 
        
        comb=VALUES["comb"] 
        for i=1,#callTypeT do
            callTypeB[i]=callTypeT[i][1]
            callType[callTypeT[i][1]]=1
            keyword[callTypeT[i][1]]=callTypeT[i][2]
            extraKeyword[callTypeT[i][1]]=callTypeT[i][3]  
            doubleExtraKeyword[callTypeT[i][1]]=callTypeT[i][4]
        end   
    end
    --print(comb)
    
    local stat=keyword["stat"] or extraKeyword["class"]
    
    local role=keyword["role"] 
    if comb=="Trinket"then
        if keyword["stat"] and not keyword["role"] then
            role="딜러"            
        end
        if keyword["role"]=="힐러" then
            stat="지능"
        elseif keyword["role"]=="탱커" and not keyword["stat"] then
            stat=extraKeyword["role"]
        end 
        if keyword["dungeon"] then
            link=1
        else
            link=0
        end        
        
        --print("role:"..role)
        --print("stat:"..stat)        
    end    
    
    if comb=="Class_Stat" then
        local newSpec
        if keyword["class"]=="드루" then if
            keyword["stat"]=="지능" then newSpec="회복" elseif
            keyword["stat"]=="민첩" then newSpec="야성"  end
            
        elseif keyword["class"]=="술사" then if
            keyword["stat"]=="지능" then newSpec="정기" elseif
            keyword["stat"]=="민첩" then newSpec="고양" end
            
        elseif keyword["class"]=="수도" then if
            keyword["stat"]=="지능" then newSpec="운무" elseif
            keyword["stat"]=="민첩" then newSpec="양조" end
            
        elseif keyword["class"]=="기사" then if
            keyword["stat"]=="지능" then newSpec="신기" end
            
        elseif keyword["class"]=="사제" or keyword["class"]=="법사" or keyword["class"]=="흑마" or keyword["class"]=="악사" then   
            newSpec=MDRgetClassInfo(keyword["class"])[3]            
        else             
            return            
        end        
        keyword["spec"]=newSpec        
    end          
    
    if comb=="Class_Something" then
        local newSpec=MDRgetClassInfo(keyword["class"])[3]
        keyword["spec"]=newSpec
        if callType["dungeon"]==1 then
            comb="Spec_Dungeon"
        elseif callType["category"]==1 then
            comb="Spec_Category"
        elseif callType["specificitem"]==1 then
            comb="Spec_Specificitem"
        elseif callType["item"]==1 then
            comb="Spec_Item"
        end
        --print("new", comb)
    end
    
    local chars=GetHaveKeyCharInfo()        
    
    local link=0
    local filter
    
    if comb=="Spec_Dungeon" or (comb=="Trinket" and keyword["dungeon"])then
        chars=filterCharsByFilter(chars,"dungeon",keyword["dungeon"],nil)
        link=1
    end    
    
    if comb=="Class_Stat" or comb=="Spec_Stat"  or comb=="Spec_Dungeon" then
        comb="Spec_Item"
    end        
    
    local spec=keyword["spec"]
    local item=keyword["specificitem"]
    local category=keyword["category"]         
    
    if keyword["specificitem"]=="방패" then        
        stat=""
        item=keyword["specificitem"]
        link=1
        
        --only 지능
    elseif keyword["specificitem"]=="보조"or  keyword["specificitem"]=="마법봉"then        
        stat="지능"
        item=keyword["specificitem"]
        link=1
        
        --only 민첩
    elseif keyword["specificitem"]=="총"or  keyword["specificitem"]=="석궁"or  keyword["specificitem"]=="활" or keyword["specificitem"]=="전투검" then        
        stat="민첩"
        item=keyword["specificitem"]
        link=1        
    elseif extraKeyword["spec"] then 
        stat=extraKeyword["spec"]        
    end      
    
    local findChars={}   
    local num=1
    
    if comb=="Stat_Specificitem" or comb=="Spec_Specificitem" then
        link=1  
    elseif comb=="Stat_Category" or comb=="Spec_Category" then
        link=0
    end    
    
    if comb=="Stat_Specificitem" or comb=="Spec_Specificitem"then
        filter="specificitem"        
    elseif comb=="Stat_Category" then
        filter="category"
    elseif comb=="Spec_Category" or comb=="Spec_Item" then 
        filter="spec"        
    elseif comb=="Trinket" then  
        filter="trinket"              
    end  
    
    VALUES={}
    VALUES["spec"]=spec
    VALUES["stat"]=stat
    VALUES["category"]=category
    VALUES["link"]=link
    VALUES["role"]=role    
    VALUES["item"]=item     
    VALUES["filter"]=filter
    
    --검색타입에 대한 알림
    if who==meGame and (callType["class"]==1 or callType["spec"] ) then         
        local yourClass=keyword["spec"] or keyword["class"]
        if not yourClass then yourClass=krClass end
        --local class=getCallTypeTable(keyword["spec"])[4] or getCallTypeTable(keyword["class"])[2] 
        
        if (not tips[1] or tips[1]<warns) and link~=1 then
            local message,weapon,spec,class,Class,eul,ro,LC
            class=MDRcolor(keyword["class"] or doubleExtraKeyword["spec"],5)
            if class=="마법사" or class=="사제" or class=="흑마법사" or class=="악마 사냥꾼" then
                spec=""
            else
                spec=MDRcolor(keyword["spec"],0).." "
            end
            
            if class=="도적" or class=="사냥꾼" or class=="악마 사냥꾼" then
                ro="으로"
            else
                ro="로"
            end
            
            if keyword["category"] then                        
                weapon=keyword["category"]
            elseif keyword["specificitem"] then
                weapon=keyword["specificitem"]
            else
                weapon="모든 무기"
            end                    
            Weapon=MDRcolor(weapon,-2)
            LC=strsub(weapon,-3)
            
            Class=MDRcolor(class)
            if LC=="검" or LC=="궁" or LC=="활" or LC=="총" or LC=="봉" or LC=="창"    then
                eul="을"
            else
                eul="를"
            end
            --if extraKeyword["spec"]
            
            message="▶"..spec..Class..ro.." 사용 가능한 "..Weapon..eul.." 검색합니다.  |cffa335ee[아이템 링크]|r를 보시려면 "..MDRcolor(class,0,"!"..(keyword["class"] or keyword["spec"])).."|cff8787ED!던전이름|r으로 검색해보세요. "
            print(message)
            tips[1]=(tips[1] or 0)+1
        end                  
    end   
    
    if chars~=nil then 
        for i=1,#chars do  
            local p=chars[i]["fullName"]
            local c=SavedInstancesDB.Toons[p]
            local mapName=c.MythicKey.name
            VALUES["dungeon"]=getShortDungeonName(mapName)
            local itemList=checkDungeonHasTrinket(VALUES)                     
        end    
    end      
    local dun={}
    
    C_Timer.After(0.1, function()            
            if chars~=nil then 
                for i=1,#chars do    
                    local p=chars[i]["fullName"]
                    local c=SavedInstancesDB.Toons[p]
                    local mapName=c.MythicKey.name
                    if dun[mapName] then
                        VALUES["sameDungeon"]=dun[mapName]
                    else                 
                        VALUES["sameDungeon"]=nil
                    end                                       
                    VALUES["dungeon"]=getShortDungeonName(mapName)
                    local itemList=checkDungeonHasTrinket(VALUES)                    
                    
                    if itemList then
                        chars[i]["extraLink"]=itemList
                        findChars[num]=chars[i]
                        dun[mapName]=num
                        num=num+1
                    end
                end    
            end         
            
            if VALUES["link"] ==1 then
                doFullReport(findChars,channel,who,"item")
            else                
                doShortReport(findChars,channel,who,"item") 
            end    
    end)
end
