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
#import "B2dWorldNode.h"

#ifdef __cplusplus
	//#include "Box2D.h"
	#import "Box2D.h"
#endif

@interface B2dLayer : Layer {

@private
	BOOL drawingWasInit;

}

@property BOOL drawingWasInit;


-(void)tick: (ccTime)deltaTime;
-(void)initializeDrawing;

-(void) createDefaultWorld;
-(void) stepSimulation: (ccTime)deltaTime;


-(void) helloWorld; // testing
//-(b2Body*)makeBlock:(b2BodyDef)blockDef shapeDef:(b2PolygonDef)shapeDef;

@end

#endif /*B2DLAYER_H*/