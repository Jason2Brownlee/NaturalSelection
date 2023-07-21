//
//  B2dLayer.m
//  Trilobite
//
// Responsible for running a Box2D based world
//

#import "B2dLayer.h"


@implementation B2dLayer 

- (id) init {
	if( ! (self=[super init]) ) {
		return nil;
	}
	
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


-(void) stepSimulation:(ccTime)deltaTime
{	
	// settings
	float32 timeStep = 1.0f / 60.0f; // 60 hz is good
	int32 velocityIterations = 10; // 10 is good
	int32 positionIterations = 8; // 8 is good
	
	// Take a time step. This performs collision detection, integration, and constraint solution
	m_b2world->Step(timeStep, velocityIterations, positionIterations);
	// validate internal structures
	//m_b2world->Validate();
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


-(b2World*) getWorld {
	return m_b2world;
}



-(void) dealloc{
	// world
	free(m_b2world);
	m_b2world = nil;
	
	[self removeAllChildrenWithCleanup:YES];
	
	[super dealloc];
}
@end
