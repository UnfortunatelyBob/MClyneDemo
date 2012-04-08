//***********************************************************************************************************
//Enemy.as			
//Author: Matthew Clyne
//
//This class manages the enemies
//***********************************************************************************************************

package
{
	import org.flixel.*;
	
	public class Enemy extends FlxSprite
	{
		[Embed(source="data/art/RunningMan.png")] protected var ImgRunningMan:Class;			
		
		private var _player:Player		//this will get passed in on initialization
		
		//can't pass anything into the constructor because of the way the enemy sprites get recycled
		public function Enemy()
		{
			super();
			loadGraphic(ImgRunningMan, true, false, 10, 18, true);		//loads my sweet art in.  Also specifies size of sprite and that it is animated.
			addAnimation("run", [0, 1, 2, 3, 4, 5, 6, 7], 12, true);	//defines the animation
		}
		
		//Called from the recycler to place the sprite
		public function initialize(X:Number, Y:Number, player:Player):void
		{
			super.reset(X - width/2,Y - height/2);
			_player = player;
		}
		
		override public function destroy():void
		{
			super.destroy();
			_player = null;		//GARBAGE
		}
		
		//The AI is super simple.  Just runs to the left slowly if they're on the screen
		override public function update():void
		{
			if(onScreen() && velocity.x == 0)
			{
				velocity.x = -25
			}
			
			play("run");
			
			if(!alive)
			{
				exists = false;
			}
		}
		
		override public function kill():void
		{
			if(!alive)
				return;
			super.kill();
			flicker(0);
			FlxG.score += 100;		//you get points when you kill enemies
		}
	}
}