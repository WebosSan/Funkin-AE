package;

import backend.PlayerSettings;
import core.FunkinGame;
import flixel.FlxGame;
import game.debug.TestState;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		PlayerSettings.init();
		addChild(new FunkinGame(0, 0, TestState, 60, 60, true, false));
	}
}
