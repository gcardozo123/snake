package gameStates;

import flash.display.Sprite;
import interfaces.IDestructible;

/**
 * A GameState can be considered a game screen
 * such as the title screen, gameplay screen, scores, etc.
 * Use the StateManager class to handle GameStates.
 * @author Guilherme Recchi Cardozo
 */
class GameState extends Sprite implements IDestructible
{
	/**
	 * The unique identifier (name) for this GameState.
	 */
	public var key(default, null):String; 
	/**
	 * @param	key The unique identifier (name) for this GameState.
	 */
	public function new(key:String) 
	{
		super();
		this.key = key;
	}
	
	/**
	 * This method is the first called by the StateManager,
	 * to initialize a state.
	 */
	public function init():Void
	{
	}
	
	/**
	 * Override this method to free the memory used by this GameState.
	 * This method is called by the StateManager when switching 
	 * from this state to another.
	 */
	public function destroy():Void
	{
	}
}