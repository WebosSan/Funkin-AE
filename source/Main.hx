package;

import backend.PlayerSettings;
import core.FunkinGame;
import flixel.FlxGame;
import game.debug.ChartingState;
import game.debug.TestState;
import haxe.Log;
import hscript.Expr.ModuleDecl;
import openfl.display.Sprite;
import rulescript.parsers.HxParser;
import rulescript.types.ScriptedTypeUtil;

class Main extends Sprite
{
	public function new()
	{
		Log.trace = Logger.log;
		ScriptedTypeUtil.resolveModule = resolveModule;
		super();
		PlayerSettings.init();
		addChild(new FunkinGame(0, 0, TestState, 60, 60, true, false));
	}
	public static function resolveModule(name:String):Array<ModuleDecl>
	{
		var path:Array<String> = name.split('.');

		var pack:Array<String> = [];

		while (path[0].charAt(0) == path[0].charAt(0).toLowerCase())
			pack.push(path.shift());

		var moduleName:String = null;

		if (path.length > 1)
			moduleName = path.shift();

		var filePath = '${(pack.length >= 1 ? pack.join('.') + '.' + (moduleName ?? path[0]) : path[0]).replace('.', '/')}';

		if (!Paths.exists(filePath + ".hx", "data"))
			return null;

		var parser = new HxParser();
		parser.allowAll();
		parser.mode = MODULE;

		return parser.parseModule(Paths.getText(filePath, "hx"));
	}
}
