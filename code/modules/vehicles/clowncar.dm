/obj/vehicle/clowncar
	name = "Clown Car"
	icon = 'icons/obj/vehicles2.dmi'
	desc = "A funny-looking car designed for circus events. Seats 30, very roomy!"
	icon_state = "clowncar"
	var/antispam = 0
	var/moving = 0
	var/honkspam = 0
	actions_types = list(/datum/action/item_action/honk_horn)

/obj/vehicle/clowncar/relaymove(mob/user as mob, dir)
	if(rider && user == rider)
		if(istype(src.loc, /turf/open/space))
			return
		icon_state = "clowncar2"
		walk(src, dir, 2)
		moving = 1

		if(antispam < world.time)
			playsound(src, "sound/machines/rev_engine.ogg", 50, 1)
			antispam = world.time + 20
	else
		..()
		return

/obj/vehicle/clowncar/Click()
	if(usr != rider)
		..()
		return
	if(!(usr.IsStun() || usr.IsKnockdown()))
		eject_rider(0, 1)
	return

/obj/vehicle/clowncar/attack_hand(mob/living/carbon/human/M as mob)
	if(!M)
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

/obj/vehicle/clowncar/MouseDrop_T(mob/living/carbon/human/target, mob/user)
	if (!istype(target) || target.buckled || get_dist(user, src) > 1 || get_dist(user, target) > 1 || user.IsStun() || user.IsKnockdown() || user.IsUnconscious() || istype(user, /mob/living/silicon/ai))
		return

	var/msg

	var/clown_tally = 0
	if(ishuman(user))
		if(istype(user:w_uniform, /obj/item/clothing/under/rank/clown))
			clown_tally += 1
		if(istype(user:shoes, /obj/item/clothing/shoes/clown_shoes))
			clown_tally += 1
		if(istype(user:wear_mask, /obj/item/clothing/mask/gas/clown_hat))
			clown_tally += 1
	if(clown_tally < 2)
		to_chat(user, "<span class='notice'>You don't feel funny enough to use the [src].</span>")
		return

	if(target == user && !user.stat)	// if drop self, then climbed in
		if(rider)
			return
		rider = target
		msg = "[user.name] climbs into the driver's seat of the [src]."
		to_chat(user, "<span class='notice'>You climb into the driver's seat of the [src].</span>")
		for(var/X in actions)
			var/datum/action/A = X
			A.Grant(user)
	else if(target != user && !user.restrained() && target.lying)
		msg = "[user.name] stuffs [target.name] into the back of the [src]!"
		to_chat(user, "<span class='notice'>You stuff [target.name] into the back of the [src]!</span>")
	else
		return

	target.forceMove(src)
	src.visible_message(msg, 3)
	return

/obj/vehicle/clowncar/Bump(atom/AM as mob|obj|turf)
	if(in_bump)
		return
	if(AM == rider || !rider)
		return
	if(world.timeofday - AM.last_bumped <= 100)
		return
	walk(src, 0)
	moving = 0
	icon_state = "clowncar"
	..()
	in_bump = 1
	playsound(src, 'sound/items/bikehorn.ogg', 50, 1)
	if(isturf(AM) || isstructure(AM) || istype(AM, /obj/machinery/door))
		to_chat(rider, "<span class='warning'><B>You crash into the wall!</B></span>")
		src.visible_message("<span class='warning'><B>[rider] crashes into the wall with the [src]!</B></span>", 1)
		eject_rider(2)
		in_bump = 0
		if (istype(AM, /obj/machinery/door/airlock))
			var/obj/machinery/door/airlock/D = AM
			D.bumpopen(rider)
		else if (istype(AM, /obj/structure/window))
			var/obj/structure/window/W = AM
			W.take_damage(100)
		return
	if(ismob(AM))
		message_admins("Bumped [AM] and gonna bowl 'em over.")
		log_admin("Bumped [AM] and gonna bowl 'em over.")
		bumpstun(AM)

//		eject_rider(2)
		in_bump = 0
		return
	/*
	if(istype(AM, /obj/vehicle/segway))
		var/obj/vehicle/segway/SG = AM
		if(SG.rider)
			SG.in_bump = 1
			var/mob/M = SG.rider
			var/mob/N = rider
			to_chat(N, "<span class='warning'><B>You crash into [M]'s [SG]!</B></span>")
			to_chat(M, "<span class='warning'>\"><B>[N] crashes into your [SG]!</B></span>")
			for (var/mob/C in AIviewers(src))
				if(C == N || C == M)
					continue
				C.visible_message("<span class='warning'><B>[N] crashes into [M]'s [SG]!</B></span>", 1)
			SG.eject_rider(1)
			in_bump = 0
			SG.in_bump = 0
			return*/
	in_bump = 0
	return

/obj/vehicle/clowncar/Bumped(var/atom/movable/AM as mob|obj)
	if (moving && ismob(AM)) //If we're moving and they're in front of us then bump they
		walk(src, 0)
		moving = 0
		bumpstun(AM)

	..()

/obj/vehicle/clowncar/proc/bumpstun(var/mob/living/M)
	if(istype(M))
		to_chat(rider, "<span class='warning'><B>You crash into [M]!</B></span>")
		M.visible_message("<span style=\"color:red\"><B>[rider] crashes into [M] with the [src]!</B></span>", 1)
		/*
		var/turf/target = get_edge_target_turf(src, src.dir)  //Throwing people around = more fun but makes the car worse as a traitor item because its harder to stuff people inside
		M.throw_at(target, 5, 1)*/
		M.Knockdown(100)
		M.adjustStaminaLoss(40)
		playsound(src.loc, "sound/misc/meteorimpact.ogg", 40, 1)

/obj/vehicle/clowncar/bullet_act(flag, A as obj)
	if (src.rider && ismob(src.rider) && prob(30))
		src.rider.bullet_act(flag, A)
		src.eject_rider(1)
	return

obj/vehicle/clowncar/proc/honk()
	if(honkspam < world.time)
		playsound(src.loc, "sound/effects/honk_hazzard.ogg", 15, 1)
		honkspam = world.time + 80


/obj/vehicle/clowncar/eject_rider(var/crashed, var/selfdismount)
	if (!src.rider || !ismob(src.rider))
		return
	rider.forceMove(src.loc)
	walk(src, 0)
	moving = 0
	if(crashed)
		if(crashed == 2)
			playsound(src.loc, "sound/misc/meteorimpact.ogg", 40, 1)
		playsound(src.loc, "shatter", 40, 1)
		to_chat(rider, "<span class='warning'><B>You are flung through the [src]'s windshield!</B></span>")
		rider.Knockdown(100)
		rider.adjustStaminaLoss(40)
		src.visible_message("<span class='warning'><B>[rider] is flung through the [src]'s windshield!</B></span>", 1)
		var/turf/target = get_edge_target_turf(src, src.dir)
		rider.throw_at(target, 5, 1)
		rider.buckled = null
		rider = null
		icon_state = "clowncar"
		if(prob(40) && src.contents.len)
			src.visible_message("<span class='warning'><B>Everything in the [src] flies out!</B></span>", 1)
			for(var/atom/A in src.contents)
				if(ismob(A))
					var/mob/N = A
					to_chat(N, "<span class='warning'><B>You are flung out of the [src]!</B></span>", 1)
					N.forceMove(src.loc)
				else if (isobj(A))
					var/obj/O = A
					O.forceMove(src.loc)
		return
	if(selfdismount)
		to_chat(rider, "<span class='notice'>You climb out of the [src].</span>")
		rider.visible_message("<B>[rider]</B> climbs out of the [src].", 1)
	for(var/X in actions)
		var/datum/action/A = X
		A.Remove(rider)
	rider.buckled = null
	rider = null
	icon_state = "clowncar"
	return

/obj/vehicle/clowncar/attackby(var/obj/item/I, var/mob/user)
	var/clown_tally = 0
	if(ishuman(user))
		if(istype(user:w_uniform, /obj/item/clothing/under/rank/clown))
			clown_tally += 1
		if(istype(user:shoes, /obj/item/clothing/shoes/clown_shoes))
			clown_tally += 1
		if(istype(user:wear_mask, /obj/item/clothing/mask/gas/clown_hat))
			clown_tally += 1
	if(clown_tally < 2)
		to_chat(user, "<span class='notice'>You don't feel funny enough to use the [src].</span>")
		return
/*
	var/obj/item/grab/G = I
	if(istype(G))	// handle grabbed mob
		if(ismob(G.affecting))
			var/mob/GM = G.affecting
			GM.forceMove(src)
			to_chat(user, "<span class='notice'>You stuff [GM.name] into the back of the [src].</span>")
			to_chat(GM, "<span class='warning'><B>[user] stuffs you into the back of the [src]!</B></span>")
			src.log_me(user, GM, "pax_enter", 1)
			src.visible_message("<span class='warning'><B>[GM.name] has been stuffed into the back of the [src] by [user]!</B></span>", 3)
			qdel(G)
			return*/
	..()
	return

// Could be useful, I guess (Convair880).
/*obj/vehicle/clowncar/proc/log_me(var/mob/rider, var/mob/pax, var/action = "", var/forced_in = 0)
	if (!src || action == "")
		return

	switch (action)
		if ("rider_enter", "rider_exit")
			if (rider && ismob(rider))
				logTheThing("vehicle", rider, null, "[action == "rider_enter" ? "starts driving" : "stops driving"] [src.name] at [log_loc(src)].")

		if ("pax_enter", "pax_exit")
			if (pax && ismob(pax))
				logTheThing("vehicle", pax, rider && ismob(rider) ? rider : null, "[action == "pax_enter" ? "is stuffed into" : "is ejected from"] [src.name] ([forced_in == 1 ? "Forced by" : "Driven by"]: [rider && ismob(rider) ? "%target%" : "N/A or unknown"]) at [log_loc(src)].")

	return*/

/obj/vehicle/clowncar/cluwne
	name = "cluwne car"
	desc = "A hideous-looking piece of shit on wheels. You probably shouldn't drive this."
	icon_state = "cluwnecar"

/obj/vehicle/clowncar/cluwne/Move()
	if(..())
		if(prob(2) && rider)
			eject_rider(1)
		pixel_x = rand(-6, 6)
		pixel_y = rand(-2, 2)
		spawn(1)
			pixel_x = rand(-6, 6)
			pixel_y = rand(-2, 2)

/obj/vehicle/clowncar/cluwne/relaymove(mob/user as mob, dir)
	..(user, dir)
	if(rider && user == rider)
		icon_state = "cluwnecar2"

/obj/vehicle/clowncar/cluwne/attackby(var/obj/item/W, var/mob/user)
	eject_rider()
	W.attack(rider, user)

/obj/vehicle/clowncar/cluwne/eject_rider(var/crashed, var/selfdismount)
	..(crashed, selfdismount)
	icon_state = "cluwnecar"
	pixel_x = 0
	pixel_y = 0

/obj/vehicle/clowncar/cluwne/Bump(atom/AM as mob|obj|turf)
	..(AM)
	icon_state = "cluwnecar"
	pixel_x = 0
	pixel_y = 0

/obj/vehicle/clowncar/cluwne/MouseDrop_T(mob/living/carbon/human/target, mob/user)
	if (!istype(target) || target.buckled || get_dist(user, src) > 1 || get_dist(user, target) > 1 || user.IsStun() || user.IsKnockdown() || user.IsUnconscious() || istype(user, /mob/living/silicon/ai))
		return

	var/msg
	var/isCluwne = FALSE
	if (istype(user, /mob/living/carbon)) //bleh typecast to check for cluwneing
		var/mob/living/carbon/M = user
		if (M.dna && M.dna.check_mutation(CLUWNEMUT))
			isCluwne = TRUE


	if(!user.mind || !isCluwne)
		to_chat(user, "<span class='warning'>You think it's a REALLY bad idea to use the [src].</span>")
		return

	if(target == user && !user.stat)	// if drop self, then climbed in
		if(rider)
			return
		rider = target
		msg = "[user.name] climbs into the driver's seat of the [src]."
		to_chat(user, "<span class='notice'>You climb into the driver's seat of the [src].</span>")
	else
		return

	target.forceMove(src)

	src.visible_message(msg, 3)
	return