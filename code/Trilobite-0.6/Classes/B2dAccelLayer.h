//
//  B2dAccelLayer.h
//  Trilobite
//
//  Created by jasonb on 3/05/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

#ifdef __cplusplus
#import "Box2D.h"
#endif

@interface B2dAccelLayer : Layer {
	
	b2World *m_b2world;
	
}

-(id) initWithWorld:(b2World*)world;


@end
