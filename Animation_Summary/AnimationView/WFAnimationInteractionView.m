//
//  WFAnimationInteractionView.m
//  Animation_Summary
//
//  Created by Jack on 2020/6/5.
//  Copyright © 2020 Jack. All rights reserved.
//

#import "WFAnimationInteractionView.h"

@implementation WFAnimationInteractionView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    NSLog(@"点击 test");
    
    CGPoint locationPoint = [self.layer convertPoint:point toLayer:self.layer.presentationLayer];
    CALayer *layer = self.layer.presentationLayer;
    if(CGRectContainsPoint(layer.bounds, locationPoint)){
        return self;
    }
    
    if (!self.layer.presentationLayer) {
        return [super hitTest:point withEvent:event];
    }
    return nil;
}

@end

@implementation WFAnimtaionButton

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    CGPoint locationPoint = [self.layer convertPoint:point toLayer:self.layer.presentationLayer];
//    CALayer *layer = self.layer.presentationLayer;
//    if(CGRectContainsPoint(layer.bounds, locationPoint)){
//        return self;
//    }
//    
//    if (!self.layer.presentationLayer) {
//        return [super hitTest:point withEvent:event];
//    }
//    return nil;
//}

@end
