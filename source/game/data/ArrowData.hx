package game.data;

typedef AnimationData = {
	var name:String;
	var prefix:String;
	var framerate:Int;
};

typedef LaneData = {
	var direction:String;
	var animations:Array<AnimationData>;
};

typedef ArrowData = {
	var antialiasing:Bool;
	var scale:Float;
	var lanes:Array<LaneData>;
};
