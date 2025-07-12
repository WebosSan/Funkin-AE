package backend;

import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.system.FlxAssets.FlxSoundAsset;
import lime.media.openal.AL;

class Conductor {
    public static var time(get, set):Float;
    public static var bpm(default, set):Int = 130;

    public static var curStep:Int = 0;
    public static var curBeat:Int = 0;

    private static var _stepTime:Float = 0;
    private static var _beatTime:Float = 0;
    private static var _stepsPerBeat:Int = 4;

    // Variables for improved timing precision
    private static var _lastUpdateTime:Float = 0;
    private static var _accumulatedTime:Float = 0;
    private static var _isPlaying:Bool = false;

    private static var _time:Float = 0;

    public static function loadSong(path:FlxSoundAsset, ?bpm:Int = 130) {
        Conductor.bpm = bpm; // Update BPM and recalculate _stepTime/_beatTime
        _time = 0;
        _accumulatedTime = 0;
        _lastUpdateTime = 0;
        _isPlaying = false;
    }

    public static function update(elapsed:Float) {
        if (FlxG.sound.music == null || !FlxG.sound.music.playing) {
            _isPlaying = false;
            return;
        }

        if (!_isPlaying) {
            _isPlaying = true;
            _lastUpdateTime = getExactMusicTime(); // Reset when starting
        }

        updateTime();
        updateStepsAndBeats();
    }

    /**
     * Updates `_time` with the lowest possible latency.
     * - Uses `getExactMusicTime()` to get the precise music position.
     * - Applies a small lerp for smoothing but prioritizes accuracy.
     */
    private static function updateTime() {
        var exactTime = getExactMusicTime();
        var delta = exactTime - _lastUpdateTime;

        if (delta >= 0 && delta < 0.1) { 
            _accumulatedTime += delta;
            _time = _accumulatedTime;
        }

        _lastUpdateTime = exactTime;
    }

    /**
     * Gets the exact music time with the lowest possible latency.
     * - For native targets (Windows, macOS, Linux), uses OpenAL directly.
     * - For HTML5, uses `SoundChannel.position` with a workaround for better precision.
     */
    private static function getExactMusicTime():Float {
        #if (openal && !html5)
        // Use OpenAL for maximum precision (~5-10 ms latency)
        if (FlxG.sound.music._channel != null) {
            var source = FlxG.sound.music._channel.__source;
            if (source != null) {
                AL.getSourcef(source, AL.SEC_OFFSET, _time);
                return _time * 1000; // Convert to milliseconds
            }
        }
        #end

        // HTML5 fallback or if OpenAL isn't available
        #if html5
        return getHTML5MusicTime();
        #else
        return FlxG.sound.music.time;
        #end
    }

    #if html5
    /**
     * HTML5-specific implementation for more precise timing
     * Uses a combination of SoundChannel.position and requestAnimationFrame timing
     */
    private static var _html5LastPosition:Float = 0;
    private static var _html5LastUpdate:Float = 0;
    private static var _html5PositionOffset:Float = 0;

    private static function getHTML5MusicTime():Float {
        var currentTime = Date.now().getTime();
        var music = FlxG.sound.music;
        
        if (music == null || music._channel == null) return 0;
        
        var reportedPosition = music.time;
        var timeSinceLastUpdate = currentTime - _html5LastUpdate;
        
        // If the position hasn't changed but time has passed (buffering/paused)
        if (reportedPosition == _html5LastPosition && timeSinceLastUpdate > 0) {
            return _html5LastPosition;
        }
        
        // If position jumped (seeked or looped)
        if (Math.abs(reportedPosition - _html5LastPosition) > 100 && timeSinceLastUpdate < 100) {
            _html5PositionOffset = reportedPosition;
        }
        
        _html5LastPosition = reportedPosition;
        _html5LastUpdate = currentTime;
        
        return reportedPosition + _html5PositionOffset;
    }
    #end

    private static function updateStepsAndBeats() {
        curStep = Math.floor(_time / _stepTime);
        curBeat = Math.floor(curStep / _stepsPerBeat);
    }

    // Setters/Getters
    public static function set_time(v:Float):Float {
        _time = v;
        _accumulatedTime = v;
        #if html5
        _html5PositionOffset = v;
        _html5LastPosition = v;
        _html5LastUpdate = Date.now().getTime();
        #end
        if (FlxG.sound.music != null) {
            FlxG.sound.music.time = v;
        }
        return v;
    }

    public static function get_time():Float {
        return _time;
    }

    public static function set_bpm(v:Int):Int {
        if (v != bpm) {
            bpm = v;
            _beatTime = (60 / bpm) * 1000; // Time per beat in ms
            _stepTime = _beatTime / _stepsPerBeat; // Time per step in ms
        }
        return bpm;
    }
}