//
//  distance.h
//  非喝不渴
//
//  Created by Yuan Ruo-Jiun on 11/10/25.
//  Copyright (c) 2011年 yuanruo@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Sqlite.h"

@interface distance : UITableViewController<CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource>{
	
	CLLocationManager *locationManager;
	Sqlite *sqliteDis;
	NSString *string,*string1;
	double latit,longit,latit2,longit2;
	int DistanceTwo;
	double Distancedouble;
	IBOutlet UITableView *myTableView;
	NSMutableArray *items;
	NSMutableArray *storeData;
	NSMutableArray *storeResult;

	NSArray *result;
//	NSMutableDictionary *dict;
}

@property (nonatomic,retain) UITableView *myTableView;
@property (nonatomic,retain) NSMutableArray *items;
@property (nonatomic,retain) NSArray *result;
//@property (nonatomic,retain) NSMutableDictionary *dict;
@property(nonatomic,readwrite, retain)	Sqlite *sqliteDis;
@property(nonatomic,retain)NSString *string;
@property(nonatomic,retain)NSString *string1;

double LantitudeLongitudeDist(double lon1,double lat1,
									 double lon2,double lat2);
@end

