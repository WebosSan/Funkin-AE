package backend;

import backend.PlayerSettings;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.Assets;
import openfl.display.BitmapData;
import openfl.filesystem.File;
import openfl.media.Sound;

class Paths
{
	public static var cacheImages:Map<String, FlxGraphic> = new Map();
	public static var cacheSounds:Map<String, Sound> = new Map();

    public static function getSparrowAtlas(path:String, ?directory:String = "images") {
        return FlxAtlasFrames.fromSparrow(getImage(path, directory), getText(path, "xml", directory));
    }

	public static function getImage(path:String, ?directory:String = "images"):FlxGraphic
	{
		var finalPath:String = getPath(path + ".png", directory);
		if (cacheImages.exists(finalPath))
		{
			return cacheImages.get(finalPath);
		}

		if (Assets.exists(finalPath))
		{
			var graphic:FlxGraphic = FlxGraphic.fromBitmapData(BitmapData.fromFile(finalPath));
			graphic.destroyOnNoUse = false;
			graphic.persist = true;
			cacheImages.set(finalPath, graphic);
			return graphic;
		}
		else
		{
			// TODO Make A Logger with a warn message
			return null;
		}
	}

	public static function getSound(path:String, ?directory:String = "sounds"):Sound
	{
		var finalPath:String = getPath(path + ".ogg", directory);
		if (cacheSounds.exists(finalPath))
		{
			return cacheSounds.get(finalPath);
		}

		if (Assets.exists(finalPath))
		{
			var sound:Sound = Sound.fromFile(finalPath);
			cacheSounds.set(finalPath, sound);
			return sound;
		}
		else
		{
			// TODO Make A Logger with a warn message
			return null;
		}
	}

	public static function getText(path:String, ?extension:String = "txt", ?directory:String = "data"):String
	{
		var finalPath:String = getPath(path + "." + extension, directory);
		if (Assets.exists(finalPath))
		{
			return Assets.getText(finalPath);
		}
		else
		{
			// TODO Make A Logger with a warn message
			return "";
		}
	}

	public static function readDirectory(path:String, ?directory:String = "")
	{
		var f:File = new File(getPath(path, directory));
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

	public static function exists(path:String, ?directory:String = ""):Bool
	{
		var finalPath:String = getPath(path, directory);
		return Assets.exists(finalPath);
	}

	public static function getPath(path:String, ?directory:String = ""):String
	{
		var basePath:String = (directory != null && directory != "") ? '$directory/$path' : path;

		var modPath:String = 'mods/${PlayerSettings.currentMod}/$basePath';
		var assetsPath:String = 'assets/$basePath';

		return Assets.exists(modPath) ? modPath : assetsPath;
	}

	public static function clearCache()
	{
		if (cacheImages != null)
		{
			for (graphic in cacheImages)
			{
				graphic.destroy();
			}
			cacheImages.clear();
		}
        if (cacheSounds != null){
            cacheSounds.clear();
        }
	}
}
