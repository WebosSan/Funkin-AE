package game.objects;

import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;

using flixel.util.FlxDestroyUtil;

class Strumline extends FlxGroup
{
	public var strums:FlxTypedSpriteGroup<Strum>;
    public var bot:Bool = false;

	public function new(strumPos:FlxPoint, lanes:Int = 4, ?skin:String = "default")
	{
		super();
		strums = new FlxTypedSpriteGroup<Strum>(strumPos.x, strumPos.y);
		add(strums);

		generateStrums(lanes);
	}

	public function generateStrums(lanes:Int = 4, ?skin:String = "default")
	{
		if (lanes > 9) // to prevent users from generating too many strums
			lanes = 9;
	
		strums.clear();
		for (id in 0...lanes) // i also added size readjustments :3
		{
			var set = lanes / 4;
			if (lanes < 5)
				set = 1;
			var strum:Strum = new Strum(0, 0, id, skin);
			strums.add(strum);
			strum.x = strums.x;
			strum.y = strums.y;
			strum.x += (160 * 0.7 / set) * id;
			strum.scale.x /= set;
			strum.scale.y /= set;
			strum.updateHitbox();
			strum.playAnimation('static');

		}
	}
}
