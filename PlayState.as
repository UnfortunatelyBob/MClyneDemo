package
{
	import org.flixel.*;
	
	public class PlayState extends FlxState
	{
		protected var _player:Player;		//This is the player.  Class inherits from Flixel Sprite
		protected var _tileBlockA:RecyclableFlxTileblock, _tileBlockB:RecyclableFlxTileblock, _tileBlockC:RecyclableFlxTileblock;		//These are blocks comprised of tiles used for building the level.
		
		protected var _enemies:FlxGroup;
		protected var _cans:FlxGroup;
		protected var _shoots:FlxGroup;
		
		override public function create():void
		{
			FlxG.bgColor = 0xffaaaaaa;

			
			generateLevel();
			
			_player = new Player(10, 200);
			add(_player);
			
			var enemy:FlxSprite = new FlxSprite(500, 196);
			enemy.makeGraphic(10,12,0xffffffff);
			add(enemy)
				
			
			FlxG.camera.setBounds(0,0, 500000, 240, true);		//Level is technically not infinite.  50,000 pixels long.  Camera needs bounds to run, can't set to none.
			FlxG.camera.follow(_player);						//Camera follows player.
		}
		
		override public function destroy():void
		{
			super.destroy();
			
			_player = null;
			
			_tileBlockA = null;
			_tileBlockB = null;
			_tileBlockC = null;
			
			_enemies = null;
			_cans = null;
			_shoots = null;
		}
		
		override public function update():void
		{
			FlxG.collide();		//this calls collide with everything.  i.e. every object should collide with every other.
			
			_player.update();
			
			updateLevel();
			
			super.update();
			
			
			
			//If you fall down one of the pits, your y coord will become higher than the max y val, meaning you fell to your death.  Reset level.
			if(_player.y > FlxG.height)
			{
				FlxG.resetState();
			}
		}
		
		//the level is constructed from three Flixel "Tileblocks" (blocks with collision, filled in with tiles).
		//At first three random width blocks are created with a gap that must be jumped between them.
		protected function generateLevel():void
		{
			var spaceOne:Number = (Math.random() * 640) + 100;		//random width for block
			_tileBlockA = new RecyclableFlxTileblock(0, 208, spaceOne, 32);	//block x, y, width, height
			_tileBlockA.loadTiles(FlxTilemap.ImgAuto, 8, 8, 0);		//block image to load, size of tiles in block, gaps to not fill
			add(_tileBlockA);
			
			var spaceTwo:Number = (Math.random() * 760) + 100;
			_tileBlockB = new RecyclableFlxTileblock(_tileBlockA.x + _tileBlockA.width + (Math.random() * 64) + 16, 208, spaceTwo, 32);		//the location of the next block is dependent on where the previous one ends.
			_tileBlockB.loadTiles(FlxTilemap.ImgAuto, 8, 8, 0);
			add(_tileBlockB);
			
			var spaceThree:Number = (Math.random() * 760) + 100;
			_tileBlockC = new RecyclableFlxTileblock(_tileBlockB.x + _tileBlockB.width + (Math.random() * 64) + 16, 208, spaceOne, 32);
			_tileBlockC.loadTiles(FlxTilemap.ImgAuto, 8, 8, 0);
			add(_tileBlockC);			
		}
		
		//Now comes the fun part.  The three blocks are recycled infinitely (if the camera never ended).
		//Once the player enters a new block, the following block is generated and the previous block remains visible.
		//The three blocks allow for the current block, previous block, and next block to all be in frame simultaneously.
		//I created the "RecyclableFlxTileblock" Class to be able to modify the existing blocks rather than having to use the "new" keyword all the time and slow things down with memory alloc.
		protected function updateLevel():void
		{
			var spacing:Number = (Math.random() * 760) + 100
			if(_player.x > _tileBlockA.x && _tileBlockB.x < _tileBlockA.x){			//player has entered the block and the "next" block is not in front of the current one.
				_tileBlockB.recycle(_tileBlockA.x + _tileBlockA.width + (Math.random() * 64) + 16, 208, spacing, 32);
				_tileBlockB.loadTiles(FlxTilemap.ImgAuto, 8, 8, 0);
				add(_tileBlockB);
			}
			else if(_player.x > _tileBlockB.x && _tileBlockC.x < _tileBlockB.x){
  				_tileBlockC.recycle(_tileBlockB.x + _tileBlockB.width + (Math.random() * 64) + 16, 208, spacing, 32);
				_tileBlockC.loadTiles(FlxTilemap.ImgAuto, 8, 8, 0);
				add(_tileBlockC);
			}
			else if(_player.x > _tileBlockC.x && _tileBlockA.x < _tileBlockC.x){
				_tileBlockA.recycle(_tileBlockC.x + _tileBlockC.width + (Math.random() * 64) + 16, 208, spacing, 32);
				_tileBlockA.loadTiles(FlxTilemap.ImgAuto, 8, 8, 0);
				add(_tileBlockA);
			}
				
		}		
	}
}