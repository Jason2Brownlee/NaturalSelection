//
//  Creature.h
//  Trilobite
//
//  Created by jasonb on 25/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "TTypes.h"

#ifdef __cplusplus
#import "Box2D.h"
#endif

#import "B2dBlock.h"

@interface Creature : CocosNode {
	
	// ivars
	b2World *m_b2world;
	
}

-(id)initAtStartPosition:(b2World*)world pos:(b2Vec2)pos;
-(void)createCreature:(b2Vec2)pos;
-(b2Vec2)currentCreaturePosition;
-(void)creatureThink:(ccTime)deltaTime;

@end
