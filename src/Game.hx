package;

import flash.display.Sprite;
import gameStates.Gameplay;

/**
 * This class represents the game.
 * @author Guilherme Recchi Cardozo
 */
class Game extends Sprite 
{
	/**
	 * Used to switch between GameStates.
	 */
	public static var stateManager(default, null):StateManager;
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
		Game.stateManager = new StateManager(this);
		gameplay = new Gameplay("Gameplay");
		Game.stateManager.add(gameplay, true);
	}
}