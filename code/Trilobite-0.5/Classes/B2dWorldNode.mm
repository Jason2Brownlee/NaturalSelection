//
//  B2dWorldNode.m
//  Trilobite
//
//  Created by jasonb on 13/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "B2dWorldNode.h"
#include "Box2D.h"

// private interface
@interface B2dWorldNode() 

	b2World *m_b2d_world;

@end


@implementation B2dWorldNode

- (id) init {
	if( ! (self=[super init]) ) {
		return nil;
	}
	
	// create a default world
	[self createDefaultWorld];
	
	return self;
}

-(void) createDefaultWorld
{
	b2AABB m_worldAABB;	
	// Define the size of the world. Simulation will still work
	// if bodies reach the end of the world, but it will be slower.
	m_worldAABB.lowerBound.Set(0.0f,0.0f);
	m_worldAABB.upperBound.Set(320.0f, 240.0f);	
	// Define the gravity vector.
	b2Vec2 gravity(0.0f, -10.0f);
	// Do we want to let bodies sleep?
	bool doSleep = true;	
	// Construct a world object, which will hold and simulate the rigid bodies.
	m_b2d_world = new b2World(m_worldAABB, gravity, doSleep);	
}

-(void) onEnter {
	[super onEnter];
}

-(void) draw {
	[super draw];
	
	// draw self
	
	// draw children
}


-(void) stepSimulation
{
	//NSLog(@"executing time step");
	
	// settings
	float32 timeStep = 1.0f / 30.0f; // 60 hz is good
	int32 velocityIterations = 5; // 10 is good
	int32 positionIterations = 1;
	
	// Take a time step. This performs collision detection, integration, and constraint solution
	m_b2d_world->Step(timeStep, velocityIterations, positionIterations);
	// validate internal structures
	m_b2d_world->Validate();
}

-(void) dealloc{
	// deallocate this first, then super	
	free(m_b2d_world);
	[super dealloc];
}

@end
