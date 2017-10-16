package state;
import state.GameState;
import interfaces.IDestructible;

/**
 * A simple StateManager, responsible for managing game states. Used
 * for adding, switching and destroying GameStates.
 * @author Guilherme Recchi Cardozo
 */
class StateManager implements IDestructible
{
	private var game:Game;
	private var states:Map<String, GameState>;
	private var currentState:GameState;
	
	public function new(game:Game) 
	{
		states = new Map<String, GameState>();
		this.game = game;
	}
	
	/**
	 * Adds a GameState to the StateManager.
	 * @param	key An unique identifier.
	 * @param	gameState The GameState.
	 * @param	autoStart Indicates whether or not we should immediately switch for the gamestate. 
	 * @return  this StateManager, so you can chain add calls.
	 */
	public function add(gameState:GameState, autoStart:Bool = false):StateManager
	{
		var key:String = gameState.key;
		
		if (key == null)
			throw "Error: null key.";
		
		if (states.exists(key))
			throw "Error: there is already a GameState with the key " + key;
		else
		{
			states[key] = gameState;
			if (autoStart)
				start(key);
		}
		return this;
	}
	
	/**
	 * Starts the next GameState, if there's a GameState running,
	 * it'll be destroyed.
	 * @param	key
	 */
	public function start(key:String):Void
	{
		if (key == null || !states.exists(key))
		{
			throw "Error: the state doesn't exist.";
			return;
		}
		if (currentState != null)
		{
			if (currentState.parent != null)
				currentState.parent.removeChild(currentState);
			
			currentState.destroy();
			currentState = null;
		}
		currentState = states[key];
		currentState.init();
		game.addChild(currentState);
	}
	
	/**
	 * Deletes the state.
	 * @param	key 
	 */
	public function removeState(key:String)
	{
		if (key == null)
		{
			throw "Error: null key.";
			return;
		}
		if (states.exists(key))
		{
			if (currentState != null && currentState.key == key)
				currentState = null;
			
			states.remove(key);
		}
	}
	
	/**
	 * Calls the method destroy on all GameStates being 
	 * handled by this StateManager.
	 */
	public function destroy():Void
	{
		if (currentState != null)
			currentState.destroy();
		
		for (key in states.keys()) 
		{
			if (states[key] != null)
			{
				states[key].destroy();
				states.remove(key);
			}
		}
	}
}