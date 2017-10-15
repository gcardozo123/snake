package;

import flash.display.Bitmap;
import flash.display.Sprite;

/**
 * Represents the tilemap where the snakes chase apples.
 * @author Guilherme Recchi Cardozo
 */
class Tilemap extends Sprite 
{
	private var tileMap:Array<Array<Float>>;
	private var numCols:Int;
	private var numRows:Int;
	private var tileWidth:Float;
	private var tileHeight:Float;
	private var backgroundWidth:Float;
	private var backgroundHeight:Float;
	
	public function new(numCols:Int, numRows:Int, tileWidth:Float, tileHeight:Float) 
	{
		super();
		this.tileWidth = tileWidth;
		this.tileHeight = tileHeight;
		this.numCols = numCols;
		this.numRows = numRows; 
		backgroundWidth  = (numCols + 2) * tileWidth;  //numCols + 2 so we have space for walls
		backgroundHeight = (numRows + 2) * tileHeight; //numRows + 2 so we have space for walls
		init();
	}
	
	private function init():Void
	{
		tileMap = new Array<Array<Float>>();
		drawBackground();
		drawWalls();
		drawTiles();
	}
	
	private function drawBackground():Void
	{
		drawRect(0, 0, backgroundWidth, backgroundHeight, 0x89b7a2);
	}
	
	private function drawWalls():Void
	{
		drawRect(0, 0, backgroundWidth, tileHeight, 0xcccccc); //top
		drawRect(0, (numRows + 1) * tileHeight, backgroundWidth, tileHeight, 0xcccccc); //bottom
		drawRect(0, 0, tileWidth, backgroundHeight, 0xcccccc); //left
		drawRect((numCols + 1) * tileWidth, 0, tileWidth, backgroundHeight, 0xcccccc); //right
	}
	
	private function drawTiles():Void
	{
		for (r in 0 ... numRows)
		{
			for (c in 0 ... numCols)
			{
				drawTile(c * tileWidth + tileWidth, r * tileHeight + tileHeight, tileWidth, tileHeight, 0x89b7a2);
			}
		}
	}
	
	private function drawRect(x:Float, y:Float, width:Float, height:Float, color:UInt):Void
	{
		graphics.beginFill(color);
		graphics.drawRect(x, y, width, height);
		graphics.endFill();
	}
	
	private function drawTile(x:Float, y:Float, width:Float, height:Float, color:UInt):Void
	{
		graphics.lineStyle(1, 0xCCCCCC);
		graphics.beginFill(color);
		graphics.drawRoundRect(x, y, width, height, 5);
		graphics.endFill();
	}
}