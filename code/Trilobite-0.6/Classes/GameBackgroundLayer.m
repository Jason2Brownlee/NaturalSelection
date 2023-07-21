//
//  GameBackgroundLayer.m
//  Trilobite
//
//  Created by jasonb on 29/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GameBackgroundLayer.h"


@implementation GameBackgroundLayer

- (id) init {
    self = [super init];
    if (self != nil) {		
		// same background for all
        Sprite * bg = [Sprite spriteWithFile:@"background.png"];
		// place in the centre
        [bg setPosition:CGPointMake(240, 160)];
        [self addChild:bg];
    }
    return self;
}

@end
