//
//  Animation.m
//  飲み物
//
//  Created by Liao Jim on 11/10/22.
//  Copyright 2011年 yuanruo@gmail.com. All rights reserved.
//

#import "Animation.h"
#import <QuartzCore/QuartzCore.h>

NSTimeInterval const kAnimation_Duration = 1.5;

@implementation Animation

#define CGAutorelease(x) (__typeof(x))[NSMakeCollectable(x) autorelease]

- (void)begin {
    
    [self beginWithCompletion:nil];

}

- (void) beginWithCompletion:(void (^)(void))aBlock {
    
    UIImageView *contentView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	contentView.image = [UIImage imageNamed:@"WellcomeView.png"];
	contentView.userInteractionEnabled = YES;
	self.view = contentView;
	[contentView release];
    
    // create the reflection layer
    CALayer *reflectionLayer = [CALayer layer];
    reflectionLayer.contents = [self.view layer].contents; // share the contents image with the screen layer
    reflectionLayer.opacity = 0.4;
    reflectionLayer.frame = CGRectOffset([self.view layer].frame, 0.5, 416.0f + 0.5); // NSHeight(displayBounds)
    reflectionLayer.transform = CATransform3DMakeScale(1.0, -1.0, 1.0); // flip the y-axis
    reflectionLayer.sublayerTransform = reflectionLayer.transform;
    [[self.view layer] addSublayer:reflectionLayer];
	
	// create a shadow layer which lies on top of the reflection layer
    CALayer *shadowLayer = [CALayer layer];
    shadowLayer.frame = reflectionLayer.bounds;
    shadowLayer.delegate = self;
    [shadowLayer setNeedsDisplay]; 
    [reflectionLayer addSublayer:shadowLayer];
	
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:kAnimation_Duration] forKey:kCATransactionAnimationDuration];
	
    // scale it down
    CABasicAnimation *shrinkAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    shrinkAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    shrinkAnimation.toValue = [NSNumber numberWithFloat:0.0];
    shrinkAnimation.fillMode = kCAFillModeForwards;
    shrinkAnimation.removedOnCompletion = NO;
	[[self.view layer] addAnimation:shrinkAnimation forKey:@"shrinkAnimation"];
	
	// fade it out
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.toValue = [NSNumber numberWithFloat:0.0];
    fadeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    fadeAnimation.fillMode = kCAFillModeForwards;
    fadeAnimation.removedOnCompletion = NO;
    [[self.view layer] addAnimation:fadeAnimation forKey:@"fadeAnimation"];
	
	// make it jump a couple of times
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef positionPath = CGAutorelease(CGPathCreateMutable());
    CGPathMoveToPoint(positionPath, NULL, [self.view layer].position.x, [self.view layer].position.y);
    CGPathAddQuadCurveToPoint(positionPath, NULL, [self.view layer].position.x, - [self.view layer].position.y, [self.view layer].position.x, [self.view layer].position.y);
    CGPathAddQuadCurveToPoint(positionPath, NULL, [self.view layer].position.x, - [self.view layer].position.y * 1.5, [self.view layer].position.x, [self.view layer].position.y);
    CGPathAddQuadCurveToPoint(positionPath, NULL, [self.view layer].position.x, - [self.view layer].position.y * 2.0, [self.view layer].position.x, [self.view layer].position.y);
    positionAnimation.path = positionPath;
    positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    positionAnimation.fillMode = kCAFillModeForwards;
    positionAnimation.removedOnCompletion = NO;
    [[self.view layer] addAnimation:positionAnimation forKey:@"positionAnimation"];
    
	[CATransaction commit];
    
    if (aBlock) {
        dispatch_after(
            dispatch_time(DISPATCH_TIME_NOW, kAnimation_Duration * NSEC_PER_SEC),
            dispatch_get_main_queue(),
            aBlock
        );
    }
    
}


@end

