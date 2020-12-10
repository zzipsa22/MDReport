local callTypeTable={
    
    ["돌"]={"all", "모든 던전"},
    ["쐐기돌"]={"all", "모든 던전"},
    ["쐐기"]={"all", "모든 던전"},
    ["전체돌"]={"all", "모든 던전"},
    ["아무"]={"all", "모든 던전"},    
    ["모든돌"]={"all", "모든 던전"},
    
    ["무슨돌"]={"currentmykey", "현재 내 돌"},
    
    ["현재돌"]={"currentall", "지금 소유한 돌"},
    ["돌내놔"]={"currentall", "지금 소유한 돌"},   
    
    ["주차"]={"parking", "주차"},
    ["단주차"]={"parking", "주차"},
    ["합법"]={"parking", "주차"},
    ["합법주차"]={"parking", "주차"},
    ["편법"]={"parking", "soft"},
    ["편법주차"]={"parking", "soft"},
    ["불법"]={"parking", "hard"},    
    ["불법주차"]={"parking", "hard"},
    
    ["이상"]={"levelrange", "99"},
    ["이하"]={"levelrange", "2"},
    
    ["힘"]={"stat", "힘"},  
    ["민"]={"stat", "민첩"},  
    ["지"]={"stat", "지능"},      
    ["민첩"]={"stat", "민첩"},  
    ["지능"]={"stat", "지능"},  
    
    --["드"]={"class", "드루"},
    ["들후"]={"class", "드루"},
    ["드루"]={"class", "드루"},
    ["드루이드"]={"class", "드루"},
    ["DRUID"]={"class", "드루"},
    --["수"]={"class", "수도"},
    ["수도"]={"class", "수도"},    
    ["수도사"]={"class", "수도"},
    ["도사"]={"class", "수도"},
    ["MONK"]={"class", "수도"},
    --["성"]={"class", "기사"},    
    --["기"]={"class", "기사"},    
    ["기사"]={"class", "기사"},
    ["성기사"]={"class", "기사"},
    ["PALADIN"]={"class", "기사"},
    --["술"]={"class", "술사"},    
    ["술사"]={"class", "술사"},
    ["주술사"]={"class", "술사"},
    ["SHAMAN"]={"class", "술사"},
    --["사"]={"class", "사제", "지능"},
    ["사제"]={"class", "사제", "지능"},
    ["흰거"]={"class", "사제", "지능"},
    ["PRIEST"]={"class", "사제", "지능"},
    --["죽"]={"class", "죽기"},
    ["죽기"]={"class", "죽기"},
    ["죽음의기사"]={"class", "죽기"},
    ["DEATHKNIGHT"]={"class", "죽기"},
    --["악"]={"class", "악사", "민첩"},
    ["악사"]={"class", "악사", "민첩"},
    ["악마사냥꾼"]={"class", "악사", "민첩"},
    ["DEMONHUNTER"]={"class", "악사", "민첩"},
    --["도"]={"class", "도적"},
    ["도적"]={"class", "도적"},
    ["돚거"]={"class", "도적"},
    ["ROGUE"]={"class", "도적"},
    --["전"]={"class", "전사"},
    ["전사"]={"class", "전사"},
    ["WARRIOR"]={"class", "전사"},
    --["흑"]={"class", "흑마", "지능"},
    ["흑마"]={"class", "흑마", "지능"},
    ["흑마법사"]={"class", "흑마", "지능"},
    ["WARLOCK"]={"class", "흑마", "지능"},
    --["법"]={"class", "법사", "지능"},
    ["법사"]={"class", "법사", "지능"},
    ["물빵"]={"class", "법사", "지능"},
    ["마법사"]={"class", "법사", "지능"},
    ["MAGE"]={"class", "법사", "지능"},
    --["냥"]={"class", "냥꾼"},
    ["냥꾼"]={"class", "냥꾼"},
    ["사냥꾼"]={"class", "냥꾼"},
    ["HUNTER"]={"class", "냥꾼"},
    
    ["회드"]={"spec", "회복", "지능","드루"},
    ["회복"]={"spec", "회복", "지능","드루"},
    ["조드"]={"spec", "조화", "지능","드루"},
    ["조화"]={"spec", "조화", "지능","드루"},
    ["수드"]={"spec", "수호", "민첩","드루"},
    ["수호"]={"spec", "수호", "민첩","드루"},
    ["야드"]={"spec", "야성", "민첩","드루"},
    ["야성"]={"spec", "야성", "민첩","드루"},
    
    ["암사"]={"spec", "암흑", "지능","사제"},
    ["암흑"]={"spec", "암흑", "지능","사제"},
    ["신사"]={"spec", "신성", "지능","사제"},
    ["신성"]={"spec", "신성", "지능","사제"},
    ["수사"]={"spec", "수양", "지능","사제"},
    ["수양"]={"spec", "수양", "지능","사제"},
    
    ["운무"]={"spec", "운무", "지능","수도"},
    ["풍운"]={"spec", "풍운", "민첩","수도"},
    ["양조"]={"spec", "양조", "민첩","수도"},
    
    ["정술"]={"spec", "정기", "지능","술사"},
    ["정기"]={"spec", "정기", "지능","술사"},
    ["고술"]={"spec", "고양", "민첩","술사"},
    ["고양"]={"spec", "고양", "민첩","술사"},
    ["복술"]={"spec", "복원", "지능","술사"},
    ["복원"]={"spec", "복원", "지능","술사"},
    
    ["보기"]={"spec", "보호", "힘","기사"},
    ["보호"]={"spec", "보호", "힘","기사"},
    ["징기"]={"spec", "징벌", "힘","기사"},
    ["징벌"]={"spec", "징벌", "힘","기사"},
    ["신기"]={"spec", "신기", "지능","기사"},
    
    ["화염"]={"spec", "화염", "지능","법사"},
    ["화법"]={"spec", "화염", "지능","법사"},
    ["냉법"]={"spec", "냉법", "지능","법사"},
    ["비법"]={"spec", "비전", "지능","법사"},
    ["비전"]={"spec", "비전", "지능","법사"},    
    
    ["파흑"]={"spec", "파괴", "지능","흑마"},
    ["파괴"]={"spec", "파괴", "지능","흑마"},
    ["고흑"]={"spec", "고통", "지능","흑마"},
    --["고통"]={"spec", "고통", "지능","흑마"},
    ["악흑"]={"spec", "악마", "지능","흑마"},
    ["악마"]={"spec", "악마", "지능","흑마"},
    
    ["무법"]={"spec", "무법", "민첩","도적"},
    ["암살"]={"spec", "암살", "민첩","도적"},
    ["잠행"]={"spec", "잠행", "민첩","도적"},
    
    ["무전"]={"spec", "무기", "힘","전사"},
    ["분노"]={"spec", "분노", "힘","전사"},
    ["분전"]={"spec", "분노", "힘","전사"},
    ["방어"]={"spec", "방어", "힘","전사"},
    ["방전"]={"spec", "방어", "힘","전사"},
    
    ["혈죽"]={"spec", "혈기", "힘","죽기"},
    ["혈기"]={"spec", "혈기", "힘","죽기"},
    ["부죽"]={"spec", "부정", "힘","죽기"},
    ["부정"]={"spec", "부정", "힘","죽기"},
    ["냉죽"]={"spec", "냉기", "힘","죽기"},
    ["냉기"]={"spec", "냉기", "힘","죽기"},
    
    ["파멸"]={"spec", "파멸", "민첩","악사"},
    ["복수"]={"spec", "복수", "민첩","악사"},
    
    ["야냥"]={"spec", "야수", "민첩","냥꾼"},
    ["야수"]={"spec", "야수", "민첩","냥꾼"},
    ["격냥"]={"spec", "사격", "민첩","냥꾼"},
    ["사격"]={"spec", "사격", "민첩","냥꾼"},
    ["생냥"]={"spec", "생존", "민첩","냥꾼"},
    ["생존"]={"spec", "생존", "민첩","냥꾼"},  
    
    ["독"]={"spell", "독"},
    ["저주"]={"spell", "저주"},
    ["질병"]={"spell", "질병"},
    
    ["방패"]={"specificitem", "방패"},
    ["한손도검"]={"specificitem", "한손도검"},
    ["양손도검"]={"specificitem", "양손도검"},
    ["한손검"]={"specificitem", "한손도검"},
    ["양손검"]={"specificitem", "양손도검"},
    ["전투검"]={"specificitem", "전투검"},
    ["단검"]={"specificitem", "단검"},
    ["지팡이"]={"specificitem", "지팡이"},
    ["장착무기"]={"specificitem", "장착무기"},
    ["장착"]={"specificitem", "장착무기"},
    ["활"]={"specificitem", "활"},
    ["총"]={"specificitem", "총"},
    ["석궁"]={"specificitem", "석궁"},
    ["한손둔기"]={"specificitem", "한손둔기"},
    ["양손둔기"]={"specificitem", "양손둔기"},
    ["한손도끼"]={"specificitem", "한손도끼"},
    ["양손도끼"]={"specificitem", "양손도끼"},
    ["마법봉"]={"specificitem", "마법봉"},
    ["보조"]={"specificitem", "보조장비"},
    ["보조장비"]={"specificitem", "보조장비"},
    ["장창"]={"specificitem", "장창"},
    ["무기"]={"item", "무기"},
    
    ["양손무기"]={"category", "양손장비"},     
    ["양손장비"]={"category", "양손장비"},     
    ["양손"]={"category", "양손장비"}, 
    
    ["한손"]={"category", "한손장비"},  
    ["한손무기"]={"category", "한손장비"},     
    ["한손장비"]={"category", "한손장비"},     
    
    ["근접무기"]={"category", "근접장비"},     
    ["근접장비"]={"category", "근접장비"},  
    ["근거리"]={"category", "근접장비"},   
    --["근접"]={"category", "근접장비"},       
    
    --["원거리"]={"category", "원거리장비"},     
    ["원거리장비"]={"category", "원거리장비"},     
    
    ["장신구"]={"trinket", "장신구"},
    
    ["힐"]={"role", "힐러","지능"},
    ["힐러"]={"role", "힐러","지능"},
    
    ["딜"]={"role", "딜러",""},
    ["딜러"]={"role", "딜러",""},
    ["캐스터"]={"role", "딜러","지능"},
    
    ["탱"]={"role", "탱커","힘/민첩"},
    ["탱커"]={"role", "탱커","힘/민첩"}, 
    ["민첩탱커"]={"role", "탱커","민첩"},     
    ["민탱커"]={"role", "탱커","민첩"},   
    ["민첩탱"]={"role", "탱커","민첩"},      
    ["민탱"]={"role", "탱커","민첩"}, 
    
    ["힘탱커"]={"role", "탱커","힘"},     
    ["힘탱"]={"role", "탱커","힘"},    
    
    --["근딜"]={"role", "딜러","힘,민첩"},
    --["원딜"]={"role", "딜러","민첩"},
    --["근접"]={"role", "딜러","힘,민첩"},
    --["원거리"]={"role", "딜러","민첩"},    
    
    ["천"]={"spell", "천"},
    ["사슬"]={"spell", "사슬"},
    ["판금"]={"spell", "판금"},
    ["가죽"]={"spell", "가죽"},
    
    ["웅심"]={"spell", "웅심"},
    ["영웅심"]={"spell", "웅심"},
    ["블러드"]={"spell", "웅심"},
    
    ["전부"]={"spell", "전부"},
    ["전투부활"]={"spell", "전부"},
    
    --어둠땅 던전
    
    ["승천"]={"dungeon", "승천"},
    ["승천의첨탑"]={"dungeon", "승천"},
    ["승첨"]={"dungeon", "승천"},
    ["첨탑"]={"dungeon", "승천"},
    
    ["역병의몰락지"]={"dungeon", "몰락"},
    ["역몰"]={"dungeon", "몰락"},
    ["몰락지"]={"dungeon", "몰락"},
    ["몰락"]={"dungeon", "몰락"},
    ["역병"]={"dungeon", "몰락"},
    
    ["고통의투기장"]={"dungeon", "투기장"},
    ["고통"]={"dungeon", "투기장"},
    ["고투"]={"dungeon", "투기장"},
    ["투기장"]={"dungeon", "투기장"},
    
    ["전당"]={"dungeon", "속죄"},
    ["속죄의전당"]={"dungeon", "속죄"},
    ["속죄"]={"dungeon", "속죄"},
    ["속전"]={"dungeon", "속죄"},
    
    ["저편"]={"dungeon", "저편"},
    
    ["죽음의상흔"]={"dungeon", "죽상"},
    ["죽상"]={"dungeon", "죽상"},
    ["죽음"]={"dungeon", "죽상"},
    ["상흔"]={"dungeon", "죽상"},
    
    ["티르너사이드의안개"]={"dungeon", "티르너"},
    ["안개"]={"dungeon", "티르너"},
    ["티르너"]={"dungeon", "티르너"},
    ["사이드"]={"dungeon", "티르너"},
    ["티사안"]={"dungeon", "티르너"},
    
    ["핏빛심연"]={"dungeon", "심연"},
    ["핏심"]={"dungeon", "심연"},
    ["심연"]={"dungeon", "심연"},
    ["핏빛"]={"dungeon", "심연"},
    
    ["버전"]={"version", nil},
    ["버젼"]={"version", nil},
    
    ["MDReport_VC"]={"forceversion", nil},
    
    ["속성"]={"affix", 0},
    ["다음속성"]={"affix", "all"},    
    ["이번주"]={"affix", 0},
    ["이번주속성"]={"affix", 0},    
    ["다음주"]={"affix", 1},
    ["다음주속성"]={"affix", 1},
    ["다다음주"]={"affix", 2},
    ["다다음주속성"]={"affix", 2},    
    ["다다다음주"]={"affix", 3},
    ["다다다음주속성"]={"affix", 3},    
    ["지난주"]={"affix", -1},
    ["저번주"]={"affix", -1},
    ["지난주속성"]={"affix", -1},
    ["지지난주"]={"affix", -2},
    ["지지난주속성"]={"affix", -2},    
    
    ["교만"]={"affix", "교만"},   
    ["파열"]={"affix", "파열"},   
    ["폭군"]={"affix", "폭군"},   
    ["폭풍"]={"affix", "폭풍"},   
    ["경화"]={"affix", "경화"},   
    ["고취"]={"affix", "고취"},   
    ["강화"]={"affix", "강화"},   
    ["괴저"]={"affix", "괴저"},   
    ["피웅"]={"affix", "피웅덩이"},   
    ["피웅덩이"]={"affix", "피웅덩이"},   
    ["분노"]={"affix", "분노"},   
    ["치명"]={"affix", "치명상"},   
    ["치명상"]={"affix", "치명상"},   
    ["원한"]={"affix", "원한"},   
    ["전율"]={"affix", "전율"},   
    ["무리"]={"affix", "무리"},   
    ["폭탄"]={"affix", "폭탄"},   
    ["변덕"]={"affix", "변덕"},   
    ["화산"]={"affix", "화산"},   
    --["각성"]={"affix", "각성"},   
    --["미혹"]={"affix", "미혹"},   
    --["과잉"]={"affix", "과잉"},   
    
    
}

function getCallTypeTable(keyword)
    for k,v in pairs(callTypeTable) do
        if keyword==k then
            return v
        end        
    end 
end
