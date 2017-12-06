/obj/item/reagent_containers/food/snacks/gushers
	name = "fruit gushers..?"
	desc = "These gushers come in... oh, it doesn't say. It's probably written in invisible ink."
	icon = 'icons/obj/food/gushers.dmi'
	icon_state = "gushers"
	trash = /obj/item/trash/gushers
	list_reagents = list("nothing" = 20)
	foodtype = FRUIT | JUNKFOOD | SUGAR

/obj/item/reagent_containers/food/snacks/gushers/tropical
	name = "tropical fruit gushers"
	icon_state = "gusherstropical"
	desc = "These gushers come in Massive Tropical Brain Hemorrhage flavor. Could this day get any better? You don't think so."
	trash = /obj/item/trash/gushers/tropical
	list_reagents = list("gushertropical" = 20)

/obj/item/reagent_containers/food/snacks/gushers/phlegm
	name = "hellacious fruit gushers"
	icon_state = "gushersphlegm"
	desc = "These gushers come in Hellacious Blue Phlegm Aneurysm flavor. These should be convienent, if somewhat unappetizing."
	trash = /obj/item/trash/gushers/phlegm
	list_reagents = list("gusherphlegm" = 20)

/obj/item/reagent_containers/food/snacks/gushers/black
	name = "black fruit gushers"
	icon_state = "gushersblack"
	desc = "These gushers come in Bodacious Black Liquid Sorrow flavor. Another Crocker nightmare rears it's ugly head."
	trash = /obj/item/trash/gushers/black
	list_reagents = list("gusherblack" = 20)

/obj/item/reagent_containers/food/snacks/gushers/syndie
	name = "tangerine fruit gushers"
	icon_state = "gusherssyndie"
	desc = "These gushers come in Treacherous Teal Tangerine flavor. These don't look like an official brand..."
	trash = /obj/item/trash/gushers/syndie
	list_reagents = list("gushersyndie" = 20)

/obj/item/reagent_containers/food/snacks/gushers/diabetic
	name = "sugary fruit gushers"
	icon_state = "gushersdiabetic"
	desc = "These gushers come in Jammin Sour Diabetic Coma flavor. The nutrition label on the side says that carbohydrates take up 99% of the nutritious value."
	trash = /obj/item/trash/gushers/diabetic
	list_reagents = list("gusherdiabetic" = 20)

/obj/item/reagent_containers/food/snacks/gushers/cherry
	name = "cherry fruit gushers"
	icon_state = "gusherscherry"
	desc = "These gushers come in Wild Cherry Apeshit Apocalypse flavor. You feel energetic just looking at the box."
	trash = /obj/item/trash/gushers/cherry
	list_reagents = list("gushercherry" = 20)

/obj/item/reagent_containers/food/snacks/gushers/citrus
	name = "citrus fruit gushers"
	icon_state = "gusherscitrus"
	desc = "These gushers come in Carnivorous Citrus Piss flavor. The smell makes you want to vomit."
	trash = /obj/item/trash/gushers/citrus
	list_reagents = list("gushercitrus" = 20)

/obj/item/reagent_containers/food/snacks/gushers/kiwi
	name = "kiwi fruit gushers"
	icon_state = "gusherskiwi"
	desc = "These gushers come in Xtreme Kiwi Xplosion flavor. A warning label on the front reads 'See your doctor after consumption.'"
	trash = /obj/item/trash/gushers/kiwi
	list_reagents = list("gusherkiwi" = 20)

/obj/item/reagent_containers/food/snacks/gushers/strawberry
	name = "strawberry fruit gushers"
	icon_state = "gushersstrawberry"
	desc = "These gushers come in Schizophrenic Strawberry Slam flavor. The nutrition label has been covered up in a piece of tape that reads 'touch fuzzy get dizzy.'"
	trash = /obj/item/trash/gushers/strawberry
	list_reagents = list("gusherstrawberry" = 20)

//Trash code below

/obj/item/trash/gushers
	name = "fruit gushers..?"
	icon = 'icons/obj/janitorgushers.dmi'
	icon_state = "gushers"

/obj/item/trash/gushers/tropical
	name = "tropical fruit gushers"
	icon_state = "gusherstropical"

/obj/item/trash/gushers/phlegm
	name = "hellacious fruit gushers"
	icon_state = "gushersphlegm"

/obj/item/trash/gushers/black
	name = "black fruit gushers"
	icon_state = "gushersblack"

/obj/item/trash/gushers/syndie
	name = "tangerine fruit gushers"
	icon_state = "gusherssyndie"

/obj/item/trash/gushers/diabetic
	name = "sugary fruit gushers"
	icon_state = "gushersdiabetic"

/obj/item/trash/gushers/cherry
	name = "cherry fruit gushers"
	icon_state = "gusherscherry"

/obj/item/trash/gushers/citrus
	name = "citrus fruit gushers"
	icon_state = "gusherscitrus"

/obj/item/trash/gushers/kiwi
	name = "kiwi fruit gushers"
	icon_state = "gusherskiwi"

/obj/item/trash/gushers/strawberry
	name = "strawberry fruit gushers"
	icon_state = "gushersstrawberry"

//supply pack in cargo console
datum/supply_pack/organic/gushers
	name = "CONSUME"
	cost = 10000
	contraband = TRUE
	contains = list(/obj/item/reagent_containers/food/snacks/gushers/tropical,
					/obj/item/reagent_containers/food/snacks/gushers/tropical,
					/obj/item/reagent_containers/food/snacks/gushers/tropical,
					/obj/item/reagent_containers/food/snacks/gushers/phlegm,
					/obj/item/reagent_containers/food/snacks/gushers/phlegm,
					/obj/item/reagent_containers/food/snacks/gushers/phlegm,
					/obj/item/reagent_containers/food/snacks/gushers/black,
					/obj/item/reagent_containers/food/snacks/gushers/black,
					/obj/item/reagent_containers/food/snacks/gushers/black,
					/obj/item/reagent_containers/food/snacks/gushers/diabetic,
					/obj/item/reagent_containers/food/snacks/gushers/diabetic,
					/obj/item/reagent_containers/food/snacks/gushers/diabetic,
					/obj/item/reagent_containers/food/snacks/gushers/cherry,
					/obj/item/reagent_containers/food/snacks/gushers/cherry,
					/obj/item/reagent_containers/food/snacks/gushers/cherry,
					/obj/item/reagent_containers/food/snacks/gushers/citrus,
					/obj/item/reagent_containers/food/snacks/gushers/citrus,
					/obj/item/reagent_containers/food/snacks/gushers/citrus,
					/obj/item/reagent_containers/food/snacks/gushers/kiwi,
					/obj/item/reagent_containers/food/snacks/gushers/kiwi,
					/obj/item/reagent_containers/food/snacks/gushers/kiwi,
					/obj/item/reagent_containers/food/snacks/gushers/strawberry,
					/obj/item/reagent_containers/food/snacks/gushers/strawberry,
					/obj/item/reagent_containers/food/snacks/gushers/strawberry)