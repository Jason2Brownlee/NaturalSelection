//
//  EnvironmentFactory.m
//  Trilobite
//
//  Created by jasonb on 2/05/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "EnvironmentFactory.h"


@implementation EnvironmentFactory


+(NSMutableArray*)environmentList {
	NSMutableArray *list = [[[NSMutableArray alloc] initWithCapacity:2] autorelease];
	
	[list addObject:@"Hello World 1"];
	[list addObject:@"Hello World 2"];
	
	return list;
}


+(Environment*)buildPlayground:(b2World*)world {
	return [[[HelloWorld alloc] initWithWorld:world withFlags:NO] autorelease];
}

+(Environment*)buildEnvironment:(int)index world:(b2World*)world {

	Environment *env = nil;
	
	switch(index) {
		case 0:
			env = [[[HelloWorld alloc] initWithWorld:world] autorelease];
			break;
		case 1:
			env = [[[HelloWorld alloc] initWithWorld:world] autorelease];
			break;
			
		default:
			env = nil;
			break;
	}
	
	return env;
}

@end
