//
//  B2dLayer.m
//  Trilobite
//
// Responsible for running a Box2D based world
//

#import "B2dLayer.h"



// private interface
@interface B2dLayer() 
// mouse fun
b2MouseJoint* m_mouseJoint;
b2Vec2 m_mouseWorld;

- (void) DrawPoint:(const b2Vec2&)p size:(float32)size color:(const b2Color&)color;
- (void) DrawSegment:(const b2Vec2&)p1 p2:(const b2Vec2&)p2 color:(const b2Color&)color;
@end



@implementation B2dLayer 




- (id) init {
	if( ! (self=[super init]) ) {
		return nil;
	}
	
	// layer cfg
	isTouchEnabled = YES;
	
	// ivar cfg
	m_mouseJoint = nil;

	
	// create a default world
	[self createDefaultWorld];	 
	
	return self;
}


-(void) onEnter {
	
	// make lines and dots look pretty
	glPointSize(3.0f);
    //glEnable(GL_LINE_SMOOTH);
	//glEnable(GL_POINT_SMOOTH);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    //glHint(GL_LINE_SMOOTH_HINT, GL_DONT_CARE);
    //glHint(GL_POINT_SMOOTH_HINT, GL_DONT_CARE);
    glLineWidth(2.0f);
	
	// timers
	[self schedule:@selector(stepSimulation:)]; 
	// parent
	[super onEnter];
}


-(void) onExit {
	// timers
	[self unschedule:@selector(stepSimulation:)]; 
	// parent
	[super onExit];
}

-(void) draw {
	[super draw];
	
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


-(void) stepSimulation:(ccTime)deltaTime
{	
	// settings
	float32 timeStep = 1.0f / 60.0f; // 60 hz is good
	int32 velocityIterations = 10; // 10 is good
	int32 positionIterations = 8; // 8 is good
	
	// Take a time step. This performs collision detection, integration, and constraint solution
	m_b2world->Step(timeStep, velocityIterations, positionIterations);
	// validate internal structures
	m_b2world->Validate();
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
	m_b2world = new b2World(m_worldAABB, gravity, doSleep);	
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

-(b2Vec2)getTouchLocation:(UITouch*)touch {
	CGPoint touchLocation = [touch locationInView: [touch view]];
	// helper to translate coords
	touchLocation = [[Director sharedDirector] convertCoordinate:touchLocation];
	return b2Vec2(touchLocation.x,touchLocation.y);
}


// touching
- (BOOL)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
		
	for (UITouch *touch in touches)
	{
		b2Vec2 p = [self getTouchLocation:touch];
		
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
		int32 count = m_b2world->Query(aabb, shapes, k_maxCount);
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
			md.body1 = m_b2world->GetGroundBody();
			md.body2 = body;
			md.target = p;
#ifdef TARGET_FLOAT32_IS_FIXED
			md.maxForce = (body->GetMass() < 16.0)? 
			(1000.0f * body->GetMass()) : float32(16000.0);
#else
			md.maxForce = 1000.0f * body->GetMass();
#endif
			m_mouseJoint = (b2MouseJoint*)m_b2world->CreateJoint(&md);
			body->WakeUp();
		}
		
	}	
	
	return kEventHandled;
}

- (BOOL)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
	// move the joint position
	for (UITouch *touch in touches)
	{
		b2Vec2 p = [self getTouchLocation:touch];
		
		m_mouseWorld = p;
		
		if (m_mouseJoint)
		{
			m_mouseJoint->SetTarget(p);
		}
	}
	
	return kEventHandled;
}

- (BOOL)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	
	// release whatever is been held
	if (m_mouseJoint)
	{
		m_b2world->DestroyJoint(m_mouseJoint);
		m_mouseJoint = nil;
	}
	return kEventHandled;
}


-(b2World*) getWorld {
	return m_b2world;
}



-(void) dealloc{
	
	if (m_mouseJoint)
	{
		m_b2world->DestroyJoint(m_mouseJoint);
		m_mouseJoint = nil;
	}
	
	// world
	free(m_b2world);
	m_b2world = nil;
	
	[self removeAllChildrenWithCleanup:YES];
	
	[super dealloc];
}
@end
