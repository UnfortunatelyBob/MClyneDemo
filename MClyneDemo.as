package
{
	import org.flixel.*;
	[SWF(width="640", height="480", backgroundColor="#804045")]
	[Frame(factoryClass="Preloader")]
	
	public class MClyneDemo extends FlxGame
	{
		public function MClyneDemo()
		{
			super(320, 240, PlayState,2);
		}
	}
}