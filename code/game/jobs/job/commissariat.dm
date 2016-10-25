/datum/job/commissar_secretary
	title = "Commissariat Secretary"
	head_position = 0
	department_flag = COM|CIV
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "central command"
	selection_color = "#82CAFF"
	req_admin_notify = 1
	economic_modifier = 10
	ideal_character_age = 34
	spawn_flags = IS_WHITELISTED

	access = list(access_commissar_secretary)
	minimal_access = list(access_commissar_secretary)

	outfit_type = /decl/hierarchy/outfit/job/commissariat_secretary


/datum/job/commissar_crew
	title = "Commissar of Crew Affairs"
	head_position = 1
	department_flag = COM|CIV
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "central command"
	selection_color = "#157DEC"
	req_admin_notify = 1
	economic_modifier = 10
	ideal_character_age = 48
	spawn_flags = IS_WHITELISTED

	access = list(access_commissar_secretary, access_commissar_crew)
	minimal_access = list(access_commissar_secretary, access_commissar_crew)

	outfit_type = /decl/hierarchy/outfit/job/commissariat_secretary

/datum/job/commissar_crew/equip(var/mob/living/carbon/human/H)
	. = ..()
	if(.)
		H.implant_loyalty(src)

/datum/job/commissar_chairman
	title = "Commissar Chairman"
	head_position = 1
	department_flag = COM|CIV
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "central command"
	selection_color = "#157DEC"
	req_admin_notify = 1
	economic_modifier = 10
	ideal_character_age = 42
	spawn_flags = IS_WHITELISTED

	access = list(access_commissar_secretary, access_commissar_crew, access_commissar_chairman)
	minimal_access = list(access_commissar_secretary, access_commissar_crew, access_commissar_chairman)

	outfit_type = /decl/hierarchy/outfit/job/commissariat_secretary

/datum/job/commissar_chairman/equip(var/mob/living/carbon/human/H)
	. = ..()
	if(.)
		H.implant_loyalty(src)
