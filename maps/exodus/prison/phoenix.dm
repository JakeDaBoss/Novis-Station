#if !defined(USING_MAP_DATUM)

//	#include "exodus_areas.dm"
//	#include "exodus_shuttles.dm"
//	#include "exodus_unit_testing.dm"
//	#include "exodus_holodecks.dm"

	#include "phoenix-0.dmm"
	#include "phoenix-1.dmm"
	#include "phoenix-2.dmm"
	#include "phoenix-3.dmm"

	#define USING_MAP_DATUM /datum/map/phoenix

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Phoenix

#endif
