package dwyer.gameplay 
{
	/**
	 * This class holds the data associated with each difficulty level that the user can select
	 * @author Mike Dwyer
	 */
	public class DifficultyLevelData 
	{
		private var gridWidth:int;
		private var gridHeight:int;
		
		///This is the average density of mines in the grid. Each spot will have this chance to be a mine.
		private var mineDensity:Number;
		
		private var difficultyName:String;

		/**
		 * CONSTRUCTOR
		 * @param	name The name of this difficulty level (user facing)
		 * @param	width The number of columns in the grid for this difficulty
		 * @param	height The number of rows in the grid for this difficulty
		 * @param	mineDensity The average percent of grid spaces taken up by mines
		 */
		public function DifficultyLevelData(name:String, width:int, height:int, mineDensity:Number) 
		{
			this.difficultyName = name;
			this.gridWidth = width;
			this.gridHeight = height;
			this.mineDensity = mineDensity;
		}
		
		/************************************************************************************************************************/
		/* PUBLIC FUNCTIONS																										*
		 ************************************************************************************************************************/
		
		public function getName():String 
		{
			return this.difficultyName;
		}
		
		public function getGridHeight():int 
		{
			return this.gridHeight;
		}
		
		public function getGridWidth():int 
		{
			return this.gridWidth;
		}
		
		public function getMineDensity():Number 
		{
			return this.mineDensity;
		}
		
	}

}