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

	NSMutableArray *appendages;	
	
	// core
	b2Body *m_body;
	b2World *m_b2world;
	b2Shape *m_shape;
	b2Color m_color;
}

// initialization
-(void) initBlock:(b2World*)world x:(float)x y:(float)y width:(float)width height:(float)height dynamic:(BOOL)dynamic sensor:(BOOL)sensor;
-(void) initStaticBlock:(b2World*)world x:(float)x y:(float)y width:(float)width height:(float)height;
-(void) initDynamicBlock:(b2World*)world x:(float)x y:(float)y width:(float)width height:(float)height;
-(void) initWorldBoundaryBlock:(b2World*)world x:(float)x y:(float)y width:(float)width height:(float)height;

// attachment
-(B2dBlock*)attachDynamicBlock:(b2World*)world creature:(creature_t*)creature;
-(void)join:(B2dBlock*)parent pos:(b2Vec2)pos creature:(creature_t*)creature;

// drawing
-(void) drawShape:(b2Shape*)shape xf:(const b2XForm&)xf color:(const b2Color&)color;
-(void) drawSolidPolygon:(const b2Vec2*)vertices vertexCount:(int32)vertexCount color:(const b2Color&)color;

// testing
-(b2Body*)getBody;
-(void)runThink;
-(void)appendagesAlloc;
-(void)setColor:(b2Color)color;

@end



#endif /*B2DBLOCK_H*/