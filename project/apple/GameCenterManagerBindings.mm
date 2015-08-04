#ifdef IPHONE
#import <UIKit/UIKit.h>
#endif

#import <CoreFoundation/CoreFoundation.h>
#include <ctype.h>
#include <objc/runtime.h>

#import "../../lib/GameCenterManager/GC Manager/GameCenterManager.h"
#include "GameCenterManagerBindings.h"

// TODO put these parameters into a struct or have multiple event handles?
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

#ifdef HX_MACOS
@interface MyGKGameCenterControllerDelegate : NSObject<GKGameCenterControllerDelegate>
@end

@implementation MyGKGameCenterControllerDelegate

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    queueGameCenterManagerEvent("onGameCenterViewControllerFinished");
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    
    dispatch_once(&once, ^
    {
        sharedInstance = [self new];
    });
    
    return sharedInstance;
}

@end
#endif

@interface MyGameCenterManagerDelegate : NSObject<GameCenterManagerDelegate>
@end

@implementation MyGameCenterManagerDelegate

#ifdef IPHONE
- (void)gameCenterManager:(GameCenterManager *)manager authenticateUser:(UIViewController *)gameCenterLoginController 
{
    [self presentViewController:gameCenterLoginController animated:YES completion:^{
        queueGameCenterManagerEvent("shouldAuthenticateUser");
    }];	
}
#elif defined HX_MACOS
- (void)gameCenterManager:(GameCenterManager *)manager authenticateUser:(NSViewController *)gameCenterLoginController
{
	[self presentViewControllerAsModalWindow:gameCenterLoginController];
    queueGameCenterManagerEvent("shouldAuthenticateUser");
}
#endif

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
	
	void authenticateUser()
	{
		#ifdef IPHONE
		UIViewController *glView = [[[UIApplication sharedApplication] keyWindow] rootViewController];
		[[GameCenterManager sharedManager] authenticateUser:glView];
		#elif defined HX_MACOS
        NSWindow* mainWindow = [[NSApplication sharedApplication] mainWindow];
        if(mainWindow == nil || mainWindow.windowController == nil)
        {
            return;
        }
		[[GameCenterManager sharedManager] authenticateUser:mainWindow.windowController];
		#endif
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
#ifdef IPHONE
		UIViewController *glView = [[[UIApplication sharedApplication] keyWindow] rootViewController];
		[[GameCenterManager sharedManager] presentAchievementsOnViewController: glView];
#elif defined HX_MACOS
        GKGameCenterViewController *achievementViewController = [[GKGameCenterViewController alloc] init];
        achievementViewController.viewState = GKGameCenterViewControllerStateAchievements;
        achievementViewController.gameCenterDelegate = [MyGKGameCenterControllerDelegate sharedInstance];
        NSWindow* mainWindow = [[NSApplication sharedApplication] mainWindow];
        if(mainWindow == nil || mainWindow.windowController == nil)
        {
            return;
        }
        [mainWindow.windowController presentViewControllerAsModalWindow:achievementViewController];
#endif
	}
	
	void presentLeaderboards()
	{
#ifdef IPHONE
		UIViewController *glView = [[[UIApplication sharedApplication] keyWindow] rootViewController];
		[[GameCenterManager sharedManager] presentLeaderboardsOnViewController: glView];
#elif defined HX_MACOS
        GKGameCenterViewController *leaderboardViewController = [[GKGameCenterViewController alloc] init];
        leaderboardViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
        leaderboardViewController.gameCenterDelegate = [MyGKGameCenterControllerDelegate sharedInstance];
        NSWindow* mainWindow = [[NSApplication sharedApplication] mainWindow];
        if(mainWindow == nil || mainWindow.windowController == nil)
        {
            return;
        }
        [mainWindow.windowController presentViewControllerAsModalWindow:leaderboardViewController];
#endif
	}
	
	void presentChallenges()
	{
#ifdef IPHONE
		UIViewController *glView = [[[UIApplication sharedApplication] keyWindow] rootViewController];
		[[GameCenterManager sharedManager] presentChallengesOnViewController: glView];
#elif defined HX_MACOS
        GKChallengesViewController *challengesViewController = [[GKChallengesViewController alloc] init];
        NSWindow* mainWindow = [[NSApplication sharedApplication] mainWindow];
        if(mainWindow == nil || mainWindow.windowController == nil)
        {
            return;
        }
        [mainWindow.windowController presentViewControllerAsModalWindow:challengesViewController];
#endif
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