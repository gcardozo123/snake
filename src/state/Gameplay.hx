package state;
import flash.Lib;
import snake.Snake;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import haxe.Timer;
import snake.SnakePlayer;

/**
 * The state where the gameplay happens.
 * @author Guilherme Recchi Cardozo
 */
class Gameplay extends GameState 
{
	private var tilemap:Tilemap;
	private var snakeOne:SnakePlayer;
	private var snakeTwo:SnakePlayer;
	private var turn:UInt;
	/**
	 * Binds keyboard keys to players.
	 */
	private var keyPlayer:Map<UInt, SnakePlayer>;
	
	public function new(key:String) 
	{
		super(key);	
	}
	
	override public function init():Void
	{
		turn = 0;
		tilemap = new Tilemap(54, 30, 18, 18);
		tilemap.x = (Lib.current.stage.stageWidth - tilemap.width) * 0.5;
		tilemap.y = (Lib.current.stage.stageHeight - tilemap.height) * 0.5;
		addChild(tilemap);
		
		snakeOne = new SnakePlayer(0, 0x005e12, 2, 5, Direction.RIGHT, 54, 30, 18, 18);
		snakeTwo = new SnakePlayer(1, 0xa09e26, tilemap.numCols - 3, 4, Direction.LEFT, 54, 30, 18, 18);
		tilemap.addSnake(snakeOne);
		tilemap.addSnake(snakeTwo);
		setupInputHandler();
		
		var timer = new Timer(100); //500ms delay
		timer.run = newTurn; 
	}
	
	/**
	 * Snake can be considered a turn-based game,
	 * this method process the turn.
	 */
	private function newTurn():Void
	{
		if (snakeOne.isAlive)
			snakeOne.update();
		if (snakeTwo.isAlive)
			snakeTwo.update();
		
		tilemap.checkCollisions();
		turn++;
	}
	
	private function setupInputHandler():Void
	{
		keyPlayer = new Map<UInt, SnakePlayer>();
		
		if (!Lib.current.stage.hasEventListener(KeyboardEvent.KEY_DOWN))
			Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			
		//Binding keyboard keys to players:
		keyPlayer[Keyboard.W] = keyPlayer[Keyboard.A] = keyPlayer[Keyboard.S] = keyPlayer[Keyboard.D] = snakeOne;
		keyPlayer[Keyboard.UP] = keyPlayer[Keyboard.DOWN] = keyPlayer[Keyboard.LEFT] = keyPlayer[Keyboard.RIGHT] = snakeTwo;
		
		snakeOne.bindKey(Keyboard.W, Direction.UP);
		snakeOne.bindKey(Keyboard.A, Direction.LEFT);
		snakeOne.bindKey(Keyboard.S, Direction.DOWN);
		snakeOne.bindKey(Keyboard.D, Direction.RIGHT);
		
		snakeTwo.bindKey(Keyboard.UP, Direction.UP);
		snakeTwo.bindKey(Keyboard.DOWN, Direction.DOWN);
		snakeTwo.bindKey(Keyboard.LEFT, Direction.LEFT);
		snakeTwo.bindKey(Keyboard.RIGHT, Direction.RIGHT);
	}
	
	private function onKeyDown(e:KeyboardEvent):Void
	{
		if (keyPlayer.exists(e.keyCode))
			keyPlayer[e.keyCode].handleKeyPress(e.keyCode, turn);
	}
	
	override public function destroy():Void
	{
		Lib.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
	}
}