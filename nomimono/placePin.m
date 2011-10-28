//
//  placePin.m
//  飲み物
//
//  Created by Yuan Ruo-Jiun on 11/10/11.
//  Copyright 2011年 yuanruo@gmail.com. All rights reserved.
//

#import "placePin.h"
#import "mapViewController.h"

@implementation placePin
@synthesize coordinate,title;
@synthesize subtitle;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coords {
    self = [super init];
    if (self != nil) coordinate = coords;
    
    return self;
}

- (void) dealloc {
    [title release];
    [subtitle release];
    
    [super dealloc];
}


@end
