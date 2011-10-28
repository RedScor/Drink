//
//  placePin.h
//  飲み物
//
//  Created by Yuan Ruo-Jiun on 11/10/11.
//  Copyright 2011年 yuanruo@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface placePin : NSObject <MKAnnotation> {
    
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;


- (id)initWithCoordinate:(CLLocationCoordinate2D)coords;


@end
