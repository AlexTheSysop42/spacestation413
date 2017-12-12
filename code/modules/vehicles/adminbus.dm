/obj/vehicle/adminbus
	name = "Admin Bus"
	desc = "A short yellow bus that looks reinforced."
	icon = 'icons/obj/vehicles2.dmi'
	icon_state = "adminbus"
	var/nonmoving_state = "adminbus"
	var/moving_state = "adminbus2"
	var/antispam = 0
	rider_visible = 0
	sealed_cabin = 1
	air_recycling = 1
	var/gib_onhit = 0
	var/is_badmin_bus = 0
	var/atom/movable/effect/darkness/darkness
	var/hornspam = 0
	actions_types = list(/datum/action/item_action/loud_horn, /datum/action/item_action/stopthebus)

obj/vehicle/Initialize()
	. = ..()
	add_cabin()

/obj/vehicle/adminbus/Del()
	if(darkness)
		qdel(darkness)
	..()

/obj/vehicle/adminbus/Move()
	if(src.darkness)
		src.darkness.forceMove(src.loc)
		if(prob(3))
			src.do_darkness()

	return ..()

obj/vehicle/adminbus/proc/horn()
	if(hornspam < world.time)
		playsound(src.loc, "sound/items/vuvuzela.ogg", 50, 1)
		hornspam = world.time + 80

obj/vehicle/adminbus/stop()
	..()
	icon_state = nonmoving_state

/obj/vehicle/adminbus/relaymove(mob/user as mob, dir)
	src.overlays = null
	if(rider && user == rider)
		if(istype(src.loc, /turf/open/space))
			src.overlays += icon('icons/mob/robots2.dmi', "up-speed")
		icon_state = moving_state
		walk(src, dir, 1)
		if(antispam < world.time)
			playsound(src, "sound/machines/rev_engine.ogg", 50, 1)
			antispam = world.time + 20
			//play engine sound
	else
		..()
		return

/obj/vehicle/adminbus/bullet_act(flag, A as obj)
	return

/obj/vehicle/adminbus/ex_act(severity)
	return

/atom/movable/effect/darkness
	icon = 'icons/effects/64x64_2.dmi'
	icon_state = "spooky"
	layer = ABOVE_NORMAL_TURF_LAYER
	mouse_opacity = 0
	//blend_mode = BLEND_MULTIPLY

	New()
		src.Scale(9,9)

/obj/vehicle/adminbus/Click()
	if(usr != rider)
		var/mob/M = usr
		if(M.client && M.client.holder && M.loc == src)
			to_chat(M, "<span class='warning'><B>You exit the [src]!</B></span>")
			M.remove_adminbus_powers()
			M.forceMove(src.loc)
			return
		..()
		return
	if(!(usr.IsStun() || usr.IsKnockdown()))
		eject_rider(0, 1)
	return


/obj/vehicle/adminbus/proc/do_darkness()
	if(prob(50))
		playsound(src.loc, 'sound/effects/ghost.ogg', 50, 1)
	else
		playsound(src.loc, 'sound/effects/ghost2.ogg', 50, 1)

	var/list/apcs = bounds(src, 192)
	for(var/obj/machinery/power/apc/apc in apcs)
		if(prob(60))
			apc.overload_lighting()

	if(prob(50))
		new /obj/effect/decal/cleanable/blood/gibs/bubblegum(get_turf(src))

/obj/vehicle/adminbus/proc/toggle_darkness()
	if(src.darkness)
		qdel(src.darkness)
		src.name = "Admin Bus"
		src.desc = "A short yellow bus that looks reinforced."
		src.moving_state = "adminbus2"
		src.nonmoving_state = "adminbus"
		src.is_badmin_bus = 0
	else
		src.name = "Badmin Bus"
		src.desc = "A short bus painted in blood that looks horrifyingly evil."
		src.moving_state = "badminbus2"
		src.nonmoving_state = "badminbus"
		src.is_badmin_bus = 1
		src.darkness = new
		src.darkness.forceMove(src.loc)



/obj/vehicle/adminbus/attack_hand(mob/living/carbon/human/M as mob)
	if(!M || !(M.client && M.client.holder))
		..()
		return
	if(M.dna.check_mutation(HULK))
		if(prob(40))
			to_chat(M, "<span class='warning'><B>You smash the puny [src] apart!</B></span>")
			playsound(src, "shatter", 70, 1)
			playsound(src.loc, "sound/misc/meteorimpact.ogg", 40, 1)


			src.visible_message("<span class='warning'><B>[M] smashes the [src] apart!</B></span>")
			for(var/atom/A in src.contents)
				if(ismob(A))
					var/mob/N = A
					N.forceMove(src.loc)
				else if (isobj(A))
					var/obj/O = A
					O.forceMove(src.loc)
			qdel(src)
		else
			to_chat(M, "<span class='warning'><B>You punch the puny [src]!</B></span>")
			playsound(src.loc, "sound/misc/meteorimpact.ogg", 40, 1)
			src.visible_message("<span class='warning'><B>[M] punches the [src]!</B></span>")
	else
		playsound(src.loc, "sound/machines/click.ogg", 15, 1, -3)
		if(rider && prob(40))
			playsound(src.loc, "sound/weapons/thudswoosh.ogg", 50, 1, -1)
			src.visible_message("<span class='warning'><B>[M] has pulled [rider] out of the [src]!</B></span>")
			rider.Dizzy(20)
			eject_rider()
		else
			if(src.contents.len)
				playsound(src.loc, "sound/weapons/thudswoosh.ogg", 50, 1, -1)
				src.visible_message("<span class='warning'><B>[M] opens up the [src], spilling the contents out!</B></span>")
				for(var/atom/A in src.contents)
					if(ismob(A))
						var/mob/N = A
						if (N != src.rider)
							to_chat(N, "<span class='warning'><B>You are let out of the [src] by [M]!</B></span>")
							N.forceMove(src.loc)
						else
							N.Dizzy(30)
							src.eject_rider()
					else if (isobj(A))
						var/obj/O = A
						O.forceMove(src.loc)
			else
				to_chat(M, "<span class='notice'>There's nothing inside of the [src].</span>")
				return
	return




/obj/vehicle/adminbus/MouseDrop_T(mob/living/carbon/human/target, mob/user)
	if (!istype(target) || target.buckled || get_dist(user, src) > 1 || get_dist(user, target) > 1 || user.IsStun() || user.IsKnockdown() || user.IsUnconscious() || istype(user, /mob/living/silicon/ai))
		return

	var/msg

	if(!(user.client && user.client.holder))
		to_chat(user, "<span class='notice'>You don't feel cool enough to use the [src].</span>")
		return

	if(target == user && !user.stat)	// if drop self, then climbed in


		if(rider)
			msg = "[user.name] climbs into the front of the [src]."
			to_chat(user, "<span class='notice'>You climb into the driver's seat of the [src].</span>")
		else
			rider = target
			msg = "[user.name] climbs into the driver's seat of the [src]."
			to_chat(user, "<span class='notice'>You climb into the driver's seat of the [src].</span>")
			rider.add_adminbus_powers()
			sleep(10)
			for(var/X in actions)
				var/datum/action/A = X
				A.Grant(user)

	else if(target != user && !user.restrained())
		msg = "[user.name] stuffs [target.name] into the back of the [src]!"
		to_chat(user, "<span class='notice'>You stuff [target.name] into the back of the [src]!</span>")
	else
		return

	target.forceMove(src)
	src.visible_message(msg, 3)
	return



/client/proc/toggle_gib_onhit()
	set category = "Adminbus"
	set name = "Toggle Gib On Collision"
	set desc = "Toggle gibbing when colliding with mobs."

	if(usr.stat)
		to_chat(usr, "<span style=\"color:red\">Not when you are incapacitated.</span>")
		return
	if(istype(usr.loc, /obj/vehicle/adminbus))
		var/obj/vehicle/adminbus/bus = usr.loc
		if(bus.gib_onhit)
			bus.gib_onhit = 0
			to_chat(usr, "<span class='warning'>No longer gibbing on collision.</span>")
		else
			bus.gib_onhit = 1
			to_chat(usr, "<span class='warning'>You will now gib mobs on collision. Let's paint the town red!</span>")
	else
		to_chat(usr, "<span class='warning'>Uh-oh, you aren't in the adminbus! Report this.</span>")



/client/proc/toggle_dark_adminbus()
	set category = "Adminbus"
	set name = "Toggle The Darkness"
	set desc = "Activates a cloud of darkness that the adminbus emits. Spooky..."


	if(usr.stat)
		to_chat(usr, "<span class='warning'>Not when you are incapacitated.</span>")
		return
	if(istype(usr.loc, /obj/vehicle/adminbus))
		var/obj/vehicle/adminbus/bus = usr.loc
		bus.toggle_darkness()
	else
		to_chat(usr, "<span class='warning'>Uh-oh, you aren't in the adminbus! Report this.</span>")


/mob/proc/add_adminbus_powers()
	if(src.client.holder && src.client.holder.rank)
		src.verbs += /client/proc/toggle_gib_onhit
		src.verbs += /client/proc/toggle_dark_adminbus
	return


/mob/proc/remove_adminbus_powers()
	src.verbs -= /client/proc/toggle_gib_onhit
	src.verbs -= /client/proc/toggle_dark_adminbus
	return

/obj/vehicle/adminbus/attackby(var/obj/item/I, var/mob/user)
	if(!(user.client && user.client.holder))
		to_chat(user, "<span style=\"color:blue\">You don't feel cool enough to use the [src].</span>")
		return
/*
	var/obj/item/grab/G = I
	if(istype(G))	// handle grabbed mob
		if(ismob(G.affecting))
			var/mob/GM = G.affecting
			GM.set_loc(src)
			boutput(user, "<span style=\"color:blue\">You stuff [GM.name] into the back of the [src].</span>")
			boutput(GM, "<span style=\"color:red\"><B>[user] stuffs you into the back of the [src]!</B></span>")
			for (var/mob/C in AIviewers(src))
				if(C == user)
					continue
				C.show_message("<span style=\"color:red\"><B>[GM.name] has been stuffed into the back of the [src] by [user]!</B></span>", 3)
			qdel(G)
			return*/
	..()
	return


/obj/vehicle/adminbus/Bump(atom/AM as mob|obj|turf)
	if(in_bump)
		return
	if(AM == rider || !rider)
		return
	if(!is_badmin_bus && world.timeofday - AM.last_bumped <= 100)
		return
	if(is_badmin_bus && world.timeofday - AM.last_bumped <= 50)
		return
	walk(src, 0)
	icon_state = nonmoving_state
	..()
	in_bump = 1
	if(isturf(AM))
		if(istype(AM, /turf/closed/wall/r_wall) && prob(40))
			in_bump = 0
			return
		if(istype(AM, /turf/closed/wall))
			var/turf/closed/wall/T = AM
			T.dismantle_wall(1)
			playsound(src.loc, "sound/misc/meteorimpact.ogg", 40, 1)
			playsound(src, "sound/misc/meteorimpact.ogg", 40, 1)
			to_chat(rider, "<span style=\"color:red\"><B>You crash through the wall!</B></span>")
			for(var/mob/C in viewers(src))
				shake_camera(C, 10, 4)
				if(C == rider)
					continue
				C.show_message("<span style=\"color:red\"><B>The [src] crashes through the wall!</B></span>", 1)
			in_bump = 0
			return
	if(isliving(AM))
		var/mob/living/M = AM
		to_chat(rider, "<span style=\"color:red\"><B>You crash into [M]!</B></span>")
		for (var/mob/C in viewers(src))
			shake_camera(C, 8, 3)
			if(C == rider)
				continue
			C.visible_message("<span style=\"color:red\"><B>The [src] crashes into [M]!</B></span>", 1)
		if(src.gib_onhit)
			M.gib()
		else
			M.Knockdown(160)
			M.adjustStaminaLoss(70)
			var/turf/target = get_edge_target_turf(src, src.dir)
			spawn(0)
				M.throw_at(target, 10, 2)
		playsound(src.loc, "sound/misc/meteorimpact.ogg", 40, 1)
		playsound(src, "sound/misc/meteorimpact.ogg", 40, 1)
		in_bump = 0
		return
	if(isobj(AM))
		var/obj/O = AM
		if(O.density)
			to_chat(rider, "<span style=\"color:red\"><B>You crash into [O]!</B></span>")
			for (var/mob/C in viewers(src))
				shake_camera(C, 8, 3)
				if(C == rider)
					continue
				C.show_message("<span style=\"color:red\"><B>The [src] crashes into [O]!</B></span>", 1)
			var/turf/target = get_edge_target_turf(src, src.dir)
			playsound(src.loc, "sound/misc/meteorimpact.ogg", 40, 1)
			playsound(src, "sound/misc/meteorimpact.ogg", 40, 1)
			O.throw_at(target, 10, 2)
			if(istype(O, /obj/structure/window) || istype(O, /obj/structure/grille) || istype(O, /obj/machinery/door) || istype(O, /obj/structure/girder) || istype(O, /obj/structure/foamedmetal))
				qdel(O)
			if(istype(O, /mob/living/simple_animal/))
				var/mob/living/simple_animal/A = O
				A.gib()
			if(!isnull(O) && is_badmin_bus)
				O:ex_act(2)
			in_bump = 0
			return
	in_bump = 0
	return

/obj/vehicle/adminbus/eject_rider(var/crashed, var/selfdismount)
	rider.forceMove(src.loc)
	rider.remove_adminbus_powers()
	for(var/X in actions)
		var/datum/action/A = X
		A.Remove(rider)
	walk(src, 0)
	if(crashed)
		if(crashed == 2)
			playsound(src.loc, "sound/misc/meteorimpact.ogg", 40, 1)
		playsound(src.loc, "shatter", 40, 1)
		to_chat(rider, "<span style=\"color:red\"><B>You are flung through the [src]'s windshield!</B></span>")
		rider.Knockdown(100)
		rider.adjustStaminaLoss(40)
		src.visible_message("<span class='warning'><B>[rider] is flung through the [src]'s windshield!</B></span>", 1)
		var/turf/target = get_edge_target_turf(src, src.dir)
		rider.throw_at(target, 5, 1)
		rider.buckled = null
		rider = null
		icon_state = nonmoving_state
		if(prob(40) && src.contents.len)
			src.visible_message("<span class='warning'><B>Everything in the [src] flies out!</B></span>")
			for(var/atom/A in src.contents)
				if(ismob(A))
					var/mob/N = A
					N.show_message(text("<span class='warning'><B>You are flung out of the []!</B></span>", src), 1)
					N.forceMove(src.loc)
				else if (isobj(A))
					var/obj/O = A
					O.forceMove(src.loc)

		if(is_badmin_bus)
			toggle_darkness()
		return
	if(selfdismount)
		if(is_badmin_bus)
			toggle_darkness()
		to_chat(rider, "<span class='notice'>You climb out of the [src].</span>")
		rider.visible_message("<B>[rider]</B> climbs out of the [src].", 1)
	rider.buckled = null
	rider = null
	icon_state = nonmoving_state
	return


