package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;

import extension.gamecentermanager.GameCenterManager;
import extension.gamecentermanager.GameCenterManagerListener;

class GameCenterPlayState extends BasePlayState {
	private static inline var LEADERBOARD_ID:String = "leaderboard_id";
	private static inline var ACHIEVEMENT_ID:String = "achievement_1";
	private var score(default,set):Int = 0;
	
	override public function create():Void {
		super.create();
		
		addText("Setting up Game Center Manager...");
		GameCenterManager.setupManager();
		addText("Setting Game Center Manager listener...");
		GameCenterManager.setListener(new MyGameCenterManagerListener(this));
		//GameCenterManager.setupManagerAndSetShouldCryptWithKey();
		
		addText("Creating buttons...");
		
		var x:Int = 200;
		var y:Int = 20;
		
		var addButton = function(msg:String, cb:Void->Void) {
			var button = new TextButton(x, y, msg, cb);
			add(button);
			
			x += Std.int(button.width + 20);
			
			if (x + button.width + 20 >= FlxG.width) {
				y += Std.int(button.height + 20);
				x = 200;
			}
		};
		
		addButton("Player Id", function() {
			addText("Player Id: " + GameCenterManager.localPlayerId);
		});
		addButton("Player Display Name", function() {
			addText("Player Display Name: " + GameCenterManager.localPlayerDisplayName);
		});
		addButton("Using Encryption?", function() {
			addText("Encryption Enabled: " + GameCenterManager.shouldCryptData);
		});
		addButton("Encryption Key?", function() {
			addText("Encryption Key: " + GameCenterManager.cryptKey);
		});
		addButton("Authenticate User", function() {
			addText("Serving Authenticate User Request");
			 GameCenterManager.authenticateUser();
		});
		addButton("Sync Game Center", function() {
			addText("Syncing Game Center");
			GameCenterManager.syncGameCenter();
		});
		addButton("Save + Report Score", function() {
			addText("Saving And Reporting Score (" + score + ")");
			GameCenterManager.saveAndReportScore(LEADERBOARD_ID, score, GameCenterSortOrder.HighToLow);
			score++;
		});
		addButton("Save + Report Achievement", function() {
			addText("Saving And Reporting Achievement");
			GameCenterManager.saveAndReportAchievement(ACHIEVEMENT_ID, 100.0, true);
		});
		addButton("Report Saved Scores + Achievements", function() {
			addText("Reporting Saved Scores and Achievements");
			GameCenterManager.reportSavedScoresAndAchievements();
		});
		addButton("Save Score For Later", function() {
			addText("Saving Score For Later (" + score + ")");
			GameCenterManager.saveScoreToReportLater(LEADERBOARD_ID, score);
			score++;
		});
		addButton("Save Achievement For Later", function() {
			addText("Saving Achievement For Later");
			GameCenterManager.saveAchievementToReportLater(ACHIEVEMENT_ID, 100.0);
		});
		addButton("Highscore For Leaderboard", function() {
			addText("Highscore For Leaderboard " + GameCenterManager.highScoreForLeaderboard(LEADERBOARD_ID));
		});
		addButton("Progress For Achievement", function() {
			addText("Progress For Achievement " + GameCenterManager.progressForAchievement(ACHIEVEMENT_ID));
		});
		//addButton("Request Challenges", function() {
		//	addText("Requesting Challenges");
		//	GameCenterManager.requestChallenges();
		//});
		addButton("Present Achievements", function() {
			addText("Presenting Achievements");
			 GameCenterManager.presentAchievements();
		});
		addButton("Present Leaderboards", function() {
			addText("Presenting Leaderboards");
			GameCenterManager.presentLeaderboards();
		});
		addButton("Present Challenges", function() {
			addText("Presenting Challenges");
			GameCenterManager.presentChallenges();
		});
		addButton("Reset Achievements", function() {
			addText("Resetting Achievements");
			GameCenterManager.resetAchievements();
		});
		addButton("Is Internet Available", function() {
			addText("Is Internet Available: " + GameCenterManager.isInternetAvailable());
		});
		addButton("Is Game Center Available", function() {
			addText("Is Game Center Available: " + GameCenterManager.isGameCenterAvailable());
		});
		addButton("Clear Text Log", function() {
			clearTextLog();
			addText("Cleared Text Log...");
		});
		
		addText("Initialization complete...");
	}
	
	private function set_score(score:Int):Int {
		addText("Setting current score to " + score);
		return this.score = score;
	}
}

class MyGameCenterManagerListener extends GameCenterManagerListener {
	private var game:GameCenterPlayState;
	
	public function new(state:GameCenterPlayState) {
		super();
		game = state;
	}
	
	override public function shouldAuthenticateUser():Void {
		game.addText("shouldAuthenticateUser");
	}
	
	override public function onAvailabilityChanged(availabilityState:String):Void {
		game.addText("onAvailabilityChanged: " + availabilityState);
	}
	
	override public function onError(error:String):Void {
		game.addText("onError: " + error);
	}
	
	override public function didReportScore(identifier:String, rank:Int, value:Int):Void {
		game.addText("didReportScore: " + identifier + " " + rank + " " + value);
	}
	
	override public function didReportAchievement(identifier:String, percentComplete:Float, showsCompletionBanner:Bool):Void {
		game.addText("didReportAchievement: " + identifier + " " + percentComplete + " " + showsCompletionBanner);
	}
	
	override public function didSaveAchievement(identifier:String, percentComplete:Float, showsCompletionBanner:Bool):Void {
		game.addText("didSaveAchievement: " + identifier + " " + percentComplete + " " + showsCompletionBanner);
	}
	
	override public function didSaveScore(identifier:String, rank:Int, value:Int):Void {
		game.addText("didSaveScore: " + identifier + " " + rank + " " + value);
	}
	
	override public function onAchievementsReset():Void {
		game.addText("onAchievementsReset");
	}
	
	//override public function onChallengesRequestComplete(challenges:Array<Challenge>, error:String):Void { // TODO
	//	game.addText("onChallengesRequestComplete");
	//}

	// Note Mac only, and only when achievements/leaderboards views finish, not challenges
	override public function onGameCenterViewControllerFinished() {
		game.addText("onGameCenterViewControllerFinished");
	}
}