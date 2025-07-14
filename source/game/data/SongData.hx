package game.data;

typedef SongData =
{
	songName:String,
    difficulties:Array<DifficultyData>
}

typedef DifficultyData = {
    name:String,
    metadata:DifficultyMetadata,
    notesData:NotesData
}

typedef NotesData = {
	keysMode:Int,
    data: Array<NoteData>
}

typedef NoteData = {
    //Main Note
    strumTime:Float,
    lane:Int,
    isPlayer:Bool,

    //Trail Data
    ?trailDuration:Float
} 

typedef DifficultyMetadata =
{
    bpm:Int,
    player1:String,
    player2:String,
    player3:String,
    stage:String,
    ?songPrefix:String,
	?songPostfix:String,
	?hasPlayerVocals:Bool,
	?hasEnemyVocals:Bool
}