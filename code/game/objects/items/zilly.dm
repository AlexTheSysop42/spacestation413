#define HAMMER_BRAIN_DAMAGE 10
#define HAMMER_HALLUCINATION 3

obj/item/zillyhoo_hammer
	name = "Warhammer of Zillyhoo"
	icon = 'icons/obj/homestuck_items.dmi'
	icon_state = "zillyhoo"
	item_state = "zillyhoo"
	lefthand_file = 'icons/mob/inhands/weapons/custom_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/custom_righthand.dmi'
	desc = "A weapon so silly and mirthful that it just makes you want to put a bangin' BONK on things."
	force = 0
	throwforce = 0
	hitsound = null
	throw_speed = 3
	throw_range = 7
	w_class = WEIGHT_CLASS_HUGE
	attack_verb = list("bonked", "bopped", "booped", "bwonked", "bwoinked")
	flags_1 = CONDUCT_1
	var/flip_cooldown = 0

/obj/item/zillyhoo_hammer/proc/flip_mobs(mob/living/carbon/M, mob/user)
	var/turf/T = get_turf(src)
	for(M in ohearers(7, T))
		if(ishuman(M) && M.can_hear())
			var/mob/living/carbon/human/H = M
			if(istype(H.ears, /obj/item/clothing/ears/earmuffs))
				continue
		M.emote("flip")
	flip_cooldown = world.time + 7

obj/item/zillyhoo_hammer/attack()
	playsound(src,'sound/items/bikehorn.ogg', 40,1)
	if(flip_cooldown < world.time)
		flip_mobs()
	return ..()

obj/item/zillyhoo_hammer/attack_self()
	playsound(src,'sound/items/bikehorn.ogg', 40,1)
	if(flip_cooldown < world.time)
		flip_mobs()
	return ..()

//#TRAITOR VERSION

/obj/item/zillyhoo_hammer/retardhammer/attack()
	retardify()
	return ..()

/obj/item/zillyhoo_hammer/retardhammer/attack_self(mob/user)
	retardify()
	..()

/obj/item/zillyhoo_hammer/retardhammer/proc/retardify(mob/living/carbon/M, mob/user)
	var/turf/T = get_turf(src)
	for(M in ohearers(7, T))
		if(ishuman(M) && M.can_hear())
			var/mob/living/carbon/human/H = M
			if(istype(H.ears, /obj/item/clothing/ears/earmuffs))
				continue
		M.adjustBrainLoss(HAMMER_BRAIN_DAMAGE)
		M.hallucination += 3
		log_admin("[key_name(user)] dealt brain damage to [key_name(M)] with the True Warhammer of Zillyhoo")

#undef HAMMER_BRAIN_DAMAGE
#undef HAMMER_HALLUCINATION