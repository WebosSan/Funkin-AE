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
		strums.clear();
		for (id in 0...lanes)
		{
			var strum:Strum = new Strum(0, 0, id, skin);
			strums.add(strum);
			strum.x = strums.x;
			strum.y = strums.y;
			strum.x += (160 * 0.7) * id;
		}
	}
}
