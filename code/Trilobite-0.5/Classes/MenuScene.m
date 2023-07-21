//
//  MenuScene.m
//  Trilobite

// Initially based on tutorial:http://monoclestudios.com/cocos2d_whitepaper.html
// Stripped chipmunk so macros no longer work, instead use: http://code.google.com/p/cocos2d-iphone/issues/detail?id=290

#import "MenuScene.h"
#import "GameScene.h"

@implementation MenuScene
- (id) init {
    self = [super init];
    if (self != nil) {
        //Sprite * bg = [Sprite spriteWithFile:@"menu.png"];
        //[bg setPosition:CGPointMake(240, 160)];
        //[self addChild:bg z:0];
        [self addChild:[MenuLayer node] z:1];
    }
    return self;
}
@end

@implementation MenuLayer
- (id) init {
    self = [super init];
    if (self != nil) {
        [MenuItemFont setFontSize:20];
        [MenuItemFont setFontName:@"Helvetica"];
        MenuItem *start = [MenuItemFont itemFromString:@"Start Game" target:self selector:@selector(startGame:)];
		MenuItem *playground = [MenuItemFont itemFromString:@"Playground" target:self selector:@selector(playground:)];
        MenuItem *help = [MenuItemFont itemFromString:@"Help" target:self selector:@selector(help:)];
        Menu *menu = [Menu menuWithItems:start, playground, help, nil];
        [menu alignItemsVertically];
        [self addChild:menu];
    }
    return self;
}
-(void)startGame: (id)sender {
    NSLog(@"start game");

}

-(void)playground: (id)sender {
    NSLog(@"playground");
	GameScene * gs = [GameScene node];
    [[Director sharedDirector] replaceScene:gs];
}

-(void)help: (id)sender {
    NSLog(@"help");
}
@end

