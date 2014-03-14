package dwyer 
{
	import dwyer.designData.GamePlayModes;
	import dwyer.gameplay.DifficultyLevelData;
	import dwyer.gui.DifficultySelectionScene;
	import dwyer.gui.GameOverDialog;
	import dwyer.gui.PlayableGridScene;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Sprite;
    import starling.textures.Texture;
    import starling.utils.AssetManager;
	
	/**
	 * The game class that kicks off all the game logic. Also being used as a rudamentary scene/dialog manager.
	 * @author Mike Dwyer
	 */
	public class MSPGame extends Sprite
	{		
        private static var sAssets:AssetManager;
		
		private static var _instance:MSPGame;
		
		///Used for loading the previously loaded difficulty again in the "reset" condition, where we don't go through the
		///DifficultySelectionScene
		private var lastDifficulty:DifficultyLevelData;
		
		/**
		 * CONSTRUCTOR
		 */
		public function MSPGame() 
		{
			_instance = this;
		}
				
		/************************************************************************************************************************/
		/* PRIVATE FUNCTIONS																									*
		 ************************************************************************************************************************/
		
		/**
		 * A helper function used when transitioning between scenes
		 */
		private function clearPreviousScreen():void
		{
			while (this.numChildren > 0)
				this.removeChildAt(0);
		}	
		
		/************************************************************************************************************************/
		/* PUBLIC FUNCTIONS																										*
		 ************************************************************************************************************************/
		
        public static function get assets():AssetManager { return sAssets; }
		
		public static function get instance():MSPGame {return _instance; }
				
		/**
		 * Called in initialization only once by the document. Loads the first scene when assets are done loading
		 * @param	assets
		 */
		public function start(assets:AssetManager):void
        {
            sAssets = assets;
			            
			assets.loadQueue(function(ratio:Number):void
            {
               if (ratio == 1)
                    Starling.juggler.delayCall(function():void
                    {
                        showDifficultySelectionScene();
                    }, 0.15);
            });
		}
		
		/**
		 * Shows the difficulty selection scene
		 */
		public function showDifficultySelectionScene():void
		{			
			clearPreviousScreen();
				
			var difficultySelectionScene:DifficultySelectionScene = new DifficultySelectionScene();
            addChild(difficultySelectionScene);
		}
		
		/**
		 * Shows a playable grid scene. If no difficulty is passed, loads the previous difficulty. If there was no previous
		 * difficulty, it complains.
		 * @param	difficultyLevel
		 */
		public function showPlayableGridScene(difficultyLevel:DifficultyLevelData = null):void
		{			
			clearPreviousScreen();
			
			if (difficultyLevel != null)
				this.lastDifficulty = difficultyLevel;
				
			if (this.lastDifficulty == null)
			{
				throw Error("Trying to load a playable grid without having any difficulty. Defaulting to lowest difficulty.");
				this.lastDifficulty = GamePlayModes.difficultyLevels[0];
			}
			
			var playableGridScene:PlayableGridScene = new PlayableGridScene(this.lastDifficulty);
            addChild(playableGridScene);
		}
		
		/**
		 * Shows the game over dialog.
		 * @param	won If the dialog is in a win state or lose state
		 */
		public function showGameOverDialog(won:Boolean):void
		{			
			var gameOverDialog:GameOverDialog = new GameOverDialog(won);
            addChild(gameOverDialog);
		}	
	}

}