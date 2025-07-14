package game.objects;

import flixel.group.FlxGroup;
import flixel.math.FlxPoint;

class Playfield extends FlxGroup
{
	public var strumlines:FlxTypedGroup<Strumline>;
	public var opponentStrums:Strumline;
	public var playerStrums:Strumline;

	public function new(downScroll:Bool = false, ?skin:String = "default")
	{
		super();
		var keyCount:Int = 4; // replace this with the actual keycount soon
		strumlines = new FlxTypedGroup<Strumline>();
		add(strumlines);

		opponentStrums = new Strumline(FlxPoint.get(50, !downScroll ? 50 : FlxG.height - 150), keyCount, skin);
        opponentStrums.bot = true;
		strumlines.add(opponentStrums);

		playerStrums = new Strumline(FlxPoint.get(110 + (FlxG.width / 2), opponentStrums.strums.y), keyCount, skin);
		strumlines.add(playerStrums);
	}
}
