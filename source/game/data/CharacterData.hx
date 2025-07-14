package game.data;

import flixel.math.FlxPoint;
import flixel.util.typeLimit.OneOfThree;

typedef CharacterData =
{
	healthBarColor:OneOfThree<String, Int, Array<Int>>,
	position: {
		global:Array<Int>, 
        camera:Array<Int>
	},
    animations: Array<CharacterAnimationData>,
    ?renderType:String,
    ?scale: Array<Int>,
    ?flipX:Bool,
    ?flipY:Bool
}

typedef CharacterAnimationData = {
    name:String,
    prefix:String,
    offsets: Array<Int>,
    ?framerate:Int,
    ?loop:Bool,
    ?flipX:Bool,
    ?flipY:Bool,
    ?indices:Array<Int>
}
