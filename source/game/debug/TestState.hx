package game.debug;

import backend.Paths;
import sys.FileSystem;

//Ill be using this class to test a few things
class TestState extends FlxState{
    override function create() {
        super.create();

        //Path shits

        #if desktop
        trace(FileSystem.readDirectory(Paths.getPath("data")));
        #end
    }
}