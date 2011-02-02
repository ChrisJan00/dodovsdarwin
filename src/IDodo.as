package  
{
	import org.flixel.FlxCore;
	
	/**
	 * ...
	 * @author Max Dohme
	 */
	public interface IDodo 
	{
		function takeHumanDamage():void
		function takeRatDamage():void
		function isFlying():Boolean
		function get family():int
		function overlaps(Core:FlxCore):Boolean
		function eat():void
	}
	
}