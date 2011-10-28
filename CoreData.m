//
//  CoreData.m
//  非喝不渴
//
//  Created by Liao Jim on 11/10/23.
//  Copyright 2011年 yuanruo@gmail.com. All rights reserved.
//

#import "CoreData.h"
#import <CoreData/CoreData.h>
@implementation CoreData

- (id)init
{
    self = [super init];
    if (self) {
        NSURL *url = [NSURL fileURLWithPath:@"book.squlite"];
        NSArray *bundle = [NSArray arrayWithObject:[NSBundle mainBundle]];
        NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:bundle];
        
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        
        NSError *error = nil;
        [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    
        NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc]init];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    
    }
    
    return self;
}

@end
