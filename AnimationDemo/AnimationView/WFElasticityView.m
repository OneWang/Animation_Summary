//
//  WFElasticityView.m
//  AnimationDemo
//
//  Created by Jack on 2018/3/29.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import "WFElasticityView.h"

static const CGFloat fixedDistance = -100;

@interface WFElasticityView ()<CAAnimationDelegate>
/** CAShapeLayer */
@property (strong, nonatomic) CAShapeLayer *pathLayer;
/** 绑定的scrollerView */
@property (weak, nonatomic) UIScrollView *scrollerView;
/** 偏移量 */
@property (assign, nonatomic) CGFloat offsetY;
@end

@implementation WFElasticityView

- (instancetype)initWithBlindScrollView:(UIScrollView *)scrollView{
    if (self = [super initWithFrame:CGRectZero]) {
        _scrollerView = scrollView;
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [UIColor orangeColor];
    _pathLayer = [[CAShapeLayer alloc] initWithLayer:self.layer];
    _pathLayer.path = [self calculateAnimationPathWithContentOffsetY:0];
    _pathLayer.fillColor = [UIColor orangeColor].CGColor;
    [self.layer addSublayer:_pathLayer];
    
    //监听scrollView的偏移量
    [_scrollerView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionInitial context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"] && [object isKindOfClass:[UIScrollView class]]) {
        _offsetY = self.scrollerView.contentOffset.y;
        self.frame = CGRectMake(0, _offsetY >= 0 ? 0 : _offsetY, self.scrollerView.bounds.size.width, _offsetY >=0 ? 0 : ABS(_offsetY));
        if (_scrollerView.dragging || _offsetY > fixedDistance) {
            _pathLayer.path = [self calculateAnimationPathWithContentOffsetY:-self.offsetY];
        }
        
        if (_offsetY <= fixedDistance) {
            if (!_scrollerView.isDragging) {
                [self addElasticityAnimation];
            }else{
//                [_scrollerView setContentOffset:CGPointMake(0, fixedDistance) animated:NO];
            }
        }else{
            [_scrollerView setContentOffset:CGPointMake(0, fixedDistance) animated:NO];
//            [_pathLayer removeAllAnimations];
        }
    }
}

//计算动画的路径
- (CGPathRef)calculateAnimationPathWithContentOffsetY:(CGFloat)offsetY{
    CGPoint topLeft = CGPointMake(0, 0);
    CGPoint topRight = CGPointMake(K_Screen_Width, 0);
    CGPoint bottomLeft = CGPointMake(0, _offsetY <= fixedDistance ? 100 : _offsetY);
    CGPoint bottomRight = CGPointMake(K_Screen_Width, _offsetY <= fixedDistance ? 100 : _offsetY);
    CGPoint controlPoint = CGPointMake(K_Screen_Width * 0.5, offsetY);
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:topLeft];
    [bezierPath addLineToPoint:bottomLeft];
    [bezierPath addQuadCurveToPoint:bottomRight controlPoint:controlPoint];
    [bezierPath addLineToPoint:topRight];
    [bezierPath closePath];
    return bezierPath.CGPath;
}

//添加序列帧动画
- (void)addElasticityAnimation{
    _pathLayer.path = [self calculateAnimationPathWithContentOffsetY:ABS(fixedDistance)];
    NSArray *pathValues = @[
                            (__bridge id)[self calculateAnimationPathWithContentOffsetY:ABS(_offsetY)],
                            (__bridge id)[self calculateAnimationPathWithContentOffsetY:ABS(fixedDistance) * 0.7],
                            (__bridge id)[self calculateAnimationPathWithContentOffsetY:ABS(fixedDistance) * 1.3],
                            (__bridge id)[self calculateAnimationPathWithContentOffsetY:ABS(fixedDistance) * 0.9],
                            (__bridge id)[self calculateAnimationPathWithContentOffsetY:ABS(fixedDistance) * 1.1],
                            (__bridge id)[self calculateAnimationPathWithContentOffsetY:ABS(fixedDistance)]
                            ];
    CAKeyframeAnimation *elasticAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    elasticAnimation.values = pathValues;
    elasticAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    elasticAnimation.duration = 1;
    elasticAnimation.fillMode = kCAFillModeForwards;
    elasticAnimation.removedOnCompletion = NO;
    elasticAnimation.delegate = self;
    [_pathLayer addAnimation:elasticAnimation forKey:@"elasticAnimation"];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag) {
        _pathLayer.path = [self calculateAnimationPathWithContentOffsetY:ABS(fixedDistance)];
        [_pathLayer removeAnimationForKey:@"elasticAnimation"];
    }
}

- (void)dealloc{
    [_scrollerView removeObserver:self forKeyPath:@"contentOffset"];
}

@end
