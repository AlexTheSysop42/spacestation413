/datum/emote/living/carbon/human
	mob_type_allowed_typecache = list(/mob/living/carbon/human)

/datum/emote/living/carbon/human/cry
	key = "cry"
	key_third_person = "cries"
	message = "cries."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/dap
	key = "dap"
	key_third_person = "daps"
	message = "sadly can't find anybody to give daps to, and daps themself. Shameful."
	message_param = "give daps to %t."
	restraint_check = TRUE

/datum/emote/living/carbon/human/eyebrow
	key = "eyebrow"
	message = "raises an eyebrow."

/mob/living
	var/list/alternate_farts

/datum/emote/living/carbon/fart
	key = "fart"
	key_third_person = "farts"

/datum/emote/living/carbon/fart/run_emote(mob/living/carbon/user, params)
	var/fartsound = 'sound/effects/fart.ogg'
	var/bloodkind = /obj/effect/decal/cleanable/blood
	message = null
	if(user.stat != CONSCIOUS)
		return
	var/obj/item/organ/butt/B = user.getorgan(/obj/item/organ/butt)
	if(!B)
		to_chat(user, "<span class='warning'>You don't have a butt!</span>")
		return
	var/lose_butt = prob(12)
	for(var/mob/living/M in get_turf(user))
		if(M == user)
			continue
		if(lose_butt)
			message = "hits <b>[M]</b> in the face with [B]!"
			M.apply_damage(15,"brute","head")
		else
			message = pick(
				"farts in <b>[M]</b>'s face!",
				"gives <b>[M]</b> the silent but deadly treatment!",
				"rips mad ass in <b>[M]</b>'s mug!",
				"releases the musical fruits of labor onto <b>[M]</b>!",
				"commits an act of butthole bioterror all over <b>[M]</b>!",
				"poots, singing <b>[M]</b>'s eyebrows!",
				"humiliates <b>[M]</b> like never before!",
				"gets real close to <b>[M]</b>'s face and cuts the cheese!")
	if(!message)
		message = pick(
			"rears up and lets loose a fart of tremendous magnitude!",
			"farts!",
			"toots.",
			"harvests methane from uranus at mach 3!",
			"assists global warming!",
			"farts and waves their hand dismissively.",
			"farts and pretends nothing happened.",
			"is a <b>farting</b> motherfucker!",
			"<B><font color='red'>f</font><font color='blue'>a</font><font color='red'>r</font><font color='blue'>t</font><font color='red'>s</font></B>",
			"unleashes their unholy rectal vapor!",
			"assblasts gently.",
			"lets out a wet sounding one!",
			"exorcises a <b>ferocious</b> colonic demon!",
			"pledges ass-legience to the flag!",
			"cracks open a tin of beans!",
			"tears themselves a new one!",
			"looses some pure assgas!",
			"displays the most sophisticated type of humor.",
			"strains to get the fart out. Is that <font color='red'>blood</font>?",
			"sighs and farts simultaneously.",
			"expunges a gnarly butt queef!",
			"contributes to the erosion of the ozone layer!",
			"just farts. It's natural, everyone does it.",
			"had one too many tacos this week!",
			"has the phantom shits.",
			"flexes their bunghole.",
			"'s ass sings the song that ends the earth!",
			"had to go and ruin the mood!",
			"unflinchingly farts. True confidence.",
			"shows everyone what they had for breakfast!",
			"farts so loud it startles them!",
			"breaks wind and a nearby wine glass!",
			"<b>finally achieves the perfect fart. All downhill from here.</b>")
	LAZYINITLIST(user.alternate_farts)
	if(LAZYLEN(user.alternate_farts))
		fartsound = pick(user.alternate_farts)
	if(istype(user,/mob/living/carbon/alien))
		bloodkind = /obj/effect/decal/cleanable/xenoblood
	var/obj/item/storage/book/bible/Y = locate() in get_turf(user.loc)
	if(istype(Y))
		user.Stun(20)
		playsound(Y,'sound/effects/thunder.ogg', 90, 1)
		var/turf/T = get_ranged_target_turf(user, NORTH, 8)
		T.Beam(user, icon_state="lightning[rand(1,12)]", time = 5)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.electrocution_animation(10)
		addtimer(CALLBACK(user, /mob/proc/gib), 10)
	else
		var/obj/item/storage/internal/pocket/butt/theinv = B.inv
		if(theinv.contents.len)
			var/obj/item/O = pick(theinv.contents)
			if(istype(O, /obj/item/lighter))
				var/obj/item/lighter/G = O
				if(G.lit && user.loc)
					new/obj/effect/hotspot(user.loc)
					playsound(user, fartsound, 100, 1, 5)
			else if(istype(O, /obj/item/weldingtool))
				var/obj/item/weldingtool/J = O
				if(J.welding && user.loc)
					new/obj/effect/hotspot(user.loc)
					playsound(user, fartsound, 100, 1, 5)
			else if(istype(O, /obj/item/bikehorn))
				for(var/obj/item/bikehorn/Q in theinv.contents)
					playsound(Q, 'sound/items/bikehorn.ogg', 100, 1, 5)
				message = "<span class='clown'>farts.</span>"
			else if(istype(O, /obj/item/device/megaphone))
				message = "<span class='reallybig'>farts.</span>"
				playsound(user, 'sound/effects/fartmassive.ogg', 100, 1, 5)
			else
				playsound(user, fartsound, 100, 1, 5)
			if(prob(33))
				theinv.remove_from_storage(O, user.loc)
		else
			playsound(user, fartsound, 100, 1, 5)
		sleep(1)
		if(lose_butt)
			B.Remove(user)
			B.forceMove(get_turf(user))
			new bloodkind(user.loc)
			user.nutrition = max(user.nutrition - rand(5, 20), NUTRITION_LEVEL_STARVING)
			user.visible_message("<span class='warning'><b>[user]</b> blows their ass off!</span>", "<span class='warning'>Holy shit, your butt flies off in an arc!</span>")
		else
			user.nutrition = max(user.nutrition - rand(2, 10), NUTRITION_LEVEL_STARVING)
		..()
		if(!ishuman(user)) //nonhumans don't have the message appear for some reason
			user.visible_message("<b>[user]</b> [message]")

/datum/emote/living/carbon/human/superfart
	key = "superfart"
	key_third_person = "superfarts"

/datum/emote/living/carbon/human/superfart/run_emote(mob/living/carbon/human/user, params)
	if(!ishuman(user))
		to_chat(user, "<span class='warning'>You lack that ability!</span>")
		return
	var/obj/item/organ/butt/B = user.getorgan(/obj/item/organ/butt)
	if(!B)
		to_chat(user, "<span class='danger'>You don't have a butt!</span>")
		return
	if(B.loose)
		to_chat(user, "<span class='danger'>Your butt's too loose to superfart!</span>")
		return
	B.loose = TRUE // to avoid spamsuperfart
	var/fart_type = 1 //Put this outside probability check just in case. There were cases where superfart did a normal fart.
	if(prob(76)) // 76%     1: ASSBLAST  2:SUPERNOVA  3: FARTFLY
		fart_type = 1
	else if(prob(12)) // 2.89%
		fart_type = 2
	else if(prob(12)) // 0.35%
		if(user.loc && user.loc.z == 1)
			fart_type = 3
		else
			fart_type = 2
	var/obj/item/storage/book/bible/Y = locate() in get_turf(user.loc)
	if(istype(Y))
		user.Stun(20)
		playsound(Y,'sound/effects/thunder.ogg', 90, 1)
		var/turf/T = get_ranged_target_turf(user, NORTH, 8)
		T.Beam(user, icon_state="lightning[rand(1,12)]", time = 5)
		user.electrocution_animation(10)
		addtimer(CALLBACK(user, /mob/proc/gib), 10)
	else
		for(var/i in 1 to 10)
			playsound(user, 'sound/effects/fart.ogg', 100, 1, 5)
			sleep(1)
		playsound(user, 'sound/effects/fartmassive.ogg', 75, 1, 5)
		var/obj/item/storage/internal/pocket/butt/theinv = B.inv
		if(theinv.contents.len)
			for(var/obj/item/O in theinv.contents)
				theinv.remove_from_storage(O, user.loc)
				O.throw_range = 7//will be reset on hit
				var/turf/target = get_turf(O)
				var/range = 7
				var/turf/new_turf
				var/new_dir
				switch(user.dir)
					if(1)
						new_dir = 2
					if(2)
						new_dir = 1
					if(4)
						new_dir = 8
					if(8)
						new_dir = 4
				for(var/i = 1; i < range; i++)
					new_turf = get_step(target, new_dir)
					target = new_turf
					if(new_turf.density)
						break
				O.throw_at(target,range,O.throw_speed)
		B.Remove(user)
		B.forceMove(get_turf(user))
		if(B.loose)
			B.loose = FALSE
		new /obj/effect/decal/cleanable/blood(user.loc)
		user.nutrition = max(user.nutrition - 500, NUTRITION_LEVEL_STARVING)
		switch(fart_type)
			if(1)
				for(var/mob/living/M in range(0))
					if(M != user)
						user.visible_message("<span class='warning'><b>[user]</b>'s ass blasts <b>[M]</b> in the face!</span>", "<span class='warning'>You ass blast <b>[M]</b>!</span>")
						M.apply_damage(50,"brute","head")

				user.visible_message("<span class='warning'><b>[user]</b> blows their ass off!</span>", "<span class='warning'>Holy shit, your butt flies off in an arc!</span>")

			if(2)
				user.visible_message("<span class='warning'><b>[user]</b> rips their ass apart in a massive explosion!</span>", "<span class='warning'>Holy shit, your butt goes supernova!</span>")
				playsound(user, 'sound/effects/superfart.ogg', 75, extrarange = 255, pressure_affected = FALSE)
				explosion(user.loc, 0, 1, 3, adminlog = FALSE, flame_range = 3)
				user.gib()

			if(3)
				var/endy = 0
				var/endx = 0

				switch(user.dir)
					if(NORTH)
						endy = 8
						endx = user.loc.x
					if(EAST)
						endy = user.loc.y
						endx = 8
					if(SOUTH)
						endy = 247
						endx = user.loc.x
					else
						endy = user.loc.y
						endx = 247

				//ASS BLAST USA
				user.visible_message("<span class='warning'><b>[user]</b> blows their ass off with such force, they explode!</span>", "<span class='warning'>Holy shit, your butt flies off into the galaxy!</span>")
				playsound(user, 'sound/effects/superfart.ogg', 75, extrarange = 255, pressure_affected = FALSE)
				user.gib() //can you belive I forgot to put this here?? yeah you need to see the message BEFORE you gib
				new /obj/effect/immovablerod/butt(B.loc, locate(endx, endy, 1))
				priority_announce("What the fuck was that?!", "General Alert")
				qdel(B)

/datum/emote/living/carbon/human/grumble
	key = "grumble"
	key_third_person = "grumbles"
	message = "grumbles!"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/handshake
	key = "handshake"
	message = "shakes their own hands."
	message_param = "shakes hands with %t."
	restraint_check = TRUE
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/hug
	key = "hug"
	key_third_person = "hugs"
	message = "hugs themself."
	message_param = "hugs %t."
	restraint_check = TRUE
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/mumble
	key = "mumble"
	key_third_person = "mumbles"
	message = "mumbles!"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/pale
	key = "pale"
	message = "goes pale for a second."

/datum/emote/living/carbon/human/raise
	key = "raise"
	key_third_person = "raises"
	message = "raises a hand."
	restraint_check = TRUE

/datum/emote/living/carbon/human/salute
	key = "salute"
	key_third_person = "salutes"
	message = "salutes."
	message_param = "salutes to %t."
	restraint_check = TRUE

/datum/emote/living/carbon/human/shrug
	key = "shrug"
	key_third_person = "shrugs"
	message = "shrugs."

/datum/emote/living/carbon/human/wag
	key = "wag"
	key_third_person = "wags"
	message = "wags their tail."

/datum/emote/living/carbon/human/wag/run_emote(mob/user, params)
	. = ..()
	var/mob/living/carbon/human/H = user
	if(!H.is_wagging_tail())
		H.startTailWag()
	else
		H.endTailWag()

/mob/living/carbon/human/proc/is_wagging_tail()
	return (dna && dna.species && ("waggingtail_lizard" in dna.species.mutant_bodyparts || "waggingtail_human" in dna.species.mutant_bodyparts))

/datum/emote/living/carbon/human/wag/can_run_emote(mob/user, status_check = TRUE)
	if(!..())
		return FALSE
	var/mob/living/carbon/human/H = user
	if(H.dna && H.dna.species && (("tail_lizard" in H.dna.species.mutant_bodyparts) || ("waggingtail_lizard" in H.dna.species.mutant_bodyparts) || (H.dna.features["tail_human"] != "None")))
		return TRUE

/datum/emote/living/carbon/human/wag/select_message_type(mob/user)
	. = ..()
	var/mob/living/carbon/human/H = user
	if(("waggingtail_lizard" in H.dna.species.mutant_bodyparts) || ("waggingtail_human" in H.dna.species.mutant_bodyparts))
		. = null

//Don't know where else to put this, it's basically an emote
/mob/living/carbon/human/proc/startTailWag()
	if(!dna || !dna.species)
		return
	if("tail_lizard" in dna.species.mutant_bodyparts)
		dna.species.mutant_bodyparts -= "tail_lizard"
		dna.species.mutant_bodyparts -= "spines"
		dna.species.mutant_bodyparts |= "waggingtail_lizard"
		dna.species.mutant_bodyparts |= "waggingspines"
	if("tail_human" in dna.species.mutant_bodyparts)
		dna.species.mutant_bodyparts -= "tail_human"
		dna.species.mutant_bodyparts |= "waggingtail_human"
	update_body()

/mob/living/carbon/human/proc/endTailWag()
	if(!dna || !dna.species)
		return
	if("waggingtail_lizard" in dna.species.mutant_bodyparts)
		dna.species.mutant_bodyparts -= "waggingtail_lizard"
		dna.species.mutant_bodyparts -= "waggingspines"
		dna.species.mutant_bodyparts |= "tail_lizard"
		dna.species.mutant_bodyparts |= "spines"
	if("waggingtail_human" in dna.species.mutant_bodyparts)
		dna.species.mutant_bodyparts -= "waggingtail_human"
		dna.species.mutant_bodyparts |= "tail_human"
	update_body()

/datum/emote/living/carbon/human/wing
	key = "wing"
	key_third_person = "wings"
	message = "their wings."

/datum/emote/living/carbon/human/wing/run_emote(mob/user, params)
	. = ..()
	if(.)
		var/mob/living/carbon/human/H = user
		if(findtext(select_message_type(user), "open"))
			H.OpenWings()
		else
			H.CloseWings()

/datum/emote/living/carbon/human/wing/select_message_type(mob/user)
	. = ..()
	var/mob/living/carbon/human/H = user
	if("wings" in H.dna.species.mutant_bodyparts)
		. = "opens " + message
	else
		. = "closes " + message

/datum/emote/living/carbon/human/wing/can_run_emote(mob/user, status_check = TRUE)
	if(!..())
		return FALSE
	var/mob/living/carbon/human/H = user
	if(H.dna && H.dna.species && (H.dna.features["wings"] != "None"))
		return TRUE

/mob/living/carbon/human/proc/OpenWings()
	if(!dna || !dna.species)
		return
	if("wings" in dna.species.mutant_bodyparts)
		dna.species.mutant_bodyparts -= "wings"
		dna.species.mutant_bodyparts |= "wingsopen"
	update_body()

/mob/living/carbon/human/proc/CloseWings()
	if(!dna || !dna.species)
		return
	if("wingsopen" in dna.species.mutant_bodyparts)
		dna.species.mutant_bodyparts -= "wingsopen"
		dna.species.mutant_bodyparts |= "wings"
	update_body()
	if(isturf(loc))
		var/turf/T = loc
		T.Entered(src)

//Ayy lmao
