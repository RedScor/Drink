//
//  distance.m
//  非喝不渴
//
//  Created by Yuan Ruo-Jiun on 11/10/25.
//  Copyright (c) 2011年 yuanruo@gmail.com. All rights reserved.
//

#import "distance.h"

@implementation distance
@synthesize sqliteDis,string,string1,items,myTableView,result;

- (void)dealloc {
	
	[result release];
	[string release];
	[string1 release];
	[sqliteDis release];
	[self.myTableView release];
	[items release];
	[super dealloc];
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
	items=[[NSMutableArray alloc] initWithCapacity:0];
	for (int i=0; i<10; i++) {
		[items addObject:[NSNull null]];
	}
	sqliteDis = [[[Sqlite alloc]init]autorelease];

	locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate=self; 
	
    latit = locationManager.location.coordinate.latitude;
    longit = locationManager.location.coordinate.longitude;
	
	NSString *latitudeTwo,*longitudeTwo;
	
	storeData = [[NSMutableArray alloc]init];
	storeResult = [[NSMutableArray alloc]init];
	//NSMutableArray *storeData1 = [[NSMutableArray alloc]init];
	for (int i=0; i<=391; i++) {
		latitudeTwo = [[sqliteDis.transferarray objectAtIndex:i]objectAtIndex:3];
		longitudeTwo = [[sqliteDis.transferarray objectAtIndex:i]objectAtIndex:4];
		
		latit2 = [latitudeTwo doubleValue];
		longit2 = [longitudeTwo doubleValue];
		
		DistanceTwo = LantitudeLongitudeDist(latit, longit, latit2, longit2);
		Distancedouble = (double)DistanceTwo / 1000 ;
		
		//公尺
		string1 = [NSString stringWithFormat:@"%d",DistanceTwo];
		//公里
		string = [NSString stringWithFormat:@"%2.2f",Distancedouble];
		
		[[sqliteDis.transferarray objectAtIndex:i] addObject:string];
		[[sqliteDis.transferarray objectAtIndex:i] addObject:string1];

		NSMutableDictionary *dict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
								   [[sqliteDis.transferarray objectAtIndex:i]objectAtIndex:0],@"storeName",
								   [[sqliteDis.transferarray objectAtIndex:i]objectAtIndex:6],@"DisA",
								   [[sqliteDis.transferarray objectAtIndex:i]objectAtIndex:7],@"DisB",nil];
		[storeData addObject:dict];
		
	}	

	NSSortDescriptor *description = [[[NSSortDescriptor alloc]initWithKey:@"DisA" ascending:YES]autorelease];	
	NSArray *sortdescriptors;
	sortdescriptors = [NSArray arrayWithObject:description];
	result = [storeData sortedArrayUsingDescriptors:sortdescriptors];
	NSMutableDictionary *dict = [[[NSMutableDictionary alloc]init]autorelease];
	for (int i=0; i<392; i++) {
		
		dict = [result objectAtIndex:i];
		//NSLog(@"data is = %@",[dict objectForKey:@"storeName"]);
		
		[storeResult addObject:[NSNull null]];

	NSMutableArray *tempResult=[NSMutableArray arrayWithObjects:[dict objectForKey:@"storeName"]
								,[dict objectForKey:@"DisA"],[dict objectForKey:@"DisB"], nil];
		[storeResult replaceObjectAtIndex:i withObject:tempResult];
				   
	[dict release];			   
	}
}

#define PI 3.1415926

double LantitudeLongitudeDist(double lon1,double lat1,
							  double lon2,double lat2)
{
	double er = 6378137; // 6378700.0f;
	//ave. radius = 6371.315 (someone said more accurate is 6366.707)
	//equatorial radius = 6378.388
	//nautical mile = 1.15078
	double radlat1 = PI*lat1/180.0f;
	double radlat2 = PI*lat2/180.0f;
	
	//now long.
	double radlong1 = PI*lon1/180.0f;
	double radlong2 = PI*lon2/180.0f;
	
	if( radlat1 < 0 ) radlat1 = PI/2 + fabs(radlat1);// south
	if( radlat1 > 0 ) radlat1 = PI/2 - fabs(radlat1);// north
	if( radlong1 < 0 ) radlong1 = PI*2 - fabs(radlong1);//west
	
	if( radlat2 < 0 ) radlat2 = PI/2 + fabs(radlat2);// south
	if( radlat2 > 0 ) radlat2 = PI/2 - fabs(radlat2);// north
	if( radlong2 < 0 ) radlong2 = PI*2 - fabs(radlong2);// west
	
	//spherical coordinates x=r*cos(ag)sin(at), y=r*sin(ag)*sin(at), z=r*cos(at)
	//zero ag is up so reverse lat
	double x1 = er * cos(radlong1) * sin(radlat1);
	double y1 = er * sin(radlong1) * sin(radlat1);
	double z1 = er * cos(radlat1);
	
	double x2 = er * cos(radlong2) * sin(radlat2);
	double y2 = er * sin(radlong2) * sin(radlat2);
	double z2 = er * cos(radlat2);
	
	double d = sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)+(z1-z2)*(z1-z2));
	
	//side, side, side, law of cosines and arccos
	double theta = acos((er*er+er*er-d*d)/(2*er*er));
	double dist  = theta*er;
	
	return dist;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
	items=nil;
	self.myTableView=nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    int count = [items count];
	return  count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	//sqliteDis = [[[Sqlite alloc]init]autorelease];
	
    static NSString *CellIdentifier = @"Cell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		
    } 
	if([indexPath row] == ([items count])) {
		//创建loadMoreCell
		cell.textLabel.text=@"More..";
	}else {
        //cell.textLabel.text = [[storeData objectAtIndex:indexPath.row]
							   //objectAtIndex:0];
		cell.textLabel.text = [[storeResult objectAtIndex:indexPath.row]objectAtIndex:0];
		if ([[[storeResult objectAtIndex:indexPath.row]objectAtIndex:1] doubleValue]>=1){
			cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ 公里",[[storeResult objectAtIndex:indexPath.row]objectAtIndex:1]];
		} else{
			cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ 公尺",[[storeResult objectAtIndex:indexPath.row]objectAtIndex:2]];
	}


	}
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == [items count]) {
		UITableViewCell *loadMoreCell=[tableView cellForRowAtIndexPath:indexPath];
		loadMoreCell.textLabel.text=@"loading more …";
		[self performSelectorInBackground:@selector(loadMore) withObject:nil];
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		return;
	}

}
-(void)loadMore
{
	NSMutableArray *more;
	more=[[NSMutableArray alloc] initWithCapacity:0];
	for (int i=0; i<10; i++) {
		[more addObject:[storeResult objectAtIndex:i]];
	}
	
	//加载你的数据
	[self performSelectorOnMainThread:@selector(appendTableWith:) withObject:more waitUntilDone:NO];

	[more release];
}
-(void) appendTableWith:(NSMutableArray *)data
{
	for (int i=0;i<[data count];i++) {
		[items addObject:[data objectAtIndex:i]];
		
	}

	NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:10];
	for (int ind = 0; ind < [data count]; ind++) {
		NSIndexPath    *newPath =  [NSIndexPath indexPathForRow:[items indexOfObject:[data objectAtIndex:ind]] inSection:0];
		[insertIndexPaths addObject:newPath];
		
	}
	[self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
	
}

@end
