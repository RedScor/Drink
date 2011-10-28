//
//  MADataStore.m
//  Map
//
//  Created by App on 2011/10/17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MADataStore.h"
#import <sqlite3.h>


NSString * const kMADataStore_hasPerformedInitialImport = @"MADataStore_hasPerformedInitialImport";


@interface MADataStore ()

@property (nonatomic, readonly, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, readonly, retain) NSManagedObjectModel *managedObjectModel;

@end


@implementation MADataStore
@synthesize persistentStoreCoordinator, managedObjectModel;

+ (id) defaultStore {

	static id returnedObject = nil;
	static dispatch_once_t onceToken = 0;
	dispatch_once(&onceToken, ^{
		returnedObject = [[self alloc] init];
	});

	return returnedObject;

}

- (void) dealloc {

	[persistentStoreCoordinator release];
	[managedObjectModel release];
	[super dealloc];

}

- (NSManagedObjectModel *) managedObjectModel {

	if (managedObjectModel)
		return managedObjectModel;
		
	NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
		
	managedObjectModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL] autorelease];
	
	return managedObjectModel;

}

- (NSPersistentStoreCoordinator *) persistentStoreCoordinator {

	if (persistentStoreCoordinator)
		return persistentStoreCoordinator;
	
	persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
	
	NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
	
	NSString *storeName = @"Book.sqlite";
	NSString *storePath = [documentsDirectory stringByAppendingPathComponent:storeName];
	
	NSError *storeAddingError = nil;
	if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:storePath] options:[NSDictionary dictionaryWithObjectsAndKeys:
	
		(id)kCFBooleanTrue, NSMigratePersistentStoresAutomaticallyOption,
		(id)kCFBooleanTrue, NSInferMappingModelAutomaticallyOption,
	
	nil] error:&storeAddingError]) {
	
		NSLog(@"error adding store: %@", storeAddingError);
	
	};
	
	return persistentStoreCoordinator;

}

- (NSManagedObjectContext *) disposableMOC {

	NSManagedObjectContext *returnedContext = [[[NSManagedObjectContext alloc] init] autorelease];
	
	returnedContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
	
	return returnedContext;

}

+ (BOOL) hasPerformedInitialImport {

	return [[NSUserDefaults standardUserDefaults] boolForKey:kMADataStore_hasPerformedInitialImport];

}

- (void) importData {

	NSManagedObjectContext *context = [self disposableMOC];
	
	NSURL *importedDatabaseURL = [[NSBundle mainBundle] URLForResource:@"Book" withExtension:@"sqlite"];
  
    NSParameterAssert([[NSFileManager defaultManager] fileExistsAtPath:[importedDatabaseURL path]]);
    
	sqlite3 *importedDatabase = nil;
	const char *importedDatabasePathUTF8String = [[importedDatabaseURL path] UTF8String];
	
	if (SQLITE_OK != sqlite3_open(importedDatabasePathUTF8String, &importedDatabase))
		return;
	
	void (^cleanup)(BOOL) = ^ (BOOL shouldSave) {

		sqlite3_close(importedDatabase);
		
		NSError *savingError = nil;
		if (![context save:&savingError])
			NSLog(@"Error saving: %@", savingError);
	
	};
	
	
	const char *query = "SELECT * FROM Book";
	__block sqlite3_stmt *statement =nil;

	if (SQLITE_OK != sqlite3_prepare_v2(importedDatabase, query, -1, &statement, NULL)) {

        

		cleanup(NO);
		return;
	}
		
	NSEntityDescription *bookEntity = [NSEntityDescription entityForName:@"Book" inManagedObjectContext:context];
    NSParameterAssert(bookEntity);

	NSNumber * (^fromBool)(int) = ^ (int aColumn) {
		return [NSNumber numberWithInt:sqlite3_column_bytes(statement, aColumn)];
	};	
	NSNumber * (^fromInt)(int) = ^ (int aColumn) {
		return [NSNumber numberWithInt:sqlite3_column_int(statement, aColumn)];
	};
	NSNumber * (^fromDouble)(int) = ^ (int aColumn) {
		return [NSNumber numberWithDouble:sqlite3_column_double(statement, aColumn)];
	};
	NSString * (^fromText)(int) = ^ (int aColumn) {
        
        if (!sqlite3_column_blob(statement, aColumn)) {
            return (NSString *)nil;
        }
        
		return (NSString *)[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, aColumn)];
        
	};
	NSDate * (^fromDate)(int) = ^ (int aColumn) {
		static NSString * const kDateFormatter = @"MADataStoreImportingDateFormatter";		
		NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
		NSDateFormatter *modificationDateFormatter = [threadDictionary objectForKey:kDateFormatter];
		if (!modificationDateFormatter) {
			modificationDateFormatter = [[[NSDateFormatter alloc] init] autorelease];
			[modificationDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
			[threadDictionary setObject:modificationDateFormatter forKey:kDateFormatter];
		}
		return [modificationDateFormatter dateFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, aColumn)]];
	};

	while (SQLITE_ROW == sqlite3_step(statement)) {
		
		Book *insertedBook = [[[Book alloc] initWithEntity:bookEntity insertIntoManagedObjectContext:context] autorelease];
		
		insertedBook.ID                 = fromText(0);	
		insertedBook.Name               = fromText(1);
        insertedBook.publishHouse       = fromText(2);
        insertedBook.Author             = fromText(3);
        insertedBook.BriefIntroducation        = fromText(4);
        insertedBook.Date               = fromText(5);
        insertedBook.BackImage          = fromText(6);
		

	}
	
	BOOL didFinalize = (SQLITE_OK == sqlite3_finalize(statement));
	cleanup(didFinalize);
	
	if (didFinalize) {
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:kMADataStore_hasPerformedInitialImport];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}

}



@end
