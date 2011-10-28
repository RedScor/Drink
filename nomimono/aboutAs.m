//
//  aboutAs.m
//  飲み物
//
//  Created by JimLiao on 11/10/21.
//  Copyright (c) 2011年 jimliao@thlight.com All rights reserved.
//

#import "aboutAs.h"
#import <sqlite3.h>

@implementation aboutAs

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


//page controller methods
- (IBAction)pagechange :(id)sender{
    CurrentPage = [sender currentPage];
    CATransition *anim = [CATransition animation];
    [anim setDelegate:self];
    [anim setDuration:0.3f];
    [anim setTimingFunction:UIViewAnimationCurveEaseInOut];
    [anim setType:kCATransitionPush];
    if (CurrentPage>PrevPage) {
        [anim setSubtype:kCATransitionFromRight];
    } else {
        [anim setSubtype:kCATransitionFromLeft];
    }
    if (CurrentPage==0) {
        [self.view bringSubviewToFront:favo];
    } else{
        [self.view bringSubviewToFront:aboutus];
    }
    [[self.view layer] addAnimation:anim forKey:@"Tran"];
    PrevPage = CurrentPage;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    location =[touch locationInView:self.view];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch =[touches anyObject];
    CGPoint endlocation=[touch locationInView:self.view];
    CurrentPage =[pagecontroller currentPage];
    if (endlocation.x-location.x<0) {
        [pagecontroller setCurrentPage:CurrentPage+1];
        if(CurrentPage==1)
            return;
    } else {
        [pagecontroller setCurrentPage:CurrentPage-1];
        if (CurrentPage==0) {
            return;
        }
    }
    [self pagechange:pagecontroller];
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
//    dataSource = [[NSMutableArray alloc]init];
//    [self reloadfavo:self];
    // setting page controller
    CGRect frame =self.view.frame;
    [self.view addSubview:aboutus];
    [aboutus setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-100)];
    
    [self.view addSubview:favo];
    [favo setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-100)];
    
    PrevPage=0;
    
    //TableView Setting
    dataSource = [[NSArray alloc] initWithObjects:@"JimLiao",@"DaviDay",@"Rao",@"亦揮",nil];
    [TableView.tableFooterView setBackgroundColor:[UIColor clearColor]];
	[TableView.tableHeaderView setBackgroundColor:[UIColor clearColor]];
    [TableView setDelegate:self];
	[TableView reloadData];
    for (int section = 0; section < [TableView numberOfSections]; section++) {
		for (int row = 0; row < [TableView numberOfRowsInSection:section]; row++) {
			[[TableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]] setSelectionStyle:UITableViewCellSelectionStyleNone];
		}
	}
    
}


- (IBAction)reloadfavo :(id)sender{
    NSString *url = [[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:@"FavorateData.sqlite"];
    sqlite3 *database = nil;
    
    if (sqlite3_open([url UTF8String], &database) == SQLITE_OK) {
        NSLog(@"DB OK");
        //這裡寫入要對資料庫操作的程式碼
        
        //查閱所有資料內容
        const char *sql = "select * from FavoriateRecord";
        
        //stm將存放查詢結果
        sqlite3_stmt *stm =nil;
        
        int i=0;
        if (sqlite3_prepare_v2(database, sql, -1, &stm, NULL) == SQLITE_OK) {
            while (sqlite3_step(stm) == SQLITE_ROW) {
                
                NSLog(@"database ok");
                NSString *storeName, *address,*phone,*litlon,*storePic;
                
                storeName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stm, 1)];
                phone = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stm, 2)];
                address = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stm, 4)];
                litlon = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stm, 5)];
                storePic = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stm, 6)];
                double_t longitude, latitude;
                NSString *coordinatesString = litlon;
                NSArray *coordinateComponents = [coordinatesString componentsSeparatedByString:@","];
                if ([coordinateComponents count] == 2) {
                    longitude = [[coordinateComponents objectAtIndex:0] doubleValue];
                    latitude = [[coordinateComponents objectAtIndex:1] doubleValue];
                }
                //初始化一個null陣列
                [dataSource addObject:[NSNull null]];
                
                NSArray *temp=[NSArray arrayWithObjects:storeName,address,phone,[coordinateComponents objectAtIndex:0],
                               [coordinateComponents objectAtIndex:1],storePic, nil];
                
                [dataSource replaceObjectAtIndex:i withObject:temp];
                
                            NSLog(@"transferarray adding:\n - %@ \n - %@ \n - %@ \n - %@ \n - %@ \n - %@",
                				  [[dataSource objectAtIndex:i]objectAtIndex:0],
                				  [[dataSource objectAtIndex:i]objectAtIndex:1],
                				  [[dataSource objectAtIndex:i]objectAtIndex:2],
                				  [[dataSource objectAtIndex:i]objectAtIndex:3],
                				  [[dataSource objectAtIndex:i]objectAtIndex:4],
                				  [[dataSource objectAtIndex:i]objectAtIndex:5]
                				  );
                i++;
            }
            //使用完畢後將statement釋	
            sqlite3_finalize(stm);
        }
        
        //使用完畢後關閉資料庫連結
        sqlite3_close(database);
    }
}




#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"work");
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataSource count];
    
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	[cell.textLabel setText:(NSString *)[dataSource objectAtIndex:indexPath.row]];
	//[cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[UIView beginAnimations:@"animationID" context:nil];
	[UIView setAnimationDuration:0.5f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationRepeatAutoreverses:NO];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:[tableView cellForRowAtIndexPath:indexPath] cache:YES];
	
	[UIView commitAnimations];
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
