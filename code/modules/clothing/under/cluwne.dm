/obj/item/clothing/under/cluwne
	name = "clown suit"
	desc = "<i>'HONK!'</i>"
	icon = 'icons/obj/clothing/uniforms2.dmi'
	alternate_screams = list('sound/voice/cluwnelaugh1.ogg','sound/voice/cluwnelaugh2.ogg','sound/voice/cluwnelaugh3.ogg')
	alternate_worn_icon = 'icons/mob/uniform2.dmi'
	icon_state = "cluwne"
	item_state = "cluwne"
	item_color = "cluwne"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	flags_1 = NODROP_1 | DROPDEL_1
	can_adjust = 0

/obj/item/clothing/under/cluwne/equipped(mob/living/carbon/user, slot)
	if(!ishuman(user))
		return
	if(slot == slot_w_uniform)
		var/mob/living/carbon/human/H = user
		H.dna.add_mutation(CLUWNEMUT)
		H.reindex_screams()
	return ..()