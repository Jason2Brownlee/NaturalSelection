//
//  SimpleControlsLayer.m
//  Trilobite
//
//  Created by jasonb on 3/05/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SimpleControlsLayer.h"
#import "MainMenuScene.h"

@implementation SimpleControlsLayer

- (id) init {
	if( ! (self=[super init]) ) {
		return nil;
	}
	
	[MenuItemFont setFontSize:15];
	[MenuItemFont setFontName:@"Helvetica"];
	
	// items
	MenuItem *home = [MenuItemFont itemFromString:@"back" target:self selector:@selector(back:)];
	Menu *menu = [Menu menuWithItems:home, nil];	
	[menu alignItemsVertically];
	
	menu.position = CGPointZero;
	CGSize s = [[Director sharedDirector] winSize];
	home.position = ccp( s.width-20, s.height-10);
	
	[self addChild: menu z:1];
	
	return self;
}

-(void)back: (id)sender {
	NSLog(@"back");
	MainMenuScene *m = [MainMenuScene node];
	[[Director sharedDirector] replaceScene:m];
}

-(void) dealloc{
	
	// clean up all nodes
	[self removeAllChildrenWithCleanup:YES];
	// parent
	[super dealloc];
}

@end
