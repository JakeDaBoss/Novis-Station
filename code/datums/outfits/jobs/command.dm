/decl/hierarchy/outfit/job/captain
	name = OUTFIT_JOB_NAME("Captain")
	head = /obj/item/clothing/head/caphat
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/rank/captain
	l_ear = /obj/item/device/radio/headset/heads/captain
	shoes = /obj/item/clothing/shoes/brown
	backpack = /obj/item/weapon/storage/backpack/captain
	satchel_one = /obj/item/weapon/storage/backpack/satchel_cap
	id_type = /obj/item/weapon/card/id/gold
	pda_type = /obj/item/device/pda/captain
	backpack_contents = list(/obj/item/weapon/storage/box/ids = 1)

/decl/hierarchy/outfit/job/captain/post_equip(var/mob/living/carbon/human/H)
	..()
	if(H.age>49)
		// Since we can have something other than the default uniform at this
		// point, check if we can actually attach the medal
		var/obj/item/clothing/uniform = H.w_uniform
		if(uniform)
			var/obj/item/clothing/accessory/medal/gold/nanotrasen/medal = new()
			if(uniform.can_attach_accessory(medal))
				uniform.attach_accessory(null, medal)
			else
				qdel(medal)

/decl/hierarchy/outfit/job/hop
	name = OUTFIT_JOB_NAME("Head of Personnel")
	uniform = /obj/item/clothing/under/rank/head_of_personnel
	l_ear = /obj/item/device/radio/headset/heads/hop
	shoes = /obj/item/clothing/shoes/brown
	id_type = /obj/item/weapon/card/id/silver
	pda_type = /obj/item/device/pda/heads/hop
	backpack_contents = list(/obj/item/weapon/storage/box/ids = 1)

// COMMISSAR STUFF.

/decl/hierarchy/outfit/job/commissariat_secretary
	name = OUTFIT_JOB_NAME("Commissariat Secretary")
	uniform = /obj/item/clothing/under/suit_jacket/navy
	l_ear = /obj/item/device/radio/headset/commissar_secretary
	shoes = /obj/item/clothing/shoes/brown
	id_type = /obj/item/weapon/card/id/commissar_secretary
	pda_type = /obj/item/device/pda/commissariat

/decl/hierarchy/outfit/job/commissariat_crew
	name = OUTFIT_JOB_NAME("Commissar of Crew Affairs")
	uniform = /obj/item/clothing/under/suit_jacket/female
	l_ear = /obj/item/device/radio/headset/commissar_secretary
	shoes = /obj/item/clothing/shoes/brown
	id_type = /obj/item/weapon/card/id/commissar_chair_crew
	pda_type = /obj/item/device/pda/commissariat

/decl/hierarchy/outfit/job/commissariat_chairman
	name = OUTFIT_JOB_NAME("Commissar Chairman")
	uniform = /obj/item/clothing/under/suit_jacket/female
	l_ear = /obj/item/device/radio/headset/commissar_secretary
	shoes = /obj/item/clothing/shoes/brown
	id_type = /obj/item/weapon/card/id/commissar_chair_crew
	pda_type = /obj/item/device/pda/commissariat