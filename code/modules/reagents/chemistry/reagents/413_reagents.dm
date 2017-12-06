// IF YOU'RE GOING TO ADD NEW REAGENTS, MAKE SURE THEY GO IN HERE!
// This will keep future merges with mainline tg from breaking horribly and keep you from having to recode your shit

//WACKY GUSHER FLAVORS BELOW
/datum/reagent/toxin/gusherblack
	name = "Bodacious Black Liquid Sorrow Gusher Juice"
	id = "gusherblack"
	description = "C O N S U M E"
	reagent_state = LIQUID
	color = "#000000" // rgb: BLAPCK
	toxpwr = 3
	metabolization_rate = 1
	taste_description = "oily fruit"

/datum/reagent/toxin/gushersyndie
	name = "Treachous Teal Tangerine Gusher Juice"
	id = "gushersyndie"
	description = "C O N S U M E"
	reagent_state = LIQUID
	color = "#10E4C5" //rgb: 16, 228, 197
	toxpwr = 5
	metabolization_rate = 0.25
	taste_mult = 0.2
	taste_description = "death"

/datum/reagent/toxin/gushercitrus
	name = "Carnivorous Citrus Piss Gusher Juice"
	id = "gushercitrus"
	description = "C O N S U M E"
	reagent_state = LIQUID
	color = "#A8DF00" //rgb: 168, 223, 0
	toxpwr = 0
	metabolization_rate = 2 * REAGENTS_METABOLISM
	taste_description = "your own vomit"

/datum/reagent/toxin/gushercitrus/on_mob_life(mob/living/M)
	var/mob/living/carbon/human/H = M
	if(current_cycle >= 1)
		H.vomit(1)
	..()

/datum/reagent/toxin/gusherkiwi
	name = "Xtreme Kiwi Xplosion Gusher Juice"
	id = "gusherkiwi"
	description = "C O N S U M E"
	reagent_state = LIQUID
	color = "#20A300" //rgb: 32, 163, 0
	toxpwr = 4
	metabolization_rate = 1.25 * REAGENTS_METABOLISM
	taste_description = "KIWIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII"

/datum/reagent/toxin/gusherkiwi/on_mob_life(mob/living/M)
	if(current_cycle == 1)
		M.ForceContractDisease(new /datum/disease/appendicitis)
		M.visible_message("<span class='userdanger'>[M] clutches at [M.p_their()] groin and cries in pain!</span>")
		to_chat(M, "<span class='danger'>You feel like something exploded in your groin!</span>")
		. = 1
	..()

/datum/reagent/medicine/gusherphlegm
	name = "Hellacious Blue Phlegm Aneurysm Gusher Juice"
	id = "gusherphlegm"
	description = "C O N S U M E."
	reagent_state = LIQUID
	color = "#008ED2" //rgb: 000, 142, 210
	metabolization_rate = 1
	taste_description = "rotten fruit"

/datum/reagent/medicine/gusherphlegm/on_mob_life(mob/living/M)
	M.adjustBruteLoss(-3*REM, 0)
	M.adjustFireLoss(-3*REM, 0)
	M.adjustOxyLoss(-3*REM, 0)
	M.adjustToxLoss(-3*REM, 0)
	. = 1
	..()

/datum/reagent/consumable/gushertropical
	name = "Massive Tropical Brain Hemorrhage Gusher Juice"
	id = "gushertropical"
	description = "C O N S U M E"
	metabolization_rate = 1
	reagent_state = LIQUID
	nutriment_factor = 3 * REAGENTS_METABOLISM
	color = "#F3AF33" // rgb: 243, 175, 051
	taste_description = "tropical punch"

/datum/reagent/consumable/gusherdiabetic
	name = "Jammin Sour Diabetic Coma Gusher Juice"
	id = "gusherdiabetic"
	description = "C O N S U M E"
	reagent_state = LIQUID
	metabolization_rate = 1
	nutriment_factor = 3 * REAGENTS_METABOLISM
	color = "#EAEAEA" //rgb: 234, 234, 234
	taste_description = "sugar and a severe lack of insulin"

/datum/reagent/drug/gushercherry
	name = "Wild Cherry Apeshit Apocalypse Gusher Juice"
	id = "gushercherry"
	description = "C O N S U M E"
	reagent_state = LIQUID
	color = "#DB3B30" //rgb: 219, 59, 48
	overdose_threshold = 10
	metabolization_rate = 1.25 * REAGENTS_METABOLISM
	taste_description = "an unholy amount of cherry"

/datum/reagent/drug/gushercherry/on_mob_life(mob/living/M)
	M.AdjustStun(-50, 0)
	M.AdjustKnockdown(-50, 0)
	M.AdjustUnconscious(-50, 0)
	M.adjustStaminaLoss(-3, 0)
	M.status_flags |= GOTTAGOREALLYFAST
	M.Jitter(5)
	M.adjustToxLoss(3)

/datum/reagent/drug/gushercherry/overdose_process(mob/living/M)
	M.AdjustStun(100, 0)
	M.AdjustKnockdown(100, 0)
	M.adjustStaminaLoss(3, 0)
	M.adjustToxLoss(2)

/datum/reagent/drug/gusherstrawberry
	name = "Schizophrenic Strawberry Slam Gusher Juice"
	id = "gusherstrawberry"
	description = "C O N S U M E"
	reagent_state = LIQUID
	color = "#FF325B" //rgb: 255, 50, 91
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	taste_description = "fuzzy strawberries"

/datum/reagent/drug/gusherstrawberry/on_mob_life(mob/living/M)
	M.set_drugginess(25)
	if(prob(25))
		M.emote(pick("drools", "giggles"))
	if(M.hallucination < volume && prob(20))
		M.hallucination += 5
..()

//TaB
/datum/reagent/consumable/tab
	name = "TaB"
	id = "tab"
	description = "A diet soft drink, manufactured by the Coca-Cola company."
	color = "#602E00"
	taste_description = "saccharin"
	glass_name = "glass of TaB"
	glass_desc = "A glass of TaB."

//Faygo flavor(s), someone please get around to adding more I'm lazy
/datum/reagent/consumable/faygoredpop
	name = "Red Pop Faygo"
	id = "faygoredpop"
	description = "A soft drink favored by juggalos."
	color = "#EA1010"
	taste_description = "strawberry soda"
	glass_name = "glass of red pop faygo"
	glass_desc = "A glass of Red Pop Faygo, favored by juggalos across the universe."