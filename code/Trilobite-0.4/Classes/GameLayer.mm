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


// private interface for testing
@interface B2dLayer() 
-(B2dBlock*)addBlock:(B2dBlock*)block;

@end



@implementation GameLayer

- (id) init {
		if( ! (self=[super init]) ) {
		return nil;
	}
	
	// make a simple world
	[self makeWorld];
	
	return self;
}

-(void) makeWorld {
	// env
	[self makeEnvironment];
	// creature
	[self makeCreature];
}

-(void) makeEnvironment {
	//
	// a simple box world
	// todo: make floor thicker than all other walls
	//
	
	CGSize size = [[Director sharedDirector] winSize];	
	float32 wall = 6.0f;
	
	// roof
	B2dBlock *roof = [[B2dBlock alloc] init];
	[roof initStaticBlock:m_b2world x:size.width/2.0f y:size.height-(wall/2.0f) width:size.width height:wall];
	[self addChild:roof];	
	
	// floor
	B2dBlock *floor = [[B2dBlock alloc] init];
	[floor initStaticBlock:m_b2world x:size.width/2.0f y:wall/2.0f width:size.width height:wall];
	[self addChild:floor];
	
	// left wall
	B2dBlock *lwall = [[B2dBlock alloc] init];
	[lwall initStaticBlock:m_b2world x:wall/2.0 y:size.height/2.0f width:wall height:size.height-(wall*2.0f)];
	[self addChild:lwall];
	
	// right wall
	B2dBlock *rwall = [[B2dBlock alloc] init];
	[rwall initStaticBlock:m_b2world x:size.width-(wall/2.0f) y:size.height/2.0f width:wall height:size.height-(wall*2.0f)];
	[self addChild:rwall];
}


-(void) makeCreature {
	float originX = 160.0f;
	float originY = 120.0f;
	
	// big part
	B2dBlock *block1 = [[B2dBlock alloc] init];
	[block1 initDynamicBlock:m_b2world x:originX y:originY width:20.0f height:20.0f];
	[self addChild:block1];
	
	// add tail/trunk
	B2dBlock *block2 = [self addBlock:block1];
	B2dBlock *block3 = [self addBlock:block2];
	B2dBlock *block4 = [self addBlock:block3];
	B2dBlock *block5 = [self addBlock:block4];

}

-(B2dBlock*)addBlock:(B2dBlock*)block {
	Creature c;
	c.width = 10.0f;
	c.height = 10.0f;
	c.dir = 3;
	c.lower_angle = -45.0f;
	c.upper_angle = 45.0f;
	c.speed=5.0f;
	return [block attachDynamicBlock:m_b2world creature:c];
}


-(void) dealloc{
	[super dealloc];
}

@end
