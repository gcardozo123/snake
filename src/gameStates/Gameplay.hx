package gameStates;
import flash.Lib;

/**
 * The state where the gameplay happens.
 * @author Guilherme Recchi Cardozo
 */
class Gameplay extends GameState 
{
	private var tilemap:Tilemap;
	
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
	}
	
	override public function destroy():Void
	{
		
	}
}