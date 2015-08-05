# Haxe-GameCenterManager

WORK IN PROGRESS.

Unofficial GameCenterManager Haxe bindings for OSX and iOS. 

### Features ###

Supports:
* Sync, submit, save, retrieve and track Game Center leaderboards, achievements and challenges.
* Customizable listener for reacting to Game Center events.
* Single API for Game Center on iOS and Mac OSX.

Doesn't Support:
* Fetching challenges.
* Fetching the local player's player data or profile image.

If there is something you would like adding let me know. Pull requests welcomed too! Here it is in action:
	
![Screenshot of it working](https://github.com/Tw1ddle/haxe-gamecentermanager/blob/master/demo/screenshots/unavailable.png?raw=true "Screenshot")

### Install ###

```bash
haxelib install gamecentermanager
```

### Usage ###

Include the haxelib through Project.xml:
```xml
<haxelib name="gamecentermanager" />
```

```haxe
import extension.gamecentermanager.GameCenterManager;
import extension.gamecentermanager.GameCenterManagerListener;

// Basic usage
GameCenterManager.setupManager();
GameCenterManager.setListener(new GameCenterManagerListener()); // Optional. Implement your own listener.
GameCenterManager.authenticateUser();

// A bit later...
if(GameCenterManager.isGameCenterAvailable()) {
	GameCenterManager.presentLeaderboards();
}

// Later...
if(GameCenterManager.isGameCenterAvailable()) {
	GameCenterManager.saveAndReportScore("my_leaderboard_id", 9001, GameCenterSortOrder.HighToLow);
	GameCenterManager.saveAndReportAchievement("my_achievement_id", 100.0, true);
}
```

See the demo app bundled in this distribution for another usage example.

### Notes ###
GameCenterManager supports iOS 7.0 and OSX 10.9 and higher deployment targets.

The ndlls are compiled with the ```-DOBJC_ARC``` flag i.e.
```
haxelib run hxcpp Build.xml -Dmac -DHXCPP_M64 -DOBJC_ARC
haxelib run hxcpp Build.xml -Diphoneos -DOBJC_ARC
haxelib run hxcpp Build.xml -Diphoneos -DHXCPP_ARMV7 -DOBJC_ARC
haxelib run hxcpp Build.xml -Diphoneos -DHXCPP_ARM64 -DOBJC_ARC
haxelib run hxcpp Build.xml -Diphonesim -DHXCPP_M64 -DOBJC_ARC
haxelib run hxcpp Build.xml -Diphonesim -DOBJC_ARC
```

Since the legacy runtime does not support ```-DOBJ_ARC```, only 64-bit is supported on Mac.