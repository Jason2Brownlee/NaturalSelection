//
//  SelectEnvironment.m
//  Trilobite
//
//  Created by jasonb on 2/05/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SelectEnvironment.h"

#import "GameScene.h"
#import "EnvironmentFactory.h"

// Based on: http://groups.google.com/group/cocos2d-iphone-discuss/browse_frm/thread/2e6de4a2f1befe4b/19ae2a8898a18188?lnk=gst&q=UITableView#19ae2a8898a18188
// background on customizing tables: http://cocoawithlove.com/2009/04/easy-custom-uitableview-drawing.html

@implementation SelectEnvironment

- (id) init {
	if( ! (self=[super init]) ) {
		return nil;
	}
	
	packageTableView = nil;
	list = [[EnvironmentFactory environmentList] retain];
	
	return self;
}

-(void)onEnter {
	[self attachTable];
	[super onEnter];
}

-(void)onExit {
	[self detachTable];
	[super onExit];
}

-(void) attachTable {
	// table
	if( !packageTableView ) {
		packageTableView = [self createNewTableView];
	}
	
	[[[Director sharedDirector] openGLView] addSubview:packageTableView];
}

-(void) detachTable {
	[packageTableView removeFromSuperview];
	[packageTableView release];
	packageTableView = nil;
	
	NSLog(@"table detatched...");
}

- (void) dealloc {
	[packageTableView release];
	packageTableView = nil;
	
	[list release];
	list = nil;
	
	NSLog(@"table dealloc'ed...");
	
	[super dealloc];
}

// create table view
-(UITableView*) createNewTableView {
	UITableView *ret = [[UITableView alloc] initWithFrame:CGRectZero];
	ret.delegate = self;
	ret.dataSource = self;
	//ret.opaque = NO;
	ret.frame = CGRectMake(40, 10, 235, 460);
	//ret.transform = CGAffineTransformMakeRotation(M_PI / 2.0); // 180 degrees
	//[ret setBackgroundColor:[UIColor clearColor]];
	//[ret setSeparatorColor:[UIColor clearColor]];
	
	NSLog(@"creating table...");
	
	return ret;
	
}

#pragma mark UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	//return  [packData count];
	return [list count]; //jasonb
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *MyIdentifier = @"PackageSelectCell";
	
	UILabel *name;
	UIView *view;
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
		cell.opaque=NO;
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
		
		int kCellHeight = 70; // jasonb
		view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0.0, 460, kCellHeight-2)];
		//view.opaque = NO;
		view.tag=1;
		//[view setBackgroundColor:[UIColor clearColor]];
		
		// Name
		name = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 460, 35)];
		name.tag = 2;
		//name.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:14.0 ];
		name.adjustsFontSizeToFitWidth = YES;
		name.textAlignment = UITextAlignmentLeft;
		name.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
		name.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
		//name.opaque=NO;
		//[name setBackgroundColor:[UIColor clearColor]];
		[view addSubview:name];
		[name release];
		
		[cell.contentView addSubview:view];
	}
	else
	{
		view = (UIView*)[cell.contentView viewWithTag:1];
		name = (UILabel*)[cell.contentView viewWithTag:2];
	}
	
	int index = indexPath.row;
	//NSDictionary * curpack = [packData objectAtIndex:index];
	//name.text = [curpack objectForKey:@"name"];
	
	//name.text = [NSString stringWithFormat:@"test environment %i", index];
	
	name.text = [list objectAtIndex:index];
	
	return cell;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	int index = [indexPath row];
	//NSDictionary * curpack = [packData objectAtIndex:index];
	
	//if(index == 5) {
		GameScene *gs = [[[GameScene alloc] initWithWorld:index] autorelease];	
		//GameScene * gs = [GameScene node];
		[[Director sharedDirector] replaceScene:gs];	
	//}
}


@end
