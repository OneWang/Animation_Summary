//
//  WFDisplayView.m
//  AnimationDemo
//
//  Created by Jack on 2018/3/28.
//  Copyright © 2018年 Jack. All rights reserved.
//  拖拽动画

#import "WFDisplayView.h"

@interface WFDisplayView (){
    CGFloat x;
    CGFloat y;
}
@property (nonatomic,strong) CAShapeLayer *shapeLayer;
@property (nonatomic,strong) UIBezierPath *movePath,*originPath;
@end

@implementation WFDisplayView

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [touches.anyObject locationInView:self];
    x = point.x;
    y = point.y;
    [self setNeedsDisplayView];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    y = 0;
    [self animation];
}

- (UIBezierPath *)configPathY:(CGFloat)y X:(CGFloat)x{
    CGFloat width = self.frame.size.width;
    [self.movePath removeAllPoints];
    [self.movePath moveToPoint:CGPointMake(0,0)];
    [self.movePath addLineToPoint:CGPointMake(width, 0)];
    [self.movePath addQuadCurveToPoint:CGPointMake(0, 0) controlPoint:CGPointMake(width * 0.5 , y)];
    return self.movePath;
}

//回退到顶部
- (void)animation{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.duration = 0.5;
    animation.fromValue = (__bridge id _Nullable)(self.movePath.CGPath);
    animation.toValue = (__bridge id _Nullable)(self.originPath.CGPath);
    //移动后位置保持结束后的状态
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [self.shapeLayer addAnimation:animation forKey:nil];
}

//刷新path
- (void)setNeedsDisplayView{
    //除移之前的
    [self.shapeLayer removeFromSuperlayer];
    
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);//设置shapeLayer的尺寸和位置
    self.shapeLayer.fillColor = [UIColor orangeColor].CGColor;//填充颜色为ClearColor
    //设置线条的宽度和颜色
    self.shapeLayer.lineWidth = 1.0f;
    self.shapeLayer.strokeColor = [UIColor clearColor].CGColor;
    //让贝塞尔曲线与CAShapeLayer产生联系
    self.shapeLayer.path = [self configPathY:y X:x].CGPath;
    //添加并显示
    [self.layer addSublayer:self.shapeLayer];
}

- (void)setOffsetY:(CGFloat)offsetY{
    _offsetY = offsetY;
    y = -offsetY;
    if (offsetY <= 60) {
        [self setNeedsDisplayView];
    }
    if (y < 0) {
        y = 0;
        [self setNeedsDisplayView];
    }
}

- (UIBezierPath *)movePath{
    if (!_movePath){
        _movePath = [UIBezierPath bezierPath];
    }
    return _movePath;
}

- (UIBezierPath *)originPath{
    if (!_originPath){
        CGFloat width = self.frame.size.width;
        _originPath = [UIBezierPath bezierPath];
        [_originPath moveToPoint:CGPointMake(0,0)];
        [_originPath addLineToPoint:CGPointMake(width, 0)];
        [_originPath addQuadCurveToPoint:CGPointMake(0, 0) controlPoint:CGPointMake(width * 0.5, 0)];
    }
    return _originPath;
}

@end
