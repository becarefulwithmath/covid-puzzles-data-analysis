// ideas for the new wave:
// allow loss seeking: 27% is willing to take a +5000 -5000 50/50 gamble
// explicite measure of rational vs. experiential decision making style?
// more questions about behavior: Czy w którymś momencie pandemii zgromadziłeś znaczne zapasy żywności lub innych produktów na wypadek ich niedostępności w sklepach?
// itp. 


ssc install tabstatmat
clear all 
capture cd "G:\Shared drives\Koronawirus\studies\5 common data cleaning (Ariadna data)"
capture cd "G:\Dyski współdzielone\Koronawirus\studies\5 common data cleaning (Ariadna data)"
use data_stata_format.dta, clear
do common_data_cleaning.do

capture cd "G:\Shared drives\Koronawirus\studies\4 puzzles (actual full study)\data analysis"
capture cd "G:\Dyski współdzielone\Koronawirus\studies\4 puzzles (actual full study)\data analysis"


// comments
global uwagi "p1_uwagi p2_uwagi p5_uwagi p6_uwagi p9_uwagi p10_uwagi p13_uwagi p14_uwagi"
foreach uw in $uwagi {
display "`uw'"
tab `uw' // najwięcej do p5--asian_disease
}

global uw_categories "p1_uw_ p2_uw_c p5_uw_ p6_uw_ p9_uw_ p10_uw_ p13_uw_ p14_uw_"
foreach uw in $uw_categories {
display "`uw'"
replace `uw' = "negativity" if `uw'=="rea"
replace `uw' = "other" if `uw'=="oth"
replace `uw' = "confusion" if `uw'=="con"
replace `uw' = "indifference" if `uw'=="ind"
replace `uw' = "negativity" if `uw'=="rea"
replace `uw' = "framing" if `uw'=="fra"
replace `uw' = "number provided" if `uw'=="num"
replace `uw' = "no comment" if `uw'=="non"
tab treatment `uw', chi2 row // najwięcej do p5--asian_disease
}

tabulate treatment p9_uw_c, chi2

egen number_comments = rownonmiss(*uwag*) , strok 
bysort treat: sum number_comments



//to add later into puzzles regression
rename kolejnosc_pytan order_puzzles
replace order_puzzles=subinstr(order_puzzles,"p","",.)
split order_puzzles, p("-")
global order_puzzles "order_puzzles1 order_puzzles2 order_puzzles3 order_puzzles4 order_puzzles5 order_puzzles6 order_puzzles7 order_puzzles8"

foreach x in $order_puzzles {
destring `x', replace
}

global wealth "wealth_low wealth_high"
global demogr "male age age2 i.city_population secondary_edu higher_edu $wealth health_poor health_good had_covid  covid_friends religious i.religious_freq status_unemployed status_pension status_student"
global basic_demogr "male age age2 i.city_population secondary_edu higher_edu $wealth health_poor health_good religious status_unemployed status_pension status_student"
global demogr_int "male age higher_edu"
global treatments "t_cold t_unempl"
global emotions "e_happiness e_fear e_anger e_disgust e_sadness e_surprise"
global risk "risk_overall risk_work risk_health"
global worry "worry_covid worry_cold worry_unempl"
global control "control_covid control_cold control_unempl"
global informed "informed_covid informed_cold informed_unempl"
global conspiracy "conspiracy_general_info conspiracy_stats conspiracy_excuse" //we also have conspiracy_score
global voting "i.voting"
global health_advice "mask_wearing distancing"
global covid_impact "subj_est_cases_ln subj_est_death_l"
global order_puzzles "order_puzzles1 order_puzzles2 order_puzzles3 order_puzzles4 order_puzzles5 order_puzzles6 order_puzzles7 order_puzzles8"

gen c_had_covid=t_covid*had_covid
gen c_worry_covid=t_covid*worry_covid
gen c_control_covid=t_covid*control_covid
gen c_poor_health=t_covid*health_poor
global covid_int "worry_covid control_covid c_worry_covid c_control_covid health_poor c_poor_health"



//PUZZLES DATA CLEANING
// [P1] Przypuśćmy, że 15% obywateli Polski jest zakażonych koronawirusem, a 85% jest zdrowych. Test mający wykryć koronawirusa na wczesnym etapie ma skuteczność 80%, tzn., gdy zbada się osobę faktycznie zakażoną, to jest 80% szans na to, że test wykaże, że jest zakażona, a 20% że zdrowa. Gdy zbada się osobę faktycznie zdrową, jest 80% szans, że test wykaże, że jest zdrowa, a 20% że zakażona.
//normative answer: ...
gen base_rate_negl_normative=p1>=19& p1<=51 //Raman says: let's have +-10% from normative answer. MK has doubts, see e=mail March 4
tab base_rate_negl_normative
tab p1_uwagi

/* p2 is about 1%=10 000 confirmed cases, p13 is about 1%=10 confirmed cases
p2 Załóżmy, że przebadano losową próbę Polaków i okazało się, że wśród badanych było 10 000 osób aktualnie zakażonych koronawirusem. Stanowi to 1% badanej próby.
Czy ta informacja sprawiłaby, że był(a)byś mniej czy bardziej zaniepokojony pandemią niż jesteś obecnie? 
[rotacja]
bardziej zaniepokojona(-y)
mniej zaniepokojona(-y)
*/
//normative answer: current rate of infection is 3-4% so 1% should make us less worried
capture drop beliefs_update_normative
gen beliefs_update_normative=p2==p13
/*
Władze pewnego miasta przygotowują się do konfrontacji z nową falą pandemii. Można się spodziewać, że zabije ona ok. 600 mieszkańców. Rozważane są dwa programy prewencyjne. Epidemiolodzy szacują, że ich skutki dla tych statystycznych 600 osób będą następujące:
Program A: 200 osób zostanie uratowanych
Program B: z prawdopodobieństwem 1/3 zostanie uratowanych 600 osób, z prawdopodobieństwem 2/3 nikt nie zostanie uratowany
Który program powinno się wdrożyć? Zaznacz
[rotacja]
Program A
Program B
-----------------------------------
[P5 - opcja 2] Władze pewnego miasta przygotowują się do konfrontacji z nową falą pandemii. Można się spodziewać, że zabije ona ok. 600 mieszkańców. Rozważane są dwa programy prewencyjne. Epidemiolodzy szacują, że ich skutki dla tych statystycznych 600 osób będą następujące:
Program A: 400 osób umrze
Program B: z prawdopodobieństwem 1/3 nikt nie umrze, z prawdopodobieństwem 2/3 umrą wszyscy
Który program powinno się wdrożyć? Zaznacz
[rotacja]
Program A
Program B
*/
//normative answer: no normavite answer for every participant but only aggregated preference could be observed
rename  p5_losowanie asian_disease_option
gen asian_disease_pos_framing=asian_disease_option==1
gen asian_disease_neg_framing=asian_disease_option==2
gen asian_disease_sure_option=p5==1
gen asian_disease_unsure_option=p5==2
tab asian_disease_pos_framing asian_disease_sure_option

//Śmiertelność wśród pacjentów z koronawirusem zależy od ich wieku. Załóżmy, że oszacowane prawdopodobieństwo śmierci w ciągu miesiąca od zakażenia dla mężczyzn w poszczególnych grupach wiekowych kształtuje się następująco:
//Jan ma 61 lat. Jak myślisz, jakie jest prawdopodobieństwo, że Jan umrze w ciągu miesiąca od zakażenia? 
//normative answer: ...
gen death_prob_normative=p6<1.9&p6>0.5
tab p6_uwagi

//[P9] W skali kraju można się spodziewać jeszcze około 20 000 śmiertelnych ofiar koronawirusa. Zaproponowano zmianę procedury postępowania z chorymi w szpitalach zakaźnych. Zmiana może okazać się dobra lub zła. 
//Spodziewane skutki i ich prawdopodobieństwa przedstawiono w tabeli. Dla każdego z wierszy wskaż, czy w danej sytuacji uważasz, że taka zmiana powinna zostać wprowadzona czy też nie. 
//normative answer: no normatively correct answer, except of the fact that person should either stay with yes/no for every option or to switch yes/no only one time 
// MK: how is this consistent if you switch from no to yes? it makes no sense
// RK: no idea what this comment means, rather switch from yes to no is strange, pls propose directly your change of the code
//yes==1, no==2
//options: from 5000/5000 to 5000/10000
capture drop p9_consistent_answer
gen p9_consistent_answer=0
replace p9_consistent_answer=1 if p9_h1_r1==1 & p9_h1_r2==1 & p9_h1_r3==1 & p9_h1_r4==1 & p9_h1_r5==1 & p9_h1_r6==1
replace p9_consistent_answer=1 if p9_h1_r1==1 & p9_h1_r2==1 & p9_h1_r3==1 & p9_h1_r4==1 & p9_h1_r5==1 & p9_h1_r6==2
replace p9_consistent_answer=1 if p9_h1_r1==1 & p9_h1_r2==1 & p9_h1_r3==1 & p9_h1_r4==1 & p9_h1_r5==2 & p9_h1_r6==2
replace p9_consistent_answer=1 if p9_h1_r1==1 & p9_h1_r2==1 & p9_h1_r3==1 & p9_h1_r4==2 & p9_h1_r5==2 & p9_h1_r6==2
replace p9_consistent_answer=1 if p9_h1_r1==1 & p9_h1_r2==1 & p9_h1_r3==2 & p9_h1_r4==2 & p9_h1_r5==2 & p9_h1_r6==2
replace p9_consistent_answer=1 if p9_h1_r1==1 & p9_h1_r2==2 & p9_h1_r3==2 & p9_h1_r4==2 & p9_h1_r5==2 & p9_h1_r6==2
replace p9_consistent_answer=1 if p9_h1_r1==2 & p9_h1_r2==2 & p9_h1_r3==2 & p9_h1_r4==2 & p9_h1_r5==2 & p9_h1_r6==2
replace p9_consistent_answer=1 if p9_h1_r1==2 & p9_h1_r2==2 & p9_h1_r3==2 & p9_h1_r4==2 & p9_h1_r5==2 & p9_h1_r6==1 
replace p9_consistent_answer=1 if p9_h1_r1==2 & p9_h1_r2==2 & p9_h1_r3==2 & p9_h1_r4==2 & p9_h1_r5==1 & p9_h1_r6==1
replace p9_consistent_answer=1 if p9_h1_r1==2 & p9_h1_r2==2 & p9_h1_r3==2 & p9_h1_r4==1 & p9_h1_r5==1 & p9_h1_r6==1
replace p9_consistent_answer=1 if p9_h1_r1==2 & p9_h1_r2==2 & p9_h1_r3==1 & p9_h1_r4==1 & p9_h1_r5==1 & p9_h1_r6==1
replace p9_consistent_answer=1 if p9_h1_r1==2 & p9_h1_r2==1 & p9_h1_r3==1 & p9_h1_r4==1 & p9_h1_r5==1 & p9_h1_r6==1
tab p9_consistent_answer
//gen p9_do_nothing=p9_h1_r1==2 & p9_h1_r2==2 & p9_h1_r3==2 & p9_h1_r4==2 & p9_h1_r5==2 & p9_h1_r6==2
//tab p9_do_nothing

//normative if only "all no" OR "switch from no to yes" OR "all yes"
gen p9_normative=0
replace p9_normative=1 if p9_h1_r1==2 & p9_h1_r2==2 & p9_h1_r3==2 & p9_h1_r4==2 & p9_h1_r5==2 & p9_h1_r6==2
replace p9_normative=1 if p9_h1_r1==1 & p9_consistent_answer==1
replace p9_normative=1 if p9_h1_r1==1 & p9_h1_r2==1 & p9_h1_r3==1 & p9_h1_r4==1 & p9_h1_r5==1 & p9_h1_r6==1
tab p9_normative
tab p9_normative p9_consistent_answer

egen loss_aversion=rsum(p9_h1_r*)
replace loss_aversion=((loss_aversion-6)*1000+4500)/5000 

gen loss_averse_normative= loss_aversion<1.2

//[P11] Załóżmy, że jesteś teraz zdrowy/a- nie masz koronawirusa. Spotykasz 100 osób. Przy każdym spotkaniu, które rozpoczynasz będąc zdrowy/a, masz 99,5% szans na to, że pozostaniesz zdrowy/a (nie zostaniesz zakażony/a koronawirusem). 
//Jakie jest prawdopodobieństwo, że pozostaniesz zdrowy/a po ostatnim ze 100 spotkań?
//normative answer: ...
capture drop compound_prob_norm
gen compound_prob_normative=p10>=40& p10<=80

tab compound_prob_normative
capture drop compound_nonsense
gen compound_nonsense = p10==99.5
sum compound_nonse
gen compound_non_nonsense=1-compound_nonsense
tab p10_uwagi

//[P15] W Braniewie odsetek zakażonych koronawirusem codziennie się podwaja. Po 12 dniach zakażeni są wszyscy. 
//Po ilu dniach zakażona była połowa mieszkańców?
//normative answer: 11
gen lilypad_normative=p14==11
tab lilypad_normative
tab p14_uwagi

//generating performance
// MK: what is that? why not egen performance=rsum($normative)? also, wouldn't be more informative to look at mean, not sum?
// RK: because I donk know all STATA commands that you know :) these comments are not productive, lets just change code
// MK: well, this one works, so no problem. Just wanted to make sure that I understand what's happenning here?
sum *_normative
global normative "base_rate_negl_normative death_prob_normative beliefs_update_normative compound_prob_normative lilypad_normative"
gen performance = 0
gen counter = 0
foreach x in $normative {
 replace performance=performance+`x' 
 replace counter = counter +1
}
replace performance = performance/counter
sum performance 

foreach x in $normative {
display "`x'"
format `x' %12.2fc
kwallis `x', by(treatment)
 }
 
bysort treatment: ttest asian_disease_sure_option, by(asian_disease_pos_framing)


set varabbrev on, permanently
tabstat $normative, by(treatment) statistics( mean ) format(%12.2f) nototal save
tabstat $normative, by(treatment) statistics( mean sd ) format(%12.2f) 

//tabstatmat temp
// RK: above part returns error: no tabstat results in memory
//matrix temp = temp'
//mat li temp, noheader format(%12.2f)



//fear determinants
quietly ologit e_fear $treatments
est store m_0
quietly ologit e_fear $treatments $demogr
est store m_1
quietly ologit e_fear $treatments $demogr $health_advice  $risk $worry $voting $control $informed conspiracy_score $covid_impact
est store m_2
est table m_0 m_1 m_2, b(%12.3f) var(20) star(.01 .05 .10) stats(N)

//other emo determinants
foreach x in $emotions {
display "`x'"
ologit `x' $treatments 
est store `x'
}

est table $emotions, b(%12.3f) var(20) star(.01 .05 .10) stats(N)

tabstat $emotions, by(treatment) statistics( mean sd) format(%12.2f)

tabstat $emotions, by(treatment) statistics( mean) save nototal

tabstatmat temp
matrix temp = temp'
mat li temp, noheader format(%12.2f)

foreach x in $emotions {
display "`x'"
format `x' %12.2fc
kwallis `x', by(treatment)
 }

//performance determinants (with order effects)
ologit performance $treatments
est store m_0
ologit performance $treatments $basic_demogr
est store m_1
ologit performance $treatments $basic_demogr $emotions 
est store m_2


est table m_0 m_1 m_2 , b(%12.3f) var(20) star(.01 .05 .10) stats(N)
//no order effect of vars "order_puzzles_..."
//test order_puzzles1/order_puzzles8 // jointly significant
//RK: above causes error:order_puzzles1 not found
//performance determinants (no order effects)

// determinants of correct answers to specific puzzles
ologit compound_prob_normative $demogr
foreach x in $normative {
display "`x'"
ologit `x' $treatments $demogr
}

//for presentation
gen vaccination_y=v_decision==3|v_decision==4
global demogr_for_summary "male age edu $wealth health_poor health_good religious control_covid control_cold control_unempl informed_covid informed_cold informed_unempl mask_wearing distancing conspiracy_general_info conspiracy_stats conspiracy_excuse vaccination_y"

asdoc sum $demogr_for_summary $emotions $worry performance, replace
