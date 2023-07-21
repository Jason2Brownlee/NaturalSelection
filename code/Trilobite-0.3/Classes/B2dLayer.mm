//
//  B2dLayer.m
//  Trilobite
//
// Responsible for running a Box2D based world
//

#import "B2dLayer.h"


// private interface
@interface B2dLayer() 

b2World *m_b2d_world;

// mouse fun
b2MouseJoint* m_mouseJoint;
b2Vec2 m_mouseWorld;

// joint testing
b2RevoluteJoint* m_globalJoint;

// testing
-(b2Body*)makeBlock:(b2BodyDef)blockDef shapeDef:(b2PolygonDef)shapeDef;
-(void) DrawShape:(b2Shape*)shape xf:(const b2XForm&)xf color:(const b2Color&)color core:(bool)core;
-(void) DrawSolidPolygon:(const b2Vec2*)vertices vertexCount:(int32)vertexCount color:(const b2Color&)color;
- (void) DrawPoint:(const b2Vec2&)p size:(float32)size color:(const b2Color&)color;
- (void) DrawSegment:(const b2Vec2&)p1 p2:(const b2Vec2&)p2 color:(const b2Color&)color;

-(void) makeEnvironment;
-(void) makeCreature;
-(void) updateCreatureBrain;
@end


@implementation B2dLayer 

@synthesize drawingWasInit;


- (id) init {
	if( ! (self=[super init]) ) {
		return nil;
	}
	
	// layer cfg
	isTouchEnabled = YES;
	
	// ivar cfg
	m_mouseJoint = NULL;
	m_b2d_world = NULL;
	
	// create a default world
	[self createDefaultWorld];
	[self helloWorld];
	 
	[self schedule:@selector(tick:)]; 

	
	return self;
}


-(void) onEnter {
	[super onEnter];
}

-(void) draw {
	[super draw];
	
	if(!self.drawingWasInit) {
		self.drawingWasInit = YES;
		[self initializeDrawing];
	}
	
	// HACK HACK HACK - should be using cocos2d hierarchy
	
	// based on drawing code from world debug drawing routines
	
	// process all bodies
	for (b2Body* b = m_b2d_world->GetBodyList(); b; b = b->GetNext())
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
	
	// process all joints
	for (b2Joint* joint = m_b2d_world->GetJointList(); joint; joint = joint->GetNext())
	{
		if(joint->GetType() == e_mouseJoint)
		{
			continue;
		}		
		
		b2Body* b1 = joint->GetBody1();
		b2Body* b2 = joint->GetBody2();
		const b2XForm& xf1 = b1->GetXForm();
		const b2XForm& xf2 = b2->GetXForm();
		b2Vec2 x1 = xf1.position;
		b2Vec2 x2 = xf2.position;
		b2Vec2 p1 = joint->GetAnchor1();
		b2Vec2 p2 = joint->GetAnchor2();
		
		
		// default
		b2Color jointColor = b2Color(0.5f, 0.8f, 0.8f);
		[self DrawSegment:x1 p2:p1 color:jointColor];
		[self DrawSegment:p1 p2:p2 color:jointColor];
		[self DrawSegment:x2 p2:p2 color:jointColor];
	}
	
	if (m_mouseJoint)
	{
		b2Body* body = m_mouseJoint->GetBody2();
		b2Vec2 p1 = body->GetWorldPoint(m_mouseJoint->m_localAnchor);
		b2Vec2 p2 = m_mouseJoint->m_target;
		
		[self DrawSegment:p1 p2:p2 color:b2Color(0.8f,0.8f,0.8f)];

		[self DrawPoint:p1 size:4 color:b2Color(0,1,0)];
		[self DrawPoint:p2 size:4 color:b2Color(0,1,0)];
	}
}

-(void)initializeDrawing {

	// do these do anything? TEST
	
	glEnable(GL_LINE_SMOOTH);
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glHint(GL_LINE_SMOOTH_HINT, GL_DONT_CARE);	

}

-(void)tick: (ccTime)deltaTime {
	// one tick of the simulation
	[self stepSimulation:deltaTime];
}

-(void) dealloc{
	// deallocate this first, then super	
	free(m_b2d_world);
	
	[super dealloc];
}


-(void) stepSimulation:(ccTime)deltaTime
{	
	// settings
	//float32 timeStep = 1.0f / 30.0f; // 60 hz is good
	int32 velocityIterations = 8; // 10 is good
	int32 positionIterations = 6; // 8 is good
	
	// Take a time step. This performs collision detection, integration, and constraint solution
	m_b2d_world->Step(deltaTime, velocityIterations, positionIterations);
	// validate internal structures
	//m_b2d_world->Validate();
	
	[self updateCreatureBrain];
}

-(void) createDefaultWorld {
	CGSize s = [[Director sharedDirector] winSize];
	
	b2AABB m_worldAABB;	
	// Define the size of the world. Simulation will still work
	// if bodies reach the end of the world, but it will be slower.	
	m_worldAABB.lowerBound.Set(0.0f,0.0f);
	m_worldAABB.upperBound.Set(s.width, s.height);	
	// Define the gravity vector.
	b2Vec2 gravity(0.0f, -10.0f);
	// Do we want to let bodies sleep?
	bool doSleep = true;	
	// Construct a world object, which will hold and simulate the rigid bodies.
	m_b2d_world = new b2World(m_worldAABB, gravity, doSleep);	
}

-(b2Body*)makeBlock:(b2BodyDef)blockDef shapeDef:(b2PolygonDef)shapeDef {
	b2Body* block = m_b2d_world->CreateBody(&blockDef);
	block->CreateShape(&shapeDef);
	// add to world?
	return block;
}




-(void) makeEnvironment {
	//
	// a simple box world
	// todo: make floor thicker than all other walls
	//
	
	CGSize size = [[Director sharedDirector] winSize];	
	float32 wall = 6.0f;
	
	// roof
	b2BodyDef roofBodyDef;
	roofBodyDef.position.Set(size.width/2.0f, size.height-(wall/2.0f)); // center of shape
	b2PolygonDef roofShapeDef;
	roofShapeDef.SetAsBox(size.width/2.0f, wall/2.0f); // box from origin
	[self makeBlock:roofBodyDef shapeDef:roofShapeDef];
	
	// floor
	b2BodyDef floorBodyDef;
	floorBodyDef.position.Set(size.width/2.0f, wall/2.0f); // center of shape
	b2PolygonDef floorShapeDef;
	floorShapeDef.SetAsBox(size.width/2.0f, wall/2.0f); // box from origin
	[self makeBlock:floorBodyDef shapeDef:floorShapeDef];
	
	// left wall
	b2BodyDef lwallBodyDef;
	lwallBodyDef.position.Set(wall/2.0f, size.height/2.0f); // center of shape
	b2PolygonDef lwallShapeDef;
	lwallShapeDef.SetAsBox(wall/2.0f, (size.height/2.0f)-wall); // box from origin
	[self makeBlock:lwallBodyDef shapeDef:lwallShapeDef];
	
	// right wall
	b2BodyDef rwallBodyDef;
	rwallBodyDef.position.Set(size.width-(wall/2.0f), size.height/2.0f); // center of shape
	b2PolygonDef rwallShapeDef;
	rwallShapeDef.SetAsBox(wall/2.0f, (size.height/2.0f)-wall); // box from origin
	[self makeBlock:rwallBodyDef shapeDef:rwallShapeDef];
}


-(void) makeCreature {
	
	// dynamic body 1
	b2BodyDef bodyDef1;
	bodyDef1.position.Set(160.0f, 120.0f);
	// dynamic shape
	b2PolygonDef shapeDef1;
	shapeDef1.SetAsBox(10.0f, 10.0f);
	shapeDef1.density = 1.0f; // Set the box density to be non-zero, so it will be dynamic.
	shapeDef1.friction = 0.3f; // Override the default friction.
	b2Body* dynamicBlock1 = [self makeBlock:bodyDef1 shapeDef:shapeDef1];
	dynamicBlock1->SetMassFromShapes(); //Now tell the dynamic body to compute it's mass properties base on its shape.	
	
	// dynamic body 2
	b2BodyDef bodyDef2;
	bodyDef2.position.Set(145.0f, 115.0f);
	// dynamic shape
	b2PolygonDef shapeDef2;
	shapeDef2.SetAsBox(5.0f, 5.0f);
	shapeDef2.density = 1.0f; // Set the box density to be non-zero, so it will be dynamic.
	shapeDef2.friction = 0.3f; // Override the default friction.
	b2Body* dynamicBlock2 = [self makeBlock:bodyDef2 shapeDef:shapeDef2];
	dynamicBlock2->SetMassFromShapes(); //Now tell the dynamic body to compute it's mass properties base on its shape.
	
	// joint between two bodies
	b2RevoluteJointDef jointDef;
	b2Vec2 joinPos = b2Vec2(150, 115);
	jointDef.Initialize(dynamicBlock1, dynamicBlock2, joinPos);
	jointDef.lowerAngle = -0.5f * b2_pi; // -90 degrees
	jointDef.upperAngle = 0.5f * b2_pi; // +90 degrees
	jointDef.enableLimit = true;
	jointDef.maxMotorTorque = 1000000.0f; //10000000
	jointDef.motorSpeed = 5.0f;
	jointDef.enableMotor = true;	
	//jointDef.referenceAngle = 0;
	m_globalJoint = (b2RevoluteJoint*) m_b2d_world->CreateJoint(&jointDef);
}

-(void) updateCreatureBrain {
	
	float32 angle = m_globalJoint->GetJointAngle();	
	if(angle<=m_globalJoint->GetLowerLimit())
	{
		// reverse motor
		m_globalJoint->SetMotorSpeed(-m_globalJoint->GetMotorSpeed()); // forward
	}
	else if(angle>=m_globalJoint->GetUpperLimit())
	{
		// reverse motor
		m_globalJoint->SetMotorSpeed(-m_globalJoint->GetMotorSpeed()); // backward
	}
	
	// the the body this joint belongs to
	b2Body *body = m_globalJoint->GetBody2();
	
}

// HACK HACK HACK - should be external
// should be using B2dBlock's
-(void) helloWorld {
	// env
	[self makeEnvironment];
	// creature
	[self makeCreature];
}



-(void) DrawShape:(b2Shape*)shape xf:(const b2XForm&)xf color:(const b2Color&)color core:(bool)core
{

	
	switch (shape->GetType())
	{
			// others...
			
		case e_polygonShape:
		{
			b2PolygonShape* poly = (b2PolygonShape*)shape;
			int32 vertexCount = poly->GetVertexCount();
			const b2Vec2* localVertices = poly->GetVertices();
			
			b2Assert(vertexCount <= b2_maxPolygonVertices);
			b2Vec2 vertices[b2_maxPolygonVertices];
			
			for (int32 i = 0; i < vertexCount; ++i)
			{
				vertices[i] = b2Mul(xf, localVertices[i]);
			}			
			[self DrawSolidPolygon:vertices vertexCount:vertexCount color:color];			
		}
		break;						
	}
}



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


- (void) DrawSegment:(const b2Vec2&)p1 p2:(const b2Vec2&)p2 color:(const b2Color&)color
{	
	glEnableClientState(GL_VERTEX_ARRAY);
	
	glColor4f(color.r, color.g, color.b,1);
	GLfloat glVertices[] = {p1.x,p1.y,p2.x,p2.y};
	glVertexPointer(2, GL_FLOAT, 0, glVertices);
	glDrawArrays(GL_LINES, 0, 2);
	
	glDisableClientState(GL_VERTEX_ARRAY);
}

- (void) DrawPoint:(const b2Vec2&)p size:(float32)size color:(const b2Color&)color
{
	glEnableClientState(GL_VERTEX_ARRAY);
	
	glColor4f(color.r, color.g, color.b,1);
	glPointSize(size);
	GLfloat glVertices[] = {p.x,p.y};
	glVertexPointer(2, GL_FLOAT, 0, glVertices);
	glDrawArrays(GL_POINTS, 0, 1);
	glPointSize(1.0f);
	
	glDisableClientState(GL_VERTEX_ARRAY);
}


// mouse touching
- (BOOL)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
		
	for (UITouch *touch in touches)
	{
		CGSize s = [[Director sharedDirector] winSize];
		CGPoint touchLocation = [touch locationInView: [touch view]];
		b2Vec2 p = b2Vec2(touchLocation.x,s.height-touchLocation.y);
		
		m_mouseWorld = p;
		
		// check if already connected
		if (m_mouseJoint != NULL)
		{
			return kEventHandled;
			//continue;
		}
		
		// Make a small box.
		b2AABB aabb;
		b2Vec2 d;
		d.Set(0.001f, 0.001f);
		aabb.lowerBound = p - d;
		aabb.upperBound = p + d;
		
		// Query the world for overlapping shapes.
		const int32 k_maxCount = 10;
		b2Shape* shapes[k_maxCount];
		int32 count = m_b2d_world->Query(aabb, shapes, k_maxCount);
		b2Body* body = NULL;
		for (int32 i = 0; i < count; ++i)
		{
			b2Body* shapeBody = shapes[i]->GetBody();
			if (shapeBody->IsStatic() == false && shapeBody->GetMass() > 0.0f)
			{
				bool inside = shapes[i]->TestPoint(shapeBody->GetXForm(), p);
				if (inside)
				{
					body = shapes[i]->GetBody();
					break;
				}
			}
		}
		
		if (body)
		{
			b2MouseJointDef md;
			md.body1 = m_b2d_world->GetGroundBody();
			md.body2 = body;
			md.target = p;
#ifdef TARGET_FLOAT32_IS_FIXED
			md.maxForce = (body->GetMass() < 16.0)? 
			(1000.0f * body->GetMass()) : float32(16000.0);
#else
			md.maxForce = 1000.0f * body->GetMass();
#endif
			m_mouseJoint = (b2MouseJoint*)m_b2d_world->CreateJoint(&md);
			body->WakeUp();
		}
		
	}	
	
	return kEventHandled;
}

- (BOOL)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
	// move the joint position
	for (UITouch *touch in touches)
	{
		CGSize s = [[Director sharedDirector] winSize];
		CGPoint touchLocation = [touch locationInView: [touch view]];				
		b2Vec2 pos = b2Vec2(touchLocation.x,s.height-touchLocation.y);
		
		m_mouseWorld = pos;
		
		if (m_mouseJoint)
		{
			m_mouseJoint->SetTarget(pos);
		}
	}
	
	return kEventHandled;
}

- (BOOL)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	
	// release whatever is been held
	if (m_mouseJoint)
	{
		m_b2d_world->DestroyJoint(m_mouseJoint);
		m_mouseJoint = NULL;
	}
	return kEventHandled;
}



@end
