package game.objects;

import backend.Paths;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;
import game.data.ArrowData;
import haxe.Json5;

class Strum extends FunkinSprite
{
	public static var lanes:Array<String> = ["left", "down", "up", "right", "space", "left2", "down2", "up2", "right2"]; // handy for picking

	public var lane:Int = 0; // direction
	public var downScroll:Bool = false; // should the notes with the same lane as this strum scroll down or up?
	public var skin:ArrowData; // skindata ig

	public function new(x:Float = 0, y:Float = 0, lane:Int = 0, ?skinName:String = "default")
	{
		super();
		setPosition(x, y);
		this.lane = lane;
		reload(skinName);
	}

	public function reload(skinName:String = "default") // useful for changing the looks
	{
		if (!Paths.exists('notes/$skinName/data.json5', 'data')) // fallback just incase the skin doesnt exist
			skinName = 'default';
		skin = Json5.parse(Paths.getText('notes/$skinName/data', 'json5', 'data'));
		frames = Paths.getSparrowAtlas('notes/$skinName/notes', 'data');
		var animations = skin.lanes[lane % skin.lanes.length].animations;
		for (animationData in animations)
			setAnimationByPrefix(animationData.name, animationData.prefix, FlxPoint.get(), animationData.framerate, false);
		playAnimation('static');
		updateHitbox();

		setGraphicSize(width * skin.scale);
		antialiasing = skin.antialiasing;
		updateHitbox();

		playAnimation('static');
	}

	public override function playAnimation(name:String, ?force:Bool = false) // overriden to fix offsets (offsets dont scale thats why)
	{
		super.playAnimation(name, force);
		centerOffsets();
		centerOrigin();
	}
}
