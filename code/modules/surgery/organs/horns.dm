/obj/item/organ/horns
	name = "horns"
	desc = "Whoever these belonged to must be feeling a lot less horny now."
	zone = "head"
	slot = ORGAN_SLOT_HORNS
	gender = PLURAL

/obj/item/organ/horns/troll
	name = "troll horns"
	var/horn_type = "Nubby"

/obj/item/organ/horns/troll/New(var/location)
	..()
	update_horn_icon()

/obj/item/organ/horns/troll/proc/update_horn_icon()
	var/datum/sprite_accessory/S = GLOB.troll_horns_list[horn_type]
	if(S)
		icon = S.icon
		icon_state = S.icon_state

/obj/item/organ/horns/troll/Insert(mob/living/carbon/human/H, special = 0, drop_if_replaced = TRUE)
	..()
	H.dna.features["horns_troll"] = horn_type
	H.update_hair()

/obj/item/organ/horns/troll/Remove(mob/living/carbon/human/H,  special = 0)
	..()
	horn_type = H.dna.features["horns_troll"]
	update_horn_icon()
	H.dna.features["horns_troll"] = "None"
	H.update_hair()
