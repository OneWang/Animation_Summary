//
//  WFParabolaAnimation.m
//  Animation_Summary
//
//  Created by Jack on 2019/3/22.
//  Copyright © 2019 Jack. All rights reserved.
//

#import "WFParabolaAnimation.h"

@implementation WFParabolaAnimation

+ (void)addParabolaAnimation:(UIImage *)animationView startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint completion:(void (^)(BOOL))completion{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.contents = (id)animationView.CGImage;
    shapeLayer.frame = CGRectMake(startPoint.x - 20, startPoint.y - 20, 40, 40);
    
    UIViewController *currentVC = [self getCurrentVC];
    [currentVC.view.layer addSublayer:shapeLayer];
    
    UIBezierPath *movePath = [UIBezierPath bezierPath];
    [movePath moveToPoint:startPoint];
    [movePath addQuadCurveToPoint:endPoint controlPoint:CGPointMake(200,100)];
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGFloat durationTime = 1;
    pathAnimation.duration = durationTime;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.path = movePath.CGPath;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:0.5];
    scaleAnimation.duration = 1.0;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fillMode = kCAFillModeForwards;
    
    [shapeLayer addAnimation:pathAnimation forKey:nil];
    [shapeLayer addAnimation:scaleAnimation forKey:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(durationTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [shapeLayer removeFromSuperlayer];
        completion(YES);
    });
}

+ (UIViewController *)getCurrentVC {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    return currentVC;
}

+ (UIViewController *)getCurrentVCFrom:(UIViewController*)rootVC {
    UIViewController *currentVC;
    if([rootVC presentedViewController]) {
        rootVC = [rootVC presentedViewController];
    }
    
    if([rootVC isKindOfClass:[UITabBarController class]]) {
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    }else if([rootVC isKindOfClass:[UINavigationController class]]){
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    }else{
        currentVC = rootVC;
    }
    return currentVC;
}


@end
