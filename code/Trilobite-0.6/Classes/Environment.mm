//
//  Environment.mm
//  Trilobite
//
//  Created by jasonb on 25/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Environment.h"



@implementation Environment


-(id)init {
	if( ! (self=[super init]) ) {
		return nil;
	}	
	return self;
}

-(id)initWithWorld:(b2World*)world {
	[self initWithWorld:world withFlags:YES];
}

-(id)initWithWorld:(b2World*)world withFlags:(BOOL)withFlags {
	if(!(self=[self init]) ) {
		return nil;
	}
	
	m_b2world = world;
	// create the world
	[self createEnvironment];	
	if(withFlags) {
		[self setFlags];
	}
	
	return self;
}


-(void)setFlags {
	b2Vec2 p1 = [self getStartFlagPosition];
	//startFlag = [self spawnFlag:p1];
	startFlag = nil;
	endFlag = [self spawnFlag:[self getEndFlagPosition]];	
}

-(B2dBlock*)spawnFlag:(b2Vec2)pos {
	CGSize size = [[Director sharedDirector] winSize];
	pos.y += size.height/4.0f;
	B2dBlock *flag = [[B2dBlock alloc] init]; 
	// no collision
	[flag initBlock:m_b2world x:pos.x y:pos.y width:2.0f height:10.0f dynamic:YES sensor:NO];
	// add to world
	[self addChild:flag];
	
	return flag;
}

-(void)createEnvironment{
	
}
-(b2Vec2)getStartFlagPosition{
	return b2Vec2(0.0f,0.0f);
}
-(b2Vec2)getEndFlagPosition{
	return b2Vec2(0.0f,0.0f);
}


-(float)calculateFitness:(Creature*)creature {
	// creature pos
	b2Vec2 cPos = [creature currentCreaturePosition];
	b2Vec2 ePos = [self getEndFlagPosition];
	// euclidean distance without sqrt
	return (cPos.x - ePos.x) * (cPos.x - ePos.x) + (cPos.y - ePos.y) * (cPos.y - ePos.y);
}

-(void)dealloc{
	if(startFlag) {
		[startFlag release];		
		startFlag = nil;
	}	
	if(endFlag) {
		[endFlag release];
		endFlag = nil;
	}
	m_b2world = nil;
	// clean up all nodes
	[self removeAllChildrenWithCleanup:YES];
	[super dealloc]; // last
}

@end
