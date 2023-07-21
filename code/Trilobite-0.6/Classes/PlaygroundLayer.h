//
//  PlaygroundLayer.h
//  Trilobite
//
//  Created by jasonb on 2/05/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

#import "B2dLayer.h"
#import "Environment.h"
#import "Creature.h"

@interface PlaygroundLayer : B2dLayer {
	Creature *creature;
}

-(void) makeCreature;
-(void) makeWorld;

@end
