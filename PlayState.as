//***********************************************************************************************************
//Playstate.as			
//Author: Matthew Clyne
//
//This class manages the main game state.  It also does level construction and update. 
//Lastly, the scrolling background images are handled here.  This game was built using
//the Flixel game tools.
//***********************************************************************************************************

package
{
	import org.flixel.*;
	
	public class PlayState extends FlxState
	{
		//embedding images and sound so I can reference them later
		[Embed(source="data/art/CloudBG.png")] protected var ImgCloudBG:Class;
		[Embed(source="data/art/TreeBG.png")] protected var ImgTreeBG:Class;
		[Embed(source="data/art/DirtTiles.png")] protected var ImgDirtTiles:Class;
		[Embed(source="data/sound/splat.mp3")] private var SndSplat:Class;
		
		protected var _player:Player;		//This is the player.  Class inherits from Flixel Spritex
		protected var _tileBlockA:RecyclableFlxTileblock, _tileBlockB:RecyclableFlxTileblock, _tileBlockC:RecyclableFlxTileblock;		//These are blocks comprised of tiles used for building the level.
		protected var _enemyTimer:int;		//This allows me to space out enemies while allowing their creation to be somewhat randomized
		protected var _score:FlxText;		//Score text
		
		//FlxGroups allow methods to be applied to all the objects that exist in that group.  Simplifies collision and other bits of code
		protected var _enemies:FlxGroup;		//enemies - this may not have been necessary in retrospect, as only one enemy is ever on screen at a time
		protected var _shots:FlxGroup;			//bullets
		protected var _lvlBlocks:FlxGroup;		//group of the level blocks
		protected var _hud:FlxGroup;			//items drawn to the Heads Up Display
		
		override public function create():void
		{
			FlxG.score = 0;			//reset the score
			FlxG.mouse.hide();		//mouse is visible in the menus
			
			//this handles the scrolling backgrounds.  Look at that parallax!
			add(new FlxBackdrop(ImgCloudBG, -0.2, 0, true, true))
			add(new FlxBackdrop(ImgTreeBG, -0.4, 0, true, true))
			
			//MEM ALLOC
			_enemies = new FlxGroup();
			_shots = new FlxGroup();
			_lvlBlocks = new FlxGroup();
			_hud = new FlxGroup();
			
			//adds things to the game state
			add(_enemies);
			add(_shots);
			add(_lvlBlocks);
			add(_hud);
			
			//CREATE PLAYER - MEM ALLOC
			_player = new Player(10, 180, _shots);
			add(_player);
			
			//generateLevel function is in this class below the update loop.
			generateLevel();				
			
			FlxG.camera.setBounds(0, 0, 500000, 240, true);		//Level is technically not infinite.  50,000 pixels long.  Camera needs bounds to run, can't set to none.
			FlxG.camera.deadzone = null;						//I had to tweak the base FlxCamera files to get the camera to work how I wanted.  This null may no longer be necessary
			FlxG.camera.follow(_player);						//Camera follows player.
			
			_enemyTimer = 2;	//the first enemy will always appear on the third block.  Gives players a second to get a "feel" for controls before throwing death their way
			
			//Score is partially managed in Flixel.  I create this text and set it to a place on the screen, then add it to the hud FlxGroup
			_score = new FlxText(FlxG.width/4,0,FlxG.width/2);
			_score.setFormat(null,16,0xffdddd,"center",0x888888);
			_hud.add(_score);
			
			//The hud FlxGroup allows me to have the text scroll with the camera movement and remain stationary on the game screen.  If I'd wanted more info on the screen, all I'd do is add it to this group
			_hud.setAll("scrollFactor", new FlxPoint(0,0));
			_hud.setAll("cameras",[FlxG.camera]);
		}
		
		override public function destroy():void
		{
			super.destroy();	//calls base class destroy
			
			//AS3 has a garbage collector.  As long as I set these to null, that garbage collector should clean the memory up for me.
			//GARBAGE COLLECTION
			_player = null;			
			_tileBlockA = null;
			_tileBlockB = null;
			_tileBlockC = null;
			_score = null;
						
			_enemies = null;
			_shots = null;
			_lvlBlocks = null;
			_hud = null;
		}
		
		override public function update():void
		{
			super.update();		//This calls update for all of the classes in here.  Player, Enemy, etc.  Super useful.  Get it?  Super.  oh...
			
			FlxG.collide(_lvlBlocks, _player);				//this checks collision with the level and the player.
			FlxG.overlap(_enemies, _shots, overlapped);		//this checks "collision" with the enemies and the ice cream bullets, and will call the overlapped callback if they do collide.
			FlxG.overlap(_player, _enemies, overlapped);	//this checks "collision" with the player and the enemies, and will call the overlapped callback if they do collide.
			
			updateLevel();		//Function is in this class, below generate level.
			
			_score.text = FlxG.score.toString();		//Converts the score number to a string which is used in the hud display
			
			if(_enemyTimer < 1)		//if it's time to make another enemy...
			{
				//Checks to see what the next block ahead of the player is, and plops an enemy in the middle of it
				//Enemies are placed in the middle because helps prevent enemies from showing up in places that are almost impossible to avoid and for the most part stops them falling in pits.
				if(_tileBlockA.x > _player.x)
					(_enemies.recycle(Enemy) as Enemy).initialize(_tileBlockA.x + _tileBlockA.width/2, 196, _player);
				else if(_tileBlockB.x > _player.x)
					(_enemies.recycle(Enemy) as Enemy).initialize(_tileBlockB.x + _tileBlockB.width/2, 196, _player);
				else
					(_enemies.recycle(Enemy) as Enemy).initialize(_tileBlockC.x + _tileBlockC.width/2, 196, _player);
				
				_enemyTimer = Math.random() * 2 + 1;		//next enemy will show up in 1-3 blocks.  0 case is bad and can generate multiple enemies in the exact same spot.
			}
			
			//If you fall down one of the pits, your y coord will become higher than the max y val, meaning you fell to your death.  Reset level.
			if(_player.y > FlxG.height)
			{
				FlxG.score = 0;
				FlxG.switchState(new FailState());		//loads into the failstate screen.  MENU
			}
			
			if(FlxG.score > 999)		//Kill 10 enemies to win.
				FlxG.switchState(new WinState());		//loads into the winstate screen.  MENU
		}
		
		//the level is constructed from three Flixel "Tileblocks" (blocks with collision information, filled in with tiles).
		//At first three random width blocks are created with a gap that must be jumped between them.
		protected function generateLevel():void
		{
			var spaceOne:Number = (Math.random() * 480) + 100;		//random width for block
			_tileBlockA = new RecyclableFlxTileblock(0, 208, spaceOne, 32);	//block x, y, width, height
			_tileBlockA.loadTiles(ImgDirtTiles, 8, 8, 0);		//block image to load, size of tiles in block, gaps to not fill
			add(_tileBlockA);					//add to the game
			_lvlBlocks.add(_tileBlockA);		//add to the collision checking group
			
			var spaceTwo:Number = (Math.random() * 480) + 100;
			_tileBlockB = new RecyclableFlxTileblock(_tileBlockA.x + _tileBlockA.width + (Math.random() * 32) + 16, 208, spaceTwo, 32);		//the location of the next block is dependent on where the previous one ends.
			_tileBlockB.loadTiles(ImgDirtTiles, 8, 8, 0);
			add(_tileBlockB);
			_lvlBlocks.add(_tileBlockB);
			
			var spaceThree:Number = (Math.random() * 480) + 100;
			_tileBlockC = new RecyclableFlxTileblock(_tileBlockB.x + _tileBlockB.width + (Math.random() * 32) + 16, 208, spaceOne, 32);
			_tileBlockC.loadTiles(ImgDirtTiles, 8, 8, 0);
			add(_tileBlockC);
			_lvlBlocks.add(_tileBlockC);
		}
		
		//Now comes the fun part.  The three blocks are recycled infinitely (if the camera never ended).
		//Once the player enters a new block, the following block is generated and the previous block remains visible.
		//The three blocks allow for the current block, previous block, and next block to all be in frame simultaneously.
		//I created the "RecyclableFlxTileblock" Class to be able to modify the existing blocks rather than having to use the "new" keyword all the time and slow things down with memory alloc.
		protected function updateLevel():void
		{
			var spacing:Number = (Math.random() * 760) + 100
			if(_player.x > _tileBlockA.x && _tileBlockB.x < _tileBlockA.x)
			{			//player has entered the block and the "next" block is not in front of the current one.
				_tileBlockB.recycle(_tileBlockA.x + _tileBlockA.width + (Math.random() * 64) + 32, 208, spacing, 32);
				_tileBlockB.loadTiles(ImgDirtTiles, 8, 8, 0);
				add(_tileBlockB);
				_enemyTimer--;		//decrement the enemy timer
			}
			else if(_player.x > _tileBlockB.x && _tileBlockC.x < _tileBlockB.x)
			{
  				_tileBlockC.recycle(_tileBlockB.x + _tileBlockB.width + (Math.random() * 64) + 32, 208, spacing, 32);
				_tileBlockC.loadTiles(ImgDirtTiles, 8, 8, 0);
				add(_tileBlockC);
				_enemyTimer--;
			}
			else if(_player.x > _tileBlockC.x && _tileBlockA.x < _tileBlockC.x)
			{
				_tileBlockA.recycle(_tileBlockC.x + _tileBlockC.width + (Math.random() * 64) + 32, 208, spacing, 32);
				_tileBlockA.loadTiles(ImgDirtTiles, 8, 8, 0);
				add(_tileBlockA);
				_enemyTimer--;
			}				
		}
		
		//This is an overlap callback function, triggered by the calls to FlxG.overlap().
		protected function overlapped(Sprite1:FlxSprite,Sprite2:FlxSprite):void
		{
			if(Sprite1 is Player)		//player is checked first.  If Player has overlapped the only case is an enemy.  Trigger failstate
			{
				FlxG.score = 0;
				FlxG.switchState(new FailState());
			}
			if(Sprite1 is Enemy)		//if the enemy has hit something as Sprite1 the only case is it's been hit by a shot
				FlxG.play(SndSplat);	//so make some noise
			Sprite1.kill();				//kill the sprites
			Sprite2.kill();
		}
	}
}