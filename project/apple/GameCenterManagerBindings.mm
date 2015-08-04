#ifdef IPHONE
#import <UIKit/UIKit.h>
#endif

#import <CoreFoundation/CoreFoundation.h>
#include <ctype.h>
#include <objc/runtime.h>

#import "../../lib/GameCenterManager/GC Manager/GameCenterManager.h"
#include "GameCenterManagerBindings.h"

// TODO put these parameters into a struct or have multiple events?
extern "C" void sendGameCenterManagerEvent(
const char* type,
int availabilityState,
int error,
const char* identifier,
int value,
int rank,
float percentComplete,
bool showsCompletionBanner);
 
void queueGameCenterManagerEvent(
const char* type = "NONE",
int availabilityState = 0,
int error = 0,
const char* identifier = "",
int value = 0,
int rank = 0,
float percentComplete = 0.0f,
bool showsCompletionBanner = false)
{
	[[NSOperationQueue mainQueue] addOperationWithBlock:^ {
		sendGameCenterManagerEvent(type, availabilityState, error, identifier, value, rank, percentComplete, showsCompletionBanner);
	}];
}

@interface MyGameCenterManagerDelegate : NSObject<GameCenterManagerDelegate>
@end

@implementation MyGameCenterManagerDelegate

// TODO implement mac equivalent of uiviewcontroller stuff
- (void)gameCenterManager:(GameCenterManager *)manager authenticateUser:(UIViewController *)gameCenterLoginController {
    // TODO
    queueGameCenterManagerEvent("shouldAuthenticateUser");
}

- (void)gameCenterManager:(GameCenterManager *)manager availabilityChanged:(NSDictionary *)availabilityInformation {
	// TODO pass delegate parameters through
    queueGameCenterManagerEvent("onAvailabilityChanged");
}

- (void)gameCenterManager:(GameCenterManager *)manager error:(NSError *)error {
    queueGameCenterManagerEvent("onError");
}

- (void)gameCenterManager:(GameCenterManager *)manager reportedAchievement:(GKAchievement *)achievement withError:(NSError *)error {
	queueGameCenterManagerEvent("didReportAchievement");
}

- (void)gameCenterManager:(GameCenterManager *)manager reportedScore:(GKScore *)score withError:(NSError *)error {
	queueGameCenterManagerEvent("didReportScore");
}

- (void)gameCenterManager:(GameCenterManager *)manager didSaveScore:(GKScore *)score {
	queueGameCenterManagerEvent("didSaveScore");
}

- (void)gameCenterManager:(GameCenterManager *)manager didSaveAchievement:(GKAchievement *)achievement {
	queueGameCenterManagerEvent("didSaveAchievement");
}

@end

namespace gamecentermanager
{
	void setupManager()
	{
		MyGameCenterManagerDelegate *delegate = [MyGameCenterManagerDelegate new];
	
		[[GameCenterManager sharedManager] setupManager];
		[[GameCenterManager sharedManager] setDelegate:delegate];
	}
	
	void setupManagerAndSetShouldCryptWithKey(const char* cryptKey)
	{
		NSString *nsCryptKey = [[NSString alloc] initWithUTF8String:cryptKey];
		[[GameCenterManager sharedManager] setupManagerAndSetShouldCryptWithKey:nsCryptKey];
		
		MyGameCenterManagerDelegate *delegate = [MyGameCenterManagerDelegate new];
		[[GameCenterManager sharedManager] setDelegate:delegate];
	}
	
	void syncGameCenter()
	{
		[[GameCenterManager sharedManager] syncGameCenter];
	}
	
	void saveAndReportScore(const char* leaderboardId, int score, int sortOrder)
	{
		NSString* nsLeaderboardId = [[NSString alloc] initWithUTF8String:leaderboardId];
		[[GameCenterManager sharedManager] saveAndReportScore:score leaderboard:nsLeaderboardId sortOrder:static_cast<GameCenterSortOrder>(sortOrder)];
	}
	
	void saveAndReportAchievement(const char* identifier, float percentComplete, bool shouldDisplayNotification)
	{
		NSString* nsIdentifier = [[NSString alloc] initWithUTF8String:identifier];
		[[GameCenterManager sharedManager] saveAndReportAchievement:nsIdentifier percentComplete:percentComplete shouldDisplayNotification:shouldDisplayNotification];
	}
	
	void reportSavedScoresAndAchievements()
	{
		[[GameCenterManager sharedManager] reportSavedScoresAndAchievements];
	}
	
	void saveScoreToReportLater(const char* leaderboardId, int score)
	{
		NSString* nsLeaderboardId = [[NSString alloc] initWithUTF8String:leaderboardId];
        
        GKScore *gkScore = [[GKScore alloc] initWithLeaderboardIdentifier:nsLeaderboardId];
        gkScore.value = score;
        
		[[GameCenterManager sharedManager] saveScoreToReportLater:gkScore];
	}
	
	void saveAchievementToReportLater(const char* identifier, float percentComplete)
	{
		NSString* nsIdentifier = [[NSString alloc] initWithUTF8String:identifier];
		[[GameCenterManager sharedManager] saveAchievementToReportLater:nsIdentifier percentComplete:percentComplete];
	}
	
	int highScoreForLeaderboard(const char* identifier)
	{
		NSString* nsIdentifier = [[NSString alloc] initWithUTF8String:identifier];
		return [[GameCenterManager sharedManager] highScoreForLeaderboard:nsIdentifier];
	}
	
	float progressForAchievement(const char* identifier)
	{
		NSString* nsIdentifier = [[NSString alloc] initWithUTF8String:identifier];
		return [[GameCenterManager sharedManager] progressForAchievement:nsIdentifier];
	}
	
	void requestChallenges()
	{
		[[GameCenterManager sharedManager] getChallengesWithCompletion:^(NSArray *challenges, NSError *error) {
            queueGameCenterManagerEvent("onChallengesRequestComplete");
        }];
	}
	
	void presentAchievements()
	{
		UIViewController *glView = [[[UIApplication sharedApplication] keyWindow] rootViewController];
		[[GameCenterManager sharedManager] presentAchievementsOnViewController: glView];
	}
	
	void presentLeaderboards()
	{
		UIViewController *glView = [[[UIApplication sharedApplication] keyWindow] rootViewController];
		[[GameCenterManager sharedManager] presentLeaderboardsOnViewController: glView];
	}
	
	void presentChallenges()
	{
		UIViewController *glView = [[[UIApplication sharedApplication] keyWindow] rootViewController];
		[[GameCenterManager sharedManager] presentChallengesOnViewController: glView];
	}
	
	void resetAchievements()
	{
        [[GameCenterManager sharedManager] resetAchievementsWithCompletion:^(NSError *error) {
            queueGameCenterManagerEvent("onAchievementsReset");
        }];
	}
	
	bool isInternetAvailable()
	{
		return [[GameCenterManager sharedManager] isInternetAvailable];
	}
	
	bool isGameCenterAvailable()
	{
		return [[GameCenterManager sharedManager] isGameCenterAvailable];
	}
	
	const char* localPlayerId()
	{
		NSString* nsLocalPlayerId = [[GameCenterManager sharedManager] localPlayerId];
		return [nsLocalPlayerId cStringUsingEncoding:[NSString defaultCStringEncoding]];
	}
	
	const char* localPlayerDisplayName()
	{
		NSString* nsLocalPlayerDisplayName = [[GameCenterManager sharedManager] localPlayerDisplayName];
		return [nsLocalPlayerDisplayName cStringUsingEncoding:[NSString defaultCStringEncoding]];
	}
	
	bool shouldCryptData()
	{
		return [[GameCenterManager sharedManager] shouldCryptData];
	}
	
	const char* cryptKey()
	{
		NSString* nsCryptKey = [[GameCenterManager sharedManager] cryptKey];
		return [nsCryptKey cStringUsingEncoding:[NSString defaultCStringEncoding]];
	}
	
	// UNIMPLEMENTED
	//highScoreForLeaderboards(identifiers:Array<String>):Map<String, Int>
	//progressForAchievements(identifiers:Array<String>):Map<String, Float>
	//localPlayerData():GameKitPlayerData
}