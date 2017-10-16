package;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.Point;
import interfaces.IDestructible;
import snake.Snake;
import utils.Destroy;
import utils.Draw;

/**
 * Represents the tilemap where the snakes chase apples.
 * @author Guilherme Recchi Cardozo
 */
class Tilemap extends Sprite implements IDestructible
{
	public var numCols(default, null):Int;
	public var numRows(default, null):Int;
	
	private var tileWidth:Float;
	private var tileHeight:Float;
	private var backgroundWidth:Float;
	private var backgroundHeight:Float;
	private var snakes:Array<Snake>;
	private var apple:Bitmap;
	/**
	 * The index of the tilemap corresponding to the apple position.
	 */
	private var applePosition:Point; 
	
	public function new(numCols:Int, numRows:Int, tileWidth:Float, tileHeight:Float) 
	{
		super();
		this.tileWidth = tileWidth;
		this.tileHeight = tileHeight;
		this.numCols = numCols;
		this.numRows = numRows; 
		backgroundWidth  = (numCols + 2) * tileWidth;  //numCols + 2 so we have space for walls
		backgroundHeight = (numRows + 2) * tileHeight; //numRows + 2 so we have space for walls
		snakes = new Array<Snake>();
		apple = new Bitmap(new BitmapData(Std.int(tileWidth), Std.int(tileHeight), false, 0xcc0000));
		apple.visible = false;
		addChild(apple);
		applePosition = new Point();
		init();
	}
	
	private function init():Void
	{
		drawBackground();
		drawWalls();
		drawTiles();
		spawnApple();
	}
	
	private function drawBackground():Void
	{
		Draw.rect(graphics, 0, 0, backgroundWidth, backgroundHeight, 0x89b7a2);
	}
	
	private function drawWalls():Void
	{
		Draw.rect(graphics, 0, 0, backgroundWidth, tileHeight, 0xcccccc); 						 	//top
		Draw.rect(graphics, 0, (numRows + 1) * tileHeight, backgroundWidth, tileHeight, 0xcccccc);  //bottom
		Draw.rect(graphics, 0, 0, tileWidth, backgroundHeight, 0xcccccc); 						 	//left
		Draw.rect(graphics, (numCols + 1) * tileWidth, 0, tileWidth, backgroundHeight, 0xcccccc);   //right
	}
	
	private function drawTiles():Void
	{
		for (r in 0 ... numRows)
		{
			for (c in 0 ... numCols)
			{
				Draw.tile(graphics, c * tileWidth + tileWidth, r * tileHeight + tileHeight, tileWidth, tileHeight, 0x89b7a2);
			}
		}
	}
	
	private function spawnApple():Void
	{
		var freePositions = getFreePositions();
		var index:Int = Std.int(freePositions.length * Math.random());
		applePosition = freePositions[index];
		apple.x = applePosition.x * tileWidth + tileWidth;   //considers the space used by the wall
		apple.y = applePosition.y * tileHeight + tileHeight; //considers the space used by the wall
		apple.visible = true;
	}
	
	/**
	 * Returns an array with all the empty cells on the map
	 */
	private function getFreePositions():Array<Point>
	{
		var occupiedPositions:Array<Point> = new Array<Point>();
		for (snake in snakes)
		{
			if (snake.isAlive)
			{
				for (segment in snake.getPositions())
				{
					occupiedPositions.push(segment);
				}
			}
		}
		var freePositions:Array<Point> = new Array<Point>();
		for (r in 0 ... numRows)
		{
			for (c in 0 ... numCols)
			{
				var isEmpty:Bool = true;
				var currentPosition = new Point(c, r);
				for (pos in occupiedPositions)
				{
					if (pos.equals(currentPosition))
					{
						isEmpty = false;
						break;
					}
				}
				if (isEmpty)
					freePositions.push(currentPosition);
			}
		}
		return freePositions;
	}
	
	public function addSnake(snake:Snake):Void
	{
		if (snakes == null)
			throw "Error: the snakes array is null.";
			
		if (idAlreadyExists(snake.ID))
			throw "Error: there's another snake using the ID " + snake.ID;
		
		snakes.push(snake);
		snake.x = tileWidth;  //considers the space used by the wall
		snake.y = tileHeight; //considers the space used by the wall
		addChild(snake);
	}
	
	/**
	 * Checks if there's a snake with the same ID 
	 * as the one passed as parameter.
	 * @param	ID One ID to be checked.
	 * @return  Bool
	 */
	private function idAlreadyExists(ID:UInt):Bool
	{
		if (snakes == null || snakes.length == 0)
			return false;
		
		for (snake in snakes)
		{
			if (snake.ID == ID)
				return true;
		}
		return false;
	}
	
	/**
	 * Checks collisions snake-snake, snakes-walls and
	 * snake-apple.
	 */
	public function checkCollisions():Void
	{
		for (snake in snakes)
		{
			if (snake.isAlive)
			{
				var head:Point = snake.getPositions()[0];
				
				if (wallCollision(head) || selfCollision(snake) || otherSnakeCollision(snake)) 
					snake.isAlive = false;
				
				if (appleCollision(snake))
				{
					snake.grow();
					spawnApple();
				}
			}
		}
	}
	
	/**
	 * Verifies if a given position is out of the map.
	 * @param	position
	 * @return
	 */
	private function wallCollision(position:Point):Bool
	{
		return position.x < 0 || position.y < 0 || position.x >= numCols || position.y >= numRows;
	}
	
	/**
	 * Verifies if the snake collides with itself.
	 * @param	snake 
	 * @return  Bool
	 */
	private function selfCollision(snake:Snake):Bool
	{
		var snakeSegments:Array<Point> = snake.getPositions();
		var head:Point = snakeSegments[0];
		
		for (i in 1 ... snakeSegments.length)
		{
			if (head.x == snakeSegments[i].x && head.y == snakeSegments[i].y)
				return true;
		}
		return false;
	}
	
	/**
	 * Verifies if a given snake collides with another.
	 * @param	reference The reference snake.
	 * @return
	 */
	private function otherSnakeCollision(reference:Snake):Bool
	{
		var head:Point = reference.getPositions()[0];
		for (snake in snakes)
		{
			for (segment in snake.getPositions())
			{
				if (snake.ID != reference.ID && snake.isAlive && head.x == segment.x && head.y == segment.y)
					return true;
			}
		}
		return false;
	}
	
	/**
	 * Verifies if a given snake collides with the apple.
	 * @param	snake
	 * @return
	 */
	private function appleCollision(snake:Snake):Bool
	{
		var head:Point = snake.getPositions()[0];
		return head.x == applePosition.x && head.y == applePosition.y;
	}
	
	public function destroy():Void
	{
		if (snakes != null)
			snakes.splice(0, snakes.length);
		if (apple != null)
			apple = Destroy.bitmap(apple);
		
		//graphics.clear(); //I commented this line so you won't stare at a blank screen when the game ends.
	}
}