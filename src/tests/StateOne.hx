package tests;

import flash.events.MouseEvent;
import gameStates.GameState;

/**
 * ...
 * @author Guilherme Recchi Cardozo
 */
class StateOne extends GameState 
{
	public function new(key:String) 
	{
		super(key);
		
		graphics.beginFill(0x006600);
		graphics.drawRect(0, 0, 300, 300);
		graphics.endFill();
		addEventListener(MouseEvent.CLICK, onClick);
	}
	
	private function onClick(e:MouseEvent):Void
	{
		Game.stateManager.start("StateTwo");
	}
}