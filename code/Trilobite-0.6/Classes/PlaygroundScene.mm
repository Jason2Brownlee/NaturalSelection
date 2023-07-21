//
//  PlaygroundScene.m
//  Trilobite
//
//  Created by jasonb on 2/05/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PlaygroundScene.h"

#import "SimpleControlsLayer.h"
#import "PlaygroundLayer.h"
#import "B2dTouchLayer.h"
#import "B2dAccelLayer.h"

@implementation PlaygroundScene
- (id) init {
	if( ! (self=[super init]) ) {
		return nil;
	}
	
	// prepare playground
	PlaygroundLayer *game = [[[PlaygroundLayer alloc] init] autorelease];
	[self addChild:game z:0];
	
    // add touch interface
	B2dTouchLayer *touch = [[[B2dTouchLayer alloc] initWithWorld:[game getWorld]] autorelease];
	[self addChild:touch z:1];
	
	// add accel layer
	B2dAccelLayer *accel = [[[B2dAccelLayer alloc] initWithWorld:[game getWorld]] autorelease];
	[self addChild:accel z:1];
	
	// interact
	SimpleControlsLayer *controls = [[[SimpleControlsLayer alloc] init] autorelease];
	[self addChild:controls z:2];
	
    return self;
}
@end
