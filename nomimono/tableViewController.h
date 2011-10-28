//
//  tableViewController.h
//  nomimono
//
//  Created by JimLiao on 11/10/7.
//  Copyright 2011年 jimliao@thlight.com All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface tableViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *context;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *context;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;

@end
