//
//  nomimonoAppDelegate.h
//  nomimono
//
//  Created by JimLiao on 11/10/7.
//  Copyright 2011年 jimliao@thlight.com All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface nomimonoAppDelegate : NSObject <UIApplicationDelegate>
{

IBOutlet UITabBarController *TabBar;

}
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain, readwrite)IBOutlet UITabBarController *TabBar;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
- (NSURL *)applicationDocumentsDirectory;

@end
