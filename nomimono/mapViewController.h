//
//  mapViewController.h
//  nomimono
//
//  Created by JimLiao on 11/10/7.
//  Copyright 2011年 jimliao@thlight.com All rights reserved.
//

#import <UIKit/UIKit.h>
#import <mapkit/mapkit.h>
#import <CoreLocation/CoreLocation.h>
#import "Sqlite.h"


@class detailViewController;
@class placePin;

@interface mapViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>
{
    MKMapView *myMap;
    int temp;
	detailViewController* userProfileVC; 

	CLLocationManager *locationManager;
}
//
@property (nonatomic,retain) IBOutlet detailViewController* userProfileVC; 


- (void)nowOnLocation;
- (IBAction) showDetail:(id)sender;

@end
