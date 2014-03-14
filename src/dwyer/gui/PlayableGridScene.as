package dwyer.gui 
{
	import dwyer.gameplay.DifficultyLevelData;
	import dwyer.gameplay.GridNodeData;
	import dwyer.gameplay.PlayableGridData;
	import dwyer.MSPGame;
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Mike Dwyer
	 */
	public class PlayableGridScene extends Sprite
	{
		private const DOWN_OFFSET_OF_GRID:int = 40;
		private const UNSELECTED_GRID_BUTTON_TEXTURE_NAME:String = "button_square";
		private const BACK_BUTTON_TEXTURE_NAME:String = "button_normal";
		
		//Text to show on buttons when they're revealed or flagged (or default)
		private const FLAGGED_TEXT:String = "F";
		private const MINE_TEXT:String = "M";
		private const DEFAULT_TEXT:String = "";
		
		private var difficultyOfGrid:DifficultyLevelData;
		
		///The data that represents the underlying grid state
		private var gridData:PlayableGridData;
		
		///The array of grid buttons, for removing buttons we didn't click through flood
		private var gridButtons:Array;
		
		///Used to tell if we're trying to reveal or flag a grid spot
		private var ctrlIsDown:Boolean = false;
		
		/**
		 * CONSTRUCTOR
		 * @param	difficulty The difficulty of the grid in this scene
		 */
		public function PlayableGridScene(difficulty:DifficultyLevelData) 
		{
			this.difficultyOfGrid = difficulty;
			
			this.gridData = new PlayableGridData(this.difficultyOfGrid);
			
			this.addEventListener(Event.ADDED_TO_STAGE, setupScene);
			this.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			this.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		/************************************************************************************************************************/
		/* PRIVATE FUNCTIONS																									*
		 ************************************************************************************************************************/
		
		private function onKeyDown(event:KeyboardEvent):void
		{
			if ( event.ctrlKey )
				ctrlIsDown = true;
		}
		
		private function onKeyUp(event:KeyboardEvent):void
		{
			if ( !event.ctrlKey )
				ctrlIsDown = false;
		}
		
		private function setupScene():void
		{
            this.removeEventListener(Event.ADDED_TO_STAGE, setupScene);
			
			this.createBackButton();
			this.layoutGridButtons();
		}
		
		private function createBackButton():void
		{
			var buttonTexture:Texture = MSPGame.assets.getTexture(BACK_BUTTON_TEXTURE_NAME);
			var backButton:Button = new Button(buttonTexture, "Back");
			backButton.addEventListener(Event.TRIGGERED, onBackButtonClicked);
			
			this.addChild(backButton);
		}
			
		private function layoutGridButtons():void
		{
			var buttonTexture:Texture = MSPGame.assets.getTexture(UNSELECTED_GRID_BUTTON_TEXTURE_NAME);
			
			var iCumulativeYPos:int = DOWN_OFFSET_OF_GRID;
			var iCumulativeXPos:int = 0;
			
			this.gridButtons = new Array(difficultyOfGrid.getGridWidth());
			for (var iXIndex:int = 0; iXIndex < difficultyOfGrid.getGridWidth(); ++iXIndex)
			{				
				this.gridButtons[iXIndex] = new Array(difficultyOfGrid.getGridHeight());
					
				var iButtonWidth:int;
				for (var iYIndex:int = 0; iYIndex < difficultyOfGrid.getGridHeight(); ++iYIndex)
				{
					var gridButton:PlayableGridButton = new PlayableGridButton(iXIndex, iYIndex, buttonTexture, DEFAULT_TEXT);
					gridButton.addEventListener(Event.TRIGGERED, onGridButtonClicked);
					this.addChild(gridButton);					
					
					this.gridButtons[iXIndex][iYIndex] = gridButton;
					
					gridButton.y = iCumulativeYPos;
					gridButton.x = iCumulativeXPos;
					
					iButtonWidth = gridButton.width;
					iCumulativeYPos += gridButton.height;					
				}
				
				iCumulativeYPos = DOWN_OFFSET_OF_GRID;
				iCumulativeXPos += iButtonWidth;
			}		
		}
		
		private function onGridButtonClicked(data:Event):void
		{	
			var clickedButton:PlayableGridButton = data.target as PlayableGridButton;
			var gridDataNode:GridNodeData = this.gridData.getDataAtNode(clickedButton.gridColumn, clickedButton.gridRow)
				
			if (this.ctrlIsDown)
			{
				if (!gridDataNode.isFlagged)
					clickedButton.text = FLAGGED_TEXT;
				else
					clickedButton.text = DEFAULT_TEXT;
				
				gridDataNode.isFlagged = !gridDataNode.isFlagged;
			}
			else
			{		
				//If we've flagged this button, we can't click it without unflagging it
				if (gridDataNode.isFlagged)
					return;
				
				clickedButton.removeEventListener(Event.TRIGGERED, onGridButtonClicked);
				
				if (gridDataNode.isMine)
				{
					clickedButton.text = MINE_TEXT;
					gameOver(false)
				}
				else
				{
					this.safeButtonReveal(clickedButton.gridColumn, clickedButton.gridRow);
					if (this.gridData.areAllFreeSpacesRevealed())
						gameOver(true);
				}
			}
		}
		
		private function gameOver(won:Boolean):void
		{
			for (var iXIndex:int = 0; iXIndex < difficultyOfGrid.getGridWidth(); ++iXIndex)
			{				
				for (var iYIndex:int = 0; iYIndex < difficultyOfGrid.getGridHeight(); ++iYIndex)
				{
					var gridButton:PlayableGridButton = this.gridButtons[iXIndex][iYIndex];
					gridButton.removeEventListener(Event.TRIGGERED, onGridButtonClicked);
				}
			}
			
			MSPGame.instance.showGameOverDialog(won);
		}
		
		private function safeButtonReveal(x:int, y:int):void
		{
			if (x < 0 || x >= this.gridButtons.length)
				return;
			if (y < 0 || y >= this.gridButtons[x].length)
				return;
			
			var clickedButton:PlayableGridButton = this.gridButtons[x][y] as PlayableGridButton;
			var gridDataNode:GridNodeData = this.gridData.getDataAtNode(clickedButton.gridColumn, clickedButton.gridRow)
			
			//Don't bother checking spaces that are already revealed or we'll get infinite recursion
			if (gridDataNode.isRevealed || gridDataNode.isFlagged)
				return;
			
			var adjacentMines:int = this.gridData.getSpaceAdjacencyNumber(x, y);
			clickedButton.text = adjacentMines.toString();
			
			gridDataNode.isRevealed = true;
			this.removeChild(clickedButton);
			
			//If there are no mines near this button, reveal spaces around it, otherwise change it to a number
			if (adjacentMines == 0)
			{	
				safeButtonReveal(x + 1, y);
				safeButtonReveal(x, y + 1);
				safeButtonReveal(x - 1, y);
				safeButtonReveal(x, y - 1);
				safeButtonReveal(x + 1, y + 1);
				safeButtonReveal(x - 1, y - 1);
				safeButtonReveal(x + 1, y - 1);
				safeButtonReveal(x - 1, y + 1);
			}
			else
			{
				//TODO clean this up
				var adjacentMinesTextField:TextField = new TextField(clickedButton.width, clickedButton.height, adjacentMines.toString(), 
					clickedButton.fontName, clickedButton.fontSize);
				adjacentMinesTextField.border = true;
				adjacentMinesTextField.color = 0xFFFFFF;
				addChild(adjacentMinesTextField);
				
				adjacentMinesTextField.x = clickedButton.x;
				adjacentMinesTextField.y = clickedButton.y;
			}
		}
		
		private function onBackButtonClicked():void
		{
			MSPGame.instance.showDifficultySelectionScene();
		}
		
	}

}