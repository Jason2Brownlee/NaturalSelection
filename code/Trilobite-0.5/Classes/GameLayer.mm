//
//  GameLayer.m
//  Trilobite
//
//  Created by jasonb on 13/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"

#ifdef __cplusplus
#import "Box2D.h"
#endif

#import "B2dBlock.h"
#import "B2dJoint.h"

#import "HelloWorld.h"
#import "SimpleWorm.h"


// private interface for testing
@interface B2dLayer() 
Environment *environment;
Creature *creature;

-(void)startEvolution;
-(void)stopEvolution;

-(void) makeEnvironment;
-(void) makeCreature;
-(void) makeWorld;

@end



@implementation GameLayer

- (id) init {
	if( ! (self=[super init]) ) {
		return nil;
	}
	
	// make a simple world
	[self makeWorld];
	
	// start evolution
	[self startEvolution];
	
	
	return self;
}

-(void)onEnter {
	// schedule a stop and eval
	float evolveTimeSeconds = 10.0f;
	[self schedule:@selector(stopEvolution) interval:evolveTimeSeconds]; 

	[super onEnter];
}

-(void)onExit {
	// stop evolution
	[self unschedule:@selector(stopEvolution)];
	
	[super onExit];
}




-(void)startEvolution {
	NSLog(@"starting evolution...");
	// spawn a creature
	[self makeCreature];
}

-(void)stopEvolution {	
	// calculate fitness
	float fitness = [environment calculateFitness:creature];	
	NSLog(@"stopping evolution... fitness=%f", fitness);
	
	// stop the game
	[[Director sharedDirector] pause];
	
	// remove the creature
	[self removeChild:creature cleanup:YES];
	[creature release];
	creature = nil;
	
	// start a new evolution
	[self startEvolution];
	
	// resume the game
	[[Director sharedDirector] resume];
}

-(void) makeWorld {
	// env
	[self makeEnvironment];
}

-(void) makeEnvironment {
	// create the hello world
	environment = [[HelloWorld alloc] initWithWorld:m_b2world];
	[self addChild:environment];
}

-(void) makeCreature {
	creature = [[SimpleWorm alloc] initAtStartPosition:m_b2world pos:[environment getStartFlagPosition]];
	[self addChild:creature];
}






-(void) dealloc{
	if(environment) {
		[environment release];
		environment = nil;
	}
	if(creature) {
		[creature release];
		creature = nil;
	}
	// clean up all nodes
	[self removeAllChildrenWithCleanup:YES];
	// parent
	[super dealloc];
}

@end
