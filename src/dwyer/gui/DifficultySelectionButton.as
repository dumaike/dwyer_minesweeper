package dwyer.gui
{
	import dwyer.gameplay.DifficultyLevelData;
	import dwyer.MSPGame;
	import flash.display.DisplayObject;
	import starling.display.Button;
	import starling.display.Stage;
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * A button to allow the user to select a difficulty to play
	 * @author Mike Dwyer
	 */
	public class DifficultySelectionButton extends Button
	{
		private var difficultyToCreate:DifficultyLevelData
		
		/**
		 * CONSTRUCTOR
		 * @param	difficulty The difficulty of the level this button will create
		 */
		public function DifficultySelectionButton(difficulty:DifficultyLevelData, upState:Texture, text:String = "", downState:Texture = null)
		{
			super(upState, text, downState);
			
			this.difficultyToCreate = difficulty;
			
			this.addEventListener(Event.TRIGGERED, onDifficultySelected);
		}
		
		/************************************************************************************************************************/
		/* PRIVATE FUNCTIONS																										*
		 ************************************************************************************************************************/
		
		private function onDifficultySelected():void
		{
			this.removeEventListener(Event.TRIGGERED, onDifficultySelected);
			
			MSPGame.instance.showPlayableGridScene(difficultyToCreate);
		}
	}

}