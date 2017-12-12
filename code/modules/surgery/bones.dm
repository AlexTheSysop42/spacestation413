/datum/surgery/bone_surgery
	name = "bone surgery"
	species = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	possible_locs = list("chest", "head", "l_arm", "r_arm", "l_leg", "r_leg")
	requires_real_bodypart = 1
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/glue_bone,
		/datum/surgery_step/set_bone,
		/datum/surgery_step/finish_bone,
		/datum/surgery_step/close
		)

/datum/surgery/bone_mending
	name = "bone mending (requires bone mender tool)"
	species = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	possible_locs = list("chest", "head", "l_arm", "r_arm", "l_leg", "r_leg")
	requires_real_bodypart = 1
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/bone_mender,
		/datum/surgery_step/close
		)

/datum/surgery/skull_mending
	name = "repair skull"
	species = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	possible_locs = list("head")
	requires_real_bodypart = 1
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/mend_skull,
		/datum/surgery_step/finish_bone,
		/datum/surgery_step/close
		)




//GLUE BONES
/datum/surgery_step/glue_bone
	name = "glue bone"
	implements = list(
		/obj/item/bonegel = 100,
		/obj/item/hand_labeler = 75,
		)
	time = 20

/datum/surgery_step/glue_bone/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("[user] starts applying medication to the damaged bones in [target]'s [parse_zone(target_zone)] with \the [tool].",
	"<span class='notice'>You start applying medication to the damaged bones in [target]'s [parse_zone(target_zone)] with \the [tool].</span>")

/datum/surgery_step/glue_bone/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("<span class='notice'>[user] applies some [tool] to [target]'s bone in [parse_zone(target_zone)].</span>", \
	"<span class='notice'>You apply some [tool] to [target]'s bone in [parse_zone(target_zone)] with \the [tool].</span>")
	return 1

/datum/surgery_step/glue_bone/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("<span class='warning'>[user]'s hand slips, smearing [tool] in the incision in [target]'s [parse_zone(target_zone)]!</span>" , \
	"<span class='warning'>Your hand slips, smearing [tool] in the incision in [target]'s [parse_zone(target_zone)]!</span>")
	return 0


// SET BONES
/datum/surgery_step/set_bone
	implements = list(
		/obj/item/bonesetter = 100,
		/obj/item/wrench = 75,
		)

	time = 24

/datum/surgery_step/set_bone/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("[user] is beginning to set the bone in [target]'s [parse_zone(target_zone)] in place with \the [tool]." , \
		"You are beginning to set the bone in [target]'s [parse_zone(target_zone)] in place with \the [tool].")

/datum/surgery_step/set_bone/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	if (affected.damagestatus == BP_BROKEN)
		user.visible_message("<span class='notice'>[user] sets the bone in [target]'s [parse_zone(target_zone)] in place with \the [tool].</span>", \
			"<span class='notice'>You set the bone in [target]'s [parse_zone(target_zone)] in place with \the [tool].</span>")
	else
		user.visible_message("<span class='notice'>[user] sets the bone in [target]'s [parse_zone(target_zone)] <span class='warning'>in the WRONG place with \the [tool].</span>", \
			"<span class='notice'>You set the bone in [target]'s [parse_zone(target_zone)] <span class='warning'>in the WRONG place with \the [tool].</span>")
		affected.fracture()
	return 1

/datum/surgery_step/set_bone/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("<span class='warning'>[user]'s hand slips, damaging the bone in [target]'s [parse_zone(target_zone)] with \the [tool]!</span>" , \
	"<span class='warning'>Your hand slips, damaging the bone in [target]'s [parse_zone(target_zone)] with \the [tool]!</span>")
	target.apply_damage(50, BRUTE, "[target_zone]")
	return 0



/datum/surgery_step/mend_skull
	implements = list(
		/obj/item/bonesetter = 100,
		/obj/item/wrench = 75,
		)

	time = 24

/datum/surgery_step/mend_skull/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("[user] is beginning piece together [target]'s skull with \the [tool]."  , \
		"You are beginning piece together [target]'s skull with \the [tool].")

/datum/surgery_step/mend_skull/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("<span class='notice'>[user] sets [target]'s skull with \the [tool].</span>" , \
	"<span class='notice'>You set [target]'s skull with \the [tool].</span>")
	return 1

/datum/surgery_step/mend_skull/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("<span class='warning'>[user]'s hand slips, damaging [target]'s face with \the [tool]!</span>"  , \
		"<span class='warning'>Your hand slips, damaging [target]'s face with \the [tool]!</span>")
	target.apply_damage(30, BRUTE, "[target_zone]")
	target.status_flags |= DISFIGURED
	return 0



//////FINISH BONE/////////
/datum/surgery_step/finish_bone
	implements = list(
		/obj/item/bonegel = 100,
		/obj/item/hand_labeler = 75,
		)
	time = 20


/datum/surgery_step/finish_bone/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("[user] starts to finish mending the damaged bones in [target]'s [parse_zone(target_zone)] with \the [tool].", \
	"You start to finish mending the damaged bones in [target]'s [parse_zone(target_zone)] with \the [tool].")

/datum/surgery_step/finish_bone/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message("<span class='notice'>[user] has mended the damaged bones in [target]'s [parse_zone(target_zone)] with \the [tool].</span>"  , \
		"<span class='notice'>You have mended the damaged bones in [target]'s [parse_zone(target_zone)] with \the [tool].</span>" )
	affected.damagestatus = BP_HEALTHY
	//affected.status &= ~ORGAN_SPLINTED
	affected.perma_injury = 0
	if(affected.brute_dam >= affected.min_broken_damage)
		affected.heal_damage(affected.brute_dam - (affected.min_broken_damage - rand(3,5))) //Put the limb's brute damage just under the bone breaking threshold, to prevent it from instabreaking again.
	return 1

/datum/surgery_step/finish_bone/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("<span class='warning'>[user]'s hand slips, smearing [tool] in the incision in [target]'s [parse_zone(target_zone)]!</span>" , \
	"<span class='warning'>Your hand slips, smearing [tool] in the incision in [target]'s [parse_zone(target_zone)]!</span>")
	return 0



/datum/surgery_step/bone_mender
	implements = list(
		/obj/item/bonesetter/bone_mender = 100,
		)

	time = 28


/datum/surgery_step/bone_mender/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("[user] starts grasping the damaged bone edges in [target]'s [parse_zone(target_zone)] with \the [tool]." , \
	"You start grasping the bone edges and fusing them in [target]'s [parse_zone(target_zone)] with \the [tool].")

/datum/surgery_step/bone_mender/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message("<span class='notice'>[user] fuses [target]'s [parse_zone(target_zone)] bone with \the [tool].</span>"  , \
		"<span class='notice'>You fuse the bone in [target]'s [parse_zone(target_zone)] with \the [tool].</span>" )
	affected.damagestatus = BP_HEALTHY
	//affected.status &= ~ORGAN_SPLINTED
	affected.perma_injury = 0
	if(affected.brute_dam >= affected.min_broken_damage)
		affected.heal_damage(affected.brute_dam - (affected.min_broken_damage - rand(3,5)))
	return 1

/datum/surgery_step/bone_mender/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("<span class='warning'>\The [tool] in [user]'s hand skips, jabbing the bone edges into the sides of [target]'s [parse_zone(target_zone)]!</span>" , \
	"<span class='warning'>Your hand jolts and \the [tool] skips, jabbing the bone edges into [target]'s [parse_zone(target_zone)] with \the [tool]!</span>")
	target.apply_damage(30, BRUTE, "[target_zone]")
	return 0

