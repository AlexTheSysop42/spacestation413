obj/item/vent_dummy
	name = "ventriloquist dummy"
	icon = 'icons/obj/dummies.dmi'
	icon_state = "dummy_default"
	item_state = "dummy_default"
	lefthand_file = 'icons/mob/inhands/lefthand.dmi'
	righthand_file = 'icons/mob/inhands/righthand.dmi'
	var/custom_name = null
	var/held = FALSE
	var/spam_flag = 0
	var/cooldowntime = 20
	var/CanRename = TRUE
	desc = "It's a puppet with a controllable mouth and arms. Suitable for ventriloquism acts and disturbing people."
	attack_verb = list("slapped", "fistbumped")

obj/item/vent_dummy/attack_self(mob/living/user)
	if(CanRename)
		if (custom_name == null)
			custom_name = stripped_input(user, "What is the puppets name?")
			if(length(custom_name) > MAX_NAME_LEN)
				to_chat(user, "<span class='danger'>Name is too long!</span>")
				return FALSE
			if(custom_name)
				name = custom_name
				desc = "It's [custom_name] the puppet... did it just move?"
		else
			if (!spam_flag)
				spam_flag = 1
				user.visible_message("<span class='notice'>[user] gives [name] a nervous fistbump. </span>")
				spawn(cooldowntime)
					spam_flag = 0
	return

obj/item/vent_dummy/sockpuppet
	name = "sock puppet"
	icon_state = "sockpuppet"
	item_state = null
	desc = "A sock with buttons for eyes. Smells like feet."


//Hand lion - More obscure british television references!

obj/item/vent_dummy/handlion
	name = "hand lion"
	icon_state = "handlion"
	item_state = "handlion"
	CanRename = FALSE
	desc = "An animatronic hand lion, straight out of Mr. Whittlinghams cupboard. It can be set to lick or strike."
	attack_verb = list("licked", "struck")
	force = 0
	throwforce = 0
	var/lick = TRUE

obj/item/vent_dummy/handlion/attack_self(mob/living/user)
	if (lick)
		user.visible_message("<span class='notice'>The hand lion gently licks [user]s hand.</span>")
	else
		playsound(src.loc, 'sound/effects/snap.ogg', 50, 1)
		user.visible_message("<span class='userdanger'>The hand lion fiercely strikes [user]s hand.</span>")

obj/item/vent_dummy/handlion/AltClick(mob/living/user)
	lick = !lick
	if (lick)
		to_chat(user, "<span class='notice'>The hand lion is now set to lick.</span>")
		force = 0
		throwforce = 0
	else
		to_chat(user, "<span class='notice'>The hand lion is now set to strike!</span>")
		force = 12
		throwforce = 20

obj/item/vent_dummy/handlion/throw_impact(atom/A)
	. = ..()
	if(!lick)
		playsound(src.loc, 'sound/effects/catgrowl.ogg', 50, 1)

//CURSED DUMMY
obj/item/vent_dummy/cursed
	var/awoken = FALSE
	var/lying = 0
	var/cannot_be_seen = 1
	var/evil_lines = list("<i>They're mocking you behind your back.</i>", "<i>Can you hear them laughing at you?</i>", "<i>We should teach them a lesson!</i>", "<i>Nobody likes you. Don't trust them.</i>", "<i>Wouldn't it be easy to just grab a knife?</i>", "<i>I say we kill 'em, kill 'em all!</i>")
	var/fake_lines = list("Someone stole the spare.", "I saw someone break into engineering.", "The AI has been electrifying doors.", "Nukie outside!", "Someone's infected!")
	var/tempting_lines = list("Psst, hey!", "Hey, you there!", "You look like you could use a friend.", "Hey, kid, want a balloon?")
	var/mob/living/carrier
	var/angry_line = "You shouldn't have done that..."

obj/item/vent_dummy/proc/Life()
	set waitfor = 0
	return

obj/item/vent_dummy/cursed/proc/awaken()
	awoken = TRUE
	flicker_lights()
	Life()
	log_admin("[name] has awoken.")
	message_admins("[name] has awoken.")

obj/item/vent_dummy/cursed/proc/purify()
	if(awoken)
		awoken = FALSE
		log_admin("[name] has been purified and calmed.")
		message_admins("[name] has been purified and calmed.")


obj/item/vent_dummy/cursed/say()
	if (prob(1) && !awoken) //1% chance to awaken the dummy each time it speaks
		awaken()
	. = ..()

obj/item/vent_dummy/cursed/throw_impact(atom/A)
	..()
	if (prob(15)) //15% chance to awaken the dummy when throwing it around
		if (!awoken)
			awaken()
		say(angry_line)

/obj/item/vent_dummy/cursed/pickup(mob/user)
	held = TRUE
	carrier = user
	. = ..()

obj/item/vent_dummy/cursed/dropped(mob/user)
	held = FALSE
	carrier = null
	. = ..()

// Awoken dummy shenanigans - tfw no multiple inheritance

/obj/item/vent_dummy/cursed/Life()
	..()
	if (awoken)
		sleep 100
		if(prob(5))
			flicker_lights()
		if(held)
			if(prob(3))
				var/line = pick(evil_lines)
				to_chat(carrier,(line))
			if(prob(3))
				var/mob/living/carbon/human/H = pick(GLOB.player_list)
				if (H != carrier)
					say("[H] is the traitor.")
				else
					say("[carrier] should be promoted to captain.")
			if(prob(3))
				say(pick(fake_lines))
		else
			if(prob(5))
				do_jitter_animation(500)

			if(prob(3))
				say(pick(tempting_lines))

			if(prob(10))
				jaunt(src)

		Life() //recursive loop for now because I can't figure out how the mob/Life() proc works for looping


/obj/item/vent_dummy/cursed/proc/flicker_lights()
	var/area/A = get_area(get_turf(src))
	for(var/obj/machinery/light/L in A)
		L.flicker()
	return

obj/item/vent_dummy/cursed/proc/jaunt(obj/item/vent_dummy/cursed/D)
	var/area/chosen = null
	chosen = GLOB.teleportlocs[pick(GLOB.teleportlocs)]

	var/list/L = list()

	for(var/turf/T in get_area_turfs(chosen.type))
		if(!T.density)
			var/clear = 1
			for(var/obj/O in T)
				if(O.density)
					clear = 0
					break
			if(clear)
				L+=T

	var/newloc = pick(L)

	if(!can_be_seen(newloc) && !can_be_seen(D.loc))
		D.loc = newloc
		log_admin("[name] moved to [chosen.name].")
		message_admins("[name] moved to [chosen.name].")


/obj/item/vent_dummy/cursed/proc/do_jitter_animation(jitteriness)
	var/amplitude = min(4, (jitteriness/100) + 1)
	var/pixel_x_diff = rand(-amplitude, amplitude)
	var/pixel_y_diff = rand(-amplitude/3, amplitude/3)
	var/final_pixel_x = get_standard_pixel_x_offset(lying)
	var/final_pixel_y = get_standard_pixel_y_offset(lying)
	animate(src, pixel_x = pixel_x + pixel_x_diff, pixel_y = pixel_y + pixel_y_diff , time = 2, loop = 6)
	animate(pixel_x = final_pixel_x , pixel_y = final_pixel_y , time = 2)
	floating = 0 // If we were without gravity, the bouncing animation got stopped, so we make sure to restart it in next life().

/obj/item/vent_dummy/cursed/proc/get_standard_pixel_x_offset(lying = 0)
	return initial(pixel_x)

/obj/item/vent_dummy/cursed/proc/get_standard_pixel_y_offset(lying = 0)
	return initial(pixel_y)

/obj/item/vent_dummy/cursed/proc/can_be_seen(turf/destination)
	if(!cannot_be_seen)
		return null
	// Check for darkness
	var/turf/T = get_turf(loc)
	if(T && destination && T.lighting_object)
		if(T.get_lumcount()<0.1 && destination.get_lumcount()<0.1) // No one can see us in the darkness, right?
			return null
		if(T == destination)
			destination = null

	// We aren't in darkness, loop for viewers.
	var/list/check_list = list(src)
	if(destination)
		check_list += destination

	// This loop will, at most, loop twice.
	for(var/atom/check in check_list)
		for(var/mob/living/M in viewers(world.view + 1, check) - src)
			if(M.client && isliving(M) && !M.has_unlimited_silicon_privilege)
				if(!M.eye_blind)
					return M
		for(var/obj/mecha/M in view(world.view + 1, check)) //assuming if you can see them they can see you
			if(M.occupant && M.occupant.client)
				if(!M.occupant.eye_blind)
					return M.occupant
	return null

/*
obj/item/vent_dummy/cursed/woody
	icon_state = "woody"
	var/pullcord_lines = list()*/

obj/item/vent_dummy/cursed/makin
	name = "puppet Makin"
	icon_state = "makin"
	CanRename = FALSE
	desc = "This ventriloquist dummy has an air of rationality about it."
	attack_verb = list("rationalized", "discoursed", "banned", "shilled")
	evil_lines = list("<i>Fanfiction is the best medium.</i>", "<i>Have you visited the library recently?</i>", "<i>You should read worm.</i>", "<i>Boring round.</i>", "<i>Go read some ratfic instead</i>", "<i>HPMOR gets better on every re-read</i>")
	fake_lines = list("ZA WARUDO", "Take it to #social", "Read worm.", "I'm banning you.", "Are you calling me... entitled?")
	tempting_lines = list("Hey you, have you read worm yet?", "Hey, you!", "Read worm.")
	angry_line = "That was a bit... irrational"