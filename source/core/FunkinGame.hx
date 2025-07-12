package core;

import backend.Conductor;
import flixel.FlxG;
import flixel.FlxGame;
import openfl.events.Event;

class FunkinGame extends FlxGame{
    public static var instance:FunkinGame;

    override function create(_:Event) {
        super.create(_);
    }

    override function update() {
        super.update();
        instance = this;
        Conductor.update(FlxG.elapsed);
    }
}