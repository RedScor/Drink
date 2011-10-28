//
//  search.h
//  飲み物
//
//  Created by Yuan Ruo-Jiun on 11/10/24.
//  Copyright (c) 2011年 yuanruo@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OverlayViewController;

@interface search : UITableViewController {
	
	NSMutableArray *listOfItems;
	NSMutableArray *copyListOfItems;
	IBOutlet UISearchBar *searchBar;
	BOOL searching;
	BOOL letUserSelectRow;
	
	OverlayViewController *ovController;
}

- (void) searchTableView;
- (void) doneSearching_Clicked:(id)sender;


@end
