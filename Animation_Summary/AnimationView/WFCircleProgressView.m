//
//  WFCircleProgressView.m
//  AnimationDemo
//
//  Created by Jack on 2018/3/20.
//  Copyright © 2018年 Jack. All rights reserved.
//  圆环进度条

#import "WFCircleProgressView.h"

@interface WFCircleProgressView ()

/** 进度条layer */
@property (strong, nonatomic) CAShapeLayer *progressLayer;
/** 进度label */
@property (strong, nonatomic) UILabel *progressLabel;
/** 结束点的view */
@property (strong, nonatomic) UIImageView *endView;
/** 进度条颜色 */
@property (strong, nonatomic) UIColor *backColor;
/** 渐变层 */
@property (nonatomic, weak) CAGradientLayer *gradientLayer;

@end

@implementation WFCircleProgressView

- (instancetype)initWithFrame:(CGRect)frame lineWidth:(CGFloat)lineWidth progressColor:(UIColor *)progressColor backgroundColor:(UIColor *)backgroundColor{
    if (self = [super initWithFrame:frame]) {
        _lineWidth = lineWidth;
        _backColor = backgroundColor;
        _progressColor = progressColor;
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [UIColor whiteColor];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat centerX = width * 0.5;
    CGFloat centerY = height * 0.5;
    //半径
    CGFloat radius = (width - _lineWidth) * 0.5;
    //创建贝塞尔路径
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:-0.5f * M_PI endAngle:1.5f * M_PI clockwise:YES];
    
    //添加背景圆环
    CAShapeLayer *backLayer = [CAShapeLayer layer];
    backLayer.frame = self.bounds;
    backLayer.fillColor = [UIColor clearColor].CGColor;
    backLayer.strokeColor = _backColor.CGColor;
    backLayer.lineWidth = _lineWidth;
    backLayer.path = [path CGPath];
    backLayer.strokeEnd = 1;
    [self.layer addSublayer:backLayer];
    
    //创建进度layer
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.frame = self.bounds;
    _progressLayer.fillColor = [UIColor clearColor].CGColor;
    //指定path的渲染颜色
    _progressLayer.strokeColor = _progressColor.CGColor;
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.lineWidth = _lineWidth;
    _progressLayer.path = [path CGPath];
    _progressLayer.strokeEnd = 0;
    [self.layer addSublayer:_progressLayer];
    
    //添加渐变色
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    _gradientLayer = gradientLayer;
    gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor, (__bridge id)[UIColor greenColor].CGColor];
    gradientLayer.frame = self.bounds;
    [backLayer addSublayer:gradientLayer];
    gradientLayer.mask = _progressLayer;
    
    //设置显示进度 label
    _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [self addSubview:_progressLabel];
    _progressLabel.text = @"0%";
    _progressLabel.center = CGPointMake(width * 0.5, height * 0.5);
    _progressLabel.font = [UIFont boldSystemFontOfSize:15];
    _progressLabel.textAlignment = NSTextAlignmentCenter;
    
    //用于显示结束位置的小点
    _endView = [[UIImageView alloc] init];
    _endView.frame = CGRectMake(0, 0, _lineWidth - 1 * 2,_lineWidth - 1 * 2);
    _endView.hidden = YES;
    _endView.backgroundColor = [UIColor blackColor];
    _endView.image = [UIImage imageNamed:@"arrow_right_44px"];
    _endView.layer.masksToBounds = YES;
    _endView.layer.cornerRadius = _endView.bounds.size.width/2;
    [self addSubview:_endView];
}

- (void)addAnimationLayer:(CAShapeLayer *)layer{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration  = 1.0f;
    animation.fromValue = @0;
    animation.toValue   = @1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [layer addAnimation:animation forKey:nil];
}

#pragma maark - setter and geter
- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    _gradientLayer.locations = @[@(0),@(progress)];
    _progressLayer.strokeColor = _progressColor.CGColor;
    _progressLayer.strokeEnd = progress;
    [_progressLayer removeAllAnimations];
    _progressLabel.text = [NSString stringWithFormat:@"%.0f%%",_progress * 100];
    [self updateEndPoint];
//    [self addAnimationLayer:_progressLayer];
}

- (void)updateEndPoint{
    CGFloat width = self.frame.size.width;
    //将进度转换成弧度
    CGFloat angel = M_PI * 2 * _progress;
    //半径
    CGFloat radius = (width - _lineWidth) * 0.5;
    //区分用户在第几象限
    int index = angel /M_PI_2;
    //用户计算圆环点上的坐标的角度
    float needAngle = angel - index * M_PI_2;
    float x = 0,y = 0;
    switch (index) {
        case 0:
            x = radius + sinf(needAngle) * radius;
            y = radius - cosf(needAngle) * radius;
            break;
        case 1:
            x = radius + cosf(needAngle) * radius;
            y = radius + sinf(needAngle) * radius;
            break;
        case 2:
            x = radius - sinf(needAngle) * radius;
            y = radius + cosf(needAngle) * radius;
            break;
        case 3:
            x = radius - cosf(needAngle) * radius;
            y = radius - sinf(needAngle) * radius;
            break;
        default:
            break;
    }
    //更新圆环位置
    CGAffineTransform transform = CGAffineTransformMakeTranslation(x, y);
    transform = CGAffineTransformRotate(transform, angel);
    
    _endView.transform = transform;
    //移动到最前
    [self bringSubviewToFront:_endView];
    _endView.hidden = false;
    if (_progress == 0 || _progress == 1) {
        _endView.hidden = true;
    }
}

@end
