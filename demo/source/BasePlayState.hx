package;
import flixel.FlxState;

class BasePlayState extends FlxState {
	private var eventText:TextItem;
	
	public function new() {
		super();
		
		eventText = new TextItem(0, 0, "Starting...");
		add(eventText);
	}
	
	public function addText(text:String):Void {
		eventText.text = text + "\n" + eventText.text;
	}
	
	public function clearTextLog():Void {
		eventText.text = "Waiting...";
	}
}