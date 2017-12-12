// Difarem, december 2017

/area/mobcapsule
	name = "\improper Mob Capsule"
	icon_state = "away"
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED
	requires_power = FALSE
	has_gravity = TRUE
	valid_territory = FALSE

/datum/map_template/mobcapsule
	var/capsule_id
	var/description

/datum/map_template/mobcapsule/regular
	name = "Lazarus Capsule interior"
	description = "A Lazarus capsule offering basic accomodation."
	capsule_id = "capsule_regular"
	mappath = "_maps/templates/capsule_1.dmm"


// OUTSIDE MONITOR VIEW
/obj/machinery/computer/security/mobcapsule
	name = "Outside"
	desc = ""
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "telescreen"

	circuit = null
	network = list() // not connected to a network
	var/mob/living/current_user = null
	var/datum/action/innate/camera_off/mobcapsule/off_action = new
	var/list/actions = list()

	var/obj/item/device/mobcapsule/capsule // associated capsule

/obj/machinery/computer/security/mobcapsule/attack_hand(mob/user)
	if(stat)
		return
	if(!capsule)
		throw EXCEPTION("no linked capsule")
		return
	if(current_user)
		to_chat(user, "The console is already in use!")
		return

	if(user.machine != src || user.eye_blind || user.incapacitated())
		user.unset_machine()

	playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 25, 0)
	user.reset_perspective(capsule)

	// grant "off" action
	off_action.target = user
	off_action.Grant(user)
	off_action.monitor = src
	actions += off_action

/obj/machinery/computer/security/mobcapsule/Destroy()
	if(current_user)
		current_user.unset_machine()
	QDEL_LIST(actions)
	return ..()

/datum/action/innate/camera_off/mobcapsule
	name = "End Outside View"
	icon_icon = 'icons/mob/actions/actions_silicon.dmi'
	button_icon_state = "camera_off"
	var/obj/machinery/computer/security/mobcapsule/monitor

/datum/action/innate/camera_off/mobcapsule/Activate()
	if(!target || !isliving(target))
		return
	var/mob/living/C = target
	C.reset_perspective(null)
	C.unset_machine()

	for(var/V in monitor.actions)
		var/datum/action/A = V
		A.Remove(C)
	monitor.actions.Cut()
	monitor.current_user = null
