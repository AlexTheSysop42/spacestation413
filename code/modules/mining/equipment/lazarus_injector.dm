/**********************Lazarus Injector**********************/
/obj/item/lazarus_injector
	name = "lazarus injector"
	desc = "An injector with a cocktail of nanomachines and chemicals, this device can seemingly raise animals from the dead, making them become friendly to the user. Unfortunately, the process is useless on higher forms of life and incredibly costly, so these were hidden in storage until an executive thought they'd be great motivation for some of their employees."
	icon = 'icons/obj/syringe.dmi'
	icon_state = "lazarus_hypo"
	item_state = "hypo"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	throwforce = 0
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 3
	throw_range = 5
	var/loaded = 1
	var/malfunctioning = 0
	var/revive_type = SENTIENCE_ORGANIC //So you can't revive boss monsters or robots with it

/obj/item/lazarus_injector/afterattack(atom/target, mob/user, proximity_flag)
	if(!loaded)
		return
	if(isliving(target) && proximity_flag)
		if(isanimal(target))
			var/mob/living/simple_animal/M = target
			if(M.sentience_type != revive_type)
				to_chat(user, "<span class='info'>[src] does not work on this sort of creature.</span>")
				return
			if(M.stat == DEAD)
				M.faction = list()
				M.revive(full_heal = 1, admin_revive = 1)
				if(ishostile(target))
					var/mob/living/simple_animal/hostile/H = M
					H.attack_same = 0
					H.friends += user
					H.robust_searching = 1
					if(malfunctioning)
						H.faction |= list("lazarus", "[REF(user)]")
						log_game("[user] has revived hostile mob [target] with a malfunctioning lazarus injector")
					else
						H.faction |= list("neutral")
				else
					M.faction |= list("neutral")
				loaded = 0
				user.visible_message("<span class='notice'>[user] injects [M] with [src], reviving it.</span>")
				SSblackbox.record_feedback("tally", "lazarus_injector", 1, M.type)
				playsound(src,'sound/effects/refill.ogg',50,1)
				icon_state = "lazarus_empty"
				return
			else
				to_chat(user, "<span class='info'>[src] is only effective on the dead.</span>")
				return
		else
			to_chat(user, "<span class='info'>[src] is only effective on lesser beings.</span>")
			return

/obj/item/lazarus_injector/emp_act()
	if(!malfunctioning)
		malfunctioning = 1

/obj/item/lazarus_injector/examine(mob/user)
	..()
	if(!loaded)
		to_chat(user, "<span class='info'>[src] is empty.</span>")
	if(malfunctioning)
		to_chat(user, "<span class='info'>The display on [src] seems to be flickering.</span>")


/*********************Mob Capsule*************************/
// ported from /vg/station by Difarem, december 2017

/obj/item/device/mobcapsule
	name = "lazarus capsule"
	var/base_name = "lazarus capsule"
	desc = "It allows you to store and deploy lazarus-injected creatures easier."
	icon = 'icons/obj/mobcap.dmi'
	icon_state = "mobcap0_empty"
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	throw_speed = 4
	throw_range = 20
	force = 0
	materials = list(MAT_METAL = 100)
	var/storage_capacity = 1
	var/tripped = 0
	var/colorindex = 0

	var/mob/living/capsuleowner = null
	var/mob/contained_mob

	var/template_id = "capsule_regular"
	var/datum/map_template/mobcapsule/template
	var/turf/interior_location
	var/obj/machinery/computer/security/mobcapsule/capsule_monitor

/obj/item/device/mobcapsule/proc/get_template()
	if(template)
		return
	template = SSmapping.capsule_templates[template_id]
	if(!template)
		throw EXCEPTION("Capsule template ([template_id]) not found!")
		qdel(src)

/obj/item/device/mobcapsule/proc/create_interior()
	get_template()

	for(var/i = 0; i <= 20; i++) // 20 tries
		var/width_border = TRANSITIONEDGE + round(template.width / 2)
		var/height_border = TRANSITIONEDGE + round(template.height / 2)
		var/z_level = ZLEVEL_BLUESPACE
		var/turf/T = locate(rand(width_border, world.maxx - width_border), rand(height_border, world.maxy - height_border), z_level)
		var/valid = TRUE

		for(var/turf/check in template.get_affected_turfs(T, 1))
			var/area/new_area = get_area(check)
			if(!istype(new_area, /area/space))
				valid = FALSE
				break

		if(valid)
			template.load(T, centered = TRUE) // HERE
			log_world("Lazarus capsule interior placed at ([T.x], [T.y], [T.z])")
			interior_location = T

			for(var/object in T.loc.contents)
				if(istype(object, /obj/machinery/computer/security/mobcapsule))
					capsule_monitor = object
					capsule_monitor.capsule = src

			if(!capsule_monitor)
				throw EXCEPTION("could not find monitor inside capsule!")

			return

	throw EXCEPTION("COULD NOT PLACE CAPSULE INTERIOR")

/obj/item/device/mobcapsule/Destroy()
	template = null
	if(contained_mob)
		dump_contents()
		new /obj/effect/particle_effect/smoke(get_turf(src))
	if(interior_location)
		qdel(interior_location.loc)
	. = ..()

/obj/item/device/mobcapsule/attackby(obj/item/W, mob/user, params)
	if(!contained_mob)
		return

	if(istype(W, /obj/item/pen))
		if(user != capsuleowner)
			to_chat(user, "<span class='warning'>\The [src] briefly flashes an error.</span>")
			return 0
		spawn()
			var/mname = sanitize(input("Choose a name for your friend.", "Name your friend", contained_mob.name) as text|null)
			if(mname)
				contained_mob.name = mname
				to_chat(user, "<span class='notice'>Renaming successful, say hello to [contained_mob]!</span>")
				name = "[base_name] - [mname]"
	else if(istype(W, /obj/item/device/healthanalyzer))
		var/obj/item/device/healthanalyzer/HA = W
		healthscan(user, contained_mob, HA.mode, HA.advanced)
	..()

/obj/item/device/mobcapsule/attack_self(mob/user)
	colorindex += 1
	if(colorindex >= 6)
		colorindex = 0
	update_icon()

/obj/item/device/mobcapsule/update_icon()
	icon_state = "mobcap[colorindex]"
	if(!contained_mob)
		icon_state = "[icon_state]_empty"
	..()

/obj/item/device/mobcapsule/pickup(mob/user)
	tripped = 0
	capsuleowner = user

/obj/item/device/mobcapsule/throw_impact(atom/target, datum/thrownthing/throwinfo)
	if(!tripped)
		if(contained_mob)
			dump_contents(throwinfo.thrower)
			tripped = 1
		else
			take_contents(target, throwinfo.thrower)
			tripped = 1
	..()

/obj/item/device/mobcapsule/proc/dump_contents(mob/user)
	if(contained_mob)
		var/turf/turf = get_turf(src)
		contained_mob.forceMove(turf)

		log_attack("[key_name(user)] has released hostile mob [contained_mob] with a capsule in area [turf.loc] ([x],[y],[z]).")
		//contained_mob.attack_log += "\[[time_stamp()]\] Released by <b>[key_name(user)]</b> in area [turf.loc] ([x],[y],[z])."
		//user.attack_log += "\[[time_stamp()]\] Released hostile mob <b>[contained_mob]</b> in area [turf.loc] ([x],[y],[z])."
		//msg_admin_attack("[key_name(user)] has released hostile mob [contained_mob] with a capsule in area [turf.loc] ([x],[y],[z]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</A>).")

		contained_mob = null
		name = base_name
		update_icon()

/obj/item/device/mobcapsule/proc/take_contents(atom/target, mob/user)
	var/mob/living/simple_animal/AM = target
	if(istype(AM))
		var/mob/living/simple_animal/M = AM
		var/mob/living/simple_animal/hostile/H = M
		if(istype(H))
			for(var/things in H.friends)
				if(capsuleowner in H.friends)
					if(insert(AM) == -1) //Limit reached
						break

/obj/item/device/mobcapsule/proc/insert(atom/movable/AM)
	if(contained_mob)
		return -1

	if(AM == capsuleowner)
		return -1 // don't capture yourself, that'd be stupid

	if(istype(AM, /mob/living))
	else if(!istype(AM, /obj/item) && !istype(AM, /obj/effect/dummy/chameleon))
		return 0
	else if(AM.density || AM.anchored)
		return 0

	if(!interior_location)
		create_interior()

	AM.forceMove(interior_location)
	contained_mob = AM
	name = "[base_name] - [AM.name]"
	update_icon()
	return 1

/obj/item/device/mobcapsule/proc/fill_random(mob/living/owner, friendly = 1)
	if(contained_mob)
		return

	var/static/blocked = list()
	var/static/list/critters // list of possible hostile mobs

	if(!critters)
		critters = subtypesof(/mob/living/simple_animal/hostile) - blocked
		critters = shuffle(critters)

	var/mob/living/simple_animal/hostile/chosen
	do
		chosen = pick(critters)
	while(initial(chosen.gold_core_spawnable) != HOSTILE_SPAWN)

	var/mob/living/simple_animal/hostile/NM = new chosen(src)

	NM.attack_same = 0
	if(!friendly)
		NM.faction |= list("lazarus", "[REF(owner)]")
		NM.robust_searching = 1
		NM.friends += owner
	else
		NM.faction |= list("neutral")

	insert(NM)
	capsuleowner = owner

/obj/item/device/mobcapsule/masterball
	name = "\improper Master Capsule"
	base_name = "\improper Master Capsule"
	desc = "A legendary capsule that allows you to store and deploy ANY type of creature."

/obj/item/device/mobcapsule/masterball/throw_impact(atom/movable/target, datum/thrownthing/throwinfo)
	if(!tripped)
		if(contained_mob)
			dump_contents(throwinfo.thrower)
			tripped = 1
		else
			insert(target)
			tripped = 1
	..()
