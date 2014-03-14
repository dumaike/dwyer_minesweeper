package dwyer
{
    import flash.display.Sprite;
    import flash.system.Capabilities;
    
    import starling.core.Starling;
    import starling.events.Event;
    import starling.textures.Texture;
    import starling.utils.AssetManager;
 
    [SWF(width = "800", height = "800", frameRate = "60", backgroundColor = "#222222")]
	/**
	 * The document class that is an entry point for our game. Mostly I just ripped this from the starling demo and culled a lot of 
	 * things that weren't required
	 */
    public class MSPDocument extends Sprite
    {
        private var mStarling:Starling;
        
        public function MSPDocument()
        {
            if (stage) 
				start();
            else 
				addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        }
        
        private function start():void
        {
            Starling.handleLostContext = true; // required on Windows, needs more memory
            
            mStarling = new Starling(MSPGame, stage);
            mStarling.enableErrorChecking = Capabilities.isDebugger;
            mStarling.start();
            
            // this event is dispatched when stage3D is set up
            mStarling.addEventListener(Event.ROOT_CREATED, onRootCreated);
        }
        
        private function onAddedToStage(event:Object):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            start();
        }
        
        private function onRootCreated(event:Event, game:MSPGame):void
        {
            // define which resources to load
            var assets:AssetManager = new AssetManager();
            assets.verbose = Capabilities.isDebugger;
            assets.enqueue(EmbeddedAssets);
        
            // game will first load resources, then start menu
            game.start(assets);
        }
    }
}