# Haxe-GameCenterManager

WORK IN PROGRESS.

[GameCenterManager](https://github.com/nihalahmed/GameCenterManager) Haxe bindings for OSX and iOS. 

### Features ###

Supports:
* Sync, submit, save, retrieve and track Game Center leaderboards, achievements and challenges.
* Customizable listener for reacting to Game Center events.
* Single API for Game Center across iOS and Mac OSX.

Doesn't Support:
* Fetching challenges.
* Exposing local player data or profile image to Haxe.

If there is something you would like adding let me know. Here it is in action:
	
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

Basic usage:
```haxe
import extension.gamecentermanager.GameCenterManager;
import extension.gamecentermanager.GameCenterManagerListener;

GameCenterManager.setupManager();
GameCenterManager.setListener(new GameCenterManagerListener()); // Extend the default listener to manage events yourself.
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

Refer to the [GameCenterManager documentation](https://github.com/nihalahmed/GameCenterManager) and the headers for explanations of what each method does. Also see the demo app bundled in this distribution.

### Notes ###
GameCenterManager supports iOS 7.0+ and OSX 10.9+ deployment targets.

The ndlls are compiled with the ```-DOBJC_ARC``` flag:
```
haxelib run hxcpp Build.xml -Dmac -DHXCPP_M64 -DOBJC_ARC
haxelib run hxcpp Build.xml -Diphoneos -DOBJC_ARC
haxelib run hxcpp Build.xml -Diphoneos -DHXCPP_ARMV7 -DOBJC_ARC
haxelib run hxcpp Build.xml -Diphoneos -DHXCPP_ARM64 -DOBJC_ARC
haxelib run hxcpp Build.xml -Diphonesim -DHXCPP_M64 -DOBJC_ARC
haxelib run hxcpp Build.xml -Diphonesim -DOBJC_ARC
```

Since the legacy runtime does not support ARC, only 64-bit is supported on Mac.

Remember to follow Apple's documentation when testing your Game Center aware app. GameCenterManager will return ```GameCenterAvailable = false```, even when Game Center is in sandbox mode.

Note that the ```GameCenterManager.authenticateUser``` method is asynchronous but is not guaranteed to bring up an authentication challenge view. So I do not recommend suspending your app or waiting for the view to be dismissed after calling this method.