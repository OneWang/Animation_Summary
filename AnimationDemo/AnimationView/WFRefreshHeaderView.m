//
//  WFRefreshHeaderView.m
//  AnimationDemo
//
//  Created by Jack on 2018/3/22.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import "WFRefreshHeaderView.h"

@interface WFRefreshHeaderView ()<CAAnimationDelegate>
/** 执行临时值 */
@property (assign, nonatomic) CGFloat execute;
/** 是否正在动画 */
@property (assign, nonatomic) BOOL isAnimation;
/** 参考view */
@property (weak, nonatomic) UIView *referenceView;
/** 定时器 */
@property (strong, nonatomic) CADisplayLink *displayLink;
/** 波浪path */
@property (strong, nonatomic) CAShapeLayer *wavaLayer;

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
    
    CAShapeLayer *waveLayer = [CAShapeLayer layer];
    waveLayer.backgroundColor = [UIColor greenColor].CGColor;
    self.wavaLayer = waveLayer;
    [self.layer addSublayer:waveLayer];
    UIView *reference = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 50)];
    _referenceView = reference;
    reference.backgroundColor = [UIColor orangeColor];
    [self addSubview:reference];
    
    [self startAnimation];
    [self startDownAnimation];
}

- (void)drawRect:(CGRect)rect{
//    UIColor *color = [UIColor purpleColor];
//    [color set];
//
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path moveToPoint:CGPointMake(0, 100)];
//    [path addQuadCurveToPoint:CGPointMake(self.bounds.size.width, 100) controlPoint:CGPointMake(self.bounds.size.width * 0.5, - _offsetY)];
//    [path closePath];
//
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextAddPath(context, path.CGPath);
//    [[UIColor redColor] set];
//    CGContextFillPath(context);
}

- (void)wave:(CGFloat)offsetY execute:(CGFloat)execute{
    _execute = execute;
    CAShapeLayer *waveLayer = [CAShapeLayer layer];
    waveLayer.path = [self wavePath:CGPointMake(0, offsetY)];
    if (!_isAnimation) {
        CGAffineTransform transform = CGAffineTransformIdentity;
        transform = CGAffineTransformTranslate(transform, 0, offsetY);
        _referenceView.transform = transform;
    }
}

- (CGPathRef)wavePath:(CGPoint)point{
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat width = self.frame.size.width;
    if (point.y < _execute) {
        [path moveToPoint:CGPointZero];
        [path addLineToPoint:CGPointMake(width, 0)];
        [path addLineToPoint:CGPointMake(width, point.y)];
        [path addLineToPoint:CGPointMake(0, point.y)];
        [path addLineToPoint:CGPointZero];
    }else {
        [path moveToPoint:CGPointZero];
        [path addLineToPoint:CGPointMake(width, 0)];
        [path addLineToPoint:CGPointMake(width, _execute)];
        [path addQuadCurveToPoint:CGPointMake(0, _execute) controlPoint:CGPointMake(width * 0.5, point.y)];
        [path addLineToPoint:CGPointZero];
    }
    return path.CGPath;
}

- (void)startAnimation{
    _isAnimation = YES;
    [self addDisplay];
    [self boundAnimation:CGPointMake(0, _execute)];
}

- (void)startDownAnimation{
    if (!_isAnimation) {
        _isAnimation = YES;
        [self addDisplay];
        [self boundDownAnimation:CGPointMake(0, _execute)];
    }
}

- (void)endAnimation{
    [self endAnimation];
}

- (void)addDisplay{
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayAcion)];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)removeDisplay{
    [_displayLink invalidate];
    _displayLink = nil;
}

- (void)displayAcion{
    CGRect frame = CGRectZero;
    if (NSStringFromCGRect(_referenceView.layer.presentationLayer.frame)) {
        frame = _referenceView.layer.presentationLayer.frame;
        dispatch_async(dispatch_get_main_queue(), ^{
            CGPathRef path = [self displayWavePath:CGPointMake(0, frame.origin.x + 25)];
            _wavaLayer.path = path;
        });
    }
}

- (CGPathRef)displayWavePath:(CGPoint)point{
    CGFloat width = self.frame.size.width;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointZero];
    [path addLineToPoint:CGPointMake(width, 0)];
    [path addLineToPoint:CGPointMake(width, _execute)];
    [path addQuadCurveToPoint:CGPointMake(0, _execute) controlPoint:CGPointMake(width * 0.5, point.y)];
    [path addLineToPoint:CGPointZero];
    return path.CGPath;
}

//开始弹簧动画
- (void)boundAnimation:(CGPoint)point{
    CAKeyframeAnimation *bounce = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    bounce.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    bounce.duration = 2.0;
    bounce.values = @[
                      @(_referenceView.frame.origin.y),
                      @(point.y * 0.5),
                      @(point.y * 1.2),
                      @(point.y * 0.8),
                      @(point.y * 1.1),
                      @(point.y)];
    bounce.fillMode = kCAFillModeForwards;
    bounce.delegate = self;
    [_referenceView.layer addAnimation:bounce forKey:@"return"];
}

//结束动画
- (void)endBoundAnimation{
    CABasicAnimation *end = [CABasicAnimation animationWithKeyPath:@"path"];
    end.duration = 0.25;
    end.fromValue = CFBridgingRelease([self wavePath:CGPointMake(0, _execute)]);
    end.toValue = (__bridge id _Nullable)([self wavePath:CGPointMake(0, 0)]);
    [_wavaLayer addAnimation:end forKey:@"end"];
}

- (void)boundDownAnimation:(CGPoint)point {
    CAKeyframeAnimation *bounce = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    bounce.timingFunction = [CAMediaTimingFunction functionWithName:@"kCAMediaTimingFunctionEaseIn"];
    bounce.duration = 1.f;
    bounce.values = @[@(point.y),
                     @(point.y * 1.1),
                     @(point.y)
                     ];
    bounce.fillMode = kCAFillModeForwards;
    bounce.delegate = self;
    [_referenceView.layer addAnimation:bounce forKey:@"returnDown"];
}


#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self removeDisplay];
    _isAnimation = NO;
}

@end
