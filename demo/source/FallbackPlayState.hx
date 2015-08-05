package;

class FallbackPlayState extends BasePlayState {
	override public function create() {
		super.create();
		addText("This is an unsupported target. Build for Mac or iOS...");
	}
}