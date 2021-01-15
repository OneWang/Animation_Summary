//
//  WFLiveAnimationView.m
//  Animation_Summary
//
//  Created by Jack on 2020/5/18.
//  Copyright © 2020 Jack. All rights reserved.
//

#import "WFLiveAnimationView.h"

@implementation WFLiveAnimationView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        for(int i = 0; i < 3; i++) {
            CAShapeLayer *itemLine = [CAShapeLayer layer];
            itemLine.lineCap       = kCALineCapButt;
            itemLine.lineJoin      = kCALineJoinRound;
            itemLine.strokeColor   = [[UIColor clearColor] CGColor];
            itemLine.fillColor     = [[UIColor clearColor] CGColor];
//            itemLine.strokeColor   = [self.itemColor CGColor];
//            itemLine.lineWidth     = self.lineWidth;
//
//            [self.layer addSublayer:itemLine];
//            [self.itemLineLayers addObject:itemLine];
        }

        
    }
    return self;
}

@end
