package interfaces;

/**
 * This interface is implemented by 
 * destructible objects, to free their memory.
 * @author Guilherme Recchi Cardozo
 */
interface IDestructible
{
	public function destroy():Void;
}