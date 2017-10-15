package tests;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.MouseEvent;
import gameStates.GameState;

/**
 * ...
 * @author Guilherme Recchi Cardozo
 */
class StateTwo extends GameState 
{
	public function new(key:String) 
	{
		super(key);
		
		graphics.beginFill(0x003344);
		graphics.drawRect(0, 0, 100, 100);
		graphics.endFill();
		addEventListener(MouseEvent.CLICK, onClick);
	}
	
	private function onClick(e:MouseEvent):Void
	{
		Game.stateManager.start("StateOne");
	}
}