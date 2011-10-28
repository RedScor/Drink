//
//  aboutAs.h
//  飲み物
//
//  Created by JimLiao on 11/10/21.
//  Copyright (c) 2011年 jimliao@thlight.com All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface aboutAs : UIViewController<UITableViewDelegate>
{
    IBOutlet id favo;
    IBOutlet id aboutus;
    IBOutlet id pagecontroller;
    int CurrentPage;
    int PrevPage;
    CGPoint location;
    IBOutlet UITableView *TableView;
    NSMutableArray *dataSource;
}

- (IBAction)pagechange :(id)sender;
- (IBAction)reloadfavo :(id)sender;
@end
