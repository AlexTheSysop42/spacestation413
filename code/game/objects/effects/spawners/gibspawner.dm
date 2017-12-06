
/obj/effect/gibspawner
	var/sparks = 0 //whether sparks spread
	var/virusProb = 20 //the chance for viruses to spread on the gibs
	var/list/gibtypes = list() //typepaths of the gib decals to spawn
	var/list/gibamounts = list() //amount to spawn for each gib decal type we'll spawn.
	var/list/gibdirections = list() //of lists of possible directions to spread each gib decal type towards.

/obj/effect/gibspawner/Initialize(mapload, datum/dna/MobDNA, list/datum/disease/diseases)
	. = ..()

	if(gibtypes.len != gibamounts.len || gibamounts.len != gibdirections.len)
		to_chat(world, "<span class='danger'>Gib list length mismatch!</span>")
		return

	var/obj/effect/decal/cleanable/blood/gibs/gib = null

	if(sparks)
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(2, 1, loc)
		s.start()

	for(var/i = 1, i<= gibtypes.len, i++)
		if(gibamounts[i])
			for(var/j = 1, j<= gibamounts[i], j++)
				var/gibType = gibtypes[i]
				gib = new gibType(loc, diseases)
				if(iscarbon(loc))
					var/mob/living/carbon/digester = loc
					digester.stomach_contents += gib

				if(MobDNA)
					gib.blood_DNA[MobDNA.unique_enzymes] = MobDNA.blood_type
				else if(istype(src, /obj/effect/gibspawner/generic)) // Probably a monkey
					gib.blood_DNA["Non-human DNA"] = "A+"
				var/list/directions = gibdirections[i]
				if(isturf(loc))
					if(directions.len)
						gib.streak(directions)

	return INITIALIZE_HINT_QDEL



/obj/effect/gibspawner/generic
	gibtypes = list(/obj/effect/decal/cleanable/blood/gibs, /obj/effect/decal/cleanable/blood/gibs, /obj/effect/decal/cleanable/blood/gibs/core)
	gibamounts = list(2,2,1)

/obj/effect/gibspawner/generic/Initialize()
	playsound(src, 'sound/effects/blobattack.ogg', 40, 1)
	gibdirections = list(list(WEST, NORTHWEST, SOUTHWEST, NORTH),list(EAST, NORTHEAST, SOUTHEAST, SOUTH), list())
	. = ..()

/obj/effect/gibspawner/human
	gibtypes = list(/obj/effect/decal/cleanable/blood/gibs/up, /obj/effect/decal/cleanable/blood/gibs/down, /obj/effect/decal/cleanable/blood/gibs, /obj/effect/decal/cleanable/blood/gibs, /obj/effect/decal/cleanable/blood/gibs/body, /obj/effect/decal/cleanable/blood/gibs/limb, /obj/effect/decal/cleanable/blood/gibs/core)
	gibamounts = list(1,1,1,1,1,1,1)

/obj/effect/gibspawner/human/Initialize()
	playsound(src, 'sound/effects/blobattack.ogg', 50, 1)
	gibdirections = list(list(NORTH, NORTHEAST, NORTHWEST),list(SOUTH, SOUTHEAST, SOUTHWEST),list(WEST, NORTHWEST, SOUTHWEST),list(EAST, NORTHEAST, SOUTHEAST), GLOB.alldirs, GLOB.alldirs, list())
	. = ..()


/obj/effect/gibspawner/humanbodypartless //only the gibs that don't look like actual full bodyparts (except torso).
	gibtypes = list(/obj/effect/decal/cleanable/blood/gibs, /obj/effect/decal/cleanable/blood/gibs/core, /obj/effect/decal/cleanable/blood/gibs, /obj/effect/decal/cleanable/blood/gibs/core, /obj/effect/decal/cleanable/blood/gibs, /obj/effect/decal/cleanable/blood/gibs/torso)
	gibamounts = list(1, 1, 1, 1, 1, 1)

/obj/effect/gibspawner/humanbodypartless/Initialize()
	playsound(src, 'sound/effects/blobattack.ogg', 50, 1)
	gibdirections = list(list(NORTH, NORTHEAST, NORTHWEST),list(SOUTH, SOUTHEAST, SOUTHWEST),list(WEST, NORTHWEST, SOUTHWEST),list(EAST, NORTHEAST, SOUTHEAST), GLOB.alldirs, list())
	. = ..()

/obj/effect/gibspawner/troll
	gibamounts = list(1,1,1,1,1,1,1)

/obj/effect/gibspawner/troll/Initialize(caste)
	playsound(src, 'sound/effects/blobattack.ogg', 50, 1)
	gibdirections = list(list(NORTH, NORTHEAST, NORTHWEST),list(SOUTH, SOUTHEAST, SOUTHWEST),list(WEST, NORTHWEST, SOUTHWEST),list(EAST, NORTHEAST, SOUTHEAST), GLOB.alldirs, GLOB.alldirs, list())
	.=..()

/obj/effect/gibspawner/troll/r
	gibtypes=list(/obj/effect/decal/cleanable/blood/gibs/up/troll_r, /obj/effect/decal/cleanable/blood/gibs/down/troll_r, /obj/effect/decal/cleanable/blood/gibs/troll_r, /obj/effect/decal/cleanable/blood/gibs/troll_r, /obj/effect/decal/cleanable/blood/gibs/body/troll_r, /obj/effect/decal/cleanable/blood/gibs/limb/troll_r, /obj/effect/decal/cleanable/blood/gibs/core/troll_r)
/obj/effect/gibspawner/troll/b
	gibtypes=list(/obj/effect/decal/cleanable/blood/gibs/up/troll_r, /obj/effect/decal/cleanable/blood/gibs/down/troll_r, /obj/effect/decal/cleanable/blood/gibs/troll_r, /obj/effect/decal/cleanable/blood/gibs/troll_r, /obj/effect/decal/cleanable/blood/gibs/body/troll_r, /obj/effect/decal/cleanable/blood/gibs/limb/troll_r, /obj/effect/decal/cleanable/blood/gibs/core/troll_r)
/obj/effect/gibspawner/troll/b
	gibtypes=list(/obj/effect/decal/cleanable/blood/gibs/up/troll_b, /obj/effect/decal/cleanable/blood/gibs/down/troll_b, /obj/effect/decal/cleanable/blood/gibs/troll_b, /obj/effect/decal/cleanable/blood/gibs/troll_b, /obj/effect/decal/cleanable/blood/gibs/body/troll_b, /obj/effect/decal/cleanable/blood/gibs/limb/troll_b, /obj/effect/decal/cleanable/blood/gibs/core/troll_b)
/obj/effect/gibspawner/troll/y
	gibtypes=list(/obj/effect/decal/cleanable/blood/gibs/up/troll_y, /obj/effect/decal/cleanable/blood/gibs/down/troll_y, /obj/effect/decal/cleanable/blood/gibs/troll_y, /obj/effect/decal/cleanable/blood/gibs/troll_y, /obj/effect/decal/cleanable/blood/gibs/body/troll_y, /obj/effect/decal/cleanable/blood/gibs/limb/troll_y, /obj/effect/decal/cleanable/blood/gibs/core/troll_y)
/obj/effect/gibspawner/troll/l
	gibtypes=list(/obj/effect/decal/cleanable/blood/gibs/up/troll_l, /obj/effect/decal/cleanable/blood/gibs/down/troll_l, /obj/effect/decal/cleanable/blood/gibs/troll_l, /obj/effect/decal/cleanable/blood/gibs/troll_l, /obj/effect/decal/cleanable/blood/gibs/body/troll_l, /obj/effect/decal/cleanable/blood/gibs/limb/troll_l, /obj/effect/decal/cleanable/blood/gibs/core/troll_l)
/obj/effect/gibspawner/troll/o
	gibtypes=list(/obj/effect/decal/cleanable/blood/gibs/up/troll_o, /obj/effect/decal/cleanable/blood/gibs/down/troll_o, /obj/effect/decal/cleanable/blood/gibs/troll_o, /obj/effect/decal/cleanable/blood/gibs/troll_o, /obj/effect/decal/cleanable/blood/gibs/body/troll_o, /obj/effect/decal/cleanable/blood/gibs/limb/troll_o, /obj/effect/decal/cleanable/blood/gibs/core/troll_o)
/obj/effect/gibspawner/troll/j
	gibtypes=list(/obj/effect/decal/cleanable/blood/gibs/up/troll_j, /obj/effect/decal/cleanable/blood/gibs/down/troll_j, /obj/effect/decal/cleanable/blood/gibs/troll_j, /obj/effect/decal/cleanable/blood/gibs/troll_j, /obj/effect/decal/cleanable/blood/gibs/body/troll_j, /obj/effect/decal/cleanable/blood/gibs/limb/troll_j, /obj/effect/decal/cleanable/blood/gibs/core/troll_j)
/obj/effect/gibspawner/troll/t
	gibtypes=list(/obj/effect/decal/cleanable/blood/gibs/up/troll_t, /obj/effect/decal/cleanable/blood/gibs/down/troll_t, /obj/effect/decal/cleanable/blood/gibs/troll_t, /obj/effect/decal/cleanable/blood/gibs/troll_t, /obj/effect/decal/cleanable/blood/gibs/body/troll_t, /obj/effect/decal/cleanable/blood/gibs/limb/troll_t, /obj/effect/decal/cleanable/blood/gibs/core/troll_t)
/obj/effect/gibspawner/troll/c
	gibtypes=list(/obj/effect/decal/cleanable/blood/gibs/up/troll_c, /obj/effect/decal/cleanable/blood/gibs/down/troll_c, /obj/effect/decal/cleanable/blood/gibs/troll_c, /obj/effect/decal/cleanable/blood/gibs/troll_c, /obj/effect/decal/cleanable/blood/gibs/body/troll_c, /obj/effect/decal/cleanable/blood/gibs/limb/troll_c, /obj/effect/decal/cleanable/blood/gibs/core/troll_c)
/obj/effect/gibspawner/troll/i
	gibtypes=list(/obj/effect/decal/cleanable/blood/gibs/up/troll_i, /obj/effect/decal/cleanable/blood/gibs/down/troll_i, /obj/effect/decal/cleanable/blood/gibs/troll_i, /obj/effect/decal/cleanable/blood/gibs/troll_i, /obj/effect/decal/cleanable/blood/gibs/body/troll_i, /obj/effect/decal/cleanable/blood/gibs/limb/troll_i, /obj/effect/decal/cleanable/blood/gibs/core/troll_i)
/obj/effect/gibspawner/troll/p
	gibtypes=list(/obj/effect/decal/cleanable/blood/gibs/up/troll_p, /obj/effect/decal/cleanable/blood/gibs/down/troll_p, /obj/effect/decal/cleanable/blood/gibs/troll_p, /obj/effect/decal/cleanable/blood/gibs/troll_p, /obj/effect/decal/cleanable/blood/gibs/body/troll_p, /obj/effect/decal/cleanable/blood/gibs/limb/troll_p, /obj/effect/decal/cleanable/blood/gibs/core/troll_p)
/obj/effect/gibspawner/troll/v
	gibtypes=list(/obj/effect/decal/cleanable/blood/gibs/up/troll_v, /obj/effect/decal/cleanable/blood/gibs/down/troll_v, /obj/effect/decal/cleanable/blood/gibs/troll_v, /obj/effect/decal/cleanable/blood/gibs/troll_v, /obj/effect/decal/cleanable/blood/gibs/body/troll_v, /obj/effect/decal/cleanable/blood/gibs/limb/troll_v, /obj/effect/decal/cleanable/blood/gibs/core/troll_v)
/obj/effect/gibspawner/troll/f
	gibtypes=list(/obj/effect/decal/cleanable/blood/gibs/up/troll_f, /obj/effect/decal/cleanable/blood/gibs/down/troll_f, /obj/effect/decal/cleanable/blood/gibs/troll_f, /obj/effect/decal/cleanable/blood/gibs/troll_f, /obj/effect/decal/cleanable/blood/gibs/body/troll_f, /obj/effect/decal/cleanable/blood/gibs/limb/troll_f, /obj/effect/decal/cleanable/blood/gibs/core/troll_f)

/obj/effect/gibspawner/trollbodypartless //only the gibs that don't look like actual full bodyparts (except torso).
	gibamounts = list(1, 1, 1, 1, 1, 1)

/obj/effect/gibspawner/trollbodypartless/Initialize(caste)
	playsound(src, 'sound/effects/blobattack.ogg', 50, 1)
	gibdirections = list(list(NORTH, NORTHEAST, NORTHWEST),list(SOUTH, SOUTHEAST, SOUTHWEST),list(WEST, NORTHWEST, SOUTHWEST),list(EAST, NORTHEAST, SOUTHEAST), GLOB.alldirs, list())
	. = ..()

/obj/effect/gibspawner/trollbodypartless/r
	gibtypes=list(/obj/effect/decal/cleanable/blood/gibs/troll_r, /obj/effect/decal/cleanable/blood/gibs/core/troll_r, /obj/effect/decal/cleanable/blood/gibs/troll_r, /obj/effect/decal/cleanable/blood/gibs/core/troll_r, /obj/effect/decal/cleanable/blood/gibs/troll_r, /obj/effect/decal/cleanable/blood/gibs/torso/troll_r)
/obj/effect/gibspawner/trollbodypartless/b
	gibtypes=list(/obj/effect/decal/cleanable/blood/gibs/troll_r, /obj/effect/decal/cleanable/blood/gibs/core/troll_r, /obj/effect/decal/cleanable/blood/gibs/troll_r, /obj/effect/decal/cleanable/blood/gibs/core/troll_r, /obj/effect/decal/cleanable/blood/gibs/troll_r, /obj/effect/decal/cleanable/blood/gibs/torso/troll_r)
/obj/effect/gibspawner/trollbodypartless/b
	gibtypes=list(/obj/effect/decal/cleanable/blood/gibs/troll_b, /obj/effect/decal/cleanable/blood/gibs/core/troll_b, /obj/effect/decal/cleanable/blood/gibs/troll_b, /obj/effect/decal/cleanable/blood/gibs/core/troll_b, /obj/effect/decal/cleanable/blood/gibs/troll_b, /obj/effect/decal/cleanable/blood/gibs/torso/troll_b)
/obj/effect/gibspawner/trollbodypartless/y
	gibtypes=list(/obj/effect/decal/cleanable/blood/gibs/troll_y, /obj/effect/decal/cleanable/blood/gibs/core/troll_y, /obj/effect/decal/cleanable/blood/gibs/troll_y, /obj/effect/decal/cleanable/blood/gibs/core/troll_y, /obj/effect/decal/cleanable/blood/gibs/troll_y, /obj/effect/decal/cleanable/blood/gibs/torso/troll_y)
/obj/effect/gibspawner/trollbodypartless/l
	gibtypes=list(/obj/effect/decal/cleanable/blood/gibs/troll_l, /obj/effect/decal/cleanable/blood/gibs/core/troll_l, /obj/effect/decal/cleanable/blood/gibs/troll_l, /obj/effect/decal/cleanable/blood/gibs/core/troll_l, /obj/effect/decal/cleanable/blood/gibs/troll_l, /obj/effect/decal/cleanable/blood/gibs/torso/troll_l)
/obj/effect/gibspawner/trollbodypartless/o
	gibtypes=list(/obj/effect/decal/cleanable/blood/gibs/troll_o, /obj/effect/decal/cleanable/blood/gibs/core/troll_o, /obj/effect/decal/cleanable/blood/gibs/troll_o, /obj/effect/decal/cleanable/blood/gibs/core/troll_o, /obj/effect/decal/cleanable/blood/gibs/troll_o, /obj/effect/decal/cleanable/blood/gibs/torso/troll_o)
/obj/effect/gibspawner/trollbodypartless/j
	gibtypes=list(/obj/effect/decal/cleanable/blood/gibs/troll_j, /obj/effect/decal/cleanable/blood/gibs/core/troll_j, /obj/effect/decal/cleanable/blood/gibs/troll_j, /obj/effect/decal/cleanable/blood/gibs/core/troll_j, /obj/effect/decal/cleanable/blood/gibs/troll_j, /obj/effect/decal/cleanable/blood/gibs/torso/troll_j)
/obj/effect/gibspawner/trollbodypartless/t
	gibtypes=list(/obj/effect/decal/cleanable/blood/gibs/troll_t, /obj/effect/decal/cleanable/blood/gibs/core/troll_t, /obj/effect/decal/cleanable/blood/gibs/troll_t, /obj/effect/decal/cleanable/blood/gibs/core/troll_t, /obj/effect/decal/cleanable/blood/gibs/troll_t, /obj/effect/decal/cleanable/blood/gibs/torso/troll_t)
/obj/effect/gibspawner/trollbodypartless/c
	gibtypes=list(/obj/effect/decal/cleanable/blood/gibs/troll_c, /obj/effect/decal/cleanable/blood/gibs/core/troll_c, /obj/effect/decal/cleanable/blood/gibs/troll_c, /obj/effect/decal/cleanable/blood/gibs/core/troll_c, /obj/effect/decal/cleanable/blood/gibs/troll_c, /obj/effect/decal/cleanable/blood/gibs/torso/troll_c)
/obj/effect/gibspawner/trollbodypartless/i
	gibtypes=list(/obj/effect/decal/cleanable/blood/gibs/troll_i, /obj/effect/decal/cleanable/blood/gibs/core/troll_i, /obj/effect/decal/cleanable/blood/gibs/troll_i, /obj/effect/decal/cleanable/blood/gibs/core/troll_i, /obj/effect/decal/cleanable/blood/gibs/troll_i, /obj/effect/decal/cleanable/blood/gibs/torso/troll_i)
/obj/effect/gibspawner/trollbodypartless/p
	gibtypes=list(/obj/effect/decal/cleanable/blood/gibs/troll_p, /obj/effect/decal/cleanable/blood/gibs/core/troll_p, /obj/effect/decal/cleanable/blood/gibs/troll_p, /obj/effect/decal/cleanable/blood/gibs/core/troll_p, /obj/effect/decal/cleanable/blood/gibs/troll_p, /obj/effect/decal/cleanable/blood/gibs/torso/troll_p)
/obj/effect/gibspawner/trollbodypartless/v
	gibtypes=list(/obj/effect/decal/cleanable/blood/gibs/troll_v, /obj/effect/decal/cleanable/blood/gibs/core/troll_v, /obj/effect/decal/cleanable/blood/gibs/troll_v, /obj/effect/decal/cleanable/blood/gibs/core/troll_v, /obj/effect/decal/cleanable/blood/gibs/troll_v, /obj/effect/decal/cleanable/blood/gibs/torso/troll_v)
/obj/effect/gibspawner/trollbodypartless/f
	gibtypes=list(/obj/effect/decal/cleanable/blood/gibs/troll_f, /obj/effect/decal/cleanable/blood/gibs/core/troll_f, /obj/effect/decal/cleanable/blood/gibs/troll_f, /obj/effect/decal/cleanable/blood/gibs/core/troll_f, /obj/effect/decal/cleanable/blood/gibs/troll_f, /obj/effect/decal/cleanable/blood/gibs/torso/troll_f)


/obj/effect/gibspawner/xeno
	gibtypes = list(/obj/effect/decal/cleanable/xenoblood/xgibs/up, /obj/effect/decal/cleanable/xenoblood/xgibs/down, /obj/effect/decal/cleanable/xenoblood/xgibs, /obj/effect/decal/cleanable/xenoblood/xgibs, /obj/effect/decal/cleanable/xenoblood/xgibs/body, /obj/effect/decal/cleanable/xenoblood/xgibs/limb, /obj/effect/decal/cleanable/xenoblood/xgibs/core)
	gibamounts = list(1,1,1,1,1,1,1)

/obj/effect/gibspawner/xeno/Initialize()
	playsound(src, 'sound/effects/blobattack.ogg', 60, 1)
	gibdirections = list(list(NORTH, NORTHEAST, NORTHWEST),list(SOUTH, SOUTHEAST, SOUTHWEST),list(WEST, NORTHWEST, SOUTHWEST),list(EAST, NORTHEAST, SOUTHEAST), GLOB.alldirs, GLOB.alldirs, list())
	. = ..()


/obj/effect/gibspawner/xenobodypartless //only the gibs that don't look like actual full bodyparts (except torso).
	gibtypes = list(/obj/effect/decal/cleanable/xenoblood/xgibs, /obj/effect/decal/cleanable/xenoblood/xgibs/core, /obj/effect/decal/cleanable/xenoblood/xgibs, /obj/effect/decal/cleanable/xenoblood/xgibs/core, /obj/effect/decal/cleanable/xenoblood/xgibs, /obj/effect/decal/cleanable/xenoblood/xgibs/torso)
	gibamounts = list(1, 1, 1, 1, 1, 1)


/obj/effect/gibspawner/xenobodypartless/Initialize()
	playsound(src, 'sound/effects/blobattack.ogg', 60, 1)
	gibdirections = list(list(NORTH, NORTHEAST, NORTHWEST),list(SOUTH, SOUTHEAST, SOUTHWEST),list(WEST, NORTHWEST, SOUTHWEST),list(EAST, NORTHEAST, SOUTHEAST), GLOB.alldirs, list())
	. = ..()

/obj/effect/gibspawner/larva
	gibtypes = list(/obj/effect/decal/cleanable/xenoblood/xgibs/larva, /obj/effect/decal/cleanable/xenoblood/xgibs/larva, /obj/effect/decal/cleanable/xenoblood/xgibs/larva/body, /obj/effect/decal/cleanable/xenoblood/xgibs/larva/body)
	gibamounts = list(1, 1, 1, 1)

/obj/effect/gibspawner/larva/Initialize()
	playsound(src, 'sound/effects/blobattack.ogg', 60, 1)
	gibdirections = list(list(NORTH, NORTHEAST, NORTHWEST),list(SOUTH, SOUTHEAST, SOUTHWEST), list(), GLOB.alldirs)
	. = ..()

/obj/effect/gibspawner/larvabodypartless
	gibtypes = list(/obj/effect/decal/cleanable/xenoblood/xgibs/larva, /obj/effect/decal/cleanable/xenoblood/xgibs/larva, /obj/effect/decal/cleanable/xenoblood/xgibs/larva)
	gibamounts = list(1, 1, 1)

/obj/effect/gibspawner/larvabodypartless/Initialize()
	playsound(src, 'sound/effects/blobattack.ogg', 60, 1)
	gibdirections = list(list(NORTH, NORTHEAST, NORTHWEST),list(SOUTH, SOUTHEAST, SOUTHWEST), list())
	. = ..()

/obj/effect/gibspawner/robot
	sparks = 1
	gibtypes = list(/obj/effect/decal/cleanable/robot_debris/up, /obj/effect/decal/cleanable/robot_debris/down, /obj/effect/decal/cleanable/robot_debris, /obj/effect/decal/cleanable/robot_debris, /obj/effect/decal/cleanable/robot_debris, /obj/effect/decal/cleanable/robot_debris/limb)
	gibamounts = list(1,1,1,1,1,1)

/obj/effect/gibspawner/robot/Initialize()
	gibdirections = list(list(NORTH, NORTHEAST, NORTHWEST),list(SOUTH, SOUTHEAST, SOUTHWEST),list(WEST, NORTHWEST, SOUTHWEST),list(EAST, NORTHEAST, SOUTHEAST), GLOB.alldirs, GLOB.alldirs)
	gibamounts[6] = pick(0,1,2)
	. = ..()
