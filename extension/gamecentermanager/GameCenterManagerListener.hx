package extension.GameCenterManager;

class GameCenterManagerListener {
	public function shouldAuthenticateUser():Void {
	}
	
	public function onAvailabilityChanged(availabilityState:String):Void { // TODO
	}
	
	public function onError(error:String):Void {
	}
	
	// TODO potentially implement GKScore, GKAchievement, GKPlayer structs and pass as parameters here
	public function didReportScore(identifier:String, rank:Int, value:Int):Void {
	}
	
	public function didReportAchievement(identifier:String, percentComplete:Float, showsCompletionBanner:Bool):Void {
	}
	
	public function didSaveAchievement(identifier:String, percentComplete:Float, showsCompletionBanner:Bool):Void {
	}
	
	public function didSaveScore(identifier:String, rank:Int, value:Int):Void {
	}
	
	public function onAchievementsReset():Void {
	}
	
	public function onChallengesRequestCompletion(challenges:Array<Challenge>, error:String):Void { // TODO
	}
	
	private static inline var SHOULD_AUTHENTICATE_USER:String = "shouldAuthenticateUser";
	private static inline var ON_AVAILABILITY_CHANGED:String = "onAvailabilityChanged";
	private static inline var ON_ERROR:String = "onError";
	private static inline var DID_REPORT_SCORE:String = "didReportScore";
	private static inline var DID_REPORT_ACHIEVEMENT:String = "didReportAchievement";
	private static inline var DID_SAVE_ACHIEVEMENT:String = "didSaveAchievement";
	private static inline var DID_SAVE_SCORE:String = "didSaveScore";
	private static inline var ON_ACHIEVEMENTS_RESET:String = "onAchievementsReset";
	private static inline var ON_CHALLENGES_REQUEST_COMPLETION = "onChallengesRequestCompletion";
	
	public function notify(inEvent:Dynamic):Void {
		var type:String = null;
		
		if(Reflect.hasField(inEvent, "type")) {
			type = Std.string (Reflect.field(inEvent, "type"));
		}
		
		switch(type) {
			case SHOULD_AUTHENTICATE_USER:
				shouldAuthenticateUser();
			case ON_AVAILABILITY_CHANGED:
				// TODO implement reflection stuff
			case ON_ERROR:
			case DID_REPORT_SCORE:
			case DID_REPORT_ACHIEVEMENT:
			case DID_SAVE_ACHIEVEMENT:
			case DID_SAVE_SCORE:
			case ON_ACHIEVEMENTS_RESET:
			case ON_CHALLENGES_REQUEST_COMPLETION:
		}
	}
}