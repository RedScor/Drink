//
//  detailViewController.m
//  飲み物
//
//  Created by Yuan Ruo-Jiun on 11/10/21.
//  Copyright (c) 2011年 yuanruo@gmail.com. All rights reserved.
//

#import "detailViewController.h"

@implementation detailViewController
@synthesize address,tele,storeimage,selectedCountry;

NSString *coffee= @"85";
NSString *coco= @"coco";
NSString *ComeBuy= @"COMEBUY";
NSString *Haagen= @"Haagen-Dazs";
NSString *isCoffee= @"IS-COFFEE";
NSString *rido= @"rido-coffee里豆咖啡";
NSString *l18= @"傳奇18";
NSString *startBucks= @"星巴克";
NSString *feet= @"歇腳亭";
NSString *water= @"水龜伯";
NSString *mos= @"磨斯漢堡";
NSString *god= @"鮮芋仙";
NSString *macdonald= @"麥當勞";
NSString *skypeo= @"天人茶";
NSString *lightHeart= @"清心";


-(void)dealloc{
	
	[tele release];
	[address release];
	[storeimage release];
	[super dealloc];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		
		
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	Sqlite *sqlite= [[[Sqlite alloc] init] autorelease];
	sTitle = self.title;
	NSString *storePic;
	//self.navigationItem.title = selectedCountry ; 
	for (int i=0; i<=391; i++) {
		if ([sTitle isEqualToString: [[sqlite.transferarray objectAtIndex:i]objectAtIndex:0]] || [selectedCountry isEqualToString:[[sqlite.transferarray objectAtIndex:i]objectAtIndex:0]]) {
			address.text = [[sqlite.transferarray objectAtIndex:i]objectAtIndex:1];
			tele.text = [[sqlite.transferarray objectAtIndex:i]objectAtIndex:2];
			storePic = [[sqlite.transferarray objectAtIndex:i]objectAtIndex:5];
            	self.navigationItem.title = [[sqlite.transferarray objectAtIndex:i]objectAtIndex:0];


		}
	}
		for (int i = 0; i<=391; i++) {
		if ([ coco isEqualToString:storePic]) {
			[storeimage setImage:[UIImage imageNamed:@"coco.jpeg"]];
			
			
		}else if([coffee isEqualToString:storePic]) {
			[storeimage setImage:[UIImage imageNamed:@"85.jpeg"]];
			

		}else if([ComeBuy isEqualToString:storePic]) {
			[storeimage setImage:[UIImage imageNamed:@"COMEBUY.jpeg"]];
			
		}
		else if([Haagen isEqualToString:storePic]) {
			[storeimage setImage:[UIImage imageNamed:@"Haagen-Dazs.jpeg"]];
		}
		else if([isCoffee isEqualToString:storePic]) {
			[storeimage setImage:[UIImage imageNamed:@"IS-COFFEE.jpeg"]];
		}
		else if([rido isEqualToString:storePic]) {
			[storeimage setImage:[UIImage imageNamed:@"rido-coffee里豆咖啡.jpeg"]];

		}else if([l18 isEqualToString:storePic]) {
			[storeimage setImage:[UIImage imageNamed:@"傳奇18.jpeg"]];
			
		}else if([startBucks isEqualToString:storePic]) {
			[storeimage setImage:[UIImage imageNamed:@"星巴克.jpeg"]];

		}else if([feet isEqualToString:storePic]) {
			[storeimage setImage:[UIImage imageNamed:@"歇腳亭.jpeg"]];
			
		}else if([water isEqualToString:storePic]) {
			[storeimage setImage:[UIImage imageNamed:@"水龜伯.jpeg"]];

		}else if([lightHeart isEqualToString:storePic]) {
			[storeimage setImage:[UIImage imageNamed:@"清心.jpeg"]];

		}else if([mos isEqualToString:storePic]) {
			[storeimage setImage:[UIImage imageNamed:@"磨斯漢堡.jpeg"]];

		}else if([god isEqualToString:storePic]) {
			[storeimage setImage:[UIImage imageNamed:@"鮮芋仙.jpeg"]];

		}else if([macdonald isEqualToString:storePic]) {
			[storeimage setImage:[UIImage imageNamed:@"麥當勞.jpeg"]];

		}else if([skypeo isEqualToString:storePic]) {
			[storeimage setImage:[UIImage imageNamed:@"天人茶.jpeg"]];

		}

	}
	
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
