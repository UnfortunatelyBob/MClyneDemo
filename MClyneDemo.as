//***********************************************************************************************************
//MClyneDemo.as			
//Author: Matthew Clyne
//
//This is the equivalent of a main.  Import Flixel, set window size and color of the browser window, then
//launch into the main menu.
//***********************************************************************************************************

package
{
	import org.flixel.*;
	[SWF(width="640", height="480", backgroundColor="#804045")]
	
	public class MClyneDemo extends FlxGame
	{
		public function MClyneDemo()
		{
			super(320, 240, MenuState, 2);
		}
	}
}