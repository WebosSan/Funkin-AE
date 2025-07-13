package game.debug;

import backend.Logger;
import backend.Paths;
import game.objects.Playfield;
import haxe.Log;
import sys.FileSystem;

//Ill be using this class to test a few things
class TestState extends FlxState{
    override function create() {
        super.create();

        //Path shits

        #if desktop
		// How FileSystem looks
		Logger.log(FileSystem.readDirectory(Paths.getPath("data")));
		// How Paths loooks
		Logger.log(Paths.readDirectory("data"));

		Logger.log(Paths.getText("here goes data"));
        #end
		var dad:FlxSprite = new FlxSprite();
		dad.frames = Paths.getSparrowAtlas("daddy dearest/spritesheet", "data/characters");
		dad.screenCenter();
		dad.animation.addByPrefix("idle", "Dad idle dance", 24);
		dad.animation.play("idle");
		add(dad);
		add(new Playfield());
    }
}