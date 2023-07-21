//
//  GameLayer.h
//  Trilobite
//
//  Created by jasonb on 13/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

#import "B2dLayer.h"
#import "Environment.h"
#import "Creature.h"


@interface GameLayer : B2dLayer {
	
	Environment *environment;
	Creature *creature;
	
}

-(id)initWithWorld:(int)worldId;

-(void)startEvolution;
-(void)stopEvolution;

//-(void) makeEnvironment;
-(void) makeCreature;
-(void) makeWorld:(int)worldId;

@end




