//
//  detailViewController.h
//  飲み物
//
//  Created by Yuan Ruo-Jiun on 11/10/21.
//  Copyright (c) 2011年 yuanruo@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sqlite.h"

@interface detailViewController : UIViewController{
	
	UINavigationBar *getTitle;
	NSString *sTitle;
	IBOutlet UILabel *address;
	IBOutlet UILabel *tele;
	IBOutlet UIImageView *storeimage;
    NSString *selectedCountry;
	
}
@property(nonatomic, retain) UILabel *address;
@property(nonatomic, retain) UILabel *tele;
@property(nonatomic, retain) UIImageView *storeimage;
@property (nonatomic, retain) NSString *selectedCountry;
	

@end
