//
//  WFRefreshHeaderView.m
//  AnimationDemo
//
//  Created by Jack on 2018/3/22.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import "WFRefreshHeaderView.h"

@implementation WFRefreshHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [UIColor yellowColor];
}

- (void)drawRect:(CGRect)rect{
    UIColor *color = [UIColor purpleColor];
    [color set];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 5.f;
    path.lineCapStyle = kCGLineCapRound;;
    path.lineJoinStyle = kCGLineJoinRound;
    [path moveToPoint:CGPointMake(10, 20)];
//    [path addQuadCurveToPoint:CGPointMake(90, 85) controlPoint:CGPointMake(60, 80)];
    [path addCurveToPoint:CGPointMake(10, 10) controlPoint1:CGPointMake(20, 25) controlPoint2:CGPointMake(96, 90)];
    [path stroke];
}

@end
