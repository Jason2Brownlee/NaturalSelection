//
//  B2dBlock.m
//  Trilobite
//
//  Created by jasonb on 13/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "B2dBlock.h"




// private interface
@interface B2dBlock() 

b2Body* dynamicBlock;

@end



@implementation B2dBlock

- (id) init {
	if( ! (self=[super init]) ) {
		return nil;
	}
	
	return self;
}

-(void) onEnter {
	[super onEnter];
}

-(void) draw {
	[super draw];
}

-(void) dealloc{
	// deallocate this first, then super	
	[super dealloc];
}

@end
