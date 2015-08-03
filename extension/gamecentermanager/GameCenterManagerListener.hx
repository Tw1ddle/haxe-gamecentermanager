package extension.GameCenterManager;

@:enum abstract GameCenterManagerErrorCode(Int) {
	var Unknown = 1;
	var NotAvailable = 2;
	var FeatureNotAvailable = 3;
	var InternetNotAvailable = 4;
	var AchievementDataMissing = 5;
}

class GameCenterManagerListener {
	public function shouldAuthenticateUser():Void {
	}
	
	public function onAvailabilityChanged(availabilityState:String):Void { // TODO
	}
	
	public function onError(error:String):Void {
	}
	
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
	
	public function onChallengesRequestComplete(challenges:Array<Challenge>, error:String):Void { // TODO
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
				var availabilityState:String = Std.string (Reflect.field(inEvent, "availabilityState"));
				onAvailabilityChanged(availabilityState);
			case ON_ERROR:
				var error:String = Std.string (Reflect.field(inEvent, "error"));
				onError(error);
			case DID_REPORT_SCORE:
				var identifier:String = Std.string (Reflect.field(inEvent, "identifier"));
				var rank:Int = Std.int (Reflect.field(inEvent, "rank"));
				var value:Int = Std.int (Reflect.field(inEvent, "value"));
				didReportScore(identifier, rank, value);
			case DID_REPORT_ACHIEVEMENT:
				var identifier:String = Std.string (Reflect.field(inEvent, "identifier"));
				var percentComplete:Float = cast (Reflect.field(inEvent, "percentComplete"));
				var showsCompletionBanner:Bool = cast (Reflect.field(inEvent, "showsCompletionBanner"));
				didReportAchievement(identifier, percentComplete, showsCompletionBanner);
			case DID_SAVE_ACHIEVEMENT:
				var identifier:String = Std.string (Reflect.field(inEvent, "identifier"));
				var percentComplete:Float = cast (Reflect.field(inEvent, "percentComplete"));
				var showsCompletionBanner:Bool = cast (Reflect.field(inEvent, "showsCompletionBanner"));
				didSaveAchievement(identifier, percentComplete, showsCompletionBanner);
			case DID_SAVE_SCORE:
				var identifier:String = Std.string (Reflect.field(inEvent, "identifier"));
				var rank:Int = Std.int (Reflect.field(inEvent, "rank"));
				var value:Int = Std.int (Reflect.field(inEvent, "value"));
				didSaveScore(identifier, rank, value);
			case ON_ACHIEVEMENTS_RESET:
				onAchievementsReset();
			case ON_CHALLENGES_REQUEST_COMPLETION:
				// TODO
		}
	}
}