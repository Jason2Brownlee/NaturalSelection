//
//  PlaygroundLayer.m
//  Trilobite
//
//  Created by jasonb on 2/05/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PlaygroundLayer.h"
#import "EnvironmentFactory.h"

// testing
#import "SimpleWorm.h"


@implementation PlaygroundLayer

- (id) init {
	if( ! (self=[super init]) ) {
		return nil;
	}
	
	[self makeWorld];	
	[self makeCreature];
	
	return self;
}

-(void) makeWorld {
	Environment *env = [EnvironmentFactory buildPlayground:m_b2world];
	[self addChild:env];
}

-(void) makeCreature {
	CGSize size = [[Director sharedDirector] winSize];

	b2Vec2 start = b2Vec2(size.width/2.0f, size.height/2.0f);
	
	creature = [[SimpleWorm alloc] initAtStartPosition:m_b2world pos:start];
	[self addChild:creature];
}

-(void) dealloc{
	[creature release];
	creature = nil;
	
	// clean up all nodes
	[self removeAllChildrenWithCleanup:YES];
	// parent
	[super dealloc];
}

@end
