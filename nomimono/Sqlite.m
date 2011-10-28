//
//  Sqlite.m
//  飲み物
//
//  Created by Yuan Ruo-Jiun on 11/10/17.
//  Copyright (c) 2011年 yuanruo@gmail.com. All rights reserved.
//

#import "Sqlite.h"

@implementation Sqlite
@synthesize transferarray;


//設定資料庫檔案的路徑
- (id) init{
    
    self = [super init];
    if (!self) {
        return 0;
    }
    
    //Initial NSMutablearry memory
	transferarray = [[NSMutableArray alloc]init];

    NSString *url = [[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:@"Book.sqlite"];
sqlite3 *database = nil;

if (sqlite3_open([url UTF8String], &database) == SQLITE_OK) {
    NSLog(@"DB OK");
    //這裡寫入要對資料庫操作的程式碼
	
	//查閱所有資料內容
	const char *sql = "select * from Book";
	
	//stm將存放查詢結果
	sqlite3_stmt *stm =nil;
	
	int i=0;
	if (sqlite3_prepare_v2(database, sql, -1, &stm, NULL) == SQLITE_OK) {
		while (sqlite3_step(stm) == SQLITE_ROW) {
			
			NSString *storeName, *address,*phone,*litlon,*storePic;
			
			storeName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stm, 1)];
			
			
			if (!sqlite3_column_text(stm, 2) || [[NSString stringWithUTF8String:sqlite3_column_text(stm, 2)] isEqualToString:@"123"]) 
			{
				phone=@"Unkown!";
			}else{
				phone = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stm, 2)];
				}
			address = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stm, 4)];
			
			litlon = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stm, 5)];
			
			if (!sqlite3_column_text(stm, 6)) 
			{
				storePic=@"Unkown!";
			}else{
				storePic = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stm, 6)];
			}
			
			
			double_t longitude, latitude;
			NSString *coordinatesString = litlon;
			NSArray *coordinateComponents = [coordinatesString componentsSeparatedByString:@","];
			if ([coordinateComponents count] == 2) {
				longitude = [[coordinateComponents objectAtIndex:0] doubleValue];
				latitude = [[coordinateComponents objectAtIndex:1] doubleValue];
			}
			//NSLog(@"%f, %f", longitude, latitude);
			//初始化一個null陣列
			[transferarray addObject:[NSNull null]];
		
			
            NSMutableArray *temp=[NSMutableArray arrayWithObjects:storeName,address,phone,[coordinateComponents objectAtIndex:0],
				[coordinateComponents objectAtIndex:1],storePic, nil];
			
			[transferarray replaceObjectAtIndex:i withObject:temp];
		
//            NSLog(@"transferarray adding:\n - %@ \n - %@ \n - %@ \n - %@ \n - %@ \n - %@",
//				  [[transferarray objectAtIndex:i]objectAtIndex:0],
//				  [[transferarray objectAtIndex:i]objectAtIndex:1],
//				  [[transferarray objectAtIndex:i]objectAtIndex:2],
//				  [[transferarray objectAtIndex:i]objectAtIndex:3],
//				  [[transferarray objectAtIndex:i]objectAtIndex:4],
//				  [[transferarray objectAtIndex:i]objectAtIndex:5]
//				  );
			i++;
		}
		//使用完畢後將statement釋	
		sqlite3_finalize(stm);
	}

    //使用完畢後關閉資料庫連結
    sqlite3_close(database);
}
		return self;

}

- (void) setTransferarray:(NSMutableArray *)newTransferarray {
	
	if (transferarray == newTransferarray)
		return;
	
	[transferarray release];
	transferarray = [newTransferarray mutableCopy];
	

}


-(void)dealloc{
	
	[transferarray release];
    [super dealloc];
}

@end
