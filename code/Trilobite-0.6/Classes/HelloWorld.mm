//
//  HelloWorld.m
//  Trilobite
//
//  Created by jasonb on 25/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "HelloWorld.h"

#ifdef __cplusplus
#import "Box2D.h"
#endif

#import "B2dBlock.h"
#import "B2dJoint.h"


@implementation HelloWorld

-(void)createEnvironment{
	//
	// a simple box world
	// todo: make floor thicker than all other walls
	//
	
	CGSize size = [[Director sharedDirector] winSize];	
	float32 wall = 2.0f;
	
	// roof
	B2dBlock *roofBlock = [[[B2dBlock alloc] init] autorelease];
	[roofBlock initWorldBoundaryBlock:m_b2world x:size.width/2.0f y:size.height-(wall/2.0f) width:size.width height:wall];
	[self addChild:roofBlock];	
	
	// floor
	B2dBlock *floorBlock = [[[B2dBlock alloc] init]autorelease];
	[floorBlock initWorldBoundaryBlock:m_b2world x:size.width/2.0f y:wall/2.0f width:size.width height:wall];
	[self addChild:floorBlock];
	
	// left wall
	B2dBlock *lwall = [[[B2dBlock alloc] init]autorelease];
	[lwall initWorldBoundaryBlock:m_b2world x:wall/2.0 y:size.height/2.0f width:wall height:size.height-(wall*2.0f)];
	[self addChild:lwall];
	
	// right wall
	B2dBlock *rwall = [[[B2dBlock alloc] init]autorelease];
	[rwall initWorldBoundaryBlock:m_b2world x:size.width-(wall/2.0f) y:size.height/2.0f width:wall height:size.height-(wall*2.0f)];
	[self addChild:rwall];
}

-(b2Vec2)getStartFlagPosition{
	CGSize size = [[Director sharedDirector] winSize];
	return b2Vec2(size.width/6.0f, 6.0f);
}
-(b2Vec2)getEndFlagPosition{
	CGSize size = [[Director sharedDirector] winSize];
	return b2Vec2(size.width-size.width/6.0f, 6.0f);
}


-(void)dealloc{
	// clean up all nodes
	[self removeAllChildrenWithCleanup:YES];
	// parent
	[super dealloc];
}


@end
