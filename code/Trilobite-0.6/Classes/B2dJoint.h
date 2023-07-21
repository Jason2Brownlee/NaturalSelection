//
//  B2dRevoluteJoint.h
//  Trilobite
//
//  Created by jasonb on 21/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#ifndef B2DJOINT_H
#define B2DJOINT_H

#import "cocos2d.h"

#ifdef __cplusplus
#import "Box2D.h"
#endif

#import "B2dBlock.h"


@interface B2dJoint : CocosNode {
b2World * m_b2world;
b2Joint* m_joint;
}

-(void) initRevoluteJoint:(b2World*)world b1:(B2dBlock*)b1 b2:(B2dBlock*)b2 point:(b2Vec2&)point lower:(float32)lower upper:(float32)upper speed:(float32)speed;

-(void)scheduledBrainTick:(ccTime)deltaTime;
-(void)drawSegment:(const b2Vec2&)p1 p2:(const b2Vec2&)p2 color:(const b2Color&)color;

// testing
-(void)runThink;

@end

#endif /*B2DJOINT_H*/