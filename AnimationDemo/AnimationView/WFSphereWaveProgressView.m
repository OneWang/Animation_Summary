//
//  WFSphereWaveProgressView.m
//  AnimationDemo
//
//  Created by Jack on 2018/3/21.
//  Copyright © 2018年 Jack. All rights reserved.
//  球形动画进度条

/**
 正弦型函数解析式：y=Asin（ωx+φ）+h
 各常数值对函数图像的影响：
 φ（初相位）：决定波形与X轴位置关系或横向移动距离（左加右减）
 ω：决定周期（最小正周期T=2π/|ω|）
 A：决定峰值（即纵向拉伸压缩的倍数）
 h：表示波形在Y轴的位置关系或纵向移动距离（上加下减）
 
 这个效果主要的思路是添加两条曲线 一条正弦曲线、一条余弦曲线 然后在曲线下添加深浅不同的背景颜色，从而达到波浪显示的效果
 */

#import "WFSphereWaveProgressView.h"

@interface WFSphereWaveProgressView ()
/** 第一个波 */
@property (strong, nonatomic) CAShapeLayer *firstLayer;
/** 第二个波 */
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
/** 显示进度label */
@property (weak, nonatomic) UILabel *progressLabel;
@end

@implementation WFSphereWaveProgressView

- (instancetype)initWithFrame:(CGRect)frame backgroundColor:(UIColor *)backColor beforColor:(UIColor *)beforColor{
    if (self = [super initWithFrame:frame]) {
        self.beforColor = beforColor;
        self.backColor = backColor;
        [self setupUI];
        [self setupAnimationData];
    }
    return self;
}

- (void)setupUI{
    //绘制背景圆
    self.layer.cornerRadius = self.bounds.size.width * 0.5;
    self.layer.masksToBounds = YES;
    
    //第一层波浪
    _firstLayer = [CAShapeLayer layer];
    _firstLayer.fillColor = _beforColor.CGColor;
    _firstLayer.strokeColor = _beforColor.CGColor;
    [self.layer addSublayer:_firstLayer];
    
    //第二层波浪
    _secondLayer = [CAShapeLayer layer];
    _secondLayer.fillColor = _backColor.CGColor;
    _secondLayer.strokeColor = _backColor.CGColor;
    [self.layer addSublayer:_secondLayer];
    
    //显示label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    _progressLabel = label;
    label.text = @"0%";
    label.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:12];
    label.adjustsFontSizeToFitWidth = YES;
    [self addSubview:label];
}

//初始化动画数据
- (void)setupAnimationData{
    _waveAmplitude = 10;
    _wavePalstance = M_PI / self.bounds.size.width;
    _waveOffsetY = self.bounds.size.height;
    //x轴移动速度
    _waveSpeed = _wavePalstance * 2;
    
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(display)];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)display{
    _waveOffsetX += _waveSpeed;
    [self updateWaveK];
    [self updateWave1];
    [self updateWave2];
}

//更新偏距的大小 直到达到目标偏距 让wave有一个匀速增长的效果
- (void)updateWaveK{
    CGFloat targetY = self.bounds.size.height * (1 - _progress);
    if (_waveOffsetY < targetY) {
        _waveOffsetY += 1;
    }
    if (_waveOffsetY > targetY ) {
        _waveOffsetY -= 1;
    }
}

- (void)updateWave1{
    //波浪宽度
    CGFloat waterWaveWidth = self.bounds.size.width;
    //初始化运动路径
    CGMutablePathRef path = CGPathCreateMutable();
    //设置起始位置
    CGPathMoveToPoint(path, nil, 0, _waveOffsetY);
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

- (void)updateWave2{
    //波浪宽度
    CGFloat waterWaveWidth = self.bounds.size.width;
    //初始化运动路径
    CGMutablePathRef path = CGPathCreateMutable();
    //设置起始位置
    CGPathMoveToPoint(path, nil, 0, _waveOffsetY);
    //初始化波浪其实Y为偏距
    CGFloat y = _waveOffsetY;
    //正弦曲线公式为： y=Asin(ωx+φ)+k;
    for (float x = 0.0f; x <= waterWaveWidth ; x++) {
        y = _waveAmplitude * sin(_wavePalstance * x + _waveOffsetX) + _waveOffsetY;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    //添加终点路径、填充底部颜色
    CGPathAddLineToPoint(path, nil, waterWaveWidth, self.bounds.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.bounds.size.height);
    CGPathCloseSubpath(path);
    _secondLayer.path = path;
    CGPathRelease(path);
}

- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    _progressLabel.text = [NSString stringWithFormat:@"%.0f%%",progress * 100];
}

/**
 开启一个定时器
 
 @param target 定时器持有者(考虑到当使用定时器的对象销毁了但是并没有手动对定时器进行释放)
 @param timeInterval 执行间隔时间
 @param handler 重复执行事件
 */
void dispatchTimer(id target, double timeInterval,void (^handler)(dispatch_source_t timer)){
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer =dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), (uint64_t)(timeInterval *NSEC_PER_SEC), 0);
    // 设置回调
    __weak __typeof(target) weaktarget  = target;
    dispatch_source_set_event_handler(timer, ^{
        if (!weaktarget)  {
            dispatch_source_cancel(timer);
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (handler) handler(timer);
            });
        }
    });
    // 启动定时器
    dispatch_resume(timer);
}

@end
