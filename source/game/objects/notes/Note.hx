package game.objects.notes;

import flixel.FlxObject;
import flixel.util.FlxSignal.FlxTypedSignal;
import game.play.PlaySettings;
import haxe.Json5;

class Note extends FlxSprite
{
	public var lane:Int;
	public var isPlayer:Bool;
	public var strum:Float;

	public var target:FlxObject;

	public static var isHittableSignal:FlxTypedSignal<Note->Void> = new FlxTypedSignal();

	private var data:NotesObjectData;

	public var size(default, set):Float;

	function set_size(v:Float):Float
	{
		size = v;
		setGraphicSize(v, v);
		updateHitbox();
		return size;
	}

	public function new(x:Float, y:Float, lane:Int, type:String = "default", ?isPlayer:Bool = false, ?strum:Float = 0)
	{
		super(x, y);

		this.lane = lane;
		this.isPlayer = isPlayer;
		this.strum = strum;

		data = Json5.parse(Paths.getText(type + "/data", "json5", "data/notes"));

		frames = Paths.getSparrowAtlas("notes", "data/notes/" + type);

		var animData:LaneData = data.lanes.filter(i -> i.direction == PlaySettings.keyOrder.get(PlaySettings.keyModes)[lane])[0];
		animation.addByPrefix("normal", animData.normal, 24);
		animation.play("normal");
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (target != null)
		{
			this.y = target.y - (Conductor.time - strum) * (0.5 * PlaySettings.speed);
			this.x = target.x;
		}

		hitWindow();
	}

	function hitWindow()
	{
		if (isPlayer)
		{
			if (Conductor.time >= strum - ((10 / 60) * 1000) && Conductor.time < strum + ((10 / 60) * 1000 / 2))
			{
				isHittableSignal.dispatch(this);
			}
		}
		else
		{
			if (strum <= Conductor.time)
			{
				isHittableSignal.dispatch(this);
			}
		}
	}
}

typedef LaneData =
{
	var direction:String;
	var normal:String;
	var hold:String;
	var end:String;
}

typedef NotesObjectData =
{
	var lanes:Array<LaneData>;
}
