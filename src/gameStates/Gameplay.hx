package gameStates;
import flash.Lib;
import Snake;
import haxe.Timer;

/**
 * The state where the gameplay happens.
 * @author Guilherme Recchi Cardozo
 */
class Gameplay extends GameState 
{
	private var tilemap:Tilemap;
	private var snakeOne:Snake;
	private var snakeTwo:Snake;
	
	public function new(key:String) 
	{
		super(key);	
	}
	
	override public function init():Void
	{
		tilemap = new Tilemap(54, 30, 18, 18);
		tilemap.x = (Lib.current.stage.stageWidth - tilemap.width) * 0.5;
		tilemap.y = (Lib.current.stage.stageHeight - tilemap.height) * 0.5;
		addChild(tilemap);
		
		snakeOne = new Snake(0, 0x005e12, 2, 5, Direction.RIGHT, 54, 30, 18, 18);
		snakeTwo = new Snake(1, 0xa09e26, tilemap.numCols - 3, 4, Direction.LEFT, 54, 30, 18, 18);
		tilemap.addSnake(snakeOne);
		tilemap.addSnake(snakeTwo);
		
		var timer = new Timer(500); //500ms delay
		timer.run = function() 
		{
			snakeOne.update();
			snakeTwo.update();
		}
	}
	
	override public function destroy():Void
	{
		
	}
}