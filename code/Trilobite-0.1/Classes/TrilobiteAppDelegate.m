//
//  TrilobiteAppDelegate.m
//  Trilobite
//
//  Created by jasonb on 13/04/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "TrilobiteAppDelegate.h"

@implementation TrilobiteAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [window setUserInteractionEnabled:YES];
    [window setMultipleTouchEnabled:YES];
    [[Director sharedDirector] setLandscape: YES];
    [[Director sharedDirector] attachInWindow:window];
	
    [window makeKeyAndVisible];
	
    MenuScene * ms = [MenuScene node];
	
    [[Director sharedDirector] runWithScene:ms];
}


@end

