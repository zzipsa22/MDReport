local who,channel,level,level2,callTypeT,comb
local callType,callTypeB,keyword,keyword2,keyword3={},{},{},{},{}
local meGame,meAddon,krClass,className=MDR["meGame"],MDR["meAddon"],MDR["krClass"],MDR["className"]
local tips={}
local warns=100
local bonus="::::::::14:70::23:1:3524:1:28:1261:::"
local bonus1="::::::::60:269::23:1:3524:1:28:2042:::::" ;--1/12강
local bonus9="{b9}"--"::::::::60:70::16:6:7617:7359:6652:7575:1550:6646:1:28:1279:::::" --9/12강
local bonus2=":6204:::::::60:70::54:5:7732:7359:6652:1550:6646:1:28:2042:::::4897" ;--시장하드
local dungeonTable={
	--[[
    ["투기장"]={
        "고통의 투기장",
        {
            {"힘","양손도끼",178866,"치특"},
            {"민첩","장창", 178865,"유가"},
            {"지능","단검", 178789,"가유"},
            {"민첩","한손둔기", 178864,"유가"},
            {"힘","한손도끼", 178863,"특치"},
            {"힘/지능","방패", 178867,"가치"},
            {"지능","보조장비", 178868,"가유"},
            {"지능","장신구",178809,"힐러/딜러","","영혼루비",133250},            
            {"힘/민첩","장신구",178811,"딜러","","전서"},            
            {"힘","장신구",178808,"딜러/탱커","","내장"},            
            {"지능","장신구",178810,"힐러","","혼령약병"},            
        },
		382
    }, 
    ["속죄"]={
        "속죄의 전당",
        {
            {"지능","지팡이",178829,"가치"},
            {"민첩","한손둔기", 178834,"특치"},
            {"지능","보조장비", 178828,"유치"},
            {"힘/민첩","장신구", 178825,"탱커","","돌심장"},
            {"지능","장신구",178826, "힐러/딜러","","자수정"},
        },
		378
    },
    ["승천"]={
        "승천의 첨탑",
        {
            {"민첩","장창",180096,"특유"},
            {"민첩","지팡이",180097,"치특"},
            {"민첩","한손도끼",180095,"치특"},
            {"민첩","활",180112,"치가","","철학자",3490572},            
            {"민첩","장신구",180116,"딜러/탱커","","령 전지"},
            {"힘","장신구", 180118,"딜러/탱커","","령의 장"},
            {"지능","장신구", 180119,"힐러","","집정관"},
            {"지능","장신구",180117,"딜러","","최고천"},
        },
		381
        
    }, 
    ["역병"]={
        "역병 몰락지",
        {
            {"민첩","장창",178929,"가치"},
            {"민첩","단검",178928,"치특"},
            {"민첩","한손도검",178754,"가특","","수포폭풍",3502009},
            {"힘","한손둔기",178752,"유가"},
            {"지능","단검",178753,"치특"},
            {"힘/민첩","장신구", 178770,"탱커","","끈적장기"},
            {"지능/민첩","장신구", 178769,"딜러","","분열수액"},
            {"힘/민첩","장신구", 178771,"딜러","","부패약병",3536192},
        },
		379
    }, 
    ["저편"]={
        "저편",
        {
            {"민첩","지팡이",179347,"가유"},
            {"지능","지팡이",179339,"특유"},
            {"힘","양손도검",179330,"치특"},
            {"민첩","한손도검",179328,"치유"},
            {"힘","한손둔기",179340,"치특"},
            {"민첩","석궁",179348,"특치"},
            {"힘/지능/민첩","장신구",179350 ,"힐러/딜러/탱커","","양자장치",2000857},
            {"힘","장신구", 179342,"딜러/탱커","","마력수정",1033908},
            {"힘/민첩","장신구", 179331,"탱커","","피칠갑",1526632},
            {"민첩","장신구", 179356,"딜러/탱커","","어둠토템"},
        },
		377
    }, 
    ["죽상"]={
        "죽음의 상흔",
        {
            {"힘","양손도검",178780,"가유"},
			{"힘","한손둔기",178730,"가유"},
            {"민첩","단검",178743,"특치"},			
            {"지능","한손도검",178737,"치가"},            
            {"민첩","총",178735,"유특"},
            {"힘/지능","방패",178750,"치유"},
            {"지능","장신구",178772 ,"딜러","","주머니"},
            {"민첩","장신구",178742 ,"딜러/탱커","","독소"},
            {"힘","장신구",178751 ,"딜러/탱커","","갈고리"},
            {"지능","장신구", 178783,"힐러","","성물함"},
        },
		376
    }, 
    ["티르너"]={
        "티르너 사이드의 안개",
        {
            {"힘","양손도끼",178713,"가유"},
            {"지능","지팡이",178714,"유특"},
            {"민첩","단검",178710,"가유"},
            {"지능","한손둔기", 178709,"특치"},
            {"힘","한손도끼",178711,"유가"},
            {"힘/지능","방패",178712,"특가"},
            {"민첩","장신구", 178715,"딜러/탱커","","오카리나"},
            {"지능","장신구", 178708,"힐러/딜러","","변신수",838551},            
        },
		375
    }, 
    ["핏심"]={
        "핏빛 심연",
        {
            {"민첩","한손도끼",178857,"유가"},
			{"민첩","전투검",178854,"치유"},            
            {"민첩","단검",178853,"가유"},
            {"힘","한손둔기",178855,"특치"},
			{"지능","한손도검",178856,"유특"},            
            {"힘/민첩","보조장비",178852,"치특"},
            {"지능","장신구", 178849,"힐러/딜러","","령 우리"},
            {"힘/민첩","장신구", 178861,"딜러/탱커","","유리병"},
            {"지능","장신구", 178850,"힐러","","태양티끌"},
            {"힘/민첩","장신구", 178862,"탱커","","칼춤꾼"},
        },
		380
    }, 

	    
	["경이"]={
        "타자베쉬: 경이의 거리",
        {
		    {"민첩","한손도검",185780,"특치"},
			{"힘","한손도검",185824,"치가"},
			{"민첩","단검",185777,"가특"},
			{"지능","단검",185821,"치유"},
			{"민첩","석궁",185783,"가유"},
			{"민첩","장착무기",185778,"치가"},		
			{"지능","보조장비",185812,"치유"},
			{"힘/지능","방패",185811,"특치"},
			{"힘/민첩","장신구", 185836,"탱커","","첫 번째 절기의 전서",3615911},
			{"힘/민첩","장신구", 190652,"딜러","근접","똑딱이"},
			{"민첩/지능","장신구", 185846,"딜러","원거리","우편정령"},
			{"지능","장신구", 185845,"힐러","","분배장치"},
        },
		391,
    }, 
	
	["소레아"]={
        "타자베쉬: 소레아의 승부수",
        {
            {"민첩","지팡이",185779,"특가"},
			{"힘","양손도끼",185810,"치유"},
			{"지능","한손도검",185841,"특유"},
			{"민첩","한손둔기",185823,"특유"},
			{"지능","지팡이",185822,"특가"},
			{"민첩","전투검",185819,"특가"},
			{"힘/지능/민첩","장신구", 190958,"힐러/딜러/탱커","","소레아",1028991},
        },
		392,
    }, 
	
	["하층"]={
        "다시 찾은 카라잔: 하층",
        {
			{"지능/민첩","장신구", 142160,"딜러","원거리","아옳리아"},
			{"힘/민첩","장신구", 142164,"딜러","근접","토우니"},
			{"힘/민첩","장신구", 142168,"탱커","","청지기"},
			{"지능","장신구", 142158,"힐러","","도가니"},
			{"힘/민첩","장신구", 142161,"탱커","","공포"},
			{"힘/민첩","장신구", 142159,"딜러","근접","손수건"},
        },
		227
		
    },
	
	["상층"]={
        "다시 찾은 카라잔: 상층",
        {
			{"지능/민첩","장신구", 142165,"딜러","원거리","피조물핵"},
			{"힘/민첩","장신구", 142169,"탱커","","허깨비"},
			{"지능/민첩","장신구", 142157,"딜러","원거리","아란루비",134129},
			{"지능","장신구", 142162,"힐러","","요동마력"},
			{"힘/민첩","장신구", 142167,"딜러","근접","지휘의 눈",1362633},
        },
		234
    }, 
	["고철"]={
        "작전명: 메카곤 - 고철장",
        {
            {"민첩","지팡이",169035,"가치"},
			{"힘","양손둔기",169050,"유치"},			
			{"민첩","한손둔기",169052,"치유"},
			{"민첩","한손도끼",169058,"착효"},
			{"지능","한손도검",169062,"치가"},
			{"민첩","단검",169066,"가특"},
			{"힘","한손도끼",168963,"착효"},
			{"민첩","총",169077,"특치"},
			{"힘/지능","방패",169068,"특화착효"},
			{"힘/민첩","장신구", 169769,"딜러","","오토바이"},
        },
		369
    }, 
	["작업"]={
        "작전명: 메카곤 - 작업장",
        {
            {"지능","한손둔기",168955,"가유"},
			{"민첩","단검",168962,"치특"},			
			{"지능","지팡이",168973,"가특사효"},
			{"힘","한손도검",169608,"가치"},
			{"힘/민첩","장신구", 168965,"탱커","","백금판"},
			{"지능","장신구", 169344,"힐러","","마나전지"},
        },
		370
    }, 
	["강철"]={
        "강철 선착장",
        {
		    {"민첩","지팡이",110059,"유가"},
			{"민첩","장착무기",110058,"유특"},
			{"민첩","한손도끼",110055,"치가"},
			{"지능","한손둔기",110057,"특유"},
			{"민첩","총",110056,"가특"},
			{"지능","마법봉",110060,"가특"},
			{"힘/민첩/지능","장신구", 110017,"힐러/딜러/탱커","","유연사효"},
			{"지능","장신구", 110002,"힐러/딜러","","가속사효"},
			{"민첩","장신구", 109997,"딜러/탱커","","특화사효"},
        },
		169,
		
    }, 
	["파멸"]={
        "파멸철로 정비소",
        {
			{"힘","양손도끼",110051,"치가"},
			{"지능","지팡이",110054,"치가"},
			{"힘","한손둔기",110052,"특가"},
			{"힘/지능","방패",110053,"유치"},
			{"민첩","장신구", 109996,"딜러/탱커","","민첩유연"},
			{"지능","장신구", 110001,"힐러/딜러","","지능특화"},
        },
		166,
    }, 
	]]
	
	["대학"]={
        "알게타르 대학",
        {			
			{"힘","양손도끼",193716,"특유"},
			{"지능","지팡이",193707,"특가"},
			{"민첩","지팡이",193723,"치유"},
			{"민첩","전투검",193717,"유치"},
			{"지능","한손도검",193710,"가특"},
			{"힘","한손도검",193711,"가유"},
			{"지능","보조장비",193709,"치가"},			
			
			{"힘/민첩","장신구", 193701,"딜러/탱커","","수수께끼",133876},
			{"지능","장신구", 193718,"힐러/딜러","","호루라기"},
			{"힘","장신구", 193719,"딜러/탱커","","용경기"},
        },
		402,
    }, 
			
	["담쟁이"]={
        "담쟁이가죽 골짜기",
        {			
			{"힘","양손둔기",193658,"특치"},
			{"지능","양손둔기",193674,"특가"},
			{"민첩","장창",193675,"치가"},
			{"민첩","단검",193664,"치유"},
			{"지능","한손둔기",193665,"특치"},
			{"민첩","석궁",193670,"특가"},				
			
			{"힘","장신구", 193652,"딜러/탱커","","나무아귀"},
			{"민첩/지능","장신구", 193660,"힐러/딜러/탱커","","우상"},			
        },
		405,		
    }, 
	
	["주입"]={
        "주입의 전당",
        {			
			{"힘","양손도검",193742,"치특"},
			{"민첩","단검",193730,"유치"},
			{"힘","한손도끼",193729,"유가"},
			{"민첩","총",193747,"특유"},
			{"지능","보조장비",193745,"가특"},	
			
			{"지능","장신구", 193736,"힐러/딜러","","맥동심장"},
			{"민첩","장신구", 193732,"딜러/탱커","","얼음구체"},
			{"힘/민첩/지능","장신구", 193743,"힐러/딜러/탱커","","이리데우스 파편"},	
        },
		406,
    }, 
	
	["넬타"]={
        "넬타루스",
        {			
			{"힘","양손둔기",193779,"가치"},
			{"힘/민첩","한손둔기",193785,"가치","","가열로폭풍",4183025},
			{"지능","단검",193790,"특유"},
			{"민첩","장착무기",193772,"치유"},
			{"힘/지능","방패",193778,"치특"},
			{"지능","보조장비",193783,"치가"},	
			
			{"지능","장신구", 193773,"힐러/딜러","","넬타루스"},
			{"지능/민첩","장신구", 193769,"힐러/딜러/탱커","","창 파편"},
			{"힘/민첩","장신구", 193786,"딜러/탱커","","돌연변이"},	
        },
		404,
    }, 
	
	["루비"]={
        "루비 생명의 웅덩이",
        {			
			{"민첩","양손도끼",193755,"가치"},
			{"지능","지팡이",193761,"치특"},
			{"민첩","단검",193756,"유가"},
			{"민첩","한손둔기",193767,"치가"},
			{"힘/지능","방패",193754,"유특"},
			{"지능","보조장비",193766,"치유"},
			
			{"힘/지능/민첩","장신구", 193757,"힐러/딜러/탱커","","알껍질",4509422},
			{"힘","장신구", 193762,"딜러/탱커","","불길결속자"},
			{"지능","장신구", 193748,"힐러/딜러","","카이락카"},	
        },
		399,
    }, 
	
	["하늘"]={
        "하늘빛 보관소",
        {			
			{"힘","장창",193638,"가특"},
			{"민첩","지팡이",193651,"특유"},
			{"지능","한손도검",193632,"가유"},
			{"민첩","한손도검",193646,"유치"},
			{"민첩","한손도끼",193631,"유가"},
			{"힘/지능","방패",193645,"가유"},
						
			{"힘","장신구", 193634,"딜러/탱커","","급성장"},
			{"지능","장신구", 193628,"힐러/딜러","","마력고서"},
			{"지능","장신구", 193639,"힐러/딜러","","조각난 심장"},	
        },
		401,
    }, 
	
	["노쿠드"]={
        "노쿠드 공격대",
        {						
			{"지능","지팡이",193699,"유특"},
			{"힘","장창",193695,"유치"},
			{"힘","한손도검",193700,"특치","","연격검",4044018},
			{"지능","단검",193687,"특가"},
			{"민첩","전투검",193688,"특치","","폭풍검",4335739},
			{"민첩","활",193681,"가치"},			
					
			{"힘/민첩","장신구", 193689,"탱커","","그라니스"},
			{"지능","장신구", 193677,"힐러/딜러","","성난깃털",2103807},
			{"민첩","장신구", 193697,"딜러/탱커","","소용돌이 병"},	
			{"힘","장신구", 193679,"딜러/탱커","","우상"},	
			{"지능","장신구", 193678,"힐러/딜러","","초소형 돌"},
        },
		400,
    }, 
	
	["울다만"]={
        "울다만: 티르의 유산",
        {						
			{"지능","지팡이",193803,"가치"},
			{"민첩","장창",193808,"유특"},
			{"민첩","한손둔기",193797,"유특"},
			{"민첩","단검",193814,"유가"},
			{"민첩","총",193796,"가특"},
			{"힘/지능","방패",193820,"치특"},
					
			{"힘","장신구", 193805,"딜러/탱커","","공명기"},
			{"힘/민첩","장신구", 193815,"딜러/탱커","","뿔피리"},	
			{"지능","장신구", 193791,"힐러/딜러","","갈퀴발톱"},			
        },
		403,
    }, 
	
	["별궁"]={
        "별의 궁정",
        {		
			{"민첩","지팡이",201995,"가특"},		
			{"힘","한손도검",201996,"특치"},
			{"민첩","석궁",201994,"특유"},
			{"힘/민첩","장신구", 137486,"딜러","근접","숫돌",519378},
			{"지능","장신구", 137484,"힐러","","밤의 영약"},	
			{"지능","장신구", 137485,"딜러","","계약서"},			
        },
		210,		
    }, 
	
	["용맹"]={
        "용맹의 전당",
        {		
			{"민첩","단검",201998,"치특"},	
			{"지능","단검",201997,"치가"},	
			{"힘/지능","방패",201999,"특치"},						
			{"힘/민첩","장신구", 133647,"탱커","","광휘의선물"},
			{"힘/민첩","장신구", 136975,"딜러","근접","무리의굶주림"},	
			{"지능/민첩","장신구", 133641,"딜러","원거리","스코발드"},	
			{"힘/민첩/지능","장신구", 133642,"힐러/딜러/탱커","","뿔피리"},	
			{"지능","장신구", 133646,"힐러","","축성의티끌"},			
        },
		200,
    },
	
	["옥룡사"]={
        "옥룡사",
        {	
			{"지능","지팡이",144093,"가치"},
			{"힘","한손도끼",144086,"치가"},
			{"지능","한손둔기",144216,"특가"},
			{"민첩","총",144090,"치가"},

			{"민첩","장신구", 144113,"딜러/탱커","","책장"},			
        },
		2,
    },
	
	["어둠달"]={
        "어둠달 지하묘지",
        {				
			{"힘","장창",110036,"치특"},
			{"지능","지팡이",110039,"가치"},
			{"민첩","단검",110038,"가특"},
			{"민첩","활",110037,"치유"},
			{"지능","보조장비",110035,"치가"},

			{"지능","장신구", 110007,"힐러","","음영석",133266},
			{"힘","장신구", 110012,"딜러","","발가락"},	
        },
		165,
    },
	
	["누각"]={
	    "소용돌이 누각",
        {	
			{"힘","양손도끼",157603,"가특"},
			{"지능","단검",56357,"치가"},
			{"힘","한손도끼",56364,"특치"},
			{"민첩","총",56366,"치가"},
			{"힘/민첩","장신구", 56370,"탱커","","유연사효"},				
        },
		438, --mapid
	},
	
	["자유"]={
	    "자유지대",
        {	
			{"힘","양손도검",159634,"가유"},
			{"힘","한손둔기",159633,"유치"},
			{"민첩","단검",159632,"유특"},
			{"민첩","한손도검",159635,"가치"},
			{"민첩","총",159130,"유치"},
			{"힘/민첩","장신구", 155881,"딜러/탱커","","납 주사위",237285},		
        },
		245, --mapid
	},
		
	["썩굴"]={
	    "썩은굴",
        {	
			{"민첩","장창",159655,"특가"},
			{"힘","양손도끼",159654,"특유"},
			{"민첩","장착무기",159653,"착효"},
			{"지능","한손둔기",159652,"가치"},
			{"민첩","단검",159134,"특치"},
			{"힘/지능","방패",159665,"치특"},
			
			{"힘/민첩","장신구", 159626,"탱커","","포자씨앗"},		
			{"지능","장신구", 159624,"딜러","","부두인형"},	
			{"힘","장신구", 159625,"딜러/탱커","","약병"},	
        },
		251, --mapid
	},
	
	["둥지"]={
	    "넬타리온의 둥지",
        {
			{"지능/민첩","장신구", 137349,"딜러","원거리","나락 혀"},
			{"힘/민첩","장신구", 137357,"딜러","근접","다르그룰"},	
			{"힘/민첩","장신구", 137338,"탱커","","로크모라"},
			{"힘/민첩","장신구", 137344,"탱커","","바위구체자"},
        },
		206, --mapid
	},
}

MDR.dungeonNames={}
MDR.dungeonNamesFull={}
for k,v in pairs(dungeonTable) do
    tinsert(MDR.dungeonNames,k)
    tinsert(MDR.dungeonNamesFull,v[1])
end

local specTable={
    ["기사"]={{"힘","지능"},{"한손도끼","양손도끼","한손둔기","양손둔기","장창","한손도검","양손도검","방패"},{"근접"}},
    ["보호"]={{"힘"},{"한손도끼","한손둔기","한손도검","방패"},{"근접"}},
    ["징벌"]={{"힘"},{"양손도끼","양손둔기","장창","양손도검"},{"근접"}},
    ["신기"]={{"지능"},{"한손도끼","한손둔기","한손도검","방패"},{"근접"}},
    
    ["드루"]={{"민첩","지능"},{"단검","장착무기","한손둔기","양손둔기","장창","지팡이","보조장비"},{"모두"}},
    ["조화"]={{"지능"},{"단검","장착무기","한손둔기","양손둔기","장창","지팡이","보조장비"},{"원거리"}},
    ["야성"]={{"민첩"},{"양손둔기","장창","지팡이"},{"근접"}},
    ["수호"]={{"민첩"},{"양손둔기","장창","지팡이"},{"근접"}},
    ["회복"]={{"지능"},{"단검","장착무기","한손둔기","양손둔기","장창","지팡이","보조장비"},{"원거리"}},
    
    ["수도"]={{"민첩","지능"},{"장창","지팡이","한손도끼","장착무기","한손둔기","한손도검","보조장비"},{"모두"}},
    ["양조"]={{"민첩"},{"한손도끼","장착무기","한손둔기","한손도검","장창","지팡이"},{"근접"}},
    ["운무"]={{"지능"},{"장창","지팡이","한손도끼","장착무기","한손둔기","한손도검","보조장비"},{"원거리"}},
    ["풍운"]={{"민첩"},{"한손도끼","장착무기","한손둔기","한손도검","장창","지팡이"},{"근접"}},
    
    ["술사"]={{"민첩","지능"},{"한손도끼","양손도끼","단검","장착","한손둔기","양손둔기","지팡이","보조장비","방패"},{"모두"}},
    ["고양"]={{"민첩"},{"한손도끼","한손둔기"},{"근접"}},
    ["복원"]={{"지능"},{"한손도끼","양손도끼","단검","장착","한손둔기","양손둔기","지팡이","보조장비","방패"},{"원거리"}},
    ["정기"]={{"지능"},{"한손도끼","양손도끼","단검","장착","한손둔기","양손둔기","지팡이","보조장비","방패"},{"원거리"}},
    
    ["사제"]={{"지능"},{"단검","지팡이","한손둔기","마법봉","보조장비"},{"원거리"}},    
    ["암흑"]={{"지능"},{"단검","지팡이","한손둔기","마법봉","보조장비"},{"원거리"}},
    ["수양"]={{"지능"},{"단검","지팡이","한손둔기","마법봉","보조장비"},{"원거리"}},
    ["신성"]={{"지능"},{"단검","지팡이","한손둔기","마법봉","보조장비"},{"원거리"}},
    
    ["법사"]={{"지능"},{"단검","지팡이","한손둔기","마법봉","보조장비"},{"원거리"}},    
    ["화염"]={{"지능"},{"단검","지팡이","한손도검","마법봉","보조장비"},{"원거리"}},    
    ["냉법"]={{"지능"},{"단검","지팡이","한손도검","마법봉","보조장비"},{"원거리"}},    
    ["비전"]={{"지능"},{"단검","지팡이","한손도검","마법봉","보조장비"},{"원거리"}},
    
    ["흑마"]={{"지능"},{"단검","지팡이","한손둔기","마법봉","보조장비"},{"원거리"}},    
    ["파괴"]={{"지능"},{"단검","지팡이","한손도검","마법봉","보조장비"},{"원거리"}},
    ["고통"]={{"지능"},{"단검","지팡이","한손도검","마법봉","보조장비"},{"원거리"}},    
    ["악마"]={{"지능"},{"단검","지팡이","한손도검","마법봉","보조장비"},{"원거리"}},   
    
    ["도적"]={{"민첩"},{"단검","장착무기","한손도끼","한손둔기","한손도검"},{"근접"}},
    ["무법"]={{"민첩"},{"장착무기","한손도끼","한손둔기","한손도검"},{"근접"}},
    ["잠행"]={{"민첩"},{"단검"},{"근접"}},
    ["암살"]={{"민첩"},{"단검"},{"근접"}},
    
    ["전사"]={{"힘"},{"한손도끼","양손도끼","단검","장착무기","한손둔기","양손둔기","장창","지팡이","한손도검","양손도검","방패"},{"근접"}},
    ["방어"]={{"힘"},{"단검","한손도끼","한손둔기","한손도검","방패"},{"근접"}},
    ["무기"]={{"힘"},{"양손도끼","양손둔기","장창","지팡이","양손도검"},{"근접"}},
    ["분노"]={{"힘"},{"한손도끼","양손도끼","단검","장착무기","한손둔기","양손둔기","장창","지팡이","한손도검","양손도검"},{"근접"}},
    
    ["죽기"]={{"힘"},{"한손도끼","양손도끼","한손둔기","양손둔기","장창","한손도검","양손도검"},{"근접"}},
    ["냉기"]={{"힘"},{"한손도끼","한손둔기","한손도검","양손도끼","양손둔기","장창","양손도검"},{"근접"}},
    ["부정"]={{"힘"},{"양손도끼","양손둔기","장창","양손도검"},{"근접"}},
    ["혈기"]={{"힘"},{"양손도끼","양손둔기","장창","양손도검"},{"근접"}},
    
    ["악사"]={{"민첩"},{"전투검","장착무기","한손도끼","한손도검"},{"근접"}},
    ["파멸"]={{"민첩"},{"전투검","장착무기","한손도끼","한손도검"},{"근접"}},
    ["복수"]={{"민첩"},{"전투검","장착무기","한손도끼","한손도검"},{"근접"}},
	
	["기원"]={{"지능"},{"단검","장착무기","한손도끼","한손도검","한손둔기","양손도끼","양손도검","양손둔기","보조장비","지팡이"},{"원거리"}},
	["황폐"]={{"지능"},{"단검","장착무기","한손도끼","한손도검","한손둔기","양손도끼","양손도검","양손둔기","보조장비","지팡이"},{"원거리"}},
	["보존"]={{"지능"},{"단검","장착무기","한손도끼","한손도검","한손둔기","양손도끼","양손도검","양손둔기","보조장비","지팡이"},{"원거리"}},
    
    ["냥꾼"]={{"민첩"},{"활","석궁","총","장창","지팡이","양손도검","양손도끼"},{"모두"}},
    ["야수"]={{"민첩"},{"활","석궁","총"},{"원거리"}},
    ["사격"]={{"민첩"},{"활","석궁","총"},{"원거리"}},
    ["생존"]={{"민첩"},{"장창","지팡이","양손도검","양손도끼"},{"근접"}},
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
        if name==k or name==v[3] then
            return v[1]
        end        
    end
    return name
end

function getShortDungeonName(dungeon)
    if dungeon==nil then return end
    
    for k,v in pairs(dungeonTable) do
        if dungeon==v[1] or dungeon==v[3] then
            return k
        end        
    end
    local string
    if strfind(dungeon," ") then
        local t=MDRsplit(dungeon," ")
        local c1=strsub(t[1],1,3)
        local c2=strsub(t[2],1,3)
        string=c1..c2
    elseif strlen(dungeon)<=9 then
        string=dungeon
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

function getSpecPositionTable(spec)
    for k,v in pairs(specTable) do
        if spec==k then
            return v[3]
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

function getBonusIDs(dungeon,level)
    local bonus
    if dungeon then
        if dungeon=="작업" or dungeon=="고철"  then
            bonus=bonus2
        else 
            bonus=bonus9             
        end         
    end
    return bonus
end

function checkDungeonHasItem(VALUES)
    local dungeon,spec,stat,category,link,item,sameDungeon,role,filter,itemID,position
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
        level=VALUES["level"]
		itemID=VALUES["itemID"]
		position=VALUES["position"]
    end  

    local bonus=getBonusIDs(dungeon,level)    
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
	if not position then
		if spec then			     
			position=getSpecPositionTable(spec)[1]
		elseif role=="탱커" or stat=="힘" then
			position="근접"
		elseif role=="힐러" or stat=="지능" then
			position="원거리"
		else
			position=""
		end
		--print("position: ",position)
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
                        local name,itemHeader="","{iH}"
						--local weaponType=gsub(dropTable[j][2],"한손","")
						local weaponType=dropTable[j][2]
						if dropTable[j][5] then   -- 이름이 지정된 템이면
                            name="\124T"..dropTable[j][6]..":0:::-5\124t"..dropTable[j][5]
							itemHeader="{iHL}"
						else
							name=weaponType.." "..dropTable[j][4]
						end
                        thisDungeonHas[itemNum]=itemHeader..dropTable[j][3]..MDRGetItemCode(dropTable[j][3])..name.."{iE}"  
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
                        local name,itemHeader="","{iH}"
						--local weaponType=gsub(dropTable[j][2],"한손","")
						local weaponType=dropTable[j][2]
						if dropTable[j][5] then   -- 이름이 지정된 템이면
                            name="\124T"..dropTable[j][6]..":0:::-5\124t"..dropTable[j][5]
							itemHeader="{iHL}"
						else
							name=weaponType.." "..dropTable[j][4]
						end
                        thisDungeonHas[itemNum]=itemHeader..dropTable[j][3]..MDRGetItemCode(dropTable[j][3])..name.."{iE}"    
                end            
                thisDungeonHasItem=1
                itemNum=itemNum+1            
            end        
        end 
		
		--특정 아이템을 지정한 경우
    elseif filter=="itemID" then
		
        for j=1,#dropTable do
            if dropTable[j][3]==itemID then     
                if sameDungeon then
                    thisDungeonHas[itemNum]=sameDungeon
                else  
                    local name,itemHeader					
					if dropTable[j][7] then
						itemHeader="{iHL}"
						name="\124T"..dropTable[j][7]..":0:::-5\124t "..dropTable[j][6]
					else
						itemHeader="{iH}"
						name=dropTable[j][6]
					end			
                    thisDungeonHas[itemNum]=itemHeader..dropTable[j][3]..MDRGetItemCode(dropTable[j][3])..name.."{iE}"                                    
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
                        local name,itemHeader="","{iH}"
						--local weaponType=gsub(dropTable[j][2],"한손","")
						local weaponType=dropTable[j][2]
						if dropTable[j][5] then   -- 이름이 지정된 템이면
							name="\124T"..dropTable[j][6]..":0:::-5\124t "..dropTable[j][5]
							itemHeader="{iHL}"
						else
							name=weaponType.." "..dropTable[j][4]
						end
                        thisDungeonHas[itemNum]=itemHeader..dropTable[j][3]..MDRGetItemCode(dropTable[j][3])..name.."{iE}"                     
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
                (strfind(dropTable[j][1],stat) and strfind(dropTable[j][4],role) 
				and ((dropTable[j][5]~="" and (strfind(dropTable[j][5],position) or position=="모두")) or dropTable[j][5]=="" or not dropTable[j][5])
				) 
                --or --스탯과 역할이 일치
                --(strfind(dropTable[j][1],stat) and role=="탱커" and dropTable[j][4]=="탱커")  --스탯이 일치하는 탱커          
            ) then            
				
                if sameDungeon then
                    thisDungeonHas[itemNum]=sameDungeon
                else  
                    local name,itemHeader					
					if dropTable[j][7] then
						itemHeader="{iHL}"
						name="\124T"..dropTable[j][7]..":0:::-5\124t "..dropTable[j][6]
					else
						itemHeader="{iH}"
						name=dropTable[j][6]
					end
					MDRGetItemCode(itemID)					
                    thisDungeonHas[itemNum]=itemHeader..dropTable[j][3]..MDRGetItemCode(dropTable[j][3])..name.."{iE}"                                  
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
        return itemList,itemNum
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
        onlyOnline=VALUES["onlyOnline"] 
		
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
	
    local itemID
	
    local role=keyword["role"]     
    
    if comb=="Trinket"then
        if keyword["stat"] and not keyword["role"] then
            role="딜러"            
        end
		if keyword["spec"] and not keyword["role"] then
			local S=keyword["spec"]
			if S=="회복" or S=="수양" or S=="복원" or S=="신성" or S=="운무" or S=="신기" then
				role="힐러"
			elseif S=="수호" or S=="양조" or S=="보호" or S=="방어" or S=="혈기" or S=="복수" then
				role="탱커"
			else
				role="딜러"
			end
		end
		if keyword["spec"] and not keyword["stat"] then
			stat=keyword2["spec"]			
		end
        if keyword["role"]=="힐러" then
            stat="지능"
        elseif keyword["role"]=="탱커" and not keyword["stat"] then
            stat=keyword2["role"]
        end        
        --print("role:"..role)
        --print("stat:"..stat)         
    end  

	if comb=="itemID" then
		itemID=keyword2["itemID"]
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
	
	if onlyOnline==1 then --현재접속중인 캐릭터만 필터링
        chars=filterCharsByFilter(chars,"name",nil,nil)
	end
    
    if keyword["dungeon"] then --던전으로 필터링
        chars=filterCharsByFilter(chars,"dungeon",keyword["dungeon"],nil)
        --link=1
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
        stat="힘/지능"        
        --only 지능
    elseif keyword["specificitem"]=="보조장비"or  keyword["specificitem"]=="마법봉"then        
        stat="지능"        
        --only 민첩
    elseif keyword["specificitem"]=="총"or  keyword["specificitem"]=="석궁"or  keyword["specificitem"]=="활" or keyword["specificitem"]=="전투검" then        
        stat="민첩"        
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
	elseif comb=="itemID" then  
		filter="itemID"
    end      
    --print(filter)
    --VALUES={}
    VALUES["spec"]=spec
    VALUES["stat"]=stat
    VALUES["category"]=category
    VALUES["link"]=link
    VALUES["role"]=role    
    VALUES["item"]=item     
    VALUES["filter"]=filter
	VALUES["itemID"]=itemID
    
    --검색타입에 대한 알림
    if who==meGame and link~=1 then         
        local yourClass=keyword["spec"] or keyword["class"]
        if not yourClass then yourClass=krClass end
        --local class=getCallTypeTable(keyword["spec"])[4] or getCallTypeTable(keyword["class"])[2] 
        
        if (not tips[1] or tips[1]<warns) and link~=1 and comb~="Trinket" and comb~="itemID" then
            
            local message,weapon,spec,class,Class,eul,ro,LC,space,kwa
            
            class=MDRcolor(keyword["class"] or keyword3["spec"] or stat,5)
            
            if class=="마법사" or class=="사제" or class=="기원사" or class=="흑마법사" or class=="악마 사냥꾼" then
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
                message="|cFF00ff00▶|r"..spec..Class..ro.." 사용 가능한 "..Weapon..eul.." 검색합니다."
            else
                message="|cFF00ff00▶|r"..MDRcolor("도적",0,stat)..space..Weapon..eul.." 모두 검색합니다."
            end
            
            print(message)
            tips[1]=(tips[1] or 0)+1
        end                  
    end   
    
    local dun={}    
	
    if chars~=nil then 
        for i=1,#chars do    
            local p=chars[i]["fullName"]
            local c=MDRconfig.Char[p]
            local mapName=c.MythicKey.name
            if dun[mapName] then
                VALUES["sameDungeon"]=dun[mapName]
            else                 
                VALUES["sameDungeon"]=nil
            end
            
            VALUES["dungeon"]=getShortDungeonName(mapName)
            local itemList,itemCount=checkDungeonHasItem(VALUES)                   
            
            if itemList then
                chars[i]["extraLink"]=itemList
				chars[i]["itemCount"]=itemCount				
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
end

function MDRGetItemCode(itemID)
	if not itemID then 
		bonus="{iB}"
	elseif itemID<120000 then --드레노어
		bonus="{iBD}"
    elseif itemID<160000 then --군단
		bonus="{iBL}"
	elseif itemID<175000 then --격아
		bonus="{iBB}"
	elseif itemID<193000 then --어둠땅
		bonus="{iBS}"
	else					  --용군단
		bonus="{iBDF}"
    end
	bonus="{iB}"
	return bonus
end
