package backend;

import openfl.Assets;
import openfl.filesystem.File;

class Paths{
	public static function readDirectory(path:String)
	{
		var f:File = new File(getPath(path));
		var files:Array<String> = [];

		if (f.exists)
		{
			for (file in f.getDirectoryListing())
			{
				files.push(file.name);
			}
		}

		return files;
	}

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