//
//  WFCircleProgressView.m
//  AnimationDemo
//
//  Created by Jack on 2018/3/20.
//  Copyright © 2018年 Jack. All rights reserved.
//  圆环进度条

#import "WFCircleProgressView.h"

@interface WFCircleProgressView (){
    CAShapeLayer *_progressLayer;
    UILabel *_progressLabel;
    UIImageView *_endPoint;
}
/** 背景的颜色 */
@property (strong, nonatomic) UIColor *backColor;

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
    
    _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [self addSubview:_progressLabel];
    _progressLabel.text = @"0%";
    _progressLabel.center = CGPointMake(width * 0.5, height * 0.5);
    _progressLabel.font = [UIFont boldSystemFontOfSize:15];
    _progressLabel.textAlignment = NSTextAlignmentCenter;
    
    //用于显示结束位置的小点
    _endPoint = [[UIImageView alloc] init];
    _endPoint.frame = CGRectMake(0, 0, _lineWidth - 1 * 2,_lineWidth - 1 * 2);
    _endPoint.hidden = true;
    _endPoint.backgroundColor = [UIColor blackColor];
    _endPoint.image = [UIImage imageNamed:@"arrow_right_44px"];
    _endPoint.layer.masksToBounds = true;
    _endPoint.layer.cornerRadius = _endPoint.bounds.size.width/2;
    [self addSubview:_endPoint];

}

#pragma maark - setter and geter
- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    _progressLayer.strokeColor = _progressColor.CGColor;
    _progressLayer.strokeEnd = progress;
    [_progressLayer removeAllAnimations];
    _progressLabel.text = [NSString stringWithFormat:@"%.0f%%",_progress * 100];
    [self updateEndPoint];
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
    //更新圆环的frame
    CGRect rect = _endPoint.frame;
    rect.origin.x = x + 1;
    rect.origin.y = y + 1;
    _endPoint.frame = rect;
    //移动到最前
    [self bringSubviewToFront:_endPoint];
    _endPoint.hidden = false;
    if (_progress == 0 || _progress == 1) {
        _endPoint.hidden = true;
    }
}

@end
