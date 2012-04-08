//***********************************************************************************************************
//WinState.as			
//Author: Matthew Clyne
//
//This is the menu that's displayed when you win.  Also plays the epic win song.  Voice acting credits
//in this game go out to Lauren Spain and myself (I did the splat noise).
//***********************************************************************************************************

package
{
	import org.flixel.*;
	
	public class WinState extends FlxState
	{	
		[Embed(source="data/sound/winnar.mp3")] private var SndWinnar:Class;		//A winner is you
		
		override public function create():void
		{
			var txt:FlxText;
			txt = new FlxText(0,FlxG.height/2 + 30,FlxG.width,"Code and Art: Matthew Clyne  Voice Acting: Lauren Spain");
			txt.size = 8;
			txt.alignment = "center";
			add(txt);
			txt = new FlxText(0,FlxG.height/2 - 70,FlxG.width,"A Winner Is You!");
			txt.size = 32;
			txt.alignment = "center";
			add(txt);
			txt = new FlxText(0,FlxG.height-30,FlxG.width,"Click to play again.");
			txt.size = 8;
			txt.alignment = "center";
			add(txt);
			
			FlxG.play(SndWinnar);
			
			FlxG.mouse.show();
		}		
		
		//You can play again if you want
		override public function update():void
		{
			if(FlxG.mouse.justPressed())
				FlxG.switchState(new PlayState());
		}
	}
}