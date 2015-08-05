package;
import flixel.FlxState;

class BasePlayState extends FlxState {
	public var eventText:TextItem;
	
	override public function create() {
		super.create();
		
		eventText = new TextItem(0, 0, "Starting...", 12);
		add(eventText);
	}
	
	public function addText(text:String):Void {
		eventText.text = text + "\n" + eventText.text;
	}
	
	public function clearTextLog():Void {
		eventText.text = "Waiting...";
	}
}