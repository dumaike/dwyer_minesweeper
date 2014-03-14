package dwyer.gameplay 
{	
	import dwyer.gameplay.DifficultyLevelData;
	
	/**
	 * This is the information for the grid of nodes. Most of it is calculated on initialization.
	 * @author Mike Dwyer
	 */
	public class PlayableGridData 
	{
		//A 2D array for the nodes. If grids were much larger or we were very very tight on resources (and doing very small optimizations), then
		//I would turn this into a 1D array with 2D indexing.
		private var mineData:Array;
	
		/**
		 * CONSTRUCTOR
		 * @param	difficultyLevel The difficulty level of this grid
		 */
		public function PlayableGridData(difficultyLevel:DifficultyLevelData) 
		{
			this.mineData = new Array(difficultyLevel.getGridWidth());
			
			//Figure out which spaces are mines
			var iXIndex:int = 0;
			var iYIndex:int = 0;
			for (iXIndex = 0; iXIndex < difficultyLevel.getGridWidth(); ++iXIndex)
			{
				this.mineData[iXIndex] =  new Array(difficultyLevel.getGridHeight());
				
				for (iYIndex = 0; iYIndex < difficultyLevel.getGridHeight(); ++iYIndex)
				{
					var createdNodeData:GridNodeData = new GridNodeData(Math.random() < difficultyLevel.getMineDensity());
					this.mineData[iXIndex][iYIndex] = createdNodeData;
				}		
			}	
		}
		
		/************************************************************************************************************************/
		/* PUBLIC FUNCTIONS																										*
		 ************************************************************************************************************************/
		
		//Set a space to be revealed
		public function revealSpace(x:int, y:int):void
		{	
			getDataAtNode(x, y).isRevealed = true;
		}
				
		/**
		 * @return True if all the free spaces (not mines), have been revealed. This is most likely the win condition.
		 */
		public function areAllFreeSpacesRevealed():Boolean
		{
			for (var iXIndex:int = 0; iXIndex < this.mineData.length; ++iXIndex)
			{				
				var gridColumn:Array = this.mineData[iXIndex];
				
				for (var iYIndex:int = 0; iYIndex < gridColumn.length; ++iYIndex)
				{
					var foundNode:GridNodeData = getDataAtNode(iXIndex, iYIndex);
					if (!foundNode.isRevealed  && !foundNode.isMine)
						return false;
				}
			}
			
			return true;
		}
		
		/**
		 * Returns the data node at a grid position. Will safetly return non-mine and non-revealed nodes if asked for
		 * spaces outside the grid.
		 * @param	x - The X coordinate of the node
		 * @param	y - The Y coordinate of the node.
		 * @return The GridDataNode at the given coordinates
		 */
		public function getDataAtNode(x:int, y:int):GridNodeData
		{
			var returnNode:GridNodeData;
			
			//This node is off the map, and therefore not a mine or revealed
			if (x < 0 || x >= this.mineData.length || y < 0 || y >= this.mineData[x].length)
			{
				returnNode = new GridNodeData(false);
				return returnNode;
			}
				
			returnNode = this.mineData[x][y] as GridNodeData;
			
			if (returnNode == null)
			{
				trace("Something other than a node is being stored in the PlayableGridData");
				returnNode = new GridNodeData(false);
				return returnNode;
			}
			
			return returnNode;
		}
		
		/**
		 * Returns the number of mines adjacent to this space. This number will not change after the grid is generated, so I 
		 * considered calculating these numbers and storing them in the GridNodeData, but that increases the load time. Given
		 * our grid sizes, I think that it's better to distribute this proccess load as the user plays and clicks spaces
		 * @param	x - The X coordinate of the node
		 * @param	y - The Y coordinate of the node.
		 * @return A number representing the number of mints adjacent to this space
		 */
		public function getSpaceAdjacencyNumber(x:int, y:int):int
		{			
			return 	this.getDataAtNode(x + 1, y).isMine + 
					this.getDataAtNode(x, y + 1).isMine +  
					this.getDataAtNode(x - 1, y).isMine + 
					this.getDataAtNode(x, y - 1).isMine + 
					this.getDataAtNode(x + 1, y + 1).isMine + 
					this.getDataAtNode(x - 1, y - 1).isMine + 
					this.getDataAtNode(x + 1, y - 1).isMine + 
					this.getDataAtNode(x - 1, y + 1).isMine;
		}
		
	}

}