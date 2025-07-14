package game.debug;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxSpriteUtil;
import game.data.SongData.DifficultyData;
import game.objects.notes.Note;
import game.play.PlaySettings;
import game.play.PlayState;
import game.play.Song;
import haxe.Json;
import openfl.display.BitmapData;
import sys.io.File;

class ChartingState extends FlxState
{
	static final GRID_SIZE:Int = 40;

	var gridSprite:FlxSprite;
	var mouseTracker:FlxSprite;

	var strumLine:FlxSprite = new FlxSprite();
	var song:Song;
	var difficulty:DifficultyData;
	var currentDifficulty:String = "normal";

	var currentType:String = "default";

	var notes:FlxTypedGroup<Note>;

	public function new(?song:Song)
	{
		if (song == null)
		{
			this.song = Song.getSong("test");
		}
		else
		{
			this.song = song;
		}
		difficulty = this.song.getDifficulty(currentDifficulty);
		PlaySettings.keyModes = Std.int(Math.max(1, Math.min(difficulty.notesData.keysMode, 9)));
		super();
	}

	function loadNotes()
	{
		notes.clear();

		final columnWidth = gridSprite.width / 2;
		final laneWidth = columnWidth / PlaySettings.keyModes;

		for (n in difficulty.notesData.data)
		{
			var noteX = gridSprite.x + (n.isPlayer ? columnWidth : 0) + (n.lane * laneWidth);

			var noteY = getYfromStrum(n.strumTime);

			var note = new Note(noteX, noteY, n.lane, currentType, n.isPlayer, n.strumTime);
			note.size = GRID_SIZE;
			notes.add(note);
		}
	}

	override function create()
	{
		super.create();
		bgColor = 0xFF45245A;
		Conductor.loadSong(Paths.getInst(difficulty.metadata.songPrefix + song.data.songName + difficulty.metadata.songPostfix), difficulty.metadata.bpm);
		FlxG.sound.music.pause();

		gridSprite = new FlxSprite();
		gridSprite.pixels = createBitmap();
		gridSprite.antialiasing = false;
		gridSprite.scale.set(GRID_SIZE, GRID_SIZE);
		gridSprite.updateHitbox();
		gridSprite.screenCenter(X);
		gridSprite.y += FlxG.height / 3;
		add(gridSprite);

		mouseTracker = new FlxSprite();
		mouseTracker.makeGraphic(GRID_SIZE, GRID_SIZE, FlxColor.GRAY);
		mouseTracker.alpha = 0.5;
		add(mouseTracker);

		add(notes = new FlxTypedGroup());

		strumLine = new FlxSprite(gridSprite.x - gridSprite.width / PlaySettings.keyModes / 2, gridSprite.y);
		strumLine.makeGraphic(Std.int(gridSprite.width + gridSprite.width / PlaySettings.keyModes), 10, FlxColor.RED);
		add(strumLine);

		loadNotes();

		FlxG.camera.follow(strumLine);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (FlxG.keys.justPressed.SPACE)
		{
			if (!FlxG.sound.music.playing)
				FlxG.sound.music.play();
			else
				FlxG.sound.music.pause();
		}

		if (FlxG.keys.justPressed.ENTER)
		{
			FlxG.switchState(PlayState.new.bind({
				song: song,
				difficulty: difficulty.name
			}));
		}

		if (FlxG.keys.justPressed.S)
		{
			File.saveContent(Paths.getPath("data.json5", "data/songs/" + song.data.songName), Json.stringify(song.data));
		}

		strumLine.y = getYfromStrum(Conductor.time);

		if (FlxG.mouse.wheel != 0)
		{
			Conductor.forward(-(FlxG.mouse.wheel * Conductor.stepTime / (FlxG.keys.pressed.SHIFT ? 4 : 1)));
		}

		if (FlxG.mouse.overlaps(gridSprite))
		{
			var mouseGridX:Float = (FlxG.mouse.x - gridSprite.x);
			var mouseGridY:Float = (FlxG.mouse.y - gridSprite.y);

			if (!FlxG.keys.pressed.SHIFT)
			{
				mouseTracker.x = gridSprite.x + Math.floor(mouseGridX / GRID_SIZE) * GRID_SIZE;
				mouseTracker.y = gridSprite.y + Math.floor(mouseGridY / GRID_SIZE) * GRID_SIZE;
			}
			else
			{
				mouseTracker.x = gridSprite.x + Math.floor(mouseGridX / GRID_SIZE) * GRID_SIZE;
				mouseTracker.y = gridSprite.y + mouseGridY;
			}

			if (FlxG.mouse.justPressed)
				addNote(mouseTracker.x, mouseTracker.y);

			if (FlxG.mouse.justPressedRight)
				searchAndDeleteNote();

			mouseTracker.visible = true;
		}
		else
		{
			mouseTracker.visible = false;
		}
	}

	function searchAndDeleteNote()
	{
		var posibleNote:Note = Lambda.find(notes.members, n -> {
			if (n == null) return false;
			return n.overlaps(mouseTracker);
		});

		if (posibleNote == null) return;

		difficulty.notesData.data.remove(Lambda.find(difficulty.notesData.data, n -> n.strumTime == posibleNote.strum));

		posibleNote.kill();
		posibleNote.destroy();
		notes.remove(posibleNote);
		posibleNote = null;
	}

	function addNote(x:Float, y:Float)
	{
		var relativeX = x - gridSprite.x;

		var columnWidth = gridSprite.width / 2;
		var laneWidth = columnWidth / PlaySettings.keyModes;

		var isPlayer:Bool = relativeX >= columnWidth;

		var sectionX = isPlayer ? relativeX - columnWidth : relativeX;

		var lane:Int = Math.floor(sectionX / laneWidth);
		lane = Std.int(FlxMath.bound(lane, 0, PlaySettings.keyModes - 1));

		var noteX = gridSprite.x + (isPlayer ? columnWidth : 0) + (lane * laneWidth);

		difficulty.notesData.data.push({
			strumTime: getStrumFromY(y),
			lane: lane,
			isPlayer: isPlayer
		});

		var note:Note = new Note(noteX, y, lane, currentType, isPlayer, getStrumFromY(y));
		note.size = GRID_SIZE;
		notes.add(note);
	}

	function getYfromStrum(strum:Float)
	{
		return gridSprite.y + (strum / Conductor.stepTime) * GRID_SIZE;
	}

	function getStrumFromY(yPos:Float):Float
	{
		var offsetY = yPos - gridSprite.y;
		var steps = offsetY / GRID_SIZE;
		var strumTime = steps * Conductor.stepTime;

		return strumTime;
	}

	function createBitmap():BitmapData
	{
		var totalColumns = PlaySettings.keyModes * 2;
		var bpm:BitmapData = new BitmapData(totalColumns, Conductor.lenghtInSteps);

		for (x in 0...totalColumns)
		{
			for (y in 0...Conductor.lenghtInSteps)
			{
				var color:Int = (y % 2 == 0) ? (x % 2 == 0 ? 0xFFB8B8B8 : FlxColor.WHITE) : (x % 2 == 0 ? FlxColor.WHITE : 0xFFB8B8B8);
				bpm.setPixel32(x, y, color);
			}
		}
		return bpm;
	}
}
