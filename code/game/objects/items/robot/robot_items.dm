//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/**********************************************************************
						Cyborg Spec Items
***********************************************************************/
//Might want to move this into several files later but for now it works here
// Consider changing this to a child of the stun baton class. ~Z
/obj/item/borg/stun
	name = "electrified arm"
	icon = 'icons/obj/decals.dmi'
	icon_state = "shock"

/obj/item/borg/stun/apply_hit_effect(mob/living/M, mob/living/silicon/robot/user, var/hit_zone)
	if(!istype(user))
		return 0

	user.visible_message("<span class='danger'>\The [user] has prodded \the [M] with \a [src]!</span>")

	if(!user.cell || !user.cell.checked_use(1250)) //Slightly more than a baton.
		return 0

	playsound(loc, 'sound/weapons/Egloves.ogg', 50, 1, -1)

	M.apply_effect(5, STUTTER)
	M.stun_effect_act(0, 70, check_zone(hit_zone), src)

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.forcesay(hit_appends)

	return 0

/obj/item/borg/overdrive
	name = "overdrive"
	icon = 'icons/obj/decals.dmi'
	icon_state = "shock"

/obj/item/borg/repairtool
	name = "Repairtool"
	icon = 'icons/obj/decals.dmi'
	icon_state = "shock"
	var/lastuse = 0

/obj/item/borg/repairtool/attack(mob/living/M as mob, mob/user as mob)
	if (!istype(M) || !istype(user))
		return 0
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	var/charge = round((world.time - lastuse)/6)	
	if (charge < 100)
		user << "<span class='notice'>The device needs more time to recharge. [charge] percent charged.</span>"
		return 0
	if (istype(M,/mob/living/silicon/robot))	//Repairing cyborgs
		var/mob/living/silicon/robot/R = M
		if ((R.getBruteLoss() + R.getFireLoss()) > 40)
			R.adjustBruteLoss(-20)
			R.adjustFireLoss(-20)
			R.updatehealth()
			lastuse = world.time
			user.visible_message("<span class='notice'>\The [user] performed crude repairs on [R].</span>",\
			"<span class='notice'>You repair some damage to [R].</span>")
		else
			user << "<span class='notice'>This device lacks the capacity to repair such minor damage.</span>"

/**********************************************************************
						HUD/SIGHT things
***********************************************************************/
/obj/item/borg/sight
	icon = 'icons/obj/decals.dmi'
	icon_state = "securearea"
	var/sight_mode = null


/obj/item/borg/sight/xray
	name = "\proper x-ray vision"
	sight_mode = BORGXRAY


/obj/item/borg/sight/thermal
	name = "\proper thermal vision"
	sight_mode = BORGTHERM
	icon_state = "thermal"
	icon = 'icons/obj/clothing/glasses.dmi'


/obj/item/borg/sight/meson
	name = "\proper meson vision"
	sight_mode = BORGMESON
	icon_state = "meson"
	icon = 'icons/obj/clothing/glasses.dmi'

/obj/item/borg/sight/material
	name = "\proper material scanner vision"
	sight_mode = BORGMATERIAL

/obj/item/borg/sight/hud
	name = "hud"
	var/obj/item/clothing/glasses/hud/hud = null


/obj/item/borg/sight/hud/med
	name = "medical hud"
	icon_state = "healthhud"
	icon = 'icons/obj/clothing/glasses.dmi'

	New()
		..()
		hud = new /obj/item/clothing/glasses/hud/health(src)
		return


/obj/item/borg/sight/hud/sec
	name = "security hud"
	icon_state = "securityhud"
	icon = 'icons/obj/clothing/glasses.dmi'

	New()
		..()
		hud = new /obj/item/clothing/glasses/hud/security(src)
		return
