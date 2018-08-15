//
//  WFWaveHeader.m
//  AnimationDemo
//
//  Created by Jack on 2018/3/30.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import "WFWaveHeader.h"

@interface WFWaveHeader ()
/** 第一条波浪 */
@property (strong, nonatomic) CAShapeLayer *firstLayer;
/** 第二条波浪 */
@property (strong, nonatomic) CAShapeLayer *secondLayer;
/** 曲线的振幅 */
@property (assign, nonatomic) float waveAmplitude;
/** 曲线的角速度 */
@property (assign, nonatomic) float wavePalstance;
/** 曲线的左右偏移 */
@property (assign, nonatomic) float waveOffsetX;
/** 曲线的上线偏移 */
@property (assign, nonatomic) float waveOffsetY;
/** 曲线的移动速度 */
@property (assign, nonatomic) float waveSpeed;
/** 定时器 */
@property (strong, nonatomic) CADisplayLink *displayLink;
/** 前景色 */
@property (strong, nonatomic) UIColor *beforColor;
/** 后景色 */
@property (strong, nonatomic) UIColor *backColor;
/** 头像 */
@property (weak, nonatomic) UIImageView *headerView;

@end

@implementation WFWaveHeader

- (instancetype)initWithFrame:(CGRect)frame backgroundColor:(UIColor *)backColor beforColor:(UIColor *)beforColor{
    if (self = [super initWithFrame:frame]) {
        _beforColor = beforColor;
        _backColor = backColor;
        [self setupUI];
        [self setupAnimationData];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [UIColor orangeColor];
    //第一层波浪
    _firstLayer = [CAShapeLayer layer];
    _firstLayer.fillColor = _backColor.CGColor;
    _firstLayer.strokeColor = _backColor.CGColor;
    [self.layer addSublayer:_firstLayer];
    
    //第二层波浪
    _secondLayer = [CAShapeLayer layer];
    _secondLayer.fillColor = _beforColor.CGColor;
    _secondLayer.strokeColor = _beforColor.CGColor;
    [self.layer addSublayer:_secondLayer];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.headerView = imageView;
    [self addSubview:imageView];
    imageView.backgroundColor = [UIColor redColor];
    imageView.layer.cornerRadius = 10;
    imageView.layer.masksToBounds = YES;
}

//初始化动画数据
- (void)setupAnimationData{
    _waveAmplitude = 5;
    _wavePalstance = M_PI / self.bounds.size.width;
    _waveOffsetY = self.bounds.size.height - 10;
    //x轴移动速度
    _waveSpeed = _wavePalstance * 5;
    
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(display)];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)display{
    _waveOffsetX += _waveSpeed;
    [self updateWave1];
    [self updateWave2];
}

- (void)updateWave1{
    //波浪宽度
    CGFloat waterWaveWidth = self.bounds.size.width;
    //初始化运动路径
    CGMutablePathRef path = CGPathCreateMutable();
    //设置起始位置
    CGPathMoveToPoint(path, nil, -1, _waveOffsetY);
    //初始化波浪其实Y为偏距
    CGFloat y = _waveOffsetY;
    //正弦曲线公式为： y=Acos(ωx+φ)+k;
    for (float x = 0.0f; x <= waterWaveWidth ; x++) {
        y = _waveAmplitude * cos(_wavePalstance * x + _waveOffsetX) + _waveOffsetY;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    //填充底部颜色
    CGPathAddLineToPoint(path, nil, waterWaveWidth, self.bounds.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.bounds.size.height);
    CGPathCloseSubpath(path);
    _firstLayer.path = path;
    CGPathRelease(path);
}

#warning 遗留bug，左边动画的时候有一条竖线
- (void)updateWave2{
    //波浪宽度
    CGFloat waterWaveWidth = self.bounds.size.width;
    //初始化运动路径
    CGMutablePathRef path = CGPathCreateMutable();
    //设置起始位置
    CGPathMoveToPoint(path, nil, -1, _waveOffsetY);
    //初始化波浪其实Y为偏距
    CGFloat y = _waveOffsetY;
    //正弦曲线公式为： y=Asin(ωx+φ)+k;
    for (float x = 0.0f; x <= waterWaveWidth ; x++) {
        y = _waveAmplitude * sin(_wavePalstance * x + _waveOffsetX) + _waveOffsetY;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    CGFloat centerX = self.frame.size.width * 0.5;
    CGFloat centerY = _waveAmplitude * sin(_wavePalstance * centerX + _waveOffsetX) + _waveOffsetY;
    self.headerView.center = CGPointMake(self.frame.size.width * 0.5, centerY - _headerView.frame.size.height * 0.5);
    if (self.callBack) {
        self.callBack(centerY);
    }
    //添加终点路径、填充底部颜色
    CGPathAddLineToPoint(path, nil, waterWaveWidth, self.bounds.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.bounds.size.height);
    CGPathCloseSubpath(path);
    _secondLayer.path = path;
    CGPathRelease(path);
}

- (void)dealloc{
    [_displayLink invalidate];
    _displayLink = nil;
}

@end
