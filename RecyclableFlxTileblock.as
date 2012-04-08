//***********************************************************************************************************
//RecyclableFlxTileblock.as			
//Author: Matthew Clyne
//
//Same as FlxTileBlock but creates a function called recycle that does just that.  By default there was
//no way to recycle these blocks.  Alloc and dereffing all that memory seemed a terrible idea, so I wrote
//this class to deal with that oversight.  The functions used were built right into Flixel already.
//***********************************************************************************************************

package
{
	import org.flixel.FlxTileblock;
	
	public class RecyclableFlxTileblock extends FlxTileblock
	{
		public function RecyclableFlxTileblock(X:int, Y:int, Width:uint, Height:uint)
		{
			super(X, Y, Width, Height);
		}
		
		//The whole reason this class exists.  Sweet sweet recycling... 
		public function recycle(X:int, Y:int, Width:uint, Height:uint):void
		{
			super.reset(X, Y);
			super.makeGraphic(Width, Height);
		}
	}
}