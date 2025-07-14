package game.debug;

import backend.Logger;
import backend.Paths;
import flixel.math.FlxPoint;
import game.objects.Character;
import haxe.Log;
import haxe.Timer;
import sys.FileSystem;

//Ill be using this class to test a few things
class TestState extends FlxState{
	var dad:Character;

    override function create() {
        super.create();

		Conductor.loadSong(Paths.getInst("test"), 100);

        #if desktop
		// How FileSystem looks
		Logger.log(FileSystem.readDirectory(Paths.getPath("data")));
		// How Paths loooks
		Logger.log(Paths.readDirectory("data"));

		Logger.log(Paths.getText("here goes data"));
		#end
		dad = Character.createCharacter(0, 0, "dad", false);
		dad.screenCenter();
		add(dad);
	}
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (Controls.LEFT_P)
		{
			dad.playAnimation("singLEFT", true);
		}
		else if (Controls.RIGHT_P)
		{
			dad.playAnimation("singRIGHT", true);
		}
		else if (Controls.UP_P)
		{
			dad.playAnimation("singUP", true);
		}
		else if (Controls.DOWN)
		{
			dad.playAnimation("singDOWN", true);
		}
	}
}