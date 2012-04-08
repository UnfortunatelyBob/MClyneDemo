//***********************************************************************************************************
//FailState.as			
//Author: Matthew Clyne
//
//This is a menu state.  Displays the game over screen and plays the "oh no" noise.
//***********************************************************************************************************

package
{
	import org.flixel.*;
	
	public class FailState extends FlxState
	{
		[Embed(source="data/sound/ohno.mp3")] private var SndOhNo:Class;
		
		override public function create():void
		{
			//FlxText is that sweet, chunky retro text you get by default with flixel.  This just draws to the screen.
			var txt:FlxText;
			FlxG.play(SndOhNo);
			txt = new FlxText(0,FlxG.height/2-50,FlxG.width,"You lost");
			txt.size = 16;
			txt.alignment = "center";
			add(txt);
			txt = new FlxText(0,FlxG.height/2,FlxG.width,"Game Over");
			txt.size = 32;
			txt.alignment = "center";
			add(txt);
			txt = new FlxText(0,FlxG.height-50,FlxG.width,"Click to play again.");
			txt.size = 8;
			txt.alignment = "center";
			add(txt);
			
			FlxG.mouse.show();		//Playtesting showed people are uncomfortable clicking if they can's see the mouse
		}
		
		//If you click... it loads back into the play state
		override public function update():void
		{
			if(FlxG.mouse.justPressed())
				FlxG.switchState(new PlayState());
		}
	}
}