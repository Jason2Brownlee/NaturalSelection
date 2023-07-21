//
//  MainMenuLayer.m
//  Trilobite
//
//  Created by jasonb on 2/05/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MainMenuLayer.h"
#import "GameScene.h"
#import "StartGameScene.h"
#import "PlaygroundScene.h"

@implementation MainMenuLayer

- (id) init {
	if( ! (self=[super init]) ) {
		return nil;
	}
	
	[MenuItemFont setFontSize:30];
	[MenuItemFont setFontName:@"Helvetica"];
	
	// items
	MenuItem *start = [MenuItemFont itemFromString:@"Start Game" target:self selector:@selector(startGame:)];
	MenuItem *playground = [MenuItemFont itemFromString:@"Playground" target:self selector:@selector(playground:)];
	MenuItem *help = [MenuItemFont itemFromString:@"Help" target:self selector:@selector(help:)];
	
	// menu
	Menu *menu = [Menu menuWithItems:start, playground, help, nil];	
	[menu alignItemsVertically];
	
	// add to layer
	[self addChild:menu];
    
    return self;
}

-(void)startGame: (id)sender {
    NSLog(@"start game");
	StartGameScene *sg = [StartGameScene node];
	[[Director sharedDirector] replaceScene:sg];
}

-(void)playground: (id)sender {
    NSLog(@"playground");
	// boot the playground
	PlaygroundScene * ps = [PlaygroundScene node];
    [[Director sharedDirector] replaceScene:ps];
}

-(void)help: (id)sender {
    NSLog(@"help");
}

@end
