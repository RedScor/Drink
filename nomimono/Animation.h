//
//  Animation.h
//  飲み物
//
//  Created by Liao Jim on 11/10/22.
//  Copyright 2011年 yuanruo@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSTimeInterval const kAnimation_Duration;

@interface Animation : UIViewController

- (void) begin;
- (void) beginWithCompletion:(void(^)(void))aBlock;

@end
