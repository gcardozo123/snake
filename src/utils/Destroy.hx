package utils;
import flash.display.Bitmap;
import interfaces.IDestructible;

/**
 * A handler to free the memory from objects.
 * @author Guilherme Recchi Cardozo
 */
class Destroy 
{
	public static function object<T:IDestructible>(obj:Null<IDestructible>):T
	{
		if (obj != null)
		{
			obj.destroy();
		}
		return null;
	}
	
	public static function array<T:IDestructible>(array:Array<T>):Array<T>
	{
		if (array != null)
		{
			for (e in array)
			{
				object(e);
			}
			array.splice(0, array.length);
		}
		return null;
	}
	
	public static function bitmap(bitmap:Bitmap):Bitmap
	{
		if (bitmap != null && bitmap.bitmapData != null)
		{
			if (bitmap.parent != null)
				bitmap.parent.removeChild(bitmap);
			
			bitmap.bitmapData.dispose();
		}
		return null;
	}
	
	public static function bitmapArray<T:Bitmap>(array:Array<T>):Array<T>
	{
		if (array != null)
		{
			for (e in array)
			{
				bitmap(e);
			}
			array.splice(0, array.length);
		}
		return null;
	}
	
}