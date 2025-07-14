package backend;

import flixel.FlxG;
import flixel.system.FlxAssets.FlxSoundAsset;
import flixel.util.FlxSignal;
import haxe.Timer;

class Conductor
{
	// MUSIC STUFF
	public static var bpm(default, set):Float = 100;
	public static var stepTime:Float = 0;
	public static var beatTime:Float = 0;
	public static var stepsPerBeat:Int = 4;

	// TRACK
	public static var time(get, set):Float;
	public static var length(get, never):Float;

	public static var lenghtInSteps:Int;
	public static var lenghtInBeats:Int;

    public static var curStep:Int = 0;
    public static var curBeat:Int = 0;

	// SIGNALS
	public static var onBeat = new FlxTypedSignal<Int->Void>();
	public static var onStep = new FlxTypedSignal<Int->Void>();

	public static function loadSong(path:FlxSoundAsset, ?bpm:Float = 100)
	{
		resetState();
		FlxG.sound.playMusic(path, 1);
		Conductor.bpm = bpm;
    }

	static function resetState()
	{
		curStep = 0;
		curBeat = 0;
	}

	public static function update(elapsed:Float)
	{
		updatePosition(time);
	}

	static function updatePosition(currentTime:Float)
	{
		var prevStep = curStep;
		var prevBeat = curBeat;
        
		curStep = Math.floor(currentTime / stepTime);
		curBeat = Math.floor(curStep / stepsPerBeat);
        
		if (curStep != prevStep)
			onStep.dispatch(curStep);
		if (curBeat != prevBeat)
			onBeat.dispatch(curBeat);
	}

	public static function forward(ms:Float)
	{
		time = Math.max(0, Math.min(time + ms, length));
	}

	// Just a placeholder
	private static var _latency:Float;
	private static var _previousTime:Float = 0;

	private static function get_time():Float
	{
		if (FlxG.sound.music.time != _previousTime)
		{
			_latency = FlxG.sound.music.time - _previousTime;
		}
		else
		{
			return FlxG.sound.music.time + (_latency / 2);
		}

		_previousTime = FlxG.sound.music.time;
		return FlxG.sound.music.time;
	}

	private static function set_time(v:Float):Float
	{
		return FlxG.sound.music.time = v;
	}

	private static function get_length():Float
	{
		return FlxG.sound.music.length;
	}

	private static function set_bpm(value:Float):Float
	{
		bpm = value;
		beatTime = (60 / bpm) * 1000;
		stepTime = beatTime / stepsPerBeat;

		lenghtInBeats = Math.ceil(length / beatTime);
		lenghtInSteps = Math.ceil(length / stepTime);
        return bpm;
    }
}