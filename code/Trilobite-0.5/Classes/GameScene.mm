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
#import "GameLayer.h"

#import "GameBackgroundLayer.h"

@implementation GameScene
- (id) init {
    self = [super init];
    if (self != nil) {	
		// place the background
		[self addChild:[GameBackgroundLayer node] z:0];
		// place the game
		[self addChild:[GameLayer node] z:1];
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
