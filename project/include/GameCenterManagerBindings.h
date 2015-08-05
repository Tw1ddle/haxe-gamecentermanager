#ifndef GAMECENTERMANAGERBINDINGS_H
#define GAMECENTERMANAGERBINDINGS_H

namespace gamecentermanager
{
    typedef struct
    {
        const char* availabilityState;
        int error;
        const char* identifier;
        int value;
        int rank;
        float percentComplete;
        bool showsCompletionBanner;
    } GameCenterManagerEventData;
    
	void setupManager();
	void setupManagerAndSetShouldCryptWithKey(const char* cryptKey);
	void authenticateUser();
	void syncGameCenter();
	void saveAndReportScore(const char* leaderboardId, int score, int sortOrder);
	void saveAndReportAchievement(const char* identifier, float percentComplete, bool shouldDisplayNotification);
	void reportSavedScoresAndAchievements();
	void saveScoreToReportLater(const char* leaderboardId, int score);
	void saveAchievementToReportLater(const char* identifier, float percentComplete);
	int highScoreForLeaderboard(const char* identifier);
	float progressForAchievement(const char* identifier);
	void requestChallenges();
	void presentAchievements();
	void presentLeaderboards();
	void presentChallenges();
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