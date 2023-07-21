//
//  SelectEnvironment.h
//  Trilobite
//
//  
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"



// Based on: http://groups.google.com/group/cocos2d-iphone-discuss/browse_frm/thread/2e6de4a2f1befe4b/19ae2a8898a18188?lnk=gst&q=UITableView#19ae2a8898a18188

@interface SelectEnvironment : Layer <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate> {

	UITableView *packageTableView; 
	NSMutableArray *list;
}


-(UITableView*) createNewTableView;
-(void) attachTable;
-(void) detachTable;

@end

