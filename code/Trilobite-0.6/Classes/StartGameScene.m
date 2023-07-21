//
//  StartGameScene.m
//  Trilobite
//
//  Created by jasonb on 2/05/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StartGameScene.h"
#import "SelectEnvironment.h"

@implementation StartGameScene

- (id) init {
	if( ! (self=[super init]) ) {
		return nil;
	}
	
	// boot the environment selection
	[self addChild:[SelectEnvironment node] z:0];
    
    return self;
}

@end
