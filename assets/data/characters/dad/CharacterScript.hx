package assets.data.characters.dad;

import StringTools;
import game.objects.Character.BaseCharacter;

//FlxColor doesnt work (hscript moment)
class CharacterScript extends BaseCharacter
{
	public function new(x:Float, y:Float, id:String)
	{
		super(x, y, id);
	}

	/* ***  SCRIPTING TEST  ***
	override function playAnimation(name:String, ?force:Bool = false)
	{
		super.playAnimation(name, force);
		if (StringTools.startsWith(name, "sing"))
		{
			color = randomColor();
		} else {
			color = 0xFFFFFFFF;
		}
	}

	private function randomColor():Int
	{
		var h:Float = Math.random(); 
		var s:Float = Math.random() / 2; 
		var l:Float = 0.80; 

		var r:Float, g:Float, b:Float;

		if (s == 0)
		{
			r = g = b = l;
		}
		else
		{
			function hue2rgb(p:Float, q:Float, t:Float):Float
			{
				if (t < 0)
					t += 1;
				if (t > 1)
					t -= 1;
				if (t < 1 / 6)
					return p + (q - p) * 6 * t;
				if (t < 1 / 2)
					return q;
				if (t < 2 / 3)
					return p + (q - p) * (2 / 3 - t) * 6;
				return p;
			}

			var q:Float = l < 0.5 ? l * (1 + s) : l + s - l * s;
			var p:Float = 2 * l - q;

			r = hue2rgb(p, q, h + 1 / 3);
			g = hue2rgb(p, q, h);
			b = hue2rgb(p, q, h - 1 / 3);
		}

		return (Std.int(r * 255) << 16 | (Std.int(g * 255) << 8 | Std.int(b * 255)));
	}
	*/
}
