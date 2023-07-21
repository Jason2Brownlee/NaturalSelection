//
//  TrilobiteAppDelegate.m
//  Trilobite
//
// Initially based on tutorial:http://monoclestudios.com/cocos2d_whitepaper.html
// Stripped chipmunk so macros no longer work, instead use: http://code.google.com/p/cocos2d-iphone/issues/detail?id=290
// updated, added more methods based on: http://lethain.com/entry/2008/oct/03/notes-on-cocos2d-iphone-development/
//

#import "TrilobiteAppDelegate.h"

@implementation TrilobiteAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	// Game began...
	
	// configure the window
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [window setUserInteractionEnabled:YES];
    [window setMultipleTouchEnabled:NO];
	
	// must be called before any othe call to the director
	// FastDirector is faster, but consumes more battery
	[Director useFastDirector];
	
    // configure the director	
	[[Director sharedDirector] setLandscape: YES]; // landscape
	[[Director sharedDirector] setDisplayFPS:YES]; // display framerate
    [[Director sharedDirector] attachInWindow:window];
	
	// make window visible
    [window makeKeyAndVisible];
	
	// create the menu
    MenuScene * menu = [MenuScene node];
	// run the menu
    [[Director sharedDirector] runWithScene:menu];
}

-(void) applicationWillResignActive:(UIApplication *)application {
    // Incoming phone call...
    [[Director sharedDirector] pause];
}

-(void) applicationDidBecomeActive:(UIApplication *)application {
    // Phone call rejected...
    [[Director sharedDirector] resume];
}

-(void) applicationWillTerminate: (UIApplication*) application {
    // Application is ending...
    [[Director sharedDirector] release];
}

@end

