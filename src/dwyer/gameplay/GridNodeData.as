package dwyer.gameplay 
{
	/**
	 * This is the data storage class for each node in the grid. Any node can either be a mine or not a mine, revealed or not revealed and
	 * flagged or not flagged.
	 * @author Mike Dwyer
	 */
	public class GridNodeData 
	{
		private var isNodeMine:Boolean;
		
		public function get isMine():Boolean { return this.isNodeMine; }
		
		private var isNodeRevealed:Boolean = false;
		public function get isRevealed():Boolean { return this.isNodeRevealed; }
		public function set isRevealed(value:Boolean):void { this.isNodeRevealed = value; }
		
		private var isNodeFlagged:Boolean = false;
		public function get isFlagged():Boolean { return this.isNodeFlagged; }
		public function set isFlagged(value:Boolean):void { this.isNodeFlagged = value; }
		
		public function GridNodeData(isMine:Boolean) 
		{
			this.isNodeMine = isMine;
		}
	}

}