//
//  GameLayer.h
//  Trilobite
//
//  Created by jasonb on 13/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#ifndef GAMELAYER_H
#define GAMELAYER_H

#import "cocos2d.h"
#import "B2dLayer.h"
#import "TTypes.h"

@interface GameLayer : B2dLayer {

}

-(void) makeEnvironment;
-(void) makeCreature;
-(void) makeWorld;

@end


#endif /*GAMELAYER_H*/

