//
//  MainMenuScene.m
//  Trilobite
//
//  Created by jasonb on 2/05/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MainMenuScene.h"
#import "MainMenuLayer.h"

@implementation MainMenuScene

- (id) init {
	if( ! (self=[super init]) ) {
		return nil;
	}
		
	// TODO - install a background image
        
	// menu items
	[self addChild:[MainMenuLayer node] z:0];
    
    return self;
}

@end
