/datum/antagonist/vampire
	name = "Vampire"
	job_rank = ROLE_VAMPIRE
	var/give_objectives = TRUE
	var/allow_rename = TRUE
	var/hud_version = "vampire"
	var/list/objectives = list() //this should be base datum antag proc and list, todo make lazy


/datum/antagonist/vampire/on_gain()
	register()
	grant_powers(owner)
	if (give_objectives)
		forge_objectives(owner)
	greet_vampire()
	finalize_vampire()
	return

/datum/antagonist/vampire/proc/register()
	SSticker.mode.vampires |= owner

/datum/antagonist/vampire/proc/unregister()
	SSticker.mode.vampires -= src


/datum/antagonist/vampire/proc/grant_powers(mob/living/carbon/vampire_mob)
	/*if(!istype(vampire_mob))
		return*/
	message_admins("granting powers")
	log_admin("granting powers")
	owner.current.make_vampire()

/mob/living/proc/make_vampire()
	message_admins("making vampire")
	log_admin("making vampire")
	if(!mind)
		return
	if(!mind.vampire)
		mind.vampire = new /datum/vampire(gender)
		mind.vampire.owner = src

	//on_mob_life(src) += list("\ref[mind.vampire]" = "OnLife")
	verbs += /client/proc/vampire_rejuvinate
	verbs += /client/proc/vampire_hypnotise
	verbs += /client/proc/vampire_glare
	verbs += /client/proc/vampire_bite
	//testing purposes REMOVE BEFORE PUSH TO MASTER
	/*for(var/handler in typesof(/client/proc))
		if(findtext("[handler]","vampire_"))
			verbs += handler*/
	for(var/i = 1; i <= 3; i++) // CHANGE TO 3 RATHER THAN 12 AFTER TESTING IS DONE
		if(!(i in mind.vampire.powers))
			mind.vampire.powers.Add(i)


	for(var/n in mind.vampire.powers)
		switch(n)
			if(VAMP_SHAPE)
				verbs += /client/proc/vampire_shapeshift
			if(VAMP_VISION)
				continue
			if(VAMP_DISEASE)
				verbs += /client/proc/vampire_disease
			if(VAMP_CLOAK)
				verbs += /client/proc/vampire_cloak
			if(VAMP_BATS)
				verbs += /client/proc/vampire_bats
			if(VAMP_SCREAM)
				verbs += /client/proc/vampire_screech
			if(VAMP_JAUNT)
				verbs += /client/proc/vampire_jaunt
			if(VAMP_BLINK)
				verbs += /client/proc/vampire_shadowstep
			if(VAMP_SLAVE)
				verbs += /client/proc/vampire_enthrall
			if(VAMP_MATURE)
				continue
			if(VAMP_SHADOW)
				verbs += /client/proc/vampire_shadowmenace
			if(VAMP_CHARISMA)
				continue
			if(VAMP_UNDYING)
				verbs += /client/proc/vampire_undeath
				verbs += /client/proc/vampire_spawncape


/mob/proc/remove_vampire_powers()
	for(var/handler in typesof(/client/proc))
		if(findtext("[handler]","vampire_"))
			verbs -= handler


/datum/antagonist/vampire/on_removal()
	unregister()
	owner.objectives -= objectives
	owner.current.remove_vampire_powers()
	owner.current.remove_vampire_vision()

	if(owner.vampire)
		qdel(owner.vampire)
		owner.vampire = null

	/*if(owner.current.hud_used)
		owner.current.hud_used.vampire_blood_display.icon_state = null
		owner.current.hud_used.vampire_blood_display.invisibility = INVISIBILITY_ABSTRACT*/

	SSticker.mode.update_vampire_icons_removed(owner)
	to_chat(owner, "<FONT color='red' size = 3><B>You grow weak and lose your powers! You are no longer a vampire and are stuck in your current form!</B></FONT>")
	. = ..()

/datum/antagonist/vampire/proc/greet_vampire()
	var/dat
	dat = "<span class='danger'>You are a Vampire!</br></span>"
	dat += {"To drink blood from somebody, use your Drink Blood skill while adjacent to them. Drink blood to gain new powers and use coffins to regenerate your body if injured.
You are weak to holy things and starlight. Don't go into space and avoid the Chaplain, the chapel, and especially Holy Water."}
	to_chat(owner, dat)
	to_chat(owner, "<B>You must complete the following tasks:</B>")
	owner.current.playsound_local(get_turf(owner.current), 'sound/effects/vampire_intro.ogg',100,0)
	owner.announce_objectives()
	return


/datum/antagonist/vampire/proc/forge_objectives()
	//Objectives are traitor objectives plus blood objectives

	var/datum/objective/blood/blood_objective = new
	blood_objective.owner = owner
	blood_objective.gen_amount_goal(150, 400)
	objectives += blood_objective

	var/datum/objective/assassinate/kill_objective = new
	kill_objective.owner = owner
	kill_objective.find_target()
	objectives += kill_objective

	var/datum/objective/steal/steal_objective = new
	steal_objective.owner = owner
	steal_objective.find_target()
	objectives += steal_objective


	switch(rand(1,100))
		if(1 to 80)
			if (!(locate(/datum/objective/escape) in objectives))
				var/datum/objective/escape/escape_objective = new
				escape_objective.owner = owner
				objectives += escape_objective
		else
			if (!(locate(/datum/objective/survive) in objectives))
				var/datum/objective/survive/survive_objective = new
				survive_objective.owner = owner
				objectives += survive_objective

	owner.objectives |= objectives


/datum/vampire
	var/bloodtotal = 0 // CHANGE TO ZERO WHEN PLAYTESTING HAPPENS
	var/bloodusable = 0 // CHANGE TO ZERO WHEN PLAYTESTING HAPPENS
	var/mob/living/owner = null
	var/gender = FEMALE
	var/iscloaking = 0 // handles the vampire cloak toggle
	var/ismenacing = 0 // handles the vampire menace toggle
	var/list/powers = list() // list of available powers and passives, see defines in setup.dm
	var/mob/living/carbon/human/draining // who the vampire is draining of blood
	var/nullified = 0 //Nullrod makes them useless for a short while.
	var/smitecounter = 0 //Keeps track of how badly the vampire has been affected by holy tiles.


/datum/vampire/New(gend = FEMALE)
	gender = gend

/datum/antagonist/vampire/proc/finalize_vampire()
	SSticker.mode.update_vampire_icons_added(owner)
	return