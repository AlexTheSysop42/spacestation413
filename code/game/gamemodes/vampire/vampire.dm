//This is the gamemode file for the ported goon gamemode vampires.
//They get a traitor objective and a blood sucking objective
/datum/game_mode
	var/vampire_name = "vampire"
	var/list/datum/mind/vampires = list()
	var/list/datum/mind/enthralled = list() //those controlled by a vampire
	var/list/thralls = list() //vammpires controlling somebody

/datum/game_mode/vampire
	name = "vampire"
	config_tag = "vampire"
	restricted_jobs = list("AI", "Cyborg", "Mobile MMI", "Security Officer", "Warden", "Detective", "Head of Security", "Captain", "Chaplain") //Consistent screening has filtered all infiltration attempts on high value jobs
	protected_jobs = list()
	required_players = 5
	var/required_players_secret = 10
	required_enemies = 1
	recommended_enemies = 4
	announce_span = "danger"
	announce_text = "There are Vampires from Space Transylvania on the station, keep your blood close and neck safe!"

	var/traitors_possible = 4
	var/num_modifier = 0
	var/objective_count = 2
	var/minimum_vampires = 1

/datum/game_mode/vampire/generate_report()
	return "Intel suggests the presence of unholy, supernatural lifeforms with a taste for blood on the station. Crewmembers are advised to cover their necks and consult their nearest spiritual advisor."

/datum/game_mode/vampire/pre_setup()

	if(CONFIG_GET(flag/protect_roles_from_antagonist))
		restricted_jobs += protected_jobs

	if(CONFIG_GET(flag/protect_assistant_from_antagonist))
		restricted_jobs += "Assistant"

	var/num_vampires = 1
	var/tsc = CONFIG_GET(number/traitor_scaling_coeff)
	if(tsc)
		num_vampires = max(minimum_vampires, min( round(num_players() / (tsc * 3))+ 2 + num_modifier, round(num_players() / (tsc * 1.5)) + num_modifier))
	else
		num_vampires = max(minimum_vampires, min(num_players(), traitors_possible))

	for(var/j = 0, j < num_vampires, j++)
		if (!antag_candidates.len)
			break
		var/datum/mind/vampire = pick(antag_candidates)
		vampires += vampire
		vampire.special_role = traitor_name
		vampire.restricted_roles = restricted_jobs

		log_game("[vampire.key] (ckey) has been selected as a Vampire") //TODO: Move these to base antag datum
		antag_candidates.Remove(vampire)

	if(vampires.len < required_enemies)
		return 0
	return 1


/datum/game_mode/vampire/post_setup()
	for(var/datum/mind/vampire in vampires)

		vampire.add_antag_datum(/datum/antagonist/vampire)
	return ..()


/datum/game_mode/proc/auto_declare_completion_vampire()

	if(vampires.len)
		var/text = "<br><font size=3><b>The [vampire_name]s were:</b></font>"

		for(var/datum/mind/vampire in vampires)
			var/traitorwin = TRUE

			text += printplayer(vampire)

			var/TC_uses = 0
			var/uplink_true = FALSE
			var/purchases = ""

			for(var/datum/component/uplink/H in GLOB.uplinks)
				if(H && H.owner && H.owner == vampire.key)
					TC_uses += H.spent_telecrystals
					uplink_true = TRUE
					purchases += H.purchase_log

			var/objectives = ""

			if(vampire.objectives.len)//If the traitor had no objectives, don't need to process this.
				var/count = 1
				for(var/datum/objective/objective in vampire.objectives)
					if(objective.check_completion())
						text += "<br><B>Objective #[count]</B>: [objective.explanation_text] <font color='green'><B>Success!</B></font>"
						SSblackbox.record_feedback("nested tally", "traitor_objective", 1, list("[objective.type]", "SUCCESS"))
					else
						text += "<br><B>Objective #[count]</B>: [objective.explanation_text] <font color='red'>Fail.</font>"
						SSblackbox.record_feedback("nested tally", "traitor_objective", 1, list("[objective.type]", "FAIL"))
						traitorwin = FALSE
					count++

			if(uplink_true)
				text += " (used [TC_uses] TC) [purchases]"
				if(TC_uses==0 && traitorwin)
					var/static/icon/badass = icon('icons/badass.dmi', "badass")
					text += "<BIG>[icon2html(badass, world)]</BIG>"

			text += objectives

			if(vampire.current)
				text += {"<br>[vampire.key] was [vampire.name] ("}
				if(vampire.current.stat == DEAD)
					text += "died"
				else
					text += "survived"
				if(vampire.current.real_name != vampire.name)
					text += " as [vampire.current.real_name]"
			else
				text += {"<br>[vampire.key] was [vampire.name] ("}
				text += "body destroyed"
			text += ")"
			text += {"<br><b>Total blood accumulated:</b> [vampire.vampire.bloodtotal]"}

			var/special_role_text
			if(vampire.special_role)
				special_role_text = lowertext(vampire.special_role)
			else
				special_role_text = "antagonist"

			if(traitorwin)
				text += "<br><font color='green'><B>The [special_role_text] was successful!</B></font>"
			else
				text += "<br><font color='red'><B>The [special_role_text] has failed!</B></font>"
		to_chat(world, text)

	return text

/datum/game_mode/proc/auto_declare_completion_enthralled()
	//var/text = vampire_completion()
	if(enthralled.len)
		text += {"<br><FONT size = 2><B>The Enthralled were:</B></FONT>"}
		for(var/datum/mind/Mind in enthralled)
			var/traitorwin = 1

			if(Mind.current)
				var/icon/flat = getFlatIcon(Mind.current, SOUTH, 1, 1)
				text += {"<br><b>[Mind.key]</b> was <b>[Mind.name]</b> ("}
				if(Mind.current.stat == DEAD)
					text += "died"
					flat.Turn(90)
				else
					text += "survived"
				if(Mind.current.real_name != Mind.name)
					text += " as [Mind.current.real_name]"
			else
				text += {"<b>[Mind.key]</b> was <b>[Mind.name]</b> ("}
				text += "body destroyed"
			text += ")"

			if(Mind.objectives.len)//If the traitor had no objectives, don't need to process this.
				var/count = 1
				for(var/datum/objective/objective in Mind.objectives)
					if(objective.check_completion())
						text += "<br><B>Objective #[count]</B>: [objective.explanation_text] <font color='green'><B>Success!</B></font>"
					else
						text += "<br><B>Objective #[count]</B>: [objective.explanation_text] <font color='red'>Fail.</font>"
						traitorwin = 0
					count++

			var/special_role_text
			if(Mind.special_role)
				special_role_text = lowertext(Mind.special_role)
			else
				special_role_text = "antagonist"

			var/TC_uses = 0
			var/uplink_true = FALSE
			var/purchases = ""

			for(var/datum/component/uplink/H in GLOB.uplinks)
				if(H && H.owner && H.owner == Mind.key)
					TC_uses += H.spent_telecrystals
					uplink_true = TRUE
					purchases += H.purchase_log

			if(uplink_true)
				text += " (used [TC_uses] TC) [purchases]"
				if(TC_uses==0 && traitorwin)
					var/static/icon/badass = icon('icons/badass.dmi', "badass")
					text += "<BIG>[icon2html(badass, world)]</BIG>"


			if(traitorwin)
				text += "<br><font color='green'><B>The [special_role_text] was successful!</B></font>"
			else
				text += "<br><font color='red'><B>The [special_role_text] has failed!</B></font>"
		text += "<BR><HR>"
	else
		if(text)
			text += "<BR><HR>"
	return text


/mob/proc/handle_bloodsucking(mob/living/carbon/human/H)
	src.mind.vampire.draining = H
	var/blood = 0
	var/bloodtotal = 0 //used to see if we increased our blood total
	var/bloodusable = 0 //used to see if we increased our blood usable
	src.log_message("\[[time_stamp()]\] <font color='red'>Bit [H.name] ([H.ckey]) in the neck and draining their blood</font>", INDIVIDUAL_ATTACK_LOG)
	H.log_message("\[[time_stamp()]\] <font color='orange'>Has been bit in the neck by [src.name] ([src.ckey])</font>", INDIVIDUAL_ATTACK_LOG)
	log_attack("[src.name] ([src.ckey]) bit [H.name] ([H.ckey]) in the neck")

	to_chat(src, "<span class='danger'>You latch on firmly to \the [H]'s neck.</span>")
	to_chat(H, "<span class='userdanger'>\The [src] latches on to your neck!</span>")

	if(!iscarbon(src))
		H.LAssailant = null
	else
		H.LAssailant = src
	while(do_mob(src, H, 50))
		if(!mind.vampire || !(mind in SSticker.mode.vampires))
			to_chat(src, "<span class='warning'>Your fangs have disappeared!</span>")
			src.mind.vampire.draining = null
			return 0
		if(NOBLOOD in H.dna.species.species_traits)
			to_chat(src, "<span class='warning'>Not a drop of blood here.</span>")
			src.mind.vampire.draining = null
			return 0
		if(!H.mind)
			to_chat(src, "<span class='warning'>This blood is lifeless and has no power.</span>")
			src.mind.vampire.draining = null
			return 0
		bloodtotal = src.mind.vampire.bloodtotal
		bloodusable = src.mind.vampire.bloodusable
		if(H.blood_volume == 0)
			to_chat(src, "<span class='warning'>They've got no blood left to give.</span>")
			break
		if(H.stat != DEAD) //alive
			blood = min(15, H.blood_volume)// if they have less than 10 blood, give them the remnant else they get 10 blood
			src.mind.vampire.bloodtotal += blood
			src.mind.vampire.bloodusable += blood
			H.adjustCloneLoss(10) // beep boop 10 damage
		else
			blood = min(7, H.blood_volume)// The dead only give 5 bloods
			src.mind.vampire.bloodtotal += blood
		if(bloodtotal != src.mind.vampire.bloodtotal)
			to_chat(src, "<span class='notice'>You have accumulated [src.mind.vampire.bloodtotal] [src.mind.vampire.bloodtotal > 1 ? "units" : "unit"] of blood[src.mind.vampire.bloodusable != bloodusable ?", and have [src.mind.vampire.bloodusable] left to use" : "."]</span>")
		check_vampire_upgrade(mind)
		H.blood_volume = max(H.blood_volume - 30, 0)

	src.mind.vampire.draining = null
	to_chat(src, "<span class='notice'>You stop draining [H.name] of blood.</span>")
	return 1

/mob/proc/check_vampire_upgrade(datum/mind/v)
	if(!v)
		return
	if(!v.vampire)
		return
	var/datum/vampire/vamp = v.vampire
	var/list/old_powers = vamp.powers.Copy()

	// This used to be a switch statement.
	// Don't use switch statements for shit like this, since blood can be any random-ass value.
	// if(100) requires the blood to be at EXACTLY 100 units to trigger.
	// if(blud >= 100) activates when blood is at or over 100 units.
	// TODO: Make this modular.

	// TIER 1
	if(vamp.bloodtotal >= 100)
		vamp.powers |= VAMP_VISION
		vamp.powers |= VAMP_SHAPE

	// TIER 2
	if(vamp.bloodtotal >= 150)
		vamp.powers |= VAMP_CLOAK
		vamp.powers |= VAMP_DISEASE

	// TIER 3
	if(vamp.bloodtotal >= 200)
		vamp.powers |= VAMP_BATS
		vamp.powers |= VAMP_SCREAM
		// Commented out until we can figured out a way to stop this from spamming.
//		to_chat(src, "<span class='notice'>Your rejuvination abilities have improved and will now heal you over time when used.</span>")

	// TIER 3.5 (/vg/)
	if(vamp.bloodtotal >= 250)
		vamp.powers |= VAMP_BLINK

	// TIER 4
	if(vamp.bloodtotal >= 300)
		vamp.powers |= VAMP_JAUNT
		vamp.powers |= VAMP_SLAVE

	// TIER 5 (/vg/)
	if(vamp.bloodtotal >= 400)
		vamp.powers |= VAMP_MATURE

	// TIER 6 (/vg/)
	if(vamp.bloodtotal >= 450)
		vamp.powers |= VAMP_SHADOW

	// TIER 66 (/vg/)
	if(vamp.bloodtotal >= 500)
		vamp.powers |= VAMP_CHARISMA

	// TIER 666 (/vg/)
	if(vamp.bloodtotal >= 666)
		vamp.powers |= VAMP_UNDYING

	announce_new_power(old_powers, vamp.powers)

/mob/proc/announce_new_power(list/old_powers, list/new_powers)
	var/msg = ""
	for(var/n in new_powers)
		if(!(n in old_powers))
			switch(n)
				if(VAMP_SHAPE)
					msg = "<span class='notice'>You have gained the shapeshifting ability, at the cost of stored blood you can change your form permanently.</span>"
					to_chat(src, "[msg]")
					verbs += /client/proc/vampire_shapeshift
				if(VAMP_VISION)
					msg = "<span class='notice'>Your vampiric vision has improved.</span>"
					to_chat(src, "[msg]")
					src.mind.store_memory("<font size = 1>[msg]</font>")
					//no verb
				if(VAMP_DISEASE)
					msg = "<span class='notice'>You have gained the Diseased Touch ability which causes those you touch to die shortly after unless treated medically.</span>"
					to_chat(src, "[msg]")
					verbs += /client/proc/vampire_disease
				if(VAMP_CLOAK)
					msg = "<span class='notice'>You have gained the Cloak of Darkness ability which when toggled makes you near invisible in the shroud of darkness.</span>"
					to_chat(src, "[msg]")
					verbs += /client/proc/vampire_cloak
				if(VAMP_BATS)
					msg = "<span class='notice'>You have gained the Summon Bats ability."
					to_chat(src, "[msg]")
					verbs += /client/proc/vampire_bats // work in progress
				if(VAMP_SCREAM)
					msg = "<span class='notice'>You have gained the Chiroptean Screech ability which stuns anything with ears in a large radius and shatters glass in the process.</span>"
					to_chat(src, "[msg]")
					verbs += /client/proc/vampire_screech
				if(VAMP_JAUNT)
					msg = "<span class='notice'>You have gained the Mist Form ability which allows you to take on the form of mist for a short period and pass over any obstacle in your path.</span>"
					to_chat(src, "[msg]")
					verbs += /client/proc/vampire_jaunt
				if(VAMP_SLAVE)
					msg = "<span class='notice'>You have gained the Enthrall ability which at a heavy blood cost allows you to enslave a human that is not loyal to any other for a random period of time.</span>"
					to_chat(src, "[msg]")
					verbs += /client/proc/vampire_enthrall
				if(VAMP_BLINK)
					msg = "<span class='notice'>You have gained the ability to shadowstep, which makes you disappear into nearby shadows at the cost of blood.</span>"
					to_chat(src, "[msg]")
					verbs += /client/proc/vampire_shadowstep
				if(VAMP_MATURE)
					msg = "<span class='sinister'>You have reached physical maturity. You are more resistant to holy things, and your vision has been improved greatly.</span>"
					to_chat(src, "[msg]")
					src.mind.store_memory("<font size = 1>[msg]</font>")
					//no verb
				if(VAMP_SHADOW)
					msg = "<span class='notice'>You have gained mastery over the shadows. In the dark, you can mask your identity, instantly terrify non-vampires who approach you, and enter the chapel for a longer period of time.</span>"
					to_chat(src, "[msg]")
					verbs += /client/proc/vampire_shadowmenace //also buffs Cloak of Shadows
				if(VAMP_CHARISMA)
					msg = "<span class='sinister'>You develop an uncanny charismatic aura that makes you difficult to disobey. Hypnotise and Enthrall take less time to perform, and Enthrall works on implanted targets.</span>"
					to_chat(src, "[msg]")
					src.mind.store_memory("<font size = 1>[msg]</font>")
					//no verb
				if(VAMP_UNDYING)
					msg = "<span class='sinister'>You have reached the absolute peak of your power. Your abilities cannot be nullified very easily, and you may return from the grave so long as your body is not burned, destroyed or sanctified. You can also spawn a rather nice cape.</span>"
					to_chat(src, "[msg]")
					src.mind.store_memory("<font size = 1>[msg]</font>")
					verbs += /client/proc/vampire_undeath
					verbs += /client/proc/vampire_spawncape




/datum/game_mode/proc/update_vampire_icons_added(datum/mind/vampire_mind)
	log_admin("vampire HUD added")
	message_admins("vampire HUD added")
	var/datum/atom_hud/antag/hud = GLOB.huds[ANTAG_HUD_VAMPIRE]
	hud.join_hud(vampire_mind.current)
	log_admin("Setting vampire HUD")
	set_antag_hud(vampire_mind.current, "vampire")

/datum/game_mode/proc/update_vampire_icons_removed(datum/mind/vampire_mind)
	var/datum/atom_hud/antag/hud = GLOB.huds[ANTAG_HUD_VAMPIRE]
	hud.leave_hud(vampire_mind.current)
	set_antag_hud(vampire_mind.current, null)

/datum/game_mode/proc/update_enthralled_icons_added(datum/mind/enthralled_mind)
	var/datum/atom_hud/antag/hud = GLOB.huds[ANTAG_HUD_VAMPIRE]
	hud.join_hud(enthralled_mind.current)
	set_antag_hud(enthralled_mind.current, "vampthrall")

/datum/game_mode/proc/update_enthralled_icons_removed(datum/mind/enthralled_mind)
	var/datum/atom_hud/antag/hud = GLOB.huds[ANTAG_HUD_VAMPIRE]
	hud.leave_hud(enthralled_mind.current)
	set_antag_hud(enthralled_mind.current, null)

/*
/datum/game_mode/proc/update_vampire_icons_added(datum/mind/vampire_mind)

	var/ref = "\ref[vampire_mind]"
	if(ref in thralls)
		if(vampire_mind.current)
			if(vampire_mind.current.client)
				var/image/I = image('icons/mob/mob3.dmi', loc = vampire_mind.current, icon_state = "vampire")
				I.plane = HUD_PLANE
				vampire_mind.current.client.images += I
	for(var/headref in thralls)
		for(var/datum/mind/t_mind in thralls[headref])
			var/datum/mind/head = locate(headref)
			if(head)
				if(head.current)
					if(head.current.client)
						var/image/I = image('icons/mob/mob3.dmi', loc = t_mind.current, icon_state = "vampthrall")
						I.plane = HUD_PLANE
						head.current.client.images += I
				if(t_mind.current)
					if(t_mind.current.client)
						var/image/I = image('icons/mob/mob3.dmi', loc = head.current, icon_state = "vampire")
						I.plane = HUD_PLANE
						t_mind.current.client.images += I
				if(t_mind.current)
					if(t_mind.current.client)
						var/image/I = image('icons/mob/mob3.dmi', loc = t_mind.current, icon_state = "vampthrall")
						I.plane = HUD_PLANE
						t_mind.current.client.images += I



/datum/game_mode/proc/update_vampire_icons_removed(datum/mind/vampire_mind)

	for(var/headref in thralls)
		var/datum/mind/head = locate(headref)
		for(var/datum/mind/t_mind in thralls[headref])
			if(t_mind.current)
				if(t_mind.current.client)
					for(var/image/I in t_mind.current.client.images)
						if((I.icon_state == "vampthrall" || I.icon_state == "vampire") && I.loc == vampire_mind.current)
							//world.log << "deleting [vampire_mind] overlay"
							//del(I)
							t_mind.current.client.images -= I
		if(head)
			//world.log << "found [head.name]"
			if(head.current)
				if(head.current.client)
					for(var/image/I in head.current.client.images)
						if((I.icon_state == "vampthrall" || I.icon_state == "vampire") && I.loc == vampire_mind.current)
							//world.log << "deleting [vampire_mind] overlay"
							//del(I)
							head.current.client.images -= I
	if(vampire_mind.current)
		if(vampire_mind.current.client)
			for(var/image/I in vampire_mind.current.client.images)
				if(I.icon_state == "vampthrall" || I.icon_state == "vampire")
					//del(I)
					vampire_mind.current.client.images -= I*/

/datum/game_mode/proc/remove_thrall(datum/mind/enthralled_mind)
	var/datum/mind/headvamp
	if(enthralled_mind.objectives && enthralled_mind.objectives.len)
		for(var/datum/objective/protect/P in enthralled_mind.objectives)
			if(findtextEx(P.explanation_text,"You have been Enthralled by"))
				headvamp = P.target //can't think of any better way to find them
				enthralled_mind.objectives -= P
	var/ref = "\ref[headvamp]"
	if(ref in thralls)
		thralls[ref] -= enthralled_mind
	enthralled -= enthralled_mind
	enthralled_mind.special_role = null
	update_vampire_icons_removed(enthralled_mind)
	//enthralled_mind.current.unsubLife(src)
	to_chat(enthralled_mind.current, "<span class='danger'><FONT size = 3>The fog clouding your mind clears. You remember nothing from the moment you were enthralled until now.</FONT></span>")

/mob/living/carbon/human/proc/check_sun()


	var/ax = x
	var/ay = y

	for(var/i = 1 to 20)
		ax += SSsun.dx
		ay += SSsun.dy

		var/turf/T = locate( round(ax,0.5),round(ay,0.5),z)

		if(T.x == 1 || T.x==world.maxx || T.y==1 || T.y==world.maxy)
			break

		if(T.density)
			return
	if(prob(45))
		switch(health)
			if(80 to 100)
				to_chat(src, "<span class='warning'>Your skin flakes away...</span>")
				adjustFireLoss(1)
			if(60 to 80)
				to_chat(src, "<span class='warning'>Your skin sizzles!</span>")
				adjustFireLoss(1)
			if((-INFINITY) to 60)
				if(!on_fire)
					to_chat(src, "<span class='danger'>Your skin catches fire!</span>")
				else
					to_chat(src, "<span class='danger'>You continue to burn!</span>")
				fire_stacks += 5
				IgniteMob()
		emote("scream",,, 1)
	else
		switch(health)
			if((-INFINITY) to 60)
				fire_stacks++
				IgniteMob()
	adjustFireLoss(3)

/mob/living/carbon/human/proc/handle_vampire_smite()
	var/smitetemp = 0
	var/vampcoat = istype(wear_suit, /obj/item/clothing/suit/storage/draculacoat) //coat reduces smiting
	if(check_holy(src)) //if you're on a holy tile get ready for pain
		smitetemp += (vampcoat ? 1 : 5)
		if(prob(35))
			to_chat(src, "<span class='danger'>This ground is blessed. Get away, or splatter it with blood to make it safe for you.</span>")

	if(!((VAMP_MATURE in mind.vampire.powers)) && get_area(get_turf(src)) == /area/chapel) //stay out of the chapel unless you want to turn into a pile of ashes
		mind.vampire.nullified = max(5, mind.vampire.nullified + 2)
		if(prob(35))
			to_chat(src, "<span class='sinister'>You feel yourself growing weaker.</span>")
		/*smitetemp += (vampcoat ? 5 : 15)
		if(prob(35))
			to_chat(src, "<span class='sinister'>Burn, wretch.</span>")
	*/

	if(!mind.vampire.nullified) //Checks to see if you can benefit from your vamp powers here
		if(VAMP_MATURE in mind.vampire.powers)
			smitetemp -= 1
		if(VAMP_SHADOW in mind.vampire.powers)
			var/turf/T = get_turf(src)
			if((T.get_lumcount() * 10) < 2)
				smitetemp -= 1

		if(VAMP_UNDYING in mind.vampire.powers)
			smitetemp -= 1

	if(smitetemp <= 0) //if you weren't smote by the tile you're on, remove a little holy
		smitetemp = -1

	mind.vampire.smitecounter = max(0, (mind.vampire.smitecounter + smitetemp))

	switch(mind.vampire.smitecounter)
		if(1 to 30) //just dizziness
			dizziness = max(5, dizziness)
			if(prob(35))
				to_chat(src, "<span class='warning'>You feel sick.</span>")
		if(30 to 60) //more dizziness, and occasional disorientation
			dizziness = max(5, dizziness + 1)
			remove_vampire_blood(1)
			if(prob(35))
				confused = max(5, confused)
				to_chat(src, "<span class='warning'>You feel very sick.</span>")
		if(60 to 90) //this is where you start barfing and losing your powers
			dizziness = max(10, dizziness + 3)
			mind.vampire.nullified = max(20, mind.vampire.nullified)
			remove_vampire_blood(2)
			if(prob(8))
				vomit()
			if(prob(35))
				confused = max(5, confused)
				to_chat(src, "<span class='warning'>You feel extremely sick. Get to a coffin as soon as you can.</span>")
		if(90 to 100) //previous effects, and skin starts to smoulder
			dizziness = max(10, dizziness + 6)
			mind.vampire.nullified = max(20, mind.vampire.nullified + 1)
			remove_vampire_blood(5)
			confused = max(10, confused)
			adjustFireLoss(1)
			if(prob(35))
				to_chat(src, "<span class='danger'>Your skin sizzles!</span>")
				visible_message("<span class='danger'>[src]'s skin sizzles!</span>")
		if(100 to (INFINITY)) //BONFIRE
			dizziness = max(50, dizziness + 8)
			mind.vampire.nullified = max(50, mind.vampire.nullified + 10)
			remove_vampire_blood(10)
			confused = max(10, confused)
			if(!on_fire)
				to_chat(src, "<span class='danger'>Your skin catches fire!</span>")
			else if(prob(35))
				to_chat(src, "<span class='danger'>The holy flames continue to burn your flesh!</span>")
			fire_stacks += 5
			IgniteMob()

/mob/living/carbon/human/proc/handle_vampire()
	if(hud_used)
		if(!hud_used.vampire_blood_display)
			hud_used.vampire_hud()
			//hud_used.human_hud(hud_used.ui_style)
		//hud_used.vampire_blood_display.maptext_width = world.icon_size*2
		//hud_used.vampire_blood_display.maptext_height = world.icon_size*/
	handle_vampire_cloak()
	handle_vampire_menace()
	handle_vampire_smite()
	handle_vampire_vision()
	if(istype(loc, /turf/open/space))
		check_sun()
	if(istype(loc, /obj/structure/closet/coffin))
		adjustBruteLoss(-4)
		adjustFireLoss(-4)
		adjustToxLoss(-4)
		adjustOxyLoss(-4)
		mind.vampire.smitecounter = 0
		mind.vampire.nullified -= 5
	mind.vampire.nullified = max(0, mind.vampire.nullified - 1)
