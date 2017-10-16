package;

import flash.display.Sprite;
import state.Gameplay;
import state.StateManager;

/**
 * This class represents the game.
 * @author Guilherme Recchi Cardozo
 */
class Game extends Sprite 
{
	/**
	 * Used to switch between GameStates.
	 */
	public static var stateManager(default, null):state.StateManager;
	/**
	 * The state where the gameplay happens.
	 */
	private var gameplay:Gameplay;
	
	public function new() 
	{
		super();
		init();
	}
	
	private function init():Void
	{
		Game.stateManager = new state.StateManager(this);
		gameplay = new Gameplay("Gameplay", onGameOver);
		Game.stateManager.add(gameplay, true);
	}
	
	private function onGameOver():Void
	{
		Game.stateManager.destroy();
	}
}