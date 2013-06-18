package  {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	[SWF(width='640', height='360', backgroundColor='#292C2C', frameRate='30')]
	public class DrawBox extends Sprite {
		
		private var m_world:b2World;
		private var m_velocityIterations:int = 10;
		private var m_positionIterations:int = 10;
		private var m_timeStep:Number = 1.0/30.0;
		private var m_physScale:Number = 30;
		private var m_sprite:Sprite;
		
		public function DrawBox() {
			
			var w:int = stage.stageWidth;
			var h:int = stage.stageHeight;
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
			// Define the gravity vector
			var gravity:b2Vec2 = new b2Vec2(0.0, 10.0);
			
			// Allow bodies to sleep
			var doSleep:Boolean = true;
			
			// Construct a world object
			m_world = new b2World(gravity, doSleep);
			m_world.SetWarmStarting(true);

			// set debug draw
			m_sprite = new Sprite();
			addChild(m_sprite);
			
			var dbgDraw:b2DebugDraw = new b2DebugDraw();
			dbgDraw.SetSprite(m_sprite);
			dbgDraw.SetDrawScale(30.0);
			dbgDraw.SetFillAlpha(0.3);
			dbgDraw.SetLineThickness(1.0);
			dbgDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
			m_world.SetDebugDraw(dbgDraw);
			
			// Create Floor
			var shape:b2PolygonShape = new b2PolygonShape();
			var bodyDef:b2BodyDef = new b2BodyDef();
			var body:b2Body;
			
			shape.SetAsBox(680/m_physScale/2, 100/m_physScale);
			bodyDef.position.Set(w / m_physScale / 2, (h + 80) / m_physScale);
			body = m_world.CreateBody(bodyDef);
			body.CreateFixture2(shape);
			
			// Create Box
			shape = new b2PolygonShape();
			bodyDef = new b2BodyDef();
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			
			bodyDef.type = b2Body.b2_dynamicBody;
			body = m_world.CreateBody(bodyDef);
			
			shape.SetAsBox(30 / m_physScale, 40 / m_physScale);
			fixtureDef.shape = shape;
			bodyDef.position.Set(320 / m_physScale, 0 / m_physScale);
			body = m_world.CreateBody(bodyDef);
			body.CreateFixture(fixtureDef);
		}
		
		public function enterFrameHandler(e:Event):void
		{
			// clear for rendering
			m_sprite.graphics.clear();
			
			// Update physics
			var physStart:uint = getTimer();
			m_world.Step(m_timeStep, m_velocityIterations, m_positionIterations);
			m_world.ClearForces();
			
			// Render
			m_world.DrawDebugData();	
		}
	}
}

