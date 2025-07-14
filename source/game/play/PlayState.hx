package game.play;

import backend.PlayerSettings;
import flixel.util.typeLimit.OneOfTwo;
import game.data.SongData.DifficultyData;
import game.play.Song;

typedef PlayOptions =
{
	song:OneOfTwo<String, Song>,
	difficulty:String
}

class PlayState extends FlxState
{
	var field:PlayField;
	var song:Song;
	var difficulty:DifficultyData;

	public function new(options:PlayOptions)
	{
		if (Std.isOfType(options.song, Song))
			song = options.song;
		else
		{
			song = Song.getSong(options.song);
		}

		difficulty = song.getDifficulty(options.difficulty);
		super();
	}

	override function create()
	{
		super.create();
		field = new PlayField(song, difficulty);
		add(field);
	}
}
