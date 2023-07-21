//
//  B2dTouchLayer.h
//  Trilobite
//
//  Created by jasonb on 2/05/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

#ifdef __cplusplus
	#import "Box2D.h"
#endif

@interface B2dTouchLayer : Layer {

	b2World *m_b2world;
	
	// mouse fun
	b2MouseJoint* m_mouseJoint;
	b2Vec2 m_mouseWorld;
}

-(id) initWithWorld:(b2World*)world;

// helpers
- (void) DrawSegment:(const b2Vec2&)p1 p2:(const b2Vec2&)p2 color:(const b2Color&)color;
- (void) DrawPoint:(const b2Vec2&)p size:(float32)size color:(const b2Color&)color;
-(b2Vec2)getTouchLocation:(UITouch*)touch;

@end
