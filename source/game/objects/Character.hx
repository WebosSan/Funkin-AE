package game.objects;

import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import game.data.CharacterData;
import haxe.Json5;
import haxe.Json;
import rulescript.scriptedClass.RuleScriptedClass;

@:ignoreFields([stringArray, typedFunction])
@:strictScriptedConstructor
class Character implements RuleScriptedClass extends BaseCharacter
{
	public static function createCharacter(x:Float, y:Float, id:String, ?isPlayer:Bool = false)
	{
		var data:CharacterData = Json5.parse(Paths.getText("data", "json5", "data/characters/" + id));
		if (data == null)
		{
			Logger.error("Character " + id + " doesn't have data!");
		}

		var scriptPath:String = 'characters.$id.CharacterScript';

		if (Main.resolveModule(scriptPath) == null)
		{
			scriptPath = 'scripts.placeholders.CharacterPlaceholder';
			trace("Loading a non-scripted character");
		}

		var character:Character = new Character(scriptPath, x, y, id);
		character.isPlayer = isPlayer;
		character.data = data;
		character.loadData();
		return character;
	}
}

class BaseCharacter extends FunkinSprite
{
	private var lastSingTime:Float;
	private var shouldDance:Bool = true;

	public var healthColor:FlxColor;
	public var id:String;
	public var data:CharacterData;

	public var isPlayer:Bool = false;

	private function new(x:Float, y:Float, id:String)
	{
		super(x, y);
		this.id = id;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (currentAnimation() != null)
		{
			if (currentAnimation().startsWith("sing"))
			{
				if (Math.abs(lastSingTime - Conductor.time) >= Conductor.stepTime)
				{
					shouldDance = true;
				}
			}
		}
	}

	function loadData()
	{
		loadSprite(data.renderType);

		if (Std.isOfType(data.healthBarColor, String))
			healthColor = FlxColor.fromString(data.healthBarColor);
		else if (Std.isOfType(data.healthBarColor, Int))
			healthColor = cast data.healthBarColor;
		else
			healthColor = FlxColor.fromRGB(data.healthBarColor[0], data.healthBarColor[1], data.healthBarColor[2]);

		positionOffset = new FlxPoint(data.position.global[0], data.position.global[1]);

		if (data.scale != null)
			scale.set(data.scale[0], data.scale[1]);
		if (data.flipX != null)
			flipX = data.flipX;
		if (data.flipY != null)
			flipY = data.flipY;

		loadAnimations();
	}

	function loadAnimations()
	{
		for (anim in data.animations)
		{
			if (anim.indices == null)
				setAnimationByPrefix(anim.name, anim.prefix, new FlxPoint(anim.offsets[0], anim.offsets[1]), anim.framerate ?? 24, anim.loop ?? false,
					anim.flipX ?? false, anim.flipY ?? false);
			else
				setAnimationByIndices(anim.name, anim.prefix, anim.indices, new FlxPoint(anim.offsets[0], anim.offsets[1]), anim.framerate ?? 24,
					anim.loop ?? false, anim.flipX ?? false, anim.flipY ?? false);
		}
	}

	function loadSprite(renderType:String)
	{
		renderType ??= "sparrow";
		switch (renderType.toLowerCase())
		{
			default:
				frames = Paths.getSparrowAtlas(id + "/spritesheet", "data/characters");
		}
	}

	override function dance()
	{
		if (shouldDance)
		{
			super.dance();
		}
	}

	override function playAnimation(name:String, ?force:Bool = false)
	{
		if (name.startsWith("sing"))
		{
			lastSingTime = Conductor.time;
			shouldDance = false;
		}
		super.playAnimation(name, force);
	}
}
