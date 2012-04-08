//***********************************************************************************************************
//MenuState.as			
//Author: Matthew Clyne
//
//Main Menu.  Has the title and the controls displayed.
//***********************************************************************************************************

package
{
	import org.flixel.*;
	
	public class MenuState extends FlxState
	{
		override public function create():void
		{
			var txt:FlxText;
			txt = new FlxText(0,FlxG.height/2-50,FlxG.width,"Matthew Clyne Demo");
			txt.size = 32;
			txt.alignment = "center";
			add(txt);
			txt = new FlxText(0,FlxG.height-60,FlxG.width,"click to play");
			txt.size = 16;
			txt.alignment = "center";
			add(txt);
			txt = new FlxText(0,FlxG.height-30,FlxG.width,"Controls: X to jump, C to shoot ice cream");
			txt.size = 8;
			txt.alignment = "center";
			add(txt);
			
			FlxG.mouse.show();
		}
		
		override public function update():void
		{
			if(FlxG.mouse.justPressed())
				FlxG.switchState(new PlayState());
		}
	}
}