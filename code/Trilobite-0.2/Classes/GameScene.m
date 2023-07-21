//
//  GameScene.m
//  Trilobite
//
// Initially based on tutorial:http://monoclestudios.com/cocos2d_whitepaper.html
// Stripped chipmunk so macros no longer work, instead use: http://code.google.com/p/cocos2d-iphone/issues/detail?id=290
// 
//

#import "GameScene.h"
#import "MenuScene.h"
#import "Box2dTestLayer.h"

@implementation GameScene
- (id) init {
    self = [super init];
    if (self != nil) {		
		/*
		// For testing - will draw an image
        Sprite * bg = [Sprite spriteWithFile:@"game.png"];
        [bg setPosition:CGPointMake(240, 160)];
        [self addChild:bg z:0];
        */
		
		// set up the ordering of things
		[self addChild:[Box2dTestLayer node] z:0]; // rendering
		[self addChild:[GameTouchLayer node] z:1]; // interaction
    }
    return self;
}
@end


// for touching
@implementation GameTouchLayer
- (id) init {
    self = [super init];
    if (self != nil) {
        isTouchEnabled = YES;
    }
    return self;
}


// back to menu on touch events
- (BOOL)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    MenuScene * ms = [MenuScene node];
    [[Director sharedDirector] replaceScene:ms];
    return kEventHandled;
}
@end
