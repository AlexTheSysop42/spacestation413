/mob/living/carbon/human/gib_animation()
	new /obj/effect/temp_visual/gib_animation(loc, "gibbed-h")

/mob/living/carbon/human/dust_animation()
	new /obj/effect/temp_visual/dust_animation(loc, "dust-h")

/mob/living/carbon/human/spawn_gibs(with_bodyparts)
	if(dna.species.has_castes)
		if(with_bodyparts)
			switch(dna.features["troll_caste"])
				if("burgundy")
					new /obj/effect/gibspawner/troll/r(get_turf(src), dna, get_static_viruses())
				if("brown")
					new /obj/effect/gibspawner/troll/b(get_turf(src), dna, get_static_viruses())
				if("yellow")
					new /obj/effect/gibspawner/troll/y(get_turf(src), dna, get_static_viruses())
				if("lime")
					new /obj/effect/gibspawner/troll/l(get_turf(src), dna, get_static_viruses())
				if("olive")
					new /obj/effect/gibspawner/troll/o(get_turf(src), dna, get_static_viruses())
				if("jade")
					new /obj/effect/gibspawner/troll/j(get_turf(src), dna, get_static_viruses())
				if("teal")
					new /obj/effect/gibspawner/troll/t(get_turf(src), dna, get_static_viruses())
				if("cerulean")
					new /obj/effect/gibspawner/troll/c(get_turf(src), dna, get_static_viruses())
				if("indigo")
					new /obj/effect/gibspawner/troll/i(get_turf(src), dna, get_static_viruses())
				if("purple")
					new /obj/effect/gibspawner/troll/p(get_turf(src), dna, get_static_viruses())
				if("violet")
					new /obj/effect/gibspawner/troll/v(get_turf(src), dna, get_static_viruses())
				if("fuschia")
					new /obj/effect/gibspawner/troll/f(get_turf(src), dna, get_static_viruses())
		else
			switch(dna.features["troll_caste"])
				if("burgundy")
					new /obj/effect/gibspawner/trollbodypartless/r(get_turf(src), dna, get_static_viruses())
				if("brown")
					new /obj/effect/gibspawner/trollbodypartless/b(get_turf(src), dna, get_static_viruses())
				if("yellow")
					new /obj/effect/gibspawner/trollbodypartless/y(get_turf(src), dna, get_static_viruses())
				if("lime")
					new /obj/effect/gibspawner/trollbodypartless/l(get_turf(src), dna, get_static_viruses())
				if("olive")
					new /obj/effect/gibspawner/trollbodypartless/o(get_turf(src), dna, get_static_viruses())
				if("jade")
					new /obj/effect/gibspawner/trollbodypartless/j(get_turf(src), dna, get_static_viruses())
				if("teal")
					new /obj/effect/gibspawner/trollbodypartless/t(get_turf(src), dna, get_static_viruses())
				if("cerulean")
					new /obj/effect/gibspawner/trollbodypartless/c(get_turf(src), dna, get_static_viruses())
				if("indigo")
					new /obj/effect/gibspawner/trollbodypartless/i(get_turf(src), dna, get_static_viruses())
				if("purple")
					new /obj/effect/gibspawner/trollbodypartless/p(get_turf(src), dna, get_static_viruses())
				if("violet")
					new /obj/effect/gibspawner/trollbodypartless/v(get_turf(src), dna, get_static_viruses())
				if("fuschia")
					new /obj/effect/gibspawner/trollbodypartless/f(get_turf(src), dna, get_static_viruses())
	else
		if(with_bodyparts)
			new /obj/effect/gibspawner/human(get_turf(src), dna, get_static_viruses())
		else
			new /obj/effect/gibspawner/humanbodypartless(get_turf(src), dna, get_static_viruses())

/mob/living/carbon/human/spawn_dust(just_ash = FALSE)
	if(just_ash)
		new /obj/effect/decal/cleanable/ash(loc)
	else
		new /obj/effect/decal/remains/human(loc)

/mob/living/carbon/human/death(gibbed)
	if(stat == DEAD)
		return
	stop_sound_channel(CHANNEL_HEARTBEAT)
	var/obj/item/organ/heart/H = getorganslot(ORGAN_SLOT_HEART)
	if(H)
		H.beat = BEAT_NONE

	. = ..()

	dizziness = 0
	jitteriness = 0

	if(ismecha(loc))
		var/obj/mecha/M = loc
		if(M.occupant == src)
			M.go_out()

	dna.species.spec_death(gibbed, src)

	if(SSticker.HasRoundStarted())
		SSblackbox.ReportDeath(src)
	if(is_devil(src))
		INVOKE_ASYNC(is_devil(src), /datum/antagonist/devil.proc/beginResurrectionCheck, src)

/mob/living/carbon/human/proc/makeSkeleton()
	status_flags |= DISFIGURED
	set_species(/datum/species/skeleton)
	return 1


/mob/living/carbon/proc/Drain()
	become_husk()
	disabilities |= NOCLONE
	blood_volume = 0
	return 1
