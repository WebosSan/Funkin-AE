package game.play;

import backend.Paths;
import game.data.SongData;
import haxe.Json5;
import haxe.Json;

class Song {
    public var data:SongData;

    private function new() {}

	public function getDifficulty(difficulty:String):DifficultyData
	{
		var difficulties:Array<DifficultyData> = data.difficulties;
		var diff:DifficultyData = Lambda.find(difficulties, d -> d.name == difficulty);

		return diff;
	}

	public static function getSong(song:String):Song
	{
		var s:Song = new Song();
		var data:SongData = Json5.parse(Paths.getText('$song/data', "json5", "data"));
		s.data = data;
		return s;
    }
}