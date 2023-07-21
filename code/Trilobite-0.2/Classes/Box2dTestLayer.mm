//
//  Box2dTestLayer.m
//  Trilobite
//
// - Added openGL based on 'cocos2d chipmunk demo' (then removed it)
// - Used drawing code in 'cocos2d chipmunk demo' as basis for drawing
// - devised box2d world management based on 'hello world' (xcode port) and box2d iphone port examples (Test class)
// - Discussion of integrating Box2d into iphone project: http://www.box2d.org/forum/viewtopic.php?f=7&t=1283
//


#import "Box2dTestLayer.h"
#import "Box2D.h"

// private interface
@interface Box2dTestLayer() 
	// HACK HACK HACK - because i cannot get Box2D.h too work in the header file
	b2World *m_world;

-(void) DrawShape:(b2Shape*)shape xf:(const b2XForm&)xf color:(const b2Color&)color core:(bool)core;
-(void) DrawSolidPolygon:(const b2Vec2*)vertices vertexCount:(int32)vertexCount color:(const b2Color&)color;

@end


// TODO - install physics into cocos 2d nodes
@implementation Box2dTestLayer
- (id) init {
    self = [super init];
    if (self != nil) {
		// initialize the physics engine
		[self createWorld];
		[self createSimulation];
		// schedule the simulation method
		[self schedule: @selector(step)];
		NSLog(@"prepared world and simulation");
    }
    return self;
}

-(void) onEnter
{
	[super onEnter];
	
	float factor = 1.0f;
	
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	glOrthof(-320/factor, 320/factor, -480/factor, 480/factor, -1.0f, 1.0f);
	
	if( [[Director sharedDirector] landscape] ) {
		glTranslatef(0.5f, -480.5f, 0.0f); // landscape
	}
	
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	
	glPointSize(3.0f);
    glEnable(GL_LINE_SMOOTH);
	glEnable(GL_POINT_SMOOTH);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glHint(GL_LINE_SMOOTH_HINT, GL_DONT_CARE);
    glHint(GL_POINT_SMOOTH_HINT, GL_DONT_CARE);
    glLineWidth(1.5f);
}

-(void) createWorld
{
	b2AABB m_worldAABB;	
	// Define the size of the world. Simulation will still work
	// if bodies reach the end of the world, but it will be slower.
	m_worldAABB.lowerBound.Set(-100.0f, -100.0f);
	m_worldAABB.upperBound.Set(100.0f, 100.0f);	
	// Define the gravity vector.
	b2Vec2 gravity(0.0f, -10.0f);
	// Do we want to let bodies sleep?
	bool doSleep = true;	
	// Construct a world object, which will hold and simulate the rigid bodies.
	m_world = new b2World(m_worldAABB, gravity, doSleep);	
}

- (void) createSimulation
{
	// Define the ground body.
	b2BodyDef groundBodyDef;
	groundBodyDef.position.Set(0.0f, -10.0f);
	
	// Call the body factory which allocates memory for the ground body
	// from a pool and creates the ground box shape (also from a pool).
	// The body is also added to the world.
	b2Body* groundBody = m_world->CreateBody(&groundBodyDef);
	
	// Define the ground box shape.
	b2PolygonDef groundShapeDef;
	
	// The extents are the half-widths of the box.
	groundShapeDef.SetAsBox(50.0f, 10.0f);
	
	// Add the ground shape to the ground body.
	groundBody->CreateShape(&groundShapeDef);
	
	// Define the dynamic body. We set its position and call the body factory.
	b2BodyDef bodyDef;
	bodyDef.position.Set(0.0f, 4.0f);
	b2Body* body = m_world->CreateBody(&bodyDef);
	
	// Define another box shape for our dynamic body.
	b2PolygonDef shapeDef;
	shapeDef.SetAsBox(1.0f, 1.0f);
	
	// Set the box density to be non-zero, so it will be dynamic.
	shapeDef.density = 1.0f;
	
	// Override the default friction.
	shapeDef.friction = 0.3f;
	
	// Add the shape to the body.
	body->CreateShape(&shapeDef);
	
	// Now tell the dynamic body to compute it's mass properties base
	// on its shape.
	body->SetMassFromShapes();	
}


// based on DrawDebugData in b2world
-(void) draw
{
	glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
	
	// process all bodies
	for (b2Body* b = m_world->GetBodyList(); b; b = b->GetNext())
	{
		// process all shapes
		const b2XForm& xf = b->GetXForm();
		for (b2Shape* s = b->GetShapeList(); s; s = s->GetNext())
		{
			if (b->IsStatic())
			{
				//DrawShape(s, xf, b2Color(0.5f, 0.9f, 0.5f), false);
				[self DrawShape:s xf:xf color:b2Color(0.5f, 0.9f, 0.5f) core:false];
			}
			else if (b->IsSleeping())
			{
				//DrawShape(s, xf, b2Color(0.5f, 0.5f, 0.9f), false);
				[self DrawShape:s xf:xf color:b2Color(0.5f, 0.5f, 0.9f) core:false];
			}
			else
			{
				//DrawShape(s, xf, b2Color(0.9f, 0.9f, 0.9f), false);
				[self DrawShape:s xf:xf color:b2Color(0.9f, 0.9f, 0.9f) core:false];
			}
		}
	}
	
	// draw joins / controllers ?
}

-(void) DrawShape:(b2Shape*)shape xf:(const b2XForm&)xf color:(const b2Color&)color core:(bool)core
//void Box2dTestLayer::DrawShape(b2Shape* shape, const b2XForm& xf, const b2Color& color, bool core)
{
	b2Color coreColor(0.9f, 0.6f, 0.6f);
	
	switch (shape->GetType())
	{
			
		case e_circleShape:
		{
			/*
			b2CircleShape* circle = (b2CircleShape*)shape;
			
			b2Vec2 center = b2Mul(xf, circle->GetLocalPosition());
			float32 radius = circle->GetRadius();
			b2Vec2 axis = xf.R.col1;
			
			m_debugDraw->DrawSolidCircle(center, radius, axis, color);
			
			if (core)
			{
				m_debugDraw->DrawCircle(center, radius - b2_toiSlop, coreColor);
			}
			 */
			NSLog(@"draw circle");
		}
		break;
			
			
		case e_polygonShape:
		{
			b2PolygonShape* poly = (b2PolygonShape*)shape;
			int32 vertexCount = poly->GetVertexCount();
			const b2Vec2* localVertices = poly->GetVertices();
			
			b2Assert(vertexCount <= b2_maxPolygonVertices);
			b2Vec2 vertices[b2_maxPolygonVertices];
			//float vertices[b2_maxPolygonVertices];
			
			for (int32 i = 0; i < vertexCount; ++i)
			{
				vertices[i] = b2Mul(xf, localVertices[i]);
				/*
				b2Vec2 v = b2Mul(xf, localVertices[i]);
				vertices[i] = v.x;
				i++;
				vertices[i] = v.y;
				 */
			}
			
			//DrawSolidPolygon(vertices, vertexCount, color);
			[self DrawSolidPolygon:vertices vertexCount:vertexCount color:color];
			
			//drawPoly( vertices, b2_maxPolygonVertices);
			
			
			
			/*
			if (core)
			{
				const b2Vec2* localCoreVertices = poly->GetCoreVertices();
				for (int32 i = 0; i < vertexCount; ++i)
				{
					vertices[i] = b2Mul(xf, localCoreVertices[i]);
				}
				m_debugDraw->DrawPolygon(vertices, vertexCount, coreColor);
			}
			*/
		}
		break;
			
			
		case e_edgeShape:
		{
			/*
			b2EdgeShape* edge = (b2EdgeShape*)shape;
			
			m_debugDraw->DrawSegment(b2Mul(xf, edge->GetVertex1()), b2Mul(xf, edge->GetVertex2()), color);
			
			if (core)
			{
				m_debugDraw->DrawSegment(b2Mul(xf, edge->GetCoreVertex1()), b2Mul(xf, edge->GetCoreVertex2()), coreColor);
			}
			*/
			NSLog(@"draw other");
		}
		break;
			 
	}
}


//void GLESDebugDraw::DrawSolidPolygon(const b2Vec2* vertices, int32 vertexCount, const b2Color& color)
-(void) DrawSolidPolygon:(const b2Vec2*)vertices vertexCount:(int32)vertexCount color:(const b2Color&)color
{
	glEnableClientState(GL_VERTEX_ARRAY);
	
	glVertexPointer(2, GL_FLOAT, 0, vertices);
	
	// fill
	glColor4f(color.r, color.g, color.b,0.5f);
	glDrawArrays(GL_TRIANGLE_FAN, 0, vertexCount);
	
	// line
	glColor4f(color.r, color.g, color.b,1);
	glDrawArrays(GL_LINE_LOOP, 0, vertexCount);

	
	glDisableClientState(GL_VERTEX_ARRAY);
}



-(void) step
{
	//NSLog(@"executing time step");
	
	// settings
	float32 timeStep = 1.0f / 30.0f; // 60 hz is good
	int32 velocityIterations = 5; // 10 is good
	int32 positionIterations = 1;
	
	// Take a time step. This performs collision detection, integration, and constraint solution
	m_world->Step(timeStep, velocityIterations, positionIterations);
	// validate internal structures
	m_world->Validate();
}

@end

