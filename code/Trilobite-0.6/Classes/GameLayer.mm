//
//  GameLayer.m
//  Trilobite
//
//  Created by jasonb on 13/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"
#import "EnvironmentFactory.h"

// testing
#import "SimpleWorm.h"


@implementation GameLayer

- (id) init {
	if( ! (self=[super init]) ) {
		return nil;
	}
	
	// make a simple world
	[self makeWorld:0];	
	// start evolution
	[self startEvolution];
		
	return self;
}


-(id)initWithWorld:(int)worldId {
	if( ! (self=[super init]) ) {
		return nil;
	}
	
	// make a simple world
	[self makeWorld:worldId];	
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

-(void) makeWorld:(int)worldId {
	// env
	environment = [EnvironmentFactory buildEnvironment:worldId world:m_b2world];
	[environment retain];
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
