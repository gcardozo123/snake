package snake;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.Point;
import interfaces.IDestructible;
import utils.Destroy;
import utils.Draw;

/**
 * Represents the Snake.
 * @author Guilherme Recchi Cardozo
 */
class Snake extends Sprite implements IDestructible
{
	/**
	 * Unique identifier that differentiates snakes.
	 */
	public var ID(default, null):UInt;
	public var isAlive(default, set):Bool;

	private var color:UInt;
	private var mapNumRows:Int;
	private var mapNumCols:Int;
	private var tileWidth:Float;
	private var tileHeight:Float;
	private var startX:Int;
	private var startY:Int;
	private var currentDirection:Direction;
	private var lastChangeDirection:UInt;
	/**
	 * The array of segments of the snake.
	 */
	private var segments:Array<Bitmap>;
	/**
	 * The indexes (column, row) for each segment of the snake on the tilemap.
	 */
	private var segmentPositions:Array<Point>;
	
	/**
	 * Creates a new Snake
	 * @param	ID Unique Identifier.
	 * @param	color The color of the snake.
	 * @param	startX Starting X position on the tilemap.
	 * @param	startY Starting Y position on the tilemap.
	 * @param	startDir Starting direction for the snake.
	 * @param	mapNumCols Numbler of columns on the tilemap.
	 * @param	mapNumRows Number of rows on the tilemap.
	 * @param	tileWidth The width for each segment of the snake.
	 * @param	tileHeight The height for each segment of the snake.
	 */
	public function new(ID:UInt, color:UInt, startX:Int, startY:Int, startDir:Direction, mapNumCols:Int, mapNumRows:Int, tileWidth:Float, tileHeight:Float) 
	{
		super();
		this.ID = ID;
		this.color = color;
		this.mapNumRows = mapNumRows;
		this.mapNumCols = mapNumCols;
		this.tileWidth = tileWidth;
		this.tileHeight = tileHeight;
		lastChangeDirection = 0;
		spawn(startX, startY, startDir);
	}
	
	/**
	 * Defines the starting position for the snake.
	 * @param	startX
	 * @param	startY
	 * @param	startDir
	 */
	public function spawn(startX:Int, startY:Int, startDir:Direction):Void
	{
		this.startX = startX;
		this.startY = startY;
		currentDirection = startDir;
		initSegmentPositions();
		initSegmentBitmaps();
		isAlive = true;
	}
	
	/**
	 * Defines the initial position for the segments of the snake.
	 */
	private function initSegmentPositions():Void
	{
		if (segmentPositions != null)
			segmentPositions.splice(0, segmentPositions.length);
		
		segmentPositions = new Array<Point>();
		var dir:Direction = getOppositeDirection(currentDirection);
		for (i in 0 ... 3)
		{
			var p = new Point();
			if (i == 0)
			{
				p.x = startX;
				p.y = startY;
			}
			else
				getNextPosition(segmentPositions[i - 1], dir, p);
			
			segmentPositions.push(p);
		}
	}
	
	private function initSegmentBitmaps():Void
	{
		if (segments != null)
			segments = Destroy.bitmapArray(segments);	
		
		var bmpd = new BitmapData(Std.int(tileWidth), Std.int(tileHeight), false, color);	
		segments = [new Bitmap(bmpd.clone()), new Bitmap(bmpd.clone()), new Bitmap(bmpd.clone())];
		
		for (i in 0 ... segments.length)
		{
			segments[i].x = tileWidth * segmentPositions[i].x;
			segments[i].y = tileHeight * segmentPositions[i].y;
			addChild(segments[i]);
		}
	}
	
	/**
	 * Returns the next position (column, row) given
	 * a point and direction.
	 * @param	from Reference point.
	 * @param	dir Movement direction.
	 * @param   output The point where the return of this function will be stored.
	 */
	private function getNextPosition(from:Point, dir:Direction, output:Point):Void
	{
		switch(dir)
		{
			case UP: 
				output.x = from.x;
				output.y = from.y - 1;
			
			case DOWN: 
				output.x = from.x;
				output.y = from.y + 1;
			
			case LEFT: 
				output.x = from.x - 1;
				output.y = from.y;
				
			case RIGHT: 
				output.x = from.x + 1;
				output.y = from.y;
		}
	}
	
	/**
	 * Returns the opposite direction from dir.
	 * @param	dir Reference direction.
	 * @return  The opposite direction.
	 */
	private function getOppositeDirection(dir:Direction):Direction
	{
		return switch(dir)
		{
			case UP: Direction.DOWN;
			case DOWN: Direction.UP;
			case LEFT: Direction.RIGHT;
			case RIGHT: Direction.LEFT;
		}
	}
	
	private function set_isAlive(value:Bool):Bool
	{
		if (!value)
			visible = false;
		return isAlive = value;
	}
	
	/**
	 * Changes the current direction of the snake.
	 * @param	newDir The new direction.
	 * @param   turn The turn when key was pressed.
	 */
	public function changeDirection(newDir:Direction, turn:UInt):Void
	{
		if (lastChangeDirection == turn) 
			return; //Can't change direction multiple times in the same turn.
		
		if (newDir == currentDirection || newDir == getOppositeDirection(currentDirection))
			return;
		
		lastChangeDirection = turn;
		currentDirection = newDir;
	}
	
	public function update():Void
	{
		if (!isAlive)
		{
			visible = false;
			return;
		}
		
		//Removes the tail of the snake and puts on the next Snake position (in front of its head).
		var newHead = segmentPositions.pop();
		getNextPosition(segmentPositions[0], currentDirection, newHead);
		segmentPositions.unshift(newHead);
		
		var newHeadBmp:Bitmap = segments.pop();
		newHeadBmp.x = tileWidth * newHead.x;
		newHeadBmp.y = tileHeight * newHead.y;
		segments.unshift(newHeadBmp);
	}
	
	public function grow():Void
	{
		var newHead = new Point();
		getNextPosition(segmentPositions[0], currentDirection, newHead);
		segmentPositions.unshift(newHead);
		
		var newHeadBmp:Bitmap = new Bitmap(new BitmapData(Std.int(tileWidth), Std.int(tileHeight), false, color));
		newHeadBmp.x = tileWidth * newHead.x;
		newHeadBmp.y = tileHeight * newHead.y;
		segments.unshift(newHeadBmp);
		addChild(segments[0]);
	}
	
	/**
	 * Returns the snake's segments positions.
	 */
	public function getPositions():Array<Point>
	{
		return segmentPositions;
	}
	
	public function destroy():Void
	{
		if (segmentPositions != null)
			segmentPositions.splice(0, segmentPositions.length);
		
		segments = Destroy.bitmapArray(segments);
	}
}

enum Direction
{
	UP;
	DOWN;
	LEFT;
	RIGHT;
}