//
//  SimpleWorm.h
//  Trilobite
//
//  Created by jasonb on 25/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Creature.h"


@interface SimpleWorm : Creature {

	B2dBlock *root;
	
	
}

-(void)addBlock:(B2dBlock*)parent def:(creature_t*)def;
-(creature_t*)createCreatureDef;
-(void)freeCreatureDef:(creature_t*)creature;


@end
