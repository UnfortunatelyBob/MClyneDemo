package
{
	import org.flixel.*;
	
	public class Player extends FlxSprite
	{
		public function Player(X:Number=0, Y:Number=0, SimpleGraphic:Class=null)
		{
			super(X, Y, SimpleGraphic);
			makeGraphic(10,12,0xffaa1111);
			
			acceleration.y = 100;
			maxVelocity.x = 150;
			maxVelocity.y = 100;
			velocity.x = 25;
		}
		
		override public function destroy():void
		{
			super.destroy();
		}
		
		override public function update():void
		{
			//The player speeds up automatically, like a driver on the accelerator.  Acceleration occurs at a higher rate at lower speeds.
			if(velocity.x < 50)
				acceleration.x = 25;
			else if(velocity.x < 80)
				acceleration.x = 15;
			else
				acceleration.x = 10;
			
			//height of jump is dependent on how long the space key is held down.  Played with it til it sort of "felt right."
			if(FlxG.keys.justPressed("SPACE") && isTouching(FlxObject.FLOOR))
				velocity.y = -40;
			if(FlxG.keys.pressed("SPACE") && velocity.y < -10 )
				velocity.y -= .1;
		}
	}
}