//
//  WFCircleAnimationView.m
//  Animation_Summary
//
//  Created by Jack on 2018/8/16.
//  Copyright © 2018年 Jack. All rights reserved.
//

#define RGBACOLOR(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#import "WFCircleAnimationView.h"

@interface WFCircleAnimationView ()

@end

@implementation WFCircleAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.f].CGColor; //圆环底色
        layer.frame = self.bounds;
        
        //创建一个圆环
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(frame.size.width * 0.5, frame.size.height * 0.5) radius:40 startAngle:0 endAngle:M_PI*2 clockwise:YES];
        
        //圆环遮罩
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.strokeColor = [UIColor redColor].CGColor;
        shapeLayer.lineWidth = 2;
        shapeLayer.strokeStart = 0;
        shapeLayer.strokeEnd = 0.4;
        shapeLayer.lineCap = kCALineCapRound;
        shapeLayer.lineDashPhase = 0.8;
        shapeLayer.path = bezierPath.CGPath;
        
        //颜色渐变
        NSMutableArray *colors = [NSMutableArray arrayWithObjects:(__bridge id)RGBACOLOR(229, 30, 119, 1).CGColor,(__bridge id)[UIColor colorWithWhite:1 alpha:0].CGColor, nil];
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.shadowPath = bezierPath.CGPath;
        gradientLayer.frame = self.bounds;
        gradientLayer.startPoint = CGPointMake(0, 1);
        gradientLayer.endPoint = CGPointMake(1, 0);
        [gradientLayer setColors:colors];
        [layer addSublayer:gradientLayer]; //设置颜色渐变
        [layer setMask:shapeLayer]; //设置圆环遮罩
        [self.layer addSublayer:layer];
        
        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        rotationAnimation.fromValue = [NSNumber numberWithFloat:0];
        rotationAnimation.toValue = [NSNumber numberWithFloat:6.0 * M_PI];
        rotationAnimation.repeatCount = MAXFLOAT;
        rotationAnimation.duration = 4;
        rotationAnimation.removedOnCompletion = NO;
        [layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    }
    return self;
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim{
    NSLog(@"动画执行中");
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSLog(@"%d",flag);
}

@end
