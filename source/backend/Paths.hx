package backend;

import openfl.Assets;

class Paths{
	public static function exists(path:String)
	{
		return Assets.exists(getPath(path));
	}

	public static function getPath(path:String)
	{
		var modPath:String = 'mods/${PlayerSettings.currentMod}/$path';
		var assetsPath:String = 'assets/$path';

		return Assets.exists(modPath) ? modPath : assetsPath;
    }
}