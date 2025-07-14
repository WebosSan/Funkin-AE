package game.play;

import backend.PlayerSettings;
import flixel.group.FlxContainer;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import game.data.SongData.DifficultyData;
import game.objects.notes.Note;
import game.objects.notes.Strum;

class PlayField extends FlxContainer
{
	public var song:Song;
	public var difficulty:DifficultyData;

	public var cpuStrums:FlxTypedSpriteGroup<Strum>;
	public var playerStrums:FlxTypedSpriteGroup<Strum>;

	public var notes:FlxTypedSpriteGroup<Note>;

	public function new(song:Song, difficulty:DifficultyData)
	{
		super();

		this.song = song;
		this.difficulty = difficulty;
		PlaySettings.keyModes = Std.int(Math.max(1, Math.min(difficulty.notesData.keysMode, 9)));

		FlxG.sound.music.play();

		add(new FlxSprite(75, 20).makeGraphic(Std.int(FlxG.width / 2.5), Std.int(FlxG.height / 10)));
		add(new FlxSprite(FlxG.width - FlxG.width / 2.5 - 75, 20).makeGraphic(Std.int(FlxG.width / 2.5), Std.int(FlxG.height / 10)));

		cpuStrums = new FlxTypedSpriteGroup<Strum>();
		playerStrums = new FlxTypedSpriteGroup<Strum>();
		notes = new FlxTypedSpriteGroup<Note>();
		add(notes);

		generateStrums(false);
		generateStrums(true);
		generateNotes();

		Note.isHittableSignal.add(onHit);
	}

	function onHit(n:Note)
	{
		if (n == null)
			return;

		if (!n.isPlayer)
		{
			trace(n.strum <= Conductor.time);
			removeNote(n);
		}
		else
		{
			if (Controls.getGameKey(PlaySettings.keyOrder.get(PlaySettings.keyModes)[n.lane], JUST_PRESSED))
			{
				removeNote(n);
			}
		}
	}

	// Eliminar nota individualmente
	function removeNote(n:Note)
	{
		n.kill();
		notes.remove(n, true);
		n.destroy();
	}

	function getStrum(lane:Int, isPlayer:Bool):Strum
	{
		var strumGroup = isPlayer ? playerStrums : cpuStrums;
		return strumGroup.members[Std.int(Math.max(0, Math.min(lane, PlaySettings.keyModes - 1)))];
	}

    function generateStrums(isPlayer:Bool = false) {
        var maxHeight = FlxG.height / 10;
        var maxWidth = FlxG.width / 2.5;
        var startX = isPlayer ? FlxG.width - maxWidth - 75 : 75;
        var strumGroup = isPlayer ? playerStrums : cpuStrums;
    
        var strumWidth = maxHeight * 0.9; 
        var spacing = 10; 
    
        var totalWidth = (strumWidth * PlaySettings.keyModes) + (spacing * (PlaySettings.keyModes - 1));
    
        var startPosX = startX + (maxWidth - totalWidth) / 2;
    
        for (i in 0...PlaySettings.keyModes) {
            var strum = new Strum(0, 20, i, "default", isPlayer);
            strum.size = strumWidth;
            strum.x = startPosX + (strumWidth + spacing) * i;
            strumGroup.add(strum);
        }
    
        add(strumGroup);
    }

	function generateNotes()
	{
		for (noteData in difficulty.notesData.data)
		{
			var note = new Note(0, 0, noteData.lane, "default", noteData.isPlayer, noteData.strumTime);
			notes.add(note);

			var strum = getStrum(note.lane, note.isPlayer);
			note.target = strum;
			note.size = strum.size;
		}
	}
}
