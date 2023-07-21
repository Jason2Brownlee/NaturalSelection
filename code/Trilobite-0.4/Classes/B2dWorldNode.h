//
//  B2dWorldNode.h
//  Trilobite
//
//  Created by jasonb on 13/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"



@interface B2dWorldNode : CocosNode {

}

-(void) createDefaultWorld;
-(void) stepSimulation;

@end
