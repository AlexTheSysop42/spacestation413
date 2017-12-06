/datum/hud/proc/vampire_hud(ui_style = 'icons/mob/screen1_Midnight.dmi')

	ui_style_icon = 'icons/mob/screen1_Midnight.dmi'


obj/screen/vampire_blood_display

	icon = 'icons/mob/screen1_Midnight.dmi'
	name = "Vampire Blood"
	icon_state = "dark128"
	screen_loc = ui_alienplasmadisplay


/datum/hud/vampire/New(mob/living/carbon/human/owner, ui_style = 'icons/mob/screen1_Midnight.dmi')
	..()


	vampire_blood_display = new /obj/screen/vampire_blood_display()
	infodisplay += vampire_blood_display