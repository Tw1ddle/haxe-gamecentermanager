#ifndef GAMECENTERMANAGERBINDINGS_H
#define GAMECENTERMANAGERBINDINGS_H

namespace gamecentermanager
{
	void setupManager();
	void setupManagerAndSetShouldCryptWithKey(const char* cryptKey);
	void syncGameCenter();
	void saveAndReportScore(const char* leaderboardId, int score, int sortOrder);
	void saveAndReportAchievement(const char* identifier, float percentComplete, bool shouldDisplayNotification);
	void reportSavedScoresAndAchievements();
	void saveScoreToReportLater(const char* leaderboardId, int score, int sortOrder);
	void saveAchievementToReportLater(const char* identifier, float percentComplete);
	int highScoreForLeaderboard(const char* identifier);
	float progressForAchievement(const char* identifier);
	void requestChallenges();
    
#ifdef IPHONE
	void presentAchievements();
	void presentLeaderboards();
	void presentChallenges();
#endif
    
	void resetAchievements();
	bool isInternetAvailable();
	bool isGameCenterAvailable();
	const char* localPlayerId();
	const char* localPlayerDisplayName();
	bool shouldCryptData();
	const char* cryptKey();
	
	// UNIMPLEMENTED
	//highScoreForLeaderboards(identifiers:Array<String>):Map<String, Int>
	//progressForAchievements(identifiers:Array<String>):Map<String, Float>
	//localPlayerData():GameKitPlayerData
}

#endif