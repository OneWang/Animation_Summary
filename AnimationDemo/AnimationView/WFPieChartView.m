//
//  WFPieChartView.m
//  AnimationDemo
//
//  Created by Jack on 2018/4/13.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import "WFPieChartView.h"
#import "WFPieChartItem.h"

static const CGFloat spaceMargin = 20.f;

@interface WFPieChartView ()
/** 数据源数组 */
@property (strong, nonatomic) NSArray<WFPieChartItem *> *itemArray;
/** 转换后的数据源数组 */
@property (strong, nonatomic) NSMutableArray *percentageArray;
/** 遮罩动画层 */
@property (weak, nonatomic) CAShapeLayer *maskLayer;
/** 半径 */
@property (assign, nonatomic) CGFloat radius;
/** 内环半径 */
@property (assign, nonatomic) CGFloat innerRadius;
@end

@implementation WFPieChartView

//MARK:初始化方法
- (instancetype)initWithFrame:(CGRect)frame items:(NSArray<WFPieChartItem *> *)items{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor lightGrayColor];
        _itemArray = items;
        [self initialMaskLayer];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self strokePineChart];
}

//MARK:初始化遮罩层
- (void)initialMaskLayer{
    self.radius = (self.frame.size.width - spaceMargin * 2) * 0.25;
    CGPoint center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    CAShapeLayer *mask = [CAShapeLayer layer];
    self.maskLayer = mask;
    UIBezierPath *bezier = [UIBezierPath bezierPathWithArcCenter:center radius:_radius startAngle:-M_PI_2 endAngle:M_PI_2 * 3 clockwise:YES];
    mask.fillColor = [UIColor clearColor].CGColor;
    mask.strokeColor = [UIColor orangeColor].CGColor;
    mask.lineWidth = self.frame.size.width * 0.5;
    mask.path = bezier.CGPath;
    mask.strokeEnd = 0;
    self.layer.mask = mask;
}

//MARK:转换数据
- (NSArray *)convertDataArray:(NSArray<WFPieChartItem *> *)dataArray{
    //计算数组中progress的和
    CGFloat totalCount = [[dataArray valueForKeyPath:@"@sum.progress"] floatValue];
    __weak typeof(self) weakSelf = self;
    __block CGFloat total = 0;
    [dataArray enumerateObjectsUsingBlock:^(WFPieChartItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (totalCount == 0) {
            [weakSelf.percentageArray addObject:@(1.0 / weakSelf.itemArray.count * (idx + 1))];
        }else{
            total += obj.progress;
            [weakSelf.percentageArray addObject:@(total/totalCount)];
        }
    }];
    return self.percentageArray;
}

//MARK:绘制饼状图
- (void)strokePineChart{
    self.piePace = _itemArray.count < 3 ? 0 : _piePace;
    NSArray *dataArray = [self convertDataArray:_itemArray];
    for (int i = 0; i < _itemArray.count; i ++) {
        WFPieChartItem *item = _itemArray[i];
        CGFloat start = 0.f;
        if (i != 0) {
            start = [dataArray[i - 1] floatValue];
        }
        CGFloat end = [dataArray[i] floatValue];
        CAShapeLayer *layer = [self drawCicleLayerWithRadius:_radius borderWidth:_borderWidth fillColor:[UIColor clearColor] borderColor:item.color startValue:start endValue:end];
        [self.layer addSublayer:layer];
    }
    [self addAnimation];
}

/**
 图像layer
 @param radius 圆环半径
 @param borderWidth 线宽度
 @param fillColor 填充颜色
 @param borderColor 线的颜色
 @param start 开始点
 @param end 结束点
 */
- (CAShapeLayer *)drawCicleLayerWithRadius:(CGFloat)radius
                               borderWidth:(CGFloat)borderWidth
                                 fillColor:(UIColor *)fillColor
                               borderColor:(UIColor *)borderColor
                                startValue:(CGFloat)start
                                  endValue:(CGFloat)end{
    CAShapeLayer *layer = [CAShapeLayer layer];
    CGPoint center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:radius
                                                    startAngle:-M_PI_2
                                                      endAngle:M_PI_2 * 3
                                                     clockwise:YES];
    layer.fillColor     = fillColor.CGColor;
    layer.strokeColor   = borderColor.CGColor;
    layer.strokeStart   = start;
    layer.strokeEnd     = end;
    layer.lineWidth     = borderWidth;
    layer.path          = path.CGPath;
    return layer;
}

//MARK:添加动画
- (void)addAnimation{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 1.f;
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue = [NSNumber numberWithFloat:1.f];
    //禁止还原
    animation.autoreverses = NO;
    //禁止完成即移除
    animation.removedOnCompletion = NO;
    //让动画保持在最后状态
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [_maskLayer addAnimation:animation forKey:@"strokeEnd"];
}

//MARK:添加点击事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = touches.anyObject;
    //触摸点
    CGPoint touchPoint = [touch locationInView:touch.view];
    CGPoint center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    //距离中心点的距离
    CGFloat distanceFromCenter = sqrtf(pow(touchPoint.x - center.x, 2.f) + powf(touchPoint.y - center.y, 2.f));
    if (distanceFromCenter < _radius - _borderWidth * 0.5 || distanceFromCenter > _radius + _borderWidth * 0.5) {
        return;
    }
    //取得触摸点的角度值
    CGFloat percentage = [self findPercentageOfAngleInCircle:touchPoint fromPoint:center];
    NSInteger index = 0;
    while (percentage > [_percentageArray[index] floatValue]) {
        index ++;
    }
//    NSLog(@"点击了第%ld个色块%f",index,percentage);
}

- (CGFloat)findPercentageOfAngleInCircle:(CGPoint)center fromPoint:(CGPoint)reference{
    //Find angle of line Passing In Reference And Center
    CGFloat angleOfLine = atanf((reference.y - center.y) / (reference.x - center.x));
    NSLog(@"%f",angleOfLine);
    CGFloat percentage = (angleOfLine + M_PI/2)/(2 * M_PI);
    return (reference.x - center.x) > 0 ? percentage : percentage + .5;
}

#pragma mark - setter and geter
- (NSMutableArray *)percentageArray{
    if (!_percentageArray) {
        _percentageArray = [NSMutableArray array];
    }
    return _percentageArray;
}

@end
