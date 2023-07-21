//
//  EnvironmentFactory.h
//  Trilobite
//
//  Created by jasonb on 2/05/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#ifdef __cplusplus
#import "Box2D.h"
#endif


#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "Environment.h"

// all env's
#import "HelloWorld.h"



@interface EnvironmentFactory : NSObject {

}

+(Environment*)buildPlayground:(b2World*)world;
+(Environment*)buildEnvironment:(int)index world:(b2World*)world;
+(NSMutableArray*)environmentList;

@end
