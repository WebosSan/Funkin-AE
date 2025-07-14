package game.objects;

import flixel.FlxCamera;
import flixel.math.FlxPoint;

class FunkinSprite extends FlxSprite
{
	public var positionOffset:FlxPoint = new FlxPoint();
	public var animOffsets:Map<String, FlxPoint> = new Map();

	public var danceOnBeat:Bool = true;

	private var _currentOffset:FlxPoint = new FlxPoint();

	public function new(x:Float = 0, y:Float = 0)
	{
		super(0, 0);
        Conductor.onBeat.add(onBeat);
        Conductor.onStep.add(onStep);
	}

	public function existsAnimation(name:String)
	{
		return animation.getByName(name) != null;
	}

	public function currentAnimation()
	{
		return animation != null ? animation.name : "";
	}

	public function setAnimationByPrefix(name:String, prefix:String, offset:FlxPoint, ?framerate:Int = 24, ?loop:Bool = false, ?flipX:Bool = false,
			?flipY:Bool = false)
	{
		this.animation.addByPrefix(name, prefix, framerate, loop, flipX, flipY);
		animOffsets.set(name, offset);
	}

	public function setAnimationByIndices(name:String, prefix:String, indices:Array<Int>, offset:FlxPoint, ?framerate:Int = 24, ?loop:Bool = true,
			?flipX:Bool = false, ?flipY:Bool = false)
	{
		this.animation.addByIndices(name, prefix, indices, "", framerate, loop, flipX, flipY);
		animOffsets.set(name, offset);
	}

	public function playAnimation(name:String, ?force:Bool = false)
	{
		this.animation.play(name, force);

		if (animOffsets.exists(name))
			_currentOffset = animOffsets.get(name);
		else
			_currentOffset = new FlxPoint();
	}

	public function onBeat(b:Int)
	{
		if (danceOnBeat)
			dance();
	}

	public function onStep(s:Int) {}

	public function dance()
	{
		if (existsAnimation("danceLeft"))
		{
			if (currentAnimation() == "danceLeft")
			{
				playAnimation("danceRight");
			}
			else if (currentAnimation() == "danceRight")
			{
				playAnimation("danceLeft");
			}
		}
		else if (existsAnimation("idle"))
		{
			playAnimation("idle");
		}
	}

	override function getScreenPosition(?result:FlxPoint, ?camera:FlxCamera):FlxPoint
	{
		var pos:FlxPoint = super.getScreenPosition(result, camera);
		pos += positionOffset;
		pos += _currentOffset;
		return pos;
	}
}
