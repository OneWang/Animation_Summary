//
//  WFRefreshHeaderView.m
//  AnimationDemo
//
//  Created by Jack on 2018/3/22.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import "WFRefreshHeaderView.h"

@interface WFRefreshHeaderView ()

@end

@implementation WFRefreshHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [UIColor whiteColor];
    
//    CAShapeLayer *waveLayer = [CAShapeLayer layer];
//    UIView *reference = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 50)];
    
}

- (void)drawRect:(CGRect)rect{
    UIColor *color = [UIColor purpleColor];
    [color set];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
//    path.lineWidth = 1.f;
//    path.lineCapStyle = kCGLineCapRound;;
//    path.lineJoinStyle = kCGLineJoinRound;
    [path moveToPoint:CGPointMake(0, 100)];
    [path addQuadCurveToPoint:CGPointMake(self.bounds.size.width, 100) controlPoint:CGPointMake(self.bounds.size.width * 0.5, - _offsetY)];
    [path closePath];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, path.CGPath);
    [[UIColor redColor] set];
    CGContextFillPath(context);
}

- (void)wave:(CGFloat)offsetY execute:(CGFloat)execute{
    
}

@end
