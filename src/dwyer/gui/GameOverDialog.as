package dwyer.gui 
{
	import dwyer.gameplay.PlayableGridData;
	import dwyer.MSPGame;
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	//TODO formal all functions to conform to a pattern private/public/etc
	//TODO comment all classes
	
	/**
	 * ...
	 * @author Mike Dwyer
	 */
	public class GameOverDialog extends Sprite
	{
		private const WON_GAME_STRING:String = "YOU WON! Play again?";
		private const LOST_GAME_STRING:String = "YOU LOST! Play again?";
		
		private const CHOICE_BUTTON_TEXTURE_NAME:String = "button_normal";
		
		private var finalString:String;
		
		/**
		 * CONTTRUCTOR
		 * @param	wonGame If the dialog is a win or lose dialog
		 */
		public function GameOverDialog(wonGame:Boolean) 
		{	
			if (wonGame)
				this.finalString = WON_GAME_STRING;
			else
				this.finalString = LOST_GAME_STRING;
			
			this.addEventListener(Event.ADDED_TO_STAGE, populateDialog);
		}
		
		/************************************************************************************************************************/
		/* PRIVATE FUNCTIONS																									*
		 ************************************************************************************************************************/
		
		private function populateDialog():void
		{
            this.removeEventListener(Event.ADDED_TO_STAGE, populateDialog);
			
			var promptFont:TextField = new TextField(stage.stageWidth/2, stage.stageHeight/2, finalString, "Ubuntu", 30);
            promptFont.border = true;
            promptFont.color = 0xFFFF00;
            addChild(promptFont);
			
			promptFont.x = stage.stageWidth / 4;
			promptFont.y = stage.stageHeight / 4;
			
			var buttonTexture:Texture = MSPGame.assets.getTexture(CHOICE_BUTTON_TEXTURE_NAME);
			
			var yesButton:Button = new Button(buttonTexture, "Yes");
			yesButton.addEventListener(Event.TRIGGERED, onYesButtonClicked);
			yesButton.y = stage.stageHeight / 1.4;
			yesButton.x = stage.stageWidth / 2 - yesButton.width;
			this.addChild(yesButton);
			
			var noButton:Button = new Button(buttonTexture, "No");
			noButton.addEventListener(Event.TRIGGERED, onNoButtonClicked);
			noButton.y = stage.stageHeight / 1.4;
			noButton.x = stage.stageWidth / 2 + noButton.width;
			this.addChild(noButton);
		}
		
		private function onYesButtonClicked(event:Event):void
		{
			var clickedButton:Button = event.target as Button;
			clickedButton.removeEventListener(Event.TRIGGERED, onYesButtonClicked);
			
			MSPGame.instance.showPlayableGridScene();
		}
		
		private function onNoButtonClicked(event:Event):void
		{
			var clickedButton:Button = event.target as Button;
			clickedButton.removeEventListener(Event.TRIGGERED, onNoButtonClicked);
			
			//Destroy this dialog
			this.parent.removeChild(this);
		}
		
	}

}