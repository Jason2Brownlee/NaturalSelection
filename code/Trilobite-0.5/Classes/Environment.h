//
//  Environment.h
//  Trilobite
//
//  Created by jasonb on 25/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

#ifdef __cplusplus
#import "Box2D.h"
#endif

#import "B2dBlock.h"
#import "Creature.h"

@interface Environment : CocosNode {
// ivars
b2World *m_b2world;
}

-(id)initWithWorld:(b2World*)world;
-(void)setFlags;
-(B2dBlock*)spawnFlag:(b2Vec2)pos;

-(void)createEnvironment;
-(b2Vec2)getStartFlagPosition;
-(b2Vec2)getEndFlagPosition;

-(float)calculateFitness:(Creature*)creature;

@end
