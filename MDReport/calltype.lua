local callTypeTable={
    
    ["돌"]={"all", "모든 던전"},
	["ehf"]={"all", "모든 던전"},
	["EHF"]={"all", "모든 던전"},
    ["쐐기돌"]={"all", "모든 던전"},
    ["쐐기"]={"all", "모든 던전"},
    ["전체돌"]={"all", "모든 던전"},
    ["아무"]={"all", "모든 던전"},  
    ["모든돌"]={"all", "모든 던전"},
    
    ["무슨돌"]={"newkey", "새 돌"},
    ["새돌"]={"newkey", "새 돌"},
    
    ["누구돌"]={"currentdungeon", "석주"},
    ["석주"]={"currentdungeon", "석주"}, 
    
	["파장"]={"promote", "파장"},    
	
    ["단주"]={"covenantall", "모든 성약단"}, 
    ["성약"]={"covenantall", "모든 성약단"}, 
    ["성약단"]={"covenantall", "모든 성약단"},   
    
    ["현재돌"]={"currentall", "지금 소유한 돌"},
    ["돌내놔"]={"currentall", "지금 소유한 돌"},    
    
    ["주차"]={"parking", "주차 정보"},
	["wnck"]={"parking", "주차 정보"},
	["WNCK"]={"parking", "주차 정보"},
    ["단주차"]={"parking", "주차 정보"},
    ["합법"]={"parking", "주차 정보"},
    ["합법주차"]={"parking", "주차 정보"},
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
    --["죽"]={"class", "죽기", "힘"},
    ["죽기"]={"class", "죽기", "힘"},
    ["죽음의기사"]={"class", "죽기", "힘"},
    ["DEATHKNIGHT"]={"class", "죽기", "힘"},
    --["악"]={"class", "악사", "민첩"},
    ["악사"]={"class", "악사", "민첩"},
    ["악마사냥꾼"]={"class", "악사", "민첩"},
    ["DEMONHUNTER"]={"class", "악사", "민첩"},
    --["도"]={"class", "도적", "민첩"},
    ["도적"]={"class", "도적", "민첩"},
    ["돚거"]={"class", "도적", "민첩"},
    ["ROGUE"]={"class", "도적", "민첩"},
    --["전"]={"class", "전사", "힘"},
    ["전사"]={"class", "전사", "힘"},
    ["WARRIOR"]={"class", "전사", "힘"},
    --["흑"]={"class", "흑마", "지능"},
    ["흑마"]={"class", "흑마", "지능"},
    ["흑마법사"]={"class", "흑마", "지능"},
    ["WARLOCK"]={"class", "흑마", "지능"},
    --["법"]={"class", "법사", "지능"},
    ["법사"]={"class", "법사", "지능"},
    ["물빵"]={"class", "법사", "지능"},
    ["마법사"]={"class", "법사", "지능"},
    ["MAGE"]={"class", "법사", "지능"},
    --["냥"]={"class", "냥꾼", "민첩"},
    ["냥꾼"]={"class", "냥꾼", "민첩"},
    ["사냥꾼"]={"class", "냥꾼", "민첩"},
    ["HUNTER"]={"class", "냥꾼", "민첩"},
	
    ["기원"]={"class", "기원", "지능"},
	["원사"]={"class", "기원", "지능"},
    ["기원사"]={"class", "기원", "지능"},
    ["EVOKER"]={"class", "기원", "지능"},
	
    ["회드"]={"spec", "회복", "지능","드루"},
    ["회복"]={"spec", "회복", "지능","드루"},
    ["조드"]={"spec", "조화", "지능","드루"},
    ["조화"]={"spec", "조화", "지능","드루"},
    ["수드"]={"spec", "수호", "민첩","드루"},
    ["수호"]={"spec", "수호", "민첩","드루"},
    ["야드"]={"spec", "야성", "민첩","드루"},
    --["야성"]={"spec", "야성", "민첩","드루"},
    
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
    ["고통"]={"spec", "고통", "지능","흑마"},
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
	["전탱"]={"spec", "방어", "힘","전사"},
	["탱전"]={"spec", "방어", "힘","전사"},
    
    ["혈죽"]={"spec", "혈기", "힘","죽기"},
    ["혈기"]={"spec", "혈기", "힘","죽기"},
	["탱죽"]={"spec", "혈기", "힘","죽기"},
	["죽탱"]={"spec", "혈기", "힘","죽기"},
    ["부죽"]={"spec", "부정", "힘","죽기"},
    ["부정"]={"spec", "부정", "힘","죽기"},
    ["냉죽"]={"spec", "냉기", "힘","죽기"},
    ["냉기"]={"spec", "냉기", "힘","죽기"},
    
    ["파멸"]={"spec", "파멸", "민첩","악사"},
	["악딜"]={"spec", "파멸", "민첩","악사"},
    ["복수"]={"spec", "복수", "민첩","악사"},
	["악탱"]={"spec", "복수", "민첩","악사"},
    
	["황폐"]={"spec", "황폐", "지능","기원"},
	["용딜"]={"spec", "황폐", "지능","기원"},
    ["보존"]={"spec", "보존", "지능","기원"},
	["용힐"]={"spec", "보존", "지능","기원"},
	
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
	
	--점수
	["점수"]={"score", "쐐기돌 평점"},
	["모든점수"]={"score", "쐐기돌 평점","all"},
	
	["평점"]={"score_link", "평점표"},
	["모든평점"]={"score_link", "모든 평점표","all"},	
	["성적"]={"score_link", "평점표"},
	["모든성적"]={"score_link", "모든 평점표","all"},
	["표"]={"score_link", "평점표"},
	["모든표"]={"score_link", "모든 평점표","all"},
	["성적표"]={"score_link", "평점표"},
	["모든성적표"]={"score_link", "모든 평점표","all"},
	["평점표"]={"score_link", "평점표"},
	["모든평점표"]={"score_link", "모든 평점표","all"},
	["점수표"]={"score_link", "평점표"},
	["모든점수표"]={"score_link", "모든 평점표","all"},
    
    --어둠땅 던전
    --[[
    ["승천"]={"dungeon", "승천"},
    ["승천의첨탑"]={"dungeon", "승천"},
    ["승첨"]={"dungeon", "승천"},
    ["첨탑"]={"dungeon", "승천"},
    
    ["역병몰락지"]={"dungeon", "역병"},
    ["역몰"]={"dungeon", "역병"},
    ["몰락지"]={"dungeon", "역병"},
    ["몰락"]={"dungeon", "역병"},
    ["역병"]={"dungeon", "역병"},

    ["고통의투기장"]={"dungeon", "투기장"},
    ["고통"]={"dungeon", "투기장"},
    ["고투"]={"dungeon", "투기장"},
    ["투기장"]={"dungeon", "투기장"},
    ["투기"]={"dungeon", "투기장"},	
    
    ["전당"]={"dungeon", "속죄"},
    ["속죄의전당"]={"dungeon", "속죄"},
    ["속죄"]={"dungeon", "속죄"},    
    
    ["저편"]={"dungeon", "저편"},

    ["죽음의상흔"]={"dungeon", "죽상"},
    ["죽상"]={"dungeon", "죽상"},
    ["죽음"]={"dungeon", "죽상"},
    ["상흔"]={"dungeon", "죽상"},
    
    ["티르너사이드의안개"]={"dungeon", "티르너"},
    ["안개"]={"dungeon", "티르너"},
    ["티르"]={"dungeon", "티르너"},
    ["티르너"]={"dungeon", "티르너"},
    ["사이드"]={"dungeon", "티르너"},    
    
    ["핏빛심연"]={"dungeon", "핏심"},
    ["핏심"]={"dungeon", "핏심"},
    ["심연"]={"dungeon", "핏심"},
    ["핏빛"]={"dungeon", "핏심"},  
	]]
	
	["경이"]={"dungeon", "경이"},
	["거리"]={"dungeon", "경이"},    
    
	["소레아"]={"dungeon", "소레아"},
    ["소래아"]={"dungeon", "소레아"},	
	["승부수"]={"dungeon", "소레아"},
	
	["타자베쉬"]={"dungeon", "타자베쉬"},	
	["타자배쉬"]={"dungeon", "타자베쉬"},	
	["타자배시"]={"dungeon", "타자베쉬"},	
	["타자베시"]={"dungeon", "타자베쉬"},	
	["타자"]={"dungeon", "타자베쉬"},	
	
	["상층"]={"dungeon", "상층"},
    ["하층"]={"dungeon", "하층"},	
	
	["카라"]={"dungeon", "카라잔"},	
	["카라잔"]={"dungeon", "카라잔"},	
	
	["고철"]={"dungeon", "고철"},
	["고철장"]={"dungeon", "고철"},
    ["작업"]={"dungeon", "작업"},	
	["작업장"]={"dungeon", "작업"},	
	
	["메카곤"]={"dungeon", "메카곤"},	
	["메카"]={"dungeon", "메카곤"},	
	
	["파멸"]={"dungeon", "파멸"},
	["파멸철로"]={"dungeon", "파멸"},
	["철로"]={"dungeon", "파멸"},
	["정비"]={"dungeon", "파멸"},
	["정비소"]={"dungeon", "파멸"},
	["파멸철로정비소"]={"dungeon", "파멸"},
    ["강철"]={"dungeon", "강철"},	
	["선착"]={"dungeon", "강철"},	
	["선착장"]={"dungeon", "강철"},		
	["강철선착장"]={"dungeon", "강철"},	
	
	["알게"]={"dungeon", "대학"},
	["알게타르"]={"dungeon", "대학"},
	["대학"]={"dungeon", "대학"},
	["알게타르대학"]={"dungeon", "대학"},
	
	["골짜기"]={"dungeon", "담쟁이"},
	["덩굴"]={"dungeon", "담쟁이"},
	["담쟁이"]={"dungeon", "담쟁이"},
	["담쟁이덩굴"]={"dungeon", "담쟁이"},
	
	["주입"]={"dungeon", "주입"},
	["주입의전당"]={"dungeon", "주입"},
	["전당"]={"dungeon", "주입"},
	
	["넬타"]={"dungeon", "넬타"},
	["넬타루스"]={"dungeon", "넬타"},
	
	["루비"]={"dungeon", "루비"},
	["루비생명"]={"dungeon", "루비"},
	["루생"]={"dungeon", "루비"},
	["웅덩이"]={"dungeon", "루비"},
	
	["하늘"]={"dungeon", "하늘"},
	["하늘빛"]={"dungeon", "하늘"},
	["보관소"]={"dungeon", "하늘"},
	["보관"]={"dungeon", "하늘"},
	
	["노쿠"]={"dungeon", "노쿠드"},
	["노쿠드"]={"dungeon", "노쿠드"},
	["쿠드"]={"dungeon", "노쿠드"},
	["노쿠드공격대"]={"dungeon", "노쿠드"},
	["공격대"]={"dungeon", "노쿠드"},
	["노공"]={"dungeon", "노쿠드"},
	
	["울다만"]={"dungeon", "울다만"},
	["티르"]={"dungeon", "울다만"},
	["울티"]={"dungeon", "울다만"},
	["유산"]={"dungeon", "울다만"},
	
	["별궁"]={"dungeon", "별궁"},
	["별의궁정"]={"dungeon", "별궁"},
	["궁정"]={"dungeon", "별궁"},
	["궁전"]={"dungeon", "별궁"},
	
	["용맹"]={"dungeon", "용맹"},
	["용전"]={"dungeon", "용맹"},
	["용맹의전당"]={"dungeon", "용맹"},
	
	["어둠달"]={"dungeon", "어둠달"},
	["어둠"]={"dungeon", "어둠달"},
	["지하"]={"dungeon", "어둠달"},
	["묘지"]={"dungeon", "어둠달"},
	["지하묘지"]={"dungeon", "어둠달"},
	
	["옥룡"]={"dungeon", "옥룡사"},
	["옥룡사"]={"dungeon", "옥룡사"},
	
	--아이템ID
	--[[
	["약병"]={"itemID", "부패약병",178771,"역병",3536192},
	["부패약병"]={"itemID", "부패약병", 178771,"역병",3536192},
	["부패"]={"itemID", "부패약병", 178771,"역병",3536192},
	
    ["변신수"]={"itemID", "변신수", 178708,"티르너",838551},
	["변신"]={"itemID", "변신수", 178708,"티르너",838551},
	
	["양자"]={"itemID", "양자장치", 179350,"저편",2000857},
	["양자장치"]={"itemID", "양자장치", 179350,"저편",2000857},
	
	["피칠갑"]={"itemID", "피칠갑", 179331,"저편",1526632},
	["피칠"]={"itemID", "피칠갑", 179331,"저편",1526632},
	["칠갑"]={"itemID", "피칠갑", 179331,"저편",1526632},
	
	["수정"]={"itemID", "마력수정", 179342,"저편",1033908},
	["압도"]={"itemID", "마력수정", 179342,"저편",1033908},
	["마력"]={"itemID", "마력수정", 179342,"저편",1033908},
	["압도수정"]={"itemID", "마력수정", 179342,"저편",1033908},	
	["마력수정"]={"itemID", "마력수정", 179342,"저편",1033908},
	
    ["루비"]={"itemID", "영혼루비", 178809,"투기장",133250},
	["영혼루비"]={"itemID", "영혼루비", 178809,"투기장",133250},
	
	["수포"]={"itemID", "수포폭풍", 178754,"역병",3502009},
	["수포폭풍"]={"itemID", "수포폭풍", 178754,"역병",3502009},
	
	["철학자"]={"itemID", "철학자", 180112,"승천",3490572},
	["철학"]={"itemID", "철학자", 180112,"승천",3490572},

	
	["지눈"]={"itemID", "지휘의 눈", 142167,"상층",1362633},
	["지휘"]={"itemID", "지휘의 눈", 142167,"상층",1362633},
	["지휘의눈"]={"itemID", "지휘의 눈", 142167,"상층",1362633},
	
	["절기"]={"itemID", "첫 번째 절기의 전서", 185836,"경이",3615911},
	]]
	["깃털"]={"itemID", "분노한 성난깃털", 193677,"노쿠드",2103807},
	["성난"]={"itemID", "분노한 성난깃털", 193677,"노쿠드",2103807},
	["성난깃털"]={"itemID", "분노한 성난깃털", 193677,"노쿠드",2103807},
	["숫돌"]={"itemID", "바람상처 숫돌", 137486,"별궁",519378},
	["음영석"]={"itemID", "공허치유사의 음영석", 110007,"어둠달",133266},
	
	--성약
    
    ["나이트페이"]={"covenant", "나이트 페이"},  
    ["나이트 페이"]={"covenant", "나이트 페이"},  
    ["나페"]={"covenant", "나이트 페이"}, 
    ["페이"]={"covenant", "나이트 페이"}, 
    
    ["강령"]={"covenant", "강령군주"},  
    ["강령군주"]={"covenant", "강령군주"},  
    
    ["벤티르"]={"covenant", "벤티르"},  
    ["밴티르"]={"covenant", "벤티르"},  
    
    ["키리안"]={"covenant", "키리안"},  
    ["키리얀"]={"covenant", "키리안"},  
	
	["위업"]={"achievement","1시즌 쐐기돌 위업"},
    
    ["얼라이언스를위하여"]={"emote","얼라이언스를위하여"},
    
    ["MDReport_VC"]={"forceversion", "버전보고"},
    ["버전"]={"forceversion", "버전보고"},
    ["버젼"]={"forceversion", "버전보고"},
    
    ["속성"]={"affix", 0},
	["어픽스"]={"affix", 0},
    ["다음속성"]={"affix", "all"},  
    --["이번주"]={"affix", 0},
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
    ["격노"]={"affix", "분노"},  
    ["치명"]={"affix", "치명상"},  
    ["치명상"]={"affix", "치명상"},  
    ["원한"]={"affix", "원한"},  
    ["전율"]={"affix", "전율"},  
    ["무리"]={"affix", "무리"},  
    ["폭탄"]={"affix", "폭탄"},  
    ["변덕"]={"affix", "변덕"},  
    ["화산"]={"affix", "화산"},  
	["천둥"]={"affix", "천둥"},
	--["장막"]={"affix", "장막"},
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
