/obj/item/clothing/shoes/cluwne
	desc = "The prankster's standard-issue clowning shoes. Damn, they're huge!"
	name = "clown shoes"
	icon = 'icons/obj/clothing/shoes2.dmi'
	alternate_worn_icon = 'icons/mob/feet2.dmi'
	icon_state = "cluwne"
	item_state = "cluwne"
	item_color = "cluwne"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	flags_1 = NODROP_1 | DROPDEL_1
	slowdown = SHOES_SLOWDOWN+1
	var/footstep = 1
	pockets = /obj/item/storage/internal/pocket/shoes/clown

/obj/item/clothing/shoes/cluwne/step_action()
	if(footstep > 1)
		playsound(src, "clownstep", 50, 1)
		footstep = 0
	else
		footstep++

/obj/item/clothing/shoes/cluwne/equipped(mob/user, slot)
	if(!ishuman(user))
		return
	if(slot == slot_shoes)
		var/mob/living/carbon/human/H = user
		H.dna.add_mutation(CLUWNEMUT)
	return