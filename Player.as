//***********************************************************************************************************
//Player.as			
//Author: Matthew Clyne
//
//This class inherits from FlxSprite and handles the player character (ice cream truck).  User input,
//"physics" behavior, and some sounds are here.
//***********************************************************************************************************

package
{
	import org.flixel.*;
	
	public class Player extends FlxSprite
	{
		//Sounds and art
		[Embed(source="data/art/ICTrkRoll1.png")] protected var ImgTruck:Class;
		[Embed(source="data/sound/pewpew.mp3")] private var SndPewPew:Class;
		[Embed(source="data/sound/boing.mp3")] private var SndBoing:Class;
		
		protected var _shots:FlxGroup;		//this is passed in on construction.  Necessary for adding Shoots to the group.
		
		public function Player(X:int, Y:int, Shots:FlxGroup)
		{
			super(X, Y);
			
			//load the image, add the animation.
			loadGraphic(ImgTruck, true, false, 36, 24, true);
			addAnimation("roll", [0, 1, 2, 3], 8, true);
					
			acceleration.y = 300;		//"gravity"
			maxVelocity.x = 175;		//max movement speed
			maxVelocity.y = 100;
			velocity.x = 25;			//starting movement speed
			_shots = Shots;				//passed in on construction
		}
		
		override public function destroy():void
		{
			super.destroy();
			_shots = null;		//GARBAGE
		}
		
		override public function update():void
		{
			if(!alive)
			{
				FlxG.resetState();
			}
			
			//The player speeds up automatically, like a driver on the accelerator.  Acceleration occurs at a higher rate at lower speeds.
			if(velocity.x < 75)
				acceleration.x = 15;
			else if(velocity.x < 150)
				acceleration.x = 10;
			else
				acceleration.x = 5;
			
			//height of jump is dependent on how long the x key is held down.  Played with it til it sort of "felt right."
			if(FlxG.keys.justPressed("X") && isTouching(FlxObject.FLOOR))
			{
				FlxG.play(SndBoing);
				velocity.y = -85;
			}
			if(FlxG.keys.pressed("X") && velocity.y < -10 )
				velocity.y -= 1.2;
			
			play("roll");	//play the animation
			
			//SHOOTS!!! (They're ice cream cones, it's hard to tell at 6px x 6px)
			if(FlxG.keys.justPressed("C"))
			{
				getMidpoint(_point);
				(_shots.recycle(Shoots) as Shoots).pewPew(_point);		//recycles the shoots sprites.  This is built into Flixel.  I wish I'd come up with this.
				FlxG.play(SndPewPew);
			}
		}
		
		override public function kill():void
		{
			if(!alive)
				return;
			solid = false;
			super.kill();
			flicker(0);
			exists = true;
			visible = false;
			velocity.make();
			acceleration.make();
			FlxG.camera.shake(0.005,0.35);				//This shake isn't too noticable because of how quickly it loads into failstate  :(
			FlxG.camera.flash(0xffd8eba2,0.35);
		}
	}
}