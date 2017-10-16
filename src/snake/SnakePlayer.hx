package snake;
import snake.Snake;

/**
 * A snake controlled by a player.
 * @author Guilherme Recchi Cardozo
 */
class SnakePlayer extends Snake 
{
	/**
	 * Maps one key (for example Keyboard.W), to a direction.
	 */
	private var keyBindings:Map<UInt, Direction>;

	
	public function new(ID:UInt, color:UInt, startX:Int, startY:Int, startDir:Direction, mapNumCols:Int, mapNumRows:Int, tileWidth:Float, tileHeight:Float) 
	{
		super(ID, color, startX, startY, startDir, mapNumCols, mapNumRows, tileWidth, tileHeight);
		keyBindings = new Map<UInt, Direction>();
	}
	
	/**
	 * Binds a key press to a direction.
	 * This method enables changing the keyboard configuration for players.
	 * @param	key A keyboard key, for example: Keyboard.W.
	 * @param	dir The direction (UP, DOWN, LEFT or RIGHT).
	 */
	public function bindKey(key:UInt, dir:Direction):Void
	{
		keyBindings[key] = dir;
	}
	
	/**
	 * Process the given key press.
	 * @param	key Key that was pressed.
	 * @param   turn The turn when key was pressed.
	 */
	public function handleKeyPress(key:UInt, turn:UInt):Void
	{
		if (!keyBindings.exists(key))
			return; //there's no key binding
			
		super.changeDirection(keyBindings[key], turn);
	}
	
	override public function destroy():Void
	{
		super.destroy();
		keyBindings = null;
	}
}