package game.debug;

import backend.Paths;
import sys.FileSystem;

//Ill be using this class to test a few things
class TestState extends FlxState{
    override function create() {
        super.create();

        //Path shits

        #if desktop
		// How FileSystem looks
        trace(FileSystem.readDirectory(Paths.getPath("data")));
		// How Paths loooks
		trace(Paths.readDirectory("data"));

		trace(Paths.getText("here goes data"));
        #end
		var dad:FlxSprite = new FlxSprite();
		dad.frames = Paths.getSparrowAtlas("daddy dearest/spritesheet", "data/characters");
		dad.screenCenter();
		dad.animation.addByPrefix("idle", "Dad idle dance", 24);
		dad.animation.play("idle");
		add(dad);
    }
}