package game.objects.notes;

import game.play.PlaySettings;
import haxe.Json5;

class Strum extends FlxSprite
{
	public var lane:Int;
	public var isPlayer:Bool;
	public var type:String;

	public var size(default, set):Float;

	function set_size(v:Float):Float
	{
		size = v;
		setGraphicSize(v, v);
		updateHitbox();
		return size;
	}

	public function new(x:Float, y:Float, lane:Int, ?type:String = "default", ?isPlayer:Bool)
	{
		super(x, y);
		this.lane = lane;
		this.isPlayer = isPlayer;
		this.type = type;

		var data:
			{
				lanes:Array<
					{
						direction:String,
						animations:Array<
							{
								name:String,
								prefix:String,
								framerate:Int
							}>
					}>
			} = Json5.parse(Paths.getText(type + "/data", "json5", "data/strums"));

		frames = Paths.getSparrowAtlas("notes", "data/strums/" + type);
        @:noCompletion
        var animData = Lambda.find(data.lanes, f -> f.direction == PlaySettings.keyOrder.get(PlaySettings.keyModes)[lane]);

        var _static = Lambda.find(animData.animations, a -> a.name == "static");
        var _pressed = Lambda.find(animData.animations, a -> a.name == "pressed");
        var _confirm = Lambda.find(animData.animations, a -> a.name == "confirm");

        animation.addByPrefix("static", _static.prefix, _static.framerate);
        animation.addByPrefix("pressed", _pressed.prefix, _pressed.framerate);
        animation.addByPrefix("confirm", _confirm.prefix, _confirm.framerate);
        animation.play("static");
	}
}
