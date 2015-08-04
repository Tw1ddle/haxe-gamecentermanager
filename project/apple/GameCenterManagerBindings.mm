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
const char* availabilityState,
int error,
const char* identifier,
int value,
int rank,
float percentComplete,
bool showsCompletionBanner);
 
void queueGameCenterManagerEvent(
const char* type,
const char* availabilityState = "UNKNOWN",
int error = 0,
const char* identifier = "",
int value = 0,
int rank = 0,
float percentComplete = 0.0f,
bool showsCompletionBanner = false)
{
	[[NSOperationQueue mainQueue] addOperationWithBlock:^ 
	{
		sendGameCenterManagerEvent(type, availabilityState, error, identifier, value, rank, percentComplete, showsCompletionBanner);
	}];
}

@interface MyGameCenterManagerDelegate : NSObject<GameCenterManagerDelegate>
@end

@implementation MyGameCenterManagerDelegate

- (void)gameCenterManager:(GameCenterManager *)manager authenticateUser:(UIViewController *)gameCenterLoginController 
{
    queueGameCenterManagerEvent("shouldAuthenticateUser");
}

- (void)gameCenterManager:(GameCenterManager *)manager availabilityChanged:(NSDictionary *)availabilityInformation
{
	const char* status = "UNKNOWN";
	
	if ([[availabilityInformation objectForKey:@"status"] isEqualToString:@"GameCenter Available"]) 
	{
		status = "AVAILABLE";
    } else {
		status = "UNAVAILABLE";
    }
	
    queueGameCenterManagerEvent("onAvailabilityChanged", status);
}

- (void)gameCenterManager:(GameCenterManager *)manager error:(NSError *)error
{
	int errorCode = 0;
	
	if(error != nil)
	{
		errorCode = error.code;
	}
	
    queueGameCenterManagerEvent("onError", "", errorCode);
}

- (void)gameCenterManager:(GameCenterManager *)manager reportedAchievement:(GKAchievement *)achievement withError:(NSError *)error
{
	const char* identifier = [achievement.identifier cStringUsingEncoding:[NSString defaultCStringEncoding]];
	float percentComplete = achievement.percentComplete;
	bool showsCompletionBanner = achievement.showsCompletionBanner;
	
	int errorCode = 0;
	if(error != nil)
	{
		errorCode = error.code;
	}
	
	queueGameCenterManagerEvent("didReportAchievement", "", errorCode, identifier, 0, 0, percentComplete, showsCompletionBanner);
}

- (void)gameCenterManager:(GameCenterManager *)manager reportedScore:(GKScore *)score withError:(NSError *)error 
{
	const char* identifier = [score.leaderboardIdentifier cStringUsingEncoding:[NSString defaultCStringEncoding]];
	int value = score.value;
	int rank = score.rank;
	int errorCode = 0;
	if(error != nil)
	{
		errorCode = error.code;
	}
	
	queueGameCenterManagerEvent("didReportScore", "", errorCode, identifier, value, rank, 0.0f, false);
}

- (void)gameCenterManager:(GameCenterManager *)manager didSaveScore:(GKScore *)score
{
	const char* identifier = [score.leaderboardIdentifier cStringUsingEncoding:[NSString defaultCStringEncoding]];
	int value = score.value;
	int rank = score.rank;
	
	queueGameCenterManagerEvent("didSaveScore", "", 0, identifier, value, rank, 0.0f, false);
}

- (void)gameCenterManager:(GameCenterManager *)manager didSaveAchievement:(GKAchievement *)achievement
{
	const char* identifier = [achievement.identifier cStringUsingEncoding:[NSString defaultCStringEncoding]];
	float percentComplete = achievement.percentComplete;
	bool showsCompletionBanner = achievement.showsCompletionBanner;
	
	queueGameCenterManagerEvent("didSaveAchievement", "", 0, identifier, 0, 0, percentComplete, showsCompletionBanner);
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