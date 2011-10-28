//
//  Book.h
//  非喝不渴
//
//  Created by Jim Liao on 11/10/24.
//  Copyright (c) 2011年 yuanruo@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Book : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * Author;
@property (nonatomic, retain) NSString * BackImage;
@property (nonatomic, retain) NSString * BriefIntroducation;
@property (nonatomic, retain) NSString * Date;
@property (nonatomic, retain) NSString * ID;
@property (nonatomic, retain) NSString * Name;
@property (nonatomic, retain) NSString * publishHouse;

@end
