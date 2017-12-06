/datum/disease/vampire_plague
	name = "Porphyric Hemophilia"
	max_stages = 2
	stage_prob = 15
	spread_text = "On contact"
	spread_flags = VIRUS_SPREAD_NON_CONTAGIOUS
	infectivity = 100
	cure_text = "Holy Water"
	cures = list("holywater")
	viable_mobtypes = list(/mob/living/carbon/human)
	cure_chance = 15//higher chance to cure, since two reagents are required
	desc = "This unholy disease rapidly spreads through the blood and shuts down major organs, leading to quick death."
	severity = VIRUS_SEVERITY_HARMFUL

/datum/disease/vampire_plague/stage_act()
	..()

	switch(stage)
		if(1)
			if(prob(2))
				affected_mob.emote("gasp")
			if(prob(2))
				to_chat(affected_mob, "<span class='danger'>You feel your veins throbbing.</span>")
				affected_mob.Dizzy(5)
			if(prob(2))
				to_chat(affected_mob, "<span class='danger'>You feel like something is terribly wrong with you.</span>")
			if(prob(5))
				affected_mob.adjustToxLoss(5)
				affected_mob.adjustBruteLoss(5)
				affected_mob.updatehealth()
		if(2)
			if(prob(2))
				affected_mob.vomit(20)
			if(prob(2))
				affected_mob.emote("scream")
				to_chat(affected_mob, "<span class='danger'>You scream in agony.</span>")
			if(prob(2))
				to_chat(affected_mob, "<span class='userdanger'>[pick("You feel your heart slowing...", "You relax and slow your heartbeat.")]</span>")
				affected_mob.adjustStaminaLoss(70)
			if(prob(10))
				affected_mob.adjustToxLoss(15)
				affected_mob.adjustBruteLoss(15)
				affected_mob.updatehealth()
	return