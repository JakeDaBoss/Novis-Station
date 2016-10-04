
//This is a list of words which are ignored by the parser when comparing message contents for names. MUST BE IN LOWER CASE!
var/list/adminhelp_ignored_words = list("unknown","the","a","an","of","monkey","alien","as")

/client/verb/adminhelp()
	set category = "Admin"
	set name = "Request Assistance"

	//handle muting and automuting
	if(prefs.muted & MUTE_ADMINHELP)
		src << "<font color='red'>Error: Admin-PM: You cannot send adminhelps (Muted).</font>"
		return

	adminhelped = 1 //Determines if they get the message to reply by clicking the name.

	spawn(300) // 30 Seconds
		src.verbs += /client/verb/adminhelp	// 2 minute cool-down for adminhelps//Go to hell

	var/mesg
	var/list/type = list ("Gameplay/Job Inquiries", "Rule Issue", "Technical Issue", "Other")
	var/selected_type = input("Pick a category.", "Admin Help", null, null) as null|anything in type
	if(selected_type)
		mesg = input("Please enter your message:", "Admin Help", null, null) as text


	//clean the input mesg
	if(!mesg)
		return
	mesg = sanitize(mesg)
	if(!mesg)
		return
	var/original_mesg = mesg

	//explode the input mesg into a list
	var/list/mesglist = splittext(mesg, " ")

	//generate keywords lookup
	var/list/surnames = list()
	var/list/forenames = list()
	var/list/ckeys = list()
	for(var/mob/M in mob_list)
		var/list/indexing = list(M.real_name, M.name)
		if(M.mind)	indexing += M.mind.name

		for(var/string in indexing)
			var/list/L = splittext(string, " ")
			var/surname_found = 0
			//surnames
			for(var/i=L.len, i>=1, i--)
				var/word = ckey(L[i])
				if(word)
					surnames[word] = M
					surname_found = i
					break
			//forenames
			for(var/i=1, i<surname_found, i++)
				var/word = ckey(L[i])
				if(word)
					forenames[word] = M
			//ckeys
			ckeys[M.ckey] = M

	var/ai_found = 0
	mesg = ""
	var/list/mobs_found = list()
	for(var/original_word in mesglist)
		var/word = ckey(original_word)
		if(word)
			if(!(word in adminhelp_ignored_words))
				if(word == "ai")
					ai_found = 1
				else
					var/mob/found = ckeys[word]
					if(!found)
						found = surnames[word]
						if(!found)
							found = forenames[word]
					if(found)
						if(!(found in mobs_found))
							mobs_found += found
							if(!ai_found && isAI(found))
								ai_found = 1
							mesg += "<b><font color='black'>[original_word] (<A HREF='?_src_=holder;adminmoreinfo=\ref[found]'>?</A>)</font></b> "
							continue
			mesg += "[original_word] "

	if(!mob) //this doesn't happen
		return

	var/ai_cl
	if(ai_found)
		ai_cl = " (<A HREF='?_src_=holder;adminchecklaws=\ref[mob]'>CL</A>)"

			//Options bar:  mob, details ( admin = 2, dev = 3, mentor = 4, character name (0 = just ckey, 1 = ckey and character name), link? (0 no don't make it a link, 1 do so),
			//		highlight special roles (0 = everyone has same looking name, 1 = antags / special roles get a golden name)

	var/mentor_mesg = "<span class='warning'>Request for Help ([selected_type]): </span>[get_options_bar(mob, 4, 0, 1, 0)][ai_cl]:</b> [mesg]"
	mesg = "<span class='danger'><b>Request for Help ([selected_type]): </b></span>[get_options_bar(mob, 2, 1, 1)][ai_cl]:</b> [mesg]"

	var/admin_number_afk = 0

	var/list/mentorholders = list()
	var/list/devholders = list()
	var/list/modholders = list()
	var/list/adminholders = list()
	for(var/client/X in admins)
		if(R_MENTOR & X.holder.rights && !(R_ADMIN & X.holder.rights)) // we don't want to count admins twice. This list should be JUST mentors
			mentorholders += X
			if(X.is_afk())
				admin_number_afk++
		if(R_VAREDIT & X.holder.rights || R_DEBUG & X.holder.rights) // Looking for anyone with +Debug which will be admins, developers, and developer mentors
			devholders += X
			if(!(R_ADMIN & X.holder.rights))
				if(X.is_afk())
					admin_number_afk++

		if(R_MOD & X.holder.rights || R_BAN & X.holder.rights) // Looking for anyone with +Debug which will be admins, developers, and developer mentors
			modholders += X
			if(!(R_ADMIN & X.holder.rights))
				if(X.is_afk())
					admin_number_afk++
		if(R_ADMIN & X.holder.rights || R_ADMIN & X.holder.rights) // just admins here please
			adminholders += X
			if(X.is_afk())
				admin_number_afk++

	var/send_to_admin
	var/send_to_mentor
	var/send_to_mod
	var/send_to_dev

	switch(selected_type)
		if("Gameplay/Job Inquiries")
			send_to_mentor = TRUE
			send_to_mod = TRUE
			send_to_admin = TRUE
		if("Rule Issue")
			send_to_mod = TRUE
			send_to_admin = TRUE
		if("Technical Issue")
			send_to_dev = TRUE
		if("Other")
			send_to_mentor = TRUE
			send_to_mod = TRUE
			send_to_admin = TRUE
			send_to_dev = TRUE

	var/list/already_notified = list()
	if(send_to_admin && adminholders.len)
		for(var/client/X in adminholders)
			if(X in already_notified) continue
			if(X.is_preference_enabled(/datum/client_preference/holder/play_adminhelp_ping))
				X << 'sound/effects/adminhelp_new.ogg'
			X << mesg
			already_notified |= X

	if(send_to_mentor && mentorholders.len)
		for(var/client/X in mentorholders)
			if(X in already_notified) continue
			if(X.is_preference_enabled(/datum/client_preference/holder/play_adminhelp_ping))
				X << 'sound/effects/adminhelp_new.ogg'
			X << mentor_mesg
			already_notified |= X

	if(send_to_mod && modholders.len)
		for(var/client/X in modholders)
			if(X in already_notified) continue
			if(X.is_preference_enabled(/datum/client_preference/holder/play_adminhelp_ping))
				X << 'sound/effects/adminhelp_new.ogg'
			X << mesg
			already_notified |= X

	if(send_to_dev && devholders.len)
		for(var/client/X in devholders)
			if(X in already_notified) continue
			if(X.is_preference_enabled(/datum/client_preference/holder/play_adminhelp_ping))
				X << 'sound/effects/adminhelp_new.ogg'
			X << mentor_mesg
			already_notified |= X


/*	for(var/client/X in admins)
		if((R_ADMIN|R_MOD|R_MENTOR) & X.holder.rights)
			if(X.is_afk())
				admin_number_afk++
			if(X.is_preference_enabled(/datum/client_preference/holder/play_adminhelp_ping))
				X << 'sound/effects/adminhelp.ogg'
			if(X.holder.rights == R_MENTOR)
				X << mentor_mesg		// Mentors won't see coloring of names on people with special_roles (Antags, etc.)
			else
				X << mesg*/

	//show it to the person adminhelping too
	src << "<font color='blue'>PM to-<b>Staff </b>: [original_mesg]</font>"

	var/admin_number_present = admins.len - admin_number_afk
	log_admin("HELP: [key_name(src)]: [original_mesg] - heard by [admin_number_present] non-AFK admins.")
	if(admin_number_present <= 0)
		send2adminirc("Request for Help from [key_name(src)]: [html_decode(original_mesg)] - !![admin_number_afk ? "All admins AFK ([admin_number_afk])" : "No admins online"]!!")
	else
		send2adminirc("Request for Help from [key_name(src)]: [html_decode(original_mesg)]")
	feedback_add_details("admin_verb","AH") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return