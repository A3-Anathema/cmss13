#define TGS_STATUS_THROTTLE 5

/datum/tgs_chat_command/status
	name = "status"
	help_text = "Gets the admincount, playercount, gamemode, and true game mode of the server"
	admin_only = TRUE

/datum/tgs_chat_command/status/Run(datum/tgs_chat_user/sender, params)
	var/list/adm = get_admin_counts()
	var/list/allmins = adm["total"]
	var/gamemode = "Unknown"
	if(!SSticker.mode) // That'd mean round didn't start yet, usually.
		gamemode = "[SSticker.master_mode] (Lobby)"
	else
		gamemode = SSticker.mode.name
	var/status = "Admins: [allmins.len] (Active: [english_list(adm["present"])] AFK: [english_list(adm["afk"])] Stealth: [english_list(adm["stealth"])] Skipped: [english_list(adm["noflags"])]). "
	status += "\nPlayers: [GLOB.clients.len]. Round has [SSticker.HasRoundStarted() ? "" : "not "]started."
	status += "\nGamemode: [gamemode] Round Time: [DisplayTimeText(world.time - SSticker.round_start_time)]"
	return status

/datum/tgs_chat_command/check
	name = "check"
	help_text = "Gets the playercount, gamemode, and address of the server"

/datum/tgs_chat_command/check/Run(datum/tgs_chat_user/sender, params)
	var/server = CONFIG_GET(string/server)
	return "[SSperf_logging.round.id ? "Round #[SSperf_logging.round.id]: " : ""][GLOB.clients.len] players on [SSmapping.configs[GROUND_MAP]?.map_name ]; Round [SSticker.HasRoundStarted() ? (SSticker.IsRoundInProgress() ? "Active" : "Finishing") : "Starting"] Round Time: [DisplayTimeText(world.time - SSticker.round_start_time)]\
	\n[server ? server : "<[world.internet_address]:[world.port]>"]"

/datum/tgs_chat_command/gameversion
	name = "gameversion"
	help_text = "Gets the version details"

/datum/tgs_chat_command/gameversion/Run(datum/tgs_chat_user/sender, params)
	var/list/msg = list("")
	msg += "BYOND Server Version: [world.byond_version].[world.byond_build] (Compiled with: [DM_VERSION].[DM_BUILD])\n"

	if (!GLOB.revdata)
		msg += "No revision information found."
	else
		msg += "Revision [copytext_char(GLOB.revdata.commit, 1, 9)]"
		if (GLOB.revdata.date)
			msg += " compiled on '[GLOB.revdata.date]'"

		if(GLOB.revdata.originmastercommit)
			msg += ", from origin commit: <[CONFIG_GET(string/githuburl)]/commit/[GLOB.revdata.originmastercommit]>"

		if(GLOB.revdata.testmerge.len)
			msg += "\n"
			for(var/datum/tgs_revision_information/test_merge/PR as anything in GLOB.revdata.testmerge)
				msg += "PR #[PR.number] at [copytext_char(PR.head_commit, 1, 9)] [PR.title].\n"
				if (PR.url)
					msg += "<[PR.url]>\n"
	return msg.Join("")
