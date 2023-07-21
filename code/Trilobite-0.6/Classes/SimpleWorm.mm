//
//  SimpleWorm.mm
//  Trilobite
//
//  Created by jasonb on 25/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SimpleWorm.h"

#ifdef __cplusplus
#import "Box2D.h"
#endif

#import "B2dBlock.h"
#import "B2dJoint.h"




@implementation SimpleWorm


-(b2Vec2)currentCreaturePosition {
	return [root getBody]->GetWorldCenter();
}

-(void)createCreature:(b2Vec2)pos {
	
	CGSize size = [[Director sharedDirector] winSize];
	float originX = pos.x;
	float originY = pos.y;// + size.height/6.0f; // off the ground
	
	// define creature
	creature_t *def = [self createCreatureDef];
	
	// make creature - root
	root = [[B2dBlock alloc] init];
	[root initDynamicBlock:m_b2world x:originX y:originY width:def->width height:def->height];
	[self addChild:root];
	// process remainder of creature
	for(int i=0; i<def->num_children; i++) {
		[self addBlock:root def:def->children[i]];
	}
	
	// release definition
	[self freeCreatureDef:def];
}

// depth first
-(void)addBlock:(B2dBlock*)parentBlock def:(creature_t*)def {
	// attach
	B2dBlock *block = [parentBlock attachDynamicBlock:m_b2world creature:def];
	// process children
	for(int i=0; i<def->num_children; i++) {
		[self addBlock:block def:def->children[i]];
	}
}

-(creature_t*)createCreatureDef {
	// root
	creature_t *base = (creature_t*) malloc(sizeof(creature_s));
	base->width = 20.0f;
	base->height = 20.0f;
	base->num_children = 1;
	base->children = (creature_s**) malloc(sizeof(creature_s*));
	
	// define worm
	creature_t *current = base;
	int depth = 1;
	int max_depth = 6;
	while(depth <= max_depth)
	{
		// create next node
		current->children[0] = (creature_t*) malloc(sizeof(creature_s));
		creature_t *leaf = current->children[0];
		leaf->width = 10.0f;
		leaf->height = 10.0f;
		leaf->dir = 2;
		leaf->lower_angle = -45.0f;
		leaf->upper_angle = 45.0f;
		leaf->speed=5.0f;
		if(depth == max_depth) {
			leaf->num_children = 0;	
			leaf->children = nil;
		} else {
			leaf->num_children = 1;	
			leaf->children = (creature_s**) malloc(sizeof(creature_s*));
		}
		
		current = leaf;
		depth++;
	}
	
	return base;
}

// depth first
-(void)freeCreatureDef:(creature_t*)creature {
	// free children
	for(int i=0; i<creature->num_children; i++) {
		[self freeCreatureDef:creature->children[i]];
	}
	// free self
	free(creature);
}

-(void)creatureThink:(ccTime)deltaTime {
	[root runThink];
}

-(void)dealloc{
	[root release];
	root = nil;
	// clean up all nodes
	[self removeAllChildrenWithCleanup:YES];
	// parent
	[super dealloc];	
}

@end
