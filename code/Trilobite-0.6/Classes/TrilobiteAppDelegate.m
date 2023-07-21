//
//  TrilobiteAppDelegate.m
//  Trilobite
//
//

#import "TrilobiteAppDelegate.h"
#import "MainMenuScene.h"

@implementation TrilobiteAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	// configure the window
    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [window setUserInteractionEnabled:YES];
    [window setMultipleTouchEnabled:NO];
	
	// must be called before any othe call to the director
	// FastDirector is faster, but consumes more battery
	[Director useFastDirector];
	
    // configure the director	
	[[Director sharedDirector] setLandscape:YES]; // landscape
	[[Director sharedDirector] setDisplayFPS:YES]; // display framerate
    [[Director sharedDirector] attachInWindow:window];
	[[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO]; // remove status bar (carrier)
	
	// make window visible
    [window makeKeyAndVisible];
	
	// create the menu
    MainMenuScene * menu = [MainMenuScene node];
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

-(void) applicationWillTerminate: (UIApplication*)application {
    // Application is ending...
    [[Director sharedDirector] release];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	// purge memroy
	[[TextureMgr sharedTextureMgr] removeAllTextures];
}

-(void) applicationSignificantTimeChange:(UIApplication *)application {
	// next delta time will be zero
	[[Director sharedDirector] setNextDeltaTimeZero:YES];
}

- (void) dealloc {
	[window release];
	[super dealloc];
}

@end

