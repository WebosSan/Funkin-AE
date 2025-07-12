package backend;

class PlayerSettings {
	public static var useAntialiasing:Bool = true;
    public static var currentMod:String = "Friday Night Funkin'";
	public static function init()
	{
		FlxSprite.defaultAntialiasing = useAntialiasing;
	}
}