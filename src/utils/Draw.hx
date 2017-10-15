package utils;
import flash.display.Graphics;

/**
 * This class makes the drawing process easier.
 * @author Guilherme Recchi Cardozo
 */
class Draw 
{

	public function new() 
	{
	}
	
	public static function rect(graphics:Graphics, x:Float, y:Float, width:Float, height:Float, color:UInt):Void
	{
		graphics.beginFill(color);
		graphics.drawRect(x, y, width, height);
		graphics.endFill();
	}
	
	public static function tile(graphics:Graphics, x:Float, y:Float, width:Float, height:Float, color:UInt):Void
	{
		graphics.lineStyle(1, 0xCCCCCC);
		graphics.beginFill(color);
		graphics.drawRoundRect(x, y, width, height, 3);
		graphics.endFill();
	}
	
}