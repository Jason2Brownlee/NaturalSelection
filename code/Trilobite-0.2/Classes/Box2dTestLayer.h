//
//  Box2dTestLayer.h
//  Trilobite
//
// problems getting box2d.h to import
// Discussion of integrating Box2d into iphone project: http://www.box2d.org/forum/viewtopic.php?f=7&t=1283
// TODO - I cannot get Box2D.h to import correctly

#import "cocos2d.h"
//#import "Box2D.h" // does not work

// drawing the game
@interface Box2dTestLayer : Layer {
	
}

-(void) createWorld;
- (void) createSimulation;

@end
