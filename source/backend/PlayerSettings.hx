package backend;

import flixel.input.FlxInput.FlxInputState;
import flixel.input.keyboard.FlxKey;
import game.play.PlaySettings;

class PlayerSettings
{
	public static var useAntialiasing:Bool = true;
	public static var currentMod:String = "Friday Night Funkin'";
	public static var keybinds:KeyBindsData;

	public static function init()
	{
		if (!FlxG.save.bind("FunkinAE"))
		{
			Logger.warn("Could'nt connect settings data, using default settings");
			useAntialiasing = true;
			currentMod = "Friday Night Funkin'";
			keybinds = {
				ui: {
					up: [W, UP],
					left: [A, LEFT],
					right: [D, RIGHT],
					down: [S, DOWN],
					accept: [ENTER, SPACE],
					back: [ESCAPE, BACKSPACE]
				},
				modes: [
					1 => ["space" => [SPACE, SPACE]],
					2 => ["left" => [LEFT, A], "right" => [RIGHT, D]],
					3 => ["left" => [LEFT, A], "up" => [UP, W], "right" => [RIGHT, D]],
					4 => ["left" => [LEFT, A], "up" => [UP, W], "down" => [DOWN, S], "right" => [RIGHT, D]],
					5 => ["left" => [LEFT, A], "up" => [UP, W], "space" => [SPACE, SPACE], "down" => [DOWN, S], "right" => [RIGHT, D]],
					6 => ["left" => [A, A], "down" => [S, S], "right" => [D, D], "left2" => [LEFT, LEFT], "up" => [UP, UP], "right2" => [RIGHT, RIGHT]],
					7 => ["left" => [A, A], "down" => [S, S], "right" => [D, D], "space" => [SPACE, SPACE], "left2" => [LEFT, LEFT], "up" => [UP, UP], "right2" => [RIGHT, RIGHT]],
					8 => ["left" => [A, A], "down" => [S, S], "up" => [W, W], "right" => [D, D], "left2" => [LEFT, LEFT], "up2" => [UP, UP], "down2" => [DOWN, DOWN], "right2" => [RIGHT, RIGHT]],
					9 => ["left" => [A, A], "down" => [S, S], "up" => [W, W], "right" => [D, D], "space" => [SPACE, SPACE], "left2" => [LEFT, LEFT], "up2" => [UP, UP], "down2" => [DOWN, DOWN], "right2" => [RIGHT, RIGHT]],
				]
			};
		}
		else
		{
			if (FlxG.save.data.useAntialiasing == null)
				FlxG.save.data.useAntialiasing = true;
			if (FlxG.save.data.currentMod == null)
				FlxG.save.data.currentMod = "Friday Night Funkin'";
			if (FlxG.save.data.keybinds == null)
				FlxG.save.data.keybinds = {
					ui: {
						up: [W, UP],
						left: [A, LEFT],
						right: [D, RIGHT],
						down: [S, DOWN],
						accept: [ENTER, SPACE],
						back: [ESCAPE, BACKSPACE]
					},
					modes: [
						1 => ["space" => [SPACE, SPACE]],
						2 => ["left" => [LEFT, A], "right" => [RIGHT, D]],
						3 => ["left" => [LEFT, A], "up" => [UP, W], "right" => [RIGHT, D]],
						4 => ["left" => [LEFT, A], "up" => [UP, W], "down" => [DOWN, S], "right" => [RIGHT, D]],
						5 => ["left" => [LEFT, A], "up" => [UP, W], "space" => [SPACE, SPACE], "down" => [DOWN, S], "right" => [RIGHT, D]],
						6 => ["left" => [A, A], "down" => [S, S], "right" => [D, D], "left2" => [LEFT, LEFT], "up" => [UP, UP], "right2" => [RIGHT, RIGHT]],
						7 => ["left" => [A, A], "down" => [S, S], "right" => [D, D], "space" => [SPACE, SPACE], "left2" => [LEFT, LEFT], "up" => [UP, UP], "right2" => [RIGHT, RIGHT]],
						8 => ["left" => [A, A], "down" => [S, S], "up" => [W, W], "right" => [D, D], "left2" => [LEFT, LEFT], "up2" => [UP, UP], "down2" => [DOWN, DOWN], "right2" => [RIGHT, RIGHT]],
						9 => ["left" => [A, A], "down" => [S, S], "up" => [W, W], "right" => [D, D], "space" => [SPACE, SPACE], "left2" => [LEFT, LEFT], "up2" => [UP, UP], "down2" => [DOWN, DOWN], "right2" => [RIGHT, RIGHT]],
					]
				};

			useAntialiasing = FlxG.save.data.useAntialiasing;
			currentMod = FlxG.save.data.currentMod;
			PlayerSettings.keybinds = FlxG.save.data.keybinds;
		}

		FlxSprite.defaultAntialiasing = useAntialiasing;
	}
}

class Controls
{
	// Left controls
	public static var LEFT(get, never):Bool;
	public static var LEFT_P(get, never):Bool;
	public static var LEFT_R(get, never):Bool;

	// Right controls
	public static var RIGHT(get, never):Bool;
	public static var RIGHT_P(get, never):Bool;
	public static var RIGHT_R(get, never):Bool;

	// Up controls
	public static var UP(get, never):Bool;
	public static var UP_P(get, never):Bool;
	public static var UP_R(get, never):Bool;

	// Down controls
	public static var DOWN(get, never):Bool;
	public static var DOWN_P(get, never):Bool;
	public static var DOWN_R(get, never):Bool;

	// Accept controls
	public static var ACCEPT(get, never):Bool;
	public static var ACCEPT_P(get, never):Bool;
	public static var ACCEPT_R(get, never):Bool;

	// Back controls
	public static var BACK(get, never):Bool;
	public static var BACK_P(get, never):Bool;
	public static var BACK_R(get, never):Bool;

	public static function getGameKey(key:String, state:FlxInputState) {
		switch (state){
			case JUST_PRESSED:
				return FlxG.keys.anyJustPressed(PlayerSettings.keybinds.modes.get(PlaySettings.keyModes).get(key));
			case JUST_RELEASED:
				return FlxG.keys.anyJustReleased(PlayerSettings.keybinds.modes.get(PlaySettings.keyModes).get(key));
			default:
				return FlxG.keys.anyPressed(PlayerSettings.keybinds.modes.get(PlaySettings.keyModes).get(key));
		}
	}

	// Left control functions
	static function get_LEFT_P():Bool
	{
		return FlxG.keys.anyJustPressed(PlayerSettings.keybinds.ui.left);
	}

	static function get_LEFT():Bool
	{
		return FlxG.keys.anyPressed(PlayerSettings.keybinds.ui.left);
	}

	static function get_LEFT_R():Bool
	{
		return FlxG.keys.anyJustReleased(PlayerSettings.keybinds.ui.left);
	}

	// Right control functions
	static function get_RIGHT_P():Bool
	{
		return FlxG.keys.anyJustPressed(PlayerSettings.keybinds.ui.right);
	}

	static function get_RIGHT():Bool
	{
		return FlxG.keys.anyPressed(PlayerSettings.keybinds.ui.right);
	}

	static function get_RIGHT_R():Bool
	{
		return FlxG.keys.anyJustReleased(PlayerSettings.keybinds.ui.right);
	}

	// Up control functions
	static function get_UP_P():Bool
	{
		return FlxG.keys.anyJustPressed(PlayerSettings.keybinds.ui.up);
	}

	static function get_UP():Bool
	{
		return FlxG.keys.anyPressed(PlayerSettings.keybinds.ui.up);
	}

	static function get_UP_R():Bool
	{
		return FlxG.keys.anyJustReleased(PlayerSettings.keybinds.ui.up);
	}

	// Down control functions
	static function get_DOWN_P():Bool
	{
		return FlxG.keys.anyJustPressed(PlayerSettings.keybinds.ui.down);
	}

	static function get_DOWN():Bool
	{
		return FlxG.keys.anyPressed(PlayerSettings.keybinds.ui.down);
	}

	static function get_DOWN_R():Bool
	{
		return FlxG.keys.anyJustReleased(PlayerSettings.keybinds.ui.down);
	}

	// Accept control functions
	static function get_ACCEPT_P():Bool
	{
		return FlxG.keys.anyJustPressed(PlayerSettings.keybinds.ui.accept);
	}

	static function get_ACCEPT():Bool
	{
		return FlxG.keys.anyPressed(PlayerSettings.keybinds.ui.accept);
	}

	static function get_ACCEPT_R():Bool
	{
		return FlxG.keys.anyJustReleased(PlayerSettings.keybinds.ui.accept);
	}

	// Back control functions
	static function get_BACK_P():Bool
	{
		return FlxG.keys.anyJustPressed(PlayerSettings.keybinds.ui.back);
	}

	static function get_BACK():Bool
	{
		return FlxG.keys.anyPressed(PlayerSettings.keybinds.ui.back);
	}

	static function get_BACK_R():Bool
	{
		return FlxG.keys.anyJustReleased(PlayerSettings.keybinds.ui.back);
	}
}

typedef KeyBindsData =
{
	ui:
	{
		up:Array<FlxKey>, down:Array<FlxKey>, left:Array<FlxKey>, right:Array<FlxKey>, accept:Array<FlxKey>, back:Array<FlxKey>
	},
	modes:Map<Int, Map<String, Array<FlxKey>>>
}

typedef KeyData = {}
