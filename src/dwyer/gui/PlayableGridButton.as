package dwyer.gui 
{
	import starling.display.Button;
	import starling.events.Event;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Mike Dwyer
	 */
	public class PlayableGridButton extends Button
	{
		private var column:int;
		public function get gridColumn():int { return this.column };
		
		private var row:int;
		public function get gridRow():int { return this.row};
		
		/**
		 * CONSTRUCTOR
		 * @param	xGridPos The X grid position of this button (0, gridWidth]
		 * @param	yGridPos The Y grid position of this button (0, gridHeight]
		 */
		public function PlayableGridButton(xGridPos:int, yGridPos:int, upState:Texture, text:String = "", downState:Texture = null)
		{
			super(upState, text, downState);
			
			this.column = xGridPos;
			this.row = yGridPos;
		}
	}

}