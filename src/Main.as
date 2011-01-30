package  
{
	import org.flixel.*; 
	[SWF(width = "640", height = "480", backgroundColor = "#000000")] 
	
	public class Main extends FlxGame
	{			
		public function Main() 
		{
			super(640, 480, MainMenu, 1); 
			//super(640, 480, Level2, 1); 
			showLogo = false;
		}
		
	}
	
}