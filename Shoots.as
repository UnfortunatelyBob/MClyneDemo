//***********************************************************************************************************
//Shoots.as			
//Author: Matthew Clyne
//
//This class manages the shoots.  I know this is terrible grammar.  In retrospect this was a terrible class
//name.  Given more time I would change it.  Inherits from FlxSprite.
//***********************************************************************************************************

package
{
	import org.flixel.*;
	
	public class Shoots extends FlxSprite
	{
		[Embed(source="data/art/IceCream.png")] protected var ImgIceCream:Class;
		
		public var _velocityX:int;
		
		//constructor has to take no arguments because shots are created through recycling
		public function Shoots()
		{
			super();
			loadGraphic(ImgIceCream, true, false, 6, 6, true);
			addAnimation("spin", [0, 1, 2, 3], 16, true);
			_velocityX = 333;		//only half the number of the beast.  Ice cream is too delicious to be truly evil
		}
		
		override public function update():void
		{
			if(!alive)
				exists = false;
			if(!onScreen())
				kill();
			play("spin");
		}
		
		override public function kill():void
		{
			if(!alive)
				return;
			velocity.x = 0;
			velocity.y = 0;
			alive = false;
			solid = false;

		}
		
		//this is the initialize function.  Perhaps pewPew isn't the best name.  I think I was in sort of a goofy mood on the day I wrote most of this class...
		public function pewPew(Location:FlxPoint):void
		{
			super.reset(Location.x + width/2,Location.y - height/2 + 2);
			solid = true;
			alive = true
			velocity.x = _velocityX;
		}
	}
}