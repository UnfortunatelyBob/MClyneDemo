package
{
	import org.flixel.*;
	
	public class PlayState extends FlxState
	{
		protected var _player:Player;
		protected var _tileBlockA:FlxTileblock, _tileBlockB:FlxTileblock, _tileBlockC:FlxTileblock;
		
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
		
		protected function generateLevel():void
		{
			var spaceOne:Number = (Math.random() * 640) + 100;
			_tileBlockA = new FlxTileblock(0, 208, spaceOne, 32);
			_tileBlockA.loadTiles(FlxTilemap.ImgAuto, 8, 8, 0);
			add(_tileBlockA);
			
			var spaceTwo:Number = (Math.random() * 760) + 100;
			_tileBlockB = new FlxTileblock(_tileBlockA.x + _tileBlockA.width + (Math.random() * 64) + 16, 208, spaceTwo, 32);
			_tileBlockB.loadTiles(FlxTilemap.ImgAuto, 8, 8, 0);
			add(_tileBlockB);
			
			var spaceThree:Number = (Math.random() * 760) + 100;
			_tileBlockC = new FlxTileblock(_tileBlockB.x + _tileBlockB.width + (Math.random() * 64) + 16, 208, spaceOne, 32);
			_tileBlockC.loadTiles(FlxTilemap.ImgAuto, 8, 8, 0);
			add(_tileBlockC);			
		}
		
		protected function updateLevel():void
		{
			var spacing:Number = (Math.random() * 760) + 100
			if(_player.x > _tileBlockA.x && _tileBlockB.x < _tileBlockA.x){
				_tileBlockB = new FlxTileblock(_tileBlockA.x + _tileBlockA.width + (Math.random() * 64) + 16, 208, spacing, 32);
				_tileBlockB.loadTiles(FlxTilemap.ImgAuto, 8, 8, 0);
				add(_tileBlockB);
			}
			else if(_player.x > _tileBlockB.x && _tileBlockC.x < _tileBlockB.x){
  				_tileBlockC = new FlxTileblock(_tileBlockB.x + _tileBlockB.width + (Math.random() * 64) + 16, 208, spacing, 32);
				_tileBlockC.loadTiles(FlxTilemap.ImgAuto, 8, 8, 0);
				add(_tileBlockC);
			}
			else if(_player.x > _tileBlockC.x && _tileBlockA.x < _tileBlockC.x){
				_tileBlockA = new FlxTileblock(_tileBlockC.x + _tileBlockC.width + (Math.random() * 64) + 16, 208, spacing, 32);
				_tileBlockA.loadTiles(FlxTilemap.ImgAuto, 8, 8, 0);
				add(_tileBlockA);
			}
				
		}		
	}
}