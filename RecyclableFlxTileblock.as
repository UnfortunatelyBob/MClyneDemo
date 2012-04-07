package
{
	import org.flixel.FlxTileblock;
	
	public class RecyclableFlxTileblock extends FlxTileblock
	{
		public function RecyclableFlxTileblock(X:int, Y:int, Width:uint, Height:uint)
		{
			super(X, Y, Width, Height);
		}
		
		public function recycle(X:int, Y:int, Width:uint, Height:uint):void
		{
			super.reset(X, Y);
			super.makeGraphic(Width, Height);
		}
	}
}