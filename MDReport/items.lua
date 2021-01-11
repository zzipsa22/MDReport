local who,channel,level,level2,callTypeT,comb
local callType,callTypeB,keyword,keyword2,keyword3={},{},{},{},{}
local meGame,meAddon,krClass,className=MDR["meGame"],MDR["meAddon"],MDR["krClass"],MDR["className"]
local tips={}
local warns=100
local bonus="::::::::14:70::23:1:3524:1:28:1261:::"
local bonus1="::::::::60:261::16:5:7203:6652:1501:5852:6646:1:28:1279:::" ;--일반
local bonus2="::::::::50:65::16:5:6536:6516:6513:1514:4786::::" ;--메카
local dungeonTable={
    ["투기장"]={
        "고통의 투기장",
        {
            {"힘","양손도끼",178866 },
            {"민첩","장창", 178865},
            {"지능","단검", 178789 },
            {"민첩","한손둔기", 178864},
            {"힘","한손도끼", 178863},
            {"힘/지능","방패", 178867 },
            {"지능","보조장비", 178868},
            {"지능","장신구",178809,"딜러" },            
            {"힘/민첩","장신구",178811,"딜러" },            
            {"힘","장신구",178808,"딜러/탱커" },            
            {"지능","장신구",178810,"힐러" },            
        }
    }, 
    ["속죄"]={
        "속죄의 전당",
        {
            {"지능","지팡이",178829},
            {"민첩","한손둔기", 178834},
            {"지능","보조장비", 178828},
            {"힘/민첩","장신구", 178825,"탱커"},
            {"지능","장신구",178826, "힐러/딜러"},
        }
    },
    ["승천"]={
        "승천의 첨탑",
        {
            {"민첩","장창",180096},
            {"민첩","지팡이",180097},
            {"민첩","한손도끼",180095},
            {"민첩","활",180112},            
            {"민첩","장신구",180116,"딜러/탱커"},
            {"힘","장신구", 180118,"딜러/탱커"},
            {"지능","장신구", 180119,"힐러"},
            {"지능","장신구",180117,"딜러"},
        }
        
    }, 
    ["역병"]={
        "역병 몰락지",
        {
            {"민첩","장창",178929},
            {"민첩","단검",178928},
            {"민첩","한손도검",178754},
            {"힘","한손둔기",178752},
            {"지능","단검",178753},
            {"힘/민첩","장신구", 178770,"탱커"},
            {"지능/민첩","장신구", 178769,"딜러"},
            {"힘/민첩","장신구", 178771,"딜러"},
        }
    }, 
    ["저편"]={
        "저편",
        {
            {"민첩","지팡이",179347},
            {"지능","지팡이",179339},
            {"힘","양손도검",179330},
            {"민첩","한손도검",179328},
            {"힘","한손둔기",179340},
            {"민첩","석궁",179348},
            {"힘/민첩/지능","장신구",179350 ,"힐러/딜러/탱커"},
            {"힘","장신구", 179342,"딜러/탱커"},
            {"힘/민첩","장신구", 179331,"탱커"},
            {"민첩","장신구", 179356,"딜러/탱커"},
        }
    }, 
    ["죽상"]={
        "죽음의 상흔",
        {
            {"힘","양손도검",178780},
            {"민첩","단검",178743},
            {"지능","한손도검",178737},
            {"힘","한손둔기",178730},
            {"민첩","총",178735},
            {"힘/지능","방패",178750},
            {"지능","장신구",178772 ,"딜러"},
            {"민첩","장신구",178742 ,"딜러/탱커"},
            {"힘","장신구",178751 ,"딜러/탱커"},
            {"지능","장신구", 178783,"힐러"},
        }
    }, 
    ["티르너"]={
        "티르너 사이드의 안개",
        {
            {"힘","양손도끼",178713},
            {"지능","지팡이",178714},
            {"민첩","단검",178710},
            {"지능","한손둔기", 178709},
            {"힘","한손도끼",178711},
            {"힘/지능","방패",178712},
            {"민첩","장신구", 178715,"딜러/탱커"},
            {"지능","장신구", 178708,"힐러/딜러"},            
        }
    }, 
    ["핏심"]={
        "핏빛 심연",
        {
            {"민첩","한손도끼",178857},
            {"지능","한손도검",178856},
            {"민첩","단검",178853},
            {"힘","한손둔기",178855},
            {"민첩","전투검",178854},
            {"힘/민첩","보조장비",178852},
            {"지능","장신구", 178849,"힐러/딜러"},
            {"힘/민첩","장신구", 178861,"딜러/탱커"},
            {"지능","장신구", 178850,"힐러"},
            {"힘/민첩","장신구", 178862,"탱커"},
        }
    }, 
    
}

MDR.dungeonNames={}
MDR.dungeonNamesFull={}
for k,v in pairs(dungeonTable) do
    tinsert(MDR.dungeonNames,k)
    tinsert(MDR.dungeonNamesFull,v[1])
end

local specTable={
    ["기사"]={{"힘","지능"},{"한손도끼","양손도끼","한손둔기","양손둔기","장창","한손도검","양손도검","방패"}},
    ["보호"]={{"힘"},{"한손도끼","한손둔기","한손도검","방패"}},
    ["징벌"]={{"힘"},{"양손도끼","양손둔기","장창","양손도검"}},
    ["신기"]={{"지능"},{"한손도끼","한손둔기","한손도검","방패"}},
    
    ["드루"]={{"민첩","지능"},{"단검","장착무기","한손둔기","양손둔기","장창","지팡이","보조장비"}},
    ["조화"]={{"지능"},{"단검","장착무기","한손둔기","양손둔기","장창","지팡이","보조장비"}},
    ["야성"]={{"민첩"},{"양손둔기","장창","지팡이"}},
    ["수호"]={{"민첩"},{"양손둔기","장창","지팡이"}},
    ["회복"]={{"지능"},{"단검","장착무기","한손둔기","양손둔기","장창","지팡이","보조장비"}},
    
    ["수도"]={{"민첩","지능"},{"장창","지팡이","한손도끼","장착무기","한손둔기","한손도검","보조장비"}},
    ["양조"]={{"민첩"},{"한손도끼","장착무기","한손둔기","한손도검","장창","지팡이"}},
    ["운무"]={{"지능"},{"장창","지팡이","한손도끼","장착무기","한손둔기","한손도검","보조장비"}},
    ["풍운"]={{"민첩"},{"한손도끼","장착무기","한손둔기","한손도검","장창","지팡이"}},
    
    ["술사"]={{"민첩","지능"},{"한손도끼","양손도끼","단검","장착","한손둔기","양손둔기","지팡이","보조장비","방패"}},
    ["고양"]={{"민첩"},{"한손도끼","한손둔기"}},
    ["복원"]={{"지능"},{"한손도끼","양손도끼","단검","장착","한손둔기","양손둔기","지팡이","보조장비","방패"}},
    ["정기"]={{"지능"},{"한손도끼","양손도끼","단검","장착","한손둔기","양손둔기","지팡이","보조장비","방패"}},
    
    ["사제"]={{"지능"},{"단검","지팡이","한손둔기","마법봉","보조장비"}},    
    ["암흑"]={{"지능"},{"단검","지팡이","한손둔기","마법봉","보조장비"}},
    ["수양"]={{"지능"},{"단검","지팡이","한손둔기","마법봉","보조장비"}},
    ["신성"]={{"지능"},{"단검","지팡이","한손둔기","마법봉","보조장비"}},
    
    ["법사"]={{"지능"},{"단검","지팡이","한손둔기","마법봉","보조장비"}},    
    ["화염"]={{"지능"},{"단검","지팡이","한손도검","마법봉","보조장비"}},    
    ["냉법"]={{"지능"},{"단검","지팡이","한손도검","마법봉","보조장비"}},    
    ["비전"]={{"지능"},{"단검","지팡이","한손도검","마법봉","보조장비"}},
    
    ["흑마"]={{"지능"},{"단검","지팡이","한손둔기","마법봉","보조장비"}},    
    ["파괴"]={{"지능"},{"단검","지팡이","한손도검","마법봉","보조장비"}},
    ["고통"]={{"지능"},{"단검","지팡이","한손도검","마법봉","보조장비"}},    
    ["악마"]={{"지능"},{"단검","지팡이","한손도검","마법봉","보조장비"}},    
    
    
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
    local ct=getCallTypeTable(dungeon) 
    local name
    if ct then 
        name=ct[2]
    else
        name=dungeon
    end
    
    for k,v in pairs(dungeonTable) do
        if name==k then
            return v[1]
        end        
    end
    return name
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

function checkDungeonHasItem(VALUES)
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
        --print("전문화로부터 스펙 가져오기")        
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

--통합 아이템 분류
function findCharAllItem(VALUES)
    local callType,callTypeB,keyword,keyword2,keyword3={},{},{},{},{}
    --print("도착")
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
            
            if callTypeT[i][1]=="dungeon" then 
                if not keyword["dungeon"] then
                    keyword["dungeon"]={}
                end
                if not tContains(keyword["dungeon"],callTypeT[i][2]) then
                    tinsert(keyword["dungeon"],callTypeT[i][2])                     
                end              
            else
                
                keyword[callTypeT[i][1]]=callTypeT[i][2]
            end
            
            --keyword[callTypeT[i][1]]=callTypeT[i][2]
            keyword2[callTypeT[i][1]]=callTypeT[i][3]  
            keyword3[callTypeT[i][1]]=callTypeT[i][4]
        end   
    end
    --print(comb)
    
    local stat=keyword["stat"] or keyword2["class"]
    
    local role=keyword["role"]     
    
    if comb=="Trinket"then
        if keyword["stat"] and not keyword["role"] then
            role="딜러"            
        end
        if keyword["role"]=="힐러" then
            stat="지능"
        elseif keyword["role"]=="탱커" and not keyword["stat"] then
            stat=keyword2["role"]
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
        
    elseif comb=="Class_Something" then
        keyword["spec"]=MDRgetClassInfo(keyword["class"])[3]
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
    
    if keyword["dungeon"] then
        chars=filterCharsByFilter(chars,"dungeon",keyword["dungeon"],nil)
        link=1
    end        
    
    local spec=keyword["spec"]
    local item=keyword["specificitem"]
    local category=keyword["category"]
    --local stat=keyword["stat"] or keyword2["spec"]   
    
    if (comb=="Class_Stat" or comb=="Spec_Stat"  or comb=="Spec_Dungeon") then
        if item then
            comb="Spec_Specificitem"
        else            
            comb="Spec_Item"
        end        
    end        
    
    if keyword["specificitem"]=="방패" then        
        stat=""        
        --only 지능
    elseif keyword["specificitem"]=="보조장비"or  keyword["specificitem"]=="마법봉"then        
        stat=""        
        --only 민첩
    elseif keyword["specificitem"]=="총"or  keyword["specificitem"]=="석궁"or  keyword["specificitem"]=="활" or keyword["specificitem"]=="전투검" then        
        stat=""        
    end       
    
    local findChars={}   
    local num=1
    
    if comb=="Stat_Specificitem" or comb=="Spec_Specificitem"then
        filter="specificitem"        
    elseif comb=="Stat_Category" then
        filter="category"
    elseif comb=="Spec_Category" or comb=="Spec_Item" then 
        filter="spec"        
    elseif comb=="Trinket" then  
        filter="trinket"              
    end      
    --print(filter)
    VALUES={}
    VALUES["spec"]=spec
    VALUES["stat"]=stat
    VALUES["category"]=category
    VALUES["link"]=link
    VALUES["role"]=role    
    VALUES["item"]=item     
    VALUES["filter"]=filter
    
    --검색타입에 대한 알림
    if who==meGame and link~=1 then         
        local yourClass=keyword["spec"] or keyword["class"]
        if not yourClass then yourClass=krClass end
        --local class=getCallTypeTable(keyword["spec"])[4] or getCallTypeTable(keyword["class"])[2] 
        
        if (not tips[1] or tips[1]<warns) and link~=1 and comb~="Trinket" then
            
            local message,weapon,spec,class,Class,eul,ro,LC,space,kwa
            class=MDRcolor(keyword["class"] or keyword3["spec"],5)
            if class=="마법사" or class=="사제" or class=="흑마법사" or class=="악마 사냥꾼" then
                spec=""
            else
                spec=(MDRcolor(keyword["spec"],0) or "").." "
            end
            
            ro=MDRko(class,"로")
            
            if keyword["category"] then                        
                weapon=keyword["category"]
            elseif keyword["specificitem"] then
                weapon=keyword["specificitem"]
            else
                weapon="모든 무기"
            end                    
            Weapon=MDRcolor(weapon,-2)
            
            Class=MDRcolor(class)
            
            if stat=="" then
                space=""
            else
                space=" "
            end
            
            eul=MDRko(weapon,"을")
            kwa=MDRko(weapon,"과")
            
            --if keyword2["spec"]
            
            if keyword["spec"] then
                message="|cFF00ff00▶|r"..spec..Class..ro.." 사용 가능한 "..Weapon..eul.." 검색합니다.  |cffa335ee[아이템 링크]|r를 보시려면 |cff8787ED!던전이름|r과 함께 입력해보세요."
            else
                message="|cFF00ff00▶|r"..MDRcolor("도적",0,stat)..space..Weapon..eul.." 모두 검색합니다. |cffa335ee[아이템 링크]|r를 보시려면 |cff8787ED!던전이름|r과 함께 입력해보세요."
            end
            
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
            local itemList=checkDungeonHasItem(VALUES)                     
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
                    local itemList=checkDungeonHasItem(VALUES)                   
                    
                    if itemList then
                        chars[i]["extraLink"]=itemList
                        findChars[num]=chars[i]
                        if not dun[mapName] then
                            dun[mapName]=num
                        end                        
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
