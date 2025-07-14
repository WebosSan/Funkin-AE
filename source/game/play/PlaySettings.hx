package game.play;

class PlaySettings
{
	public static var speed:Float = 2;
	public static var keyModes:Int;

	public static final keyOrder:Map<Int, Array<String>> = [
		1 => ["space"],
		2 => ["left", "right"],
		3 => ["left", "space", "right"],
		4 => ["left", "down", "up", "right"],
		5 => ["left", "down", "space", "up", "right"],
		6 => ["left", "down", "right", "left2", "up2", "right2"],
		7 => ["left", "down", "right", "space", "left2", "up2", "right2"],
		8 => ["left", "down", "up", "right", "left2", "down2", "up2", "right2"],
		9 => ["left", "down", "up", "right", "space", "left2", "down2", "up2", "right2"]
	];
}
