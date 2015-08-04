#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif

#include <hx/CFFI.h>
#include <stdio.h>
#include <hxcpp.h>

#include "GameCenterManager.h"

using namespace gamecentermanager;

AutoGCRoot* gameCenterManagerEventHandle = 0;

static value set_listener(value onEvent)
{
	gameCenterManagerEventHandle = new AutoGCRoot(onEvent);
	return alloc_null();
}
DEFINE_PRIM(set_listener, 1);

static value setup_manager()
{
	setupManager();
	return alloc_null();
}
DEFINE_PRIM(setup_manager, 0);

static value setup_manager_and_set_should_crypt_with_key(value key)
{
	setupManagerAndSetShouldCryptWithKey(val_string(key));
	return alloc_null();
}
DEFINE_PRIM(setup_manager_and_set_should_crypt_with_key, 1);

static value sync_game_center()
{
	syncGameCenter();
	return alloc_null();
}
DEFINE_PRIM(sync_game_center, 0);

static value save_and_report_score(value leaderboardId, value score, value sortOrder)
{
	saveAndReportScore(val_string(leaderboardId), val_int(score), val_int(sortOrder));
	return alloc_null();
}
DEFINE_PRIM(save_and_report_score, 3);

static value save_and_report_achievement(value identifier, value percentComplete, value shouldDisplayNotification)
{
	saveAndReportAchievement(val_string(identifier), val_float(percentComplete), val_bool(shouldDisplayNotification));
	return alloc_null();
}
DEFINE_PRIM(save_and_report_achievement, 3);

static value report_saved_scores_and_achievements()
{
	reportSavedScoresAndAchievements();
	return alloc_null();
}
DEFINE_PRIM(report_saved_scores_and_achievements, 0);

static value save_score_to_report_later(value leaderboardId, value score, value sortOrder)
{
	saveScoreToReportLater(val_string(leaderboardId), val_int(score), val_int(sortOrder));
	return alloc_null();
}
DEFINE_PRIM(save_score_to_report_later, 3);

static value save_achievement_to_report_later(value identifier, value percentComplete)
{
	saveAchievementToReportLater(val_string(identifier), val_float(percentComplete));
	return alloc_null();
}
DEFINE_PRIM(save_achievement_to_report_later, 2);

static value high_score_for_leaderboard(value identifier)
{
	return alloc_int(highScoreForLeaderboard(val_string(identifier)));
}
DEFINE_PRIM(high_score_for_leaderboard, 1);

static value progress_for_achievement(value identifier)
{
	return alloc_float(progressForAchievement(val_string(identifier)));
}
DEFINE_PRIM(progress_for_achievement, 1);

static value request_challenges()
{
	requestChallenges();
	return alloc_null();
}
DEFINE_PRIM(request_challenges, 0);

static value present_achievements()
{
	presentAchievements();
	return alloc_null();
}
DEFINE_PRIM(present_achievements, 0);

static value present_leaderboards()
{
	presentLeaderboards();
	return alloc_null();
}
DEFINE_PRIM(present_leaderboards, 0);

static value present_challenges()
{
	presentChallenges();
	return alloc_null();
}
DEFINE_PRIM(present_challenges, 0);

static value reset_achievements()
{
	resetAchievements();
	return alloc_null();
}
DEFINE_PRIM(reset_achievements, 0);

static value is_internet_available()
{
	return alloc_bool(isInternetAvailable());
}
DEFINE_PRIM(is_internet_available, 0);

static value is_gamecenter_available()
{
	return alloc_bool(isGameCenterAvailable());
}
DEFINE_PRIM(is_gamecenter_available, 0);

static value local_player_id()
{
	return alloc_string(localPlayerId());
}
DEFINE_PRIM(local_player_id, 0);

static value local_player_display_name()
{
	return alloc_string(localPlayerDisplayName());
}
DEFINE_PRIM(local_player_display_name, 0);

static value should_crypt_data()
{
	return alloc_bool(shouldCryptData());
}
DEFINE_PRIM(should_crypt_data, 0);

static value crypt_key()
{
	return alloc_string(cryptKey());
}
DEFINE_PRIM(crypt_key, 0);

extern "C" void gamecentermanager_main()
{
	val_int(0);
}
DEFINE_ENTRY_POINT(gamecentermanager_main);

extern "C" int gamecentermanager_register_prims()
{
	return 0;
}

// TODO use struct instead of all these parameters, or multiple events
extern "C" void sendGameCenterManagerEvent(const char* type, int availabilityState, int error, const char* identifier, int value, int rank, float percentComplete, bool showsCompletionBanner)
{
	value o = alloc_empty_object();
	alloc_field(o, val_id("type"), alloc_string(type));
	
	alloc_field(o, val_id("availabilityState"), alloc_int(availabilityState));
	alloc_field(o, val_id("error"), alloc_int(error));
	alloc_field(o, val_id("identifier"), alloc_string(identifier));
	alloc_field(o, val_id("value"), alloc_int(value));
	alloc_field(o, val_id("rank"), alloc_int(rank));
	alloc_field(o, val_id("percentComplete"), alloc_float(percentComplete));
	alloc_field(o, val_id("showsCompletionBanner"), alloc_bool(showsCompletionBanner));
	
	val_call1(gameCenterManagerEventHandle->get(), o);
}

// UNIMPLEMENTED
//static value local_player_data()
//{
//}
//DEFINE_PRIM(local_player_data, 1);