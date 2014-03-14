package dwyer.designData 
{
	import dwyer.gameplay.DifficultyLevelData;
	
	/**
	 * This class is a static wrapper for design data that I would normally expect to pull from a server in a production level game. This
	 * way this sot of data can be easily tweaked by a designer without having to upload a new swf or interrupt client engineer work.
	 * @author Mike Dwyer
	 */
	public class GamePlayModes 
	{
		public static var difficultyLevels:Array = 
		[
			new DifficultyLevelData("Easy", 5, 5, 0.1),
			new DifficultyLevelData("Medium", 10, 10, 0.1),
			new DifficultyLevelData("Hard", 15, 15, 0.1)
		];
	}

}