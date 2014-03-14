package dwyer.gui 
{
	import dwyer.designData.GamePlayModes;
	import dwyer.gameplay.DifficultyLevelData;
	import dwyer.MSPGame;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Mike Dwyer
	 */
	public class DifficultySelectionScene extends Sprite
	{		
		private const Y_PADDING_BETWEEN_BUTTONS:int = 10;		
		private const BUTTON_TEXTURE_NAME:String = "button_medium";

		/**
		 * CONSTRUCTOR
		 */
		public function DifficultySelectionScene() 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, setupDifficultyButtons);
		}
		
		/************************************************************************************************************************/
		/* PRIVATE FUNCTIONS																										*
		 ************************************************************************************************************************/
		
		private function setupDifficultyButtons():void
		{
            this.removeEventListener(Event.ADDED_TO_STAGE, setupDifficultyButtons);
			
			var buttonTexture:Texture = MSPGame.assets.getTexture(BUTTON_TEXTURE_NAME);
	
			var iCumulativeYPos:int = 0;
            for each (var difficultyLevel:DifficultyLevelData in GamePlayModes.difficultyLevels)
            {
                var button:DifficultySelectionButton = new DifficultySelectionButton(difficultyLevel, buttonTexture, difficultyLevel.getName());
                button.x = 0;
                button.y = iCumulativeYPos;
				iCumulativeYPos += button.height + Y_PADDING_BETWEEN_BUTTONS;
				
                this.addChild(button);
            }
		}
		
		private function onSelectionCompleteCallback(difficultySelected:DifficultyLevelData):void
		{
			MSPGame.instance.showDifficultySelectionScene();
		}
	}

}