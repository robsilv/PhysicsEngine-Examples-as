package {
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	import nape.space.Space;
	import nape.util.BitmapDebug;
	import nape.util.Debug;
	
	[SWF(width='640', height='360', backgroundColor='#292C2C', frameRate='30')]
	public class DrawBox extends Sprite {
		
		private var space:Space;
		private var debug:Debug;
		
		public function DrawBox():void {
			
			var w:int = stage.stageWidth;
			var h:int = stage.stageHeight;
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);

			// Create a new simulation Space.
			var gravity:Vec2 = Vec2.weak(0, 600);
			space = new Space(gravity);
			
			// Create a new BitmapDebug screen
			debug = new BitmapDebug(stage.stageWidth, stage.stageHeight, stage.color);
			addChild(debug.display);
			
			// Create Floor
			var floor:Body = new Body(BodyType.STATIC);
			floor.shapes.add(new Polygon(Polygon.rect(0, (h - 20), w, 30)));
			floor.space = space;
			
			// Create Box
			var box:Body = new Body(BodyType.DYNAMIC);
			box.shapes.add(new Polygon(Polygon.box(60, 80)));
			box.position.setxy((w / 2), 0);
			box.space = space;
		}
		
		private function enterFrameHandler(ev:Event):void {
			// Step forward in simulation by the required number of seconds.
			space.step(1 / stage.frameRate);
			
			// Render Space to the debug draw.
			debug.clear();
			debug.draw(space);
			debug.flush();
		}
	}
}
