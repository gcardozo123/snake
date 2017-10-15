package;

import flash.display.Sprite;
import flash.events.MouseEvent;
import tests.StateOne;
import tests.StateTwo;

/**
 * This class represents the game.
 * @author Guilherme Recchi Cardozo
 */
class GameTest extends Sprite 
{
	public static var stateManager(default, null):StateManager;
	
	public function new() 
	{
		super();
		init();
	}
	
	private function init():Void
	{
		var stateOne = new StateOne("StateOne");
		var stateTwo = new StateTwo("StateTwo");
		Game.stateManager = new StateManager(this);
		Game.stateManager.add(stateOne, true).add(stateTwo);
	}
}