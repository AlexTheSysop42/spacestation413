// HORN REMOVAL

/datum/surgery/horn_removal
	name = "horn removal"
	steps = list(/datum/surgery_step/saw/horns)
	species = list(/mob/living/carbon/human)
	possible_locs = list("head")

/datum/surgery/horn_removal/can_start(mob/user, mob/living/carbon/target)
	var/mob/living/carbon/human/L = target
	if(L.dna.features["horns_troll"] && L.dna.features["horns_troll"] != "None")
		return 1
	return 0

/datum/surgery_step/saw/horns
	..()
	name = "saw horns off"

/datum/surgery_step/saw/horns/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("[user] begins to saw [target]'s horns off.",
		"<span class='notice'>You begin to saw [target]'s horns off...</span>")

/datum/surgery_step/saw/horns/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	target.apply_damage(50, BRUTE, "[target_zone]")

	user.visible_message("[user] saws [target]'s horns off!",
		"<span class='notice'>You saw [target]'s horns off.</span>")

	var/obj/item/organ/horns/troll/H = new(get_turf(target))
	var/mob/living/carbon/human/L = target
	H.Remove(L)
	return 1
