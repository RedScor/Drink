//
//  Sqlite.h
//  飲み物
//
//  Created by Yuan Ruo-Jiun on 11/10/17.
//  Copyright (c) 2011年 yuanruo@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Sqlite : NSObject
{
    NSMutableArray *transferarray;
}

- (id) init;
@property(nonatomic,readwrite,retain) NSMutableArray *transferarray;

@end
