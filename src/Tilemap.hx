package;

import flash.display.Bitmap;
import flash.display.Sprite;
import utils.Destroy;
import utils.Draw;

/**
 * Represents the tilemap where the snakes chase apples.
 * @author Guilherme Recchi Cardozo
 */
class Tilemap extends Sprite 
{
	public var numCols(default, null):Int;
	public var numRows(default, null):Int;
	
	private var tilemap:Array<Array<Int>>;
	private var tileWidth:Float;
	private var tileHeight:Float;
	private var backgroundWidth:Float;
	private var backgroundHeight:Float;
	private var snakes:Array<Snake>;
	
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
		init();
	}
	
	private function init():Void
	{
		createTilemap();
		drawBackground();
		drawWalls();
		drawTiles();
	}
	
	private function createTilemap():Void
	{
		tilemap = new Array<Array<Int>>();
		for (r in 0 ... numRows)
		{
			var cols = new Array<Int>();
			for (c in 0 ... numCols)
			{
				cols.push(0);
			}
			tilemap.push(cols);
		}
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
}