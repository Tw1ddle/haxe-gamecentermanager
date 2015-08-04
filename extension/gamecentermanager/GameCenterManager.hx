package extension.GameCenterManager;

import flash.Lib;

@:enum abstract GameCenterSortOrder(Int) {
	var HighToLow = 0;
	var LowToHigh = 1;
}

class GameCenterManager {
	public static var localPlayerId(get,null):String;
	public static var localPlayerDisplayName(get,null):String;
	public static var shouldCryptData(get,null):Bool;
	public static var cryptKey(get,null):String;
	
	public static function setListener(listener:GameCenterManagerListener):Void {
		set_listener(listener.notify);
	}
	
	public static function setupManager():Void {
		setup_manager();
	}
	
	public static function setupManagerAndSetShouldCryptWithKey(cryptKey:String):Void {
		setup_manager_with_crypt_key(cryptKey);
	}
	
	public static function authenticateUser():Void {
		authenticate_user();
	}
	
	public static function syncGameCenter():Void {
		sync_game_center();
	}
	
	public static function saveAndReportScore(leaderboardId:String, score:Int, sortOrder:GameCenterSortOrder):Void {
		save_and_report_score(leaderboardId, score, sortOrder);
	}
	
	public static function saveAndReportAchievement(identifier:String, percentComplete:Float, shouldDisplayNotification:Bool):Void {
		save_and_report_achievement(identifier, percentComplete, shouldDisplayNotification);
	}
	
	public static function reportSavedScoresAndAchievements():Void {
		report_saved_scores_and_achievements();
	}
	
	public static function saveScoreToReportLater(leaderboardId:String, score:Int):Void {
		save_score_to_report_later(leaderboardId, score, sortOrder);
	}
	
	public static function saveAchievementToReportLater(identifier:String, percentComplete:Float):Void {
		save_achievement_to_report_later(identifier, percentComplete);
	}
	
	public static function highScoreForLeaderboard(identifier:String):Int {
		return high_score_for_leaderboard(identifier);
	}
	
	public static function progressForAchievement(identifier:String):Float {
		return progress_for_achievement(identifier);
	}
	
	public static function requestChallenges():Void {
		request_challenges();
	}
	
	public static function presentAchievements():Void {
		present_achievements();
	}
	
	public static function presentLeaderboards():Void {
		present_leaderboards();
	}
	
	public static function presentChallenges():Void {
		present_challenges();
	}
	
	public static function resetAchievements():Void {
		reset_achievements();
	}
	
	public static function isInternetAvailable():Bool {
		return is_internet_available();
	}
	
	private static function isGameCenterAvailable():Bool {
		return is_game_center_available();
	}
	
	private static function get_localPlayerId():String {
		return local_player_id();
	}
	
	private static function get_localPlayerDisplayName():String {
		return local_player_display_name();
	}
	
	private static function get_shouldCryptData():Bool {
		return should_crypt_data();
	}
	
	private static function get_cryptKey():String {
		return crypt_key();
	}
	
	private static inline var libName:String = "gamecentermanager";
	
	private static var set_listener = Lib.load(libName, "set_listener", 1);
	
	private static var setup_manager = Lib.load(libName, "setup_manager", 0);
	private static var setup_manager_and_set_should_crypt_with_key = Lib.load(libName, "setup_manager_and_set_should_crypt_with_key", 1);
	private static var authenticate_user = Lib.load(libName, "authenticate_user", 0);
	private static var sync_game_center = Lib.load(libName, "sync_game_center, 0);
	private static var save_and_report_score = Lib.load(libName, "save_and_report_score", 3);
	private static var save_and_report_achievement = Lib.load(libName, "save_and_report_achievement", 3);
	private static var report_saved_scores_and_achievements = Lib.load(libName, "report_saved_scores_and_achievements", 0);
	private static var save_score_to_report_later = Lib.load(libName, "save_score_to_report_later", 2);
	private static var save_achievement_to_report_later = Lib.load(libName, "save_achievement_to_report_later", 2);
	private static var high_score_for_leaderboard = Lib.load(libName, "high_score_for_leaderboard", 1);
	
	private static var progress_for_achievement = Lib.load(libName, "progress_for_achievement", 1);
	private static var request_challenges = Lib.load(libName, "request_challenges", 0);
	
	private static var present_achievements = Lib.load(libName, "present_achievements", 0);
	private static var present_leaderboards = Lib.load(libName, "present_leaderboards", 0);
	private static var present_challenges = Lib.load(libName, "present_challenges", 0);
	
	private static var reset_achievements = Lib.load(libName, "reset_achievements", 0);
	private static var is_internet_available = Lib.load(libName, "is_internet_available", 0);
	private static var is_game_center_available = Lib.load(libName, "is_game_center_available", 0);
	private static var local_player_id = Lib.load(libName, "local_player_id", 0);
	private static var local_player_display_name = Lib.load(libName, "local_player_display_name", 0);
	private static var should_crypt_data = Lib.load(libName, "should_crypt_data", 0);
	private static var crypt_key = Lib.load(libName, "crypt_key", 0);
	
	// UNIMPLEMENTED
	//public static var localPlayerData(get,null):GameKitPlayerData;
	//	private static function get_localPlayerData():GameKitPlayerData {
	//	return local_player_data();
	//}
	//public static function progressForAchievements(identifiers:Array<String>):Map<String, Float> {
	//	return progress_for_achievements(identifiers);
	//}
	//public static function highScoreForLeaderboards(identifiers:Array<String>):Map<String, Int> {
	//	return high_score_for_leaderboards(identifiers);
	//}
	//public static function localPlayerPhoto():Void {
	//}
	//private static var progress_for_achievements = Lib.load(libName, "progress_for_achievements", 1);
	//private static var high_score_for_leaderboards = Lib.load(libName, "high_score_for_leaderboards", 1);
	//private static var local_player_data = Lib.load(libName, "local_player_data", 0);
}