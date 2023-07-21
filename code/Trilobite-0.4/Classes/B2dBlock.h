//
//  B2dBlock.h
//  Trilobite
//
//  Created by jasonb on 13/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#ifndef B2DBLOCK_H
#define B2DBLOCK_H

#import "cocos2d.h"


#ifdef __cplusplus
	#import "Box2D.h"
#endif

#import "TTypes.h"



@interface B2dBlock : CocosNode {
// ivars
b2Body *m_body;
b2World *m_b2world;
}
// initialization
-(void) initStaticBlock:(b2World*)world x:(float)x y:(float)y width:(float)width height:(float)height;
-(void) initDynamicBlock:(b2World*)world x:(float)x y:(float)y width:(float)width height:(float)height;
-(B2dBlock*) attachDynamicBlock:(b2World*)world dir:(int)dir width:(float)width height:(float)height;
-(B2dBlock*)attachDynamicBlock:(b2World*)world creature:(Creature&)creature;
// drawing
-(void) drawShape:(b2Shape*)shape xf:(const b2XForm&)xf color:(const b2Color&)color;
-(void) drawSolidPolygon:(const b2Vec2*)vertices vertexCount:(int32)vertexCount color:(const b2Color&)color;
-(void) drawSegment:(const b2Vec2&)p1 p2:(const b2Vec2&)p2 color:(const b2Color&)color;
-(void) drawPoint:(const b2Vec2&)p size:(float32)size color:(const b2Color&)color;

// testing
-(b2Body*)getBody;

@end



#endif /*B2DBLOCK_H*/