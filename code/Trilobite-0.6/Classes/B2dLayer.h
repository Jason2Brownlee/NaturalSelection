//
//  B2dLayer.h
//  Trilobite
//
//  Created by jasonb on 13/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#ifndef B2DLAYER_H
#define B2DLAYER_H
 

#import "cocos2d.h"

#ifdef __cplusplus
#import "Box2D.h"
#endif

#import "B2dBlock.h"
#import "B2dJoint.h"



@interface B2dLayer : Layer {

	// ivars
	b2World *m_b2world;
}

-(void) createDefaultWorld;
-(void) stepSimulation: (ccTime)deltaTime;
-(b2World*) getWorld;

@end

#endif /*B2DLAYER_H*/