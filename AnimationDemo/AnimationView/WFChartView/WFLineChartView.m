//
//  WFLineChartView.m
//  AnimationDemo
//
//  Created by Jack on 2018/4/13.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import "WFLineChartView.h"
#import "UIView+WFExtension.h"
#import "WFChartModel.h"
#import <math.h>

/** X轴文字的大小 */
static const CGFloat axisFont = 10;
/** 距离顶部的间距 */
static const CGFloat topMargin = 30;
/** Y轴显示的label有几个 */
static const NSInteger yAxisCount = 8;
/** X,Y轴和文字之间的间距 */
static const CGFloat yTextAxisMargin = 8;
static const CGFloat xTextAxisMargin = 5;
/** 坐标轴的宽度 */
static const CGFloat axisWidth = 1;
/** 坐标轴上点的宽和高 */
static const CGFloat plotWH = 10;
/** Y轴到左边的间距 */
static const CGFloat yAxisToLeft = 40;
/** X轴到右边的间距 */
static const CGFloat xRightMargin = 15;

/** Y轴文字的间距 */
static CGFloat yAxisMargin = 0;
/** X轴的最大长度 */
static CGFloat xAxisMaxX = 0;
/** Y轴的最大长度 */
static CGFloat yAxisMaxY = 0;
/** 数据显示区域 */
static CGFloat dataChartHeight = 0;
/** Y轴显示的最大值 */
static NSInteger yAxisMaxValue = 100;

@interface WFLineChartView ()<UIScrollViewDelegate,CAAnimationDelegate>
/** 滚动的scrollview */
@property (strong, nonatomic) UIScrollView *scrollView;
/** 点的数组 */
@property (strong, nonatomic) NSArray<WFChartModel *> *dataArray;
/** 将所有创建的layer层保存在数组中 */
@property (strong, nonatomic) NSMutableArray<CAShapeLayer *> *firstLayerArray;
@property (strong, nonatomic) NSMutableArray<CAShapeLayer *> *secondLayerArray;
/** 控件数组 */
@property (strong, nonatomic) NSMutableArray<UIView *> *allViewsArray;
/** 文字数组 */
@property (strong, nonatomic) NSMutableArray<CATextLayer *> *textArray;
/** X轴绘制的起始位子 */
@property (assign, nonatomic) CGPoint xOriginPoint;
/** X中文字的高度 */
@property (assign, nonatomic) CGFloat xtextHeight;
/** 捏合时记录原先X轴点距离 */
@property (assign, nonatomic) CGFloat orginXAxisMargin;
/** 捏合时记录原来Bar的宽度 */
@property (assign, nonatomic) CGFloat originBarWidth;
/** X轴文字之间的间距 */
@property (assign, nonatomic) CGFloat xAxisMargin;
/** 捏合时记录原先动画flag */
@property (assign, nonatomic) BOOL orginAnimation;
/** 柱状图之间的间距 */
@property (assign, nonatomic) CGFloat barMargin;
@end

@implementation WFLineChartView

- (instancetype)initWithFrame:(CGRect)frame xTitleArray:(NSArray *)titleArray{
    if (self = [super initWithFrame:frame]) {
        _xAxisTitleArray = titleArray;
        [self initializeData];
    }
    return self;
}

//MARK:初始化数据
- (void)initializeData{
    _xtextHeight = [@"x" sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:axisFont]}].height;
    dataChartHeight = self.height - _xtextHeight - topMargin - xTextAxisMargin;
    yAxisMargin = dataChartHeight / yAxisCount;
    _xOriginPoint = CGPointMake(yAxisToLeft, self.height - _xtextHeight - xTextAxisMargin);
    yAxisMaxY = MAX(topMargin - yAxisMargin * 0.5, 0);
    self.xAxisMargin = _orginXAxisMargin = 30;
    self.originBarWidth = _barWidth = 5;
    _xAxisTitle = @"X";
    _yAxisTitle = @"Y";
    _barMargin = 20;
}

//设置数据源源和Y轴的最大值
- (void)showChartViewWithYAxisMaxValue:(CGFloat)yAxisMax dataSource:(NSArray<WFChartModel *> *)dataSource {
    if (dataSource.count == 1) {
        if (self.isShowInteger) {
            [dataSource.firstObject.plotArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.integerValue > yAxisMaxValue) {
                    yAxisMaxValue = obj.integerValue;
                }
            }];
        }else{
            yAxisMaxValue = yAxisMax;
        }
    }else{
        yAxisMaxValue = yAxisMax;
    }
    self.dataArray = dataSource;
    if (_chartType == WFChartViewTypeLine) {
        _headerTitle = @"折线图";
    }else{
        _headerTitle = @"柱状图";
    }
    [self showChartView];
}

- (void)showChartView{
    //截取数据
    [_dataArray enumerateObjectsUsingBlock:^(WFChartModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.plotArray.count > self.xAxisTitleArray.count) {
            obj.plotArray = [obj.plotArray subarrayWithRange:NSMakeRange(0, self.xAxisTitleArray.count)];
        }
    }];
    
    //设置柱状图的间距大于X轴中文字的间距
    if (_chartType == WFChartViewTypeBar && _xAxisMargin < _barWidth * _dataArray.count + _barMargin) {
        self.xAxisMargin = self.orginXAxisMargin = _barWidth * _dataArray.count + _barMargin;
    }
    
    [self resetDataSouce];
    
    [self addYaxisSparator];
    if (self.chartType == WFChartViewTypeLine) {
        [self addXaxisSparator];
        [self drawLineChartViewLine];
        [self drawLineChartViewPots];
    }else{
        [self drawBarChartViewBars];
    }
    
    [self drawYaxis];
    [self drawXaxis];
    
    [self createTopHeaderTitleLabelAndNote];
    [self createDisplayLabel];
    
    [self addAnimation:self.isAnimation];
}

//MARK:重置数据
- (void)resetDataSouce{
    if (self.textArray.count) {
        [self.textArray makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
        [self.textArray removeAllObjects];
    }
    if (self.allViewsArray.count) {
        [self.allViewsArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.allViewsArray removeAllObjects];
    }
    if (self.firstLayerArray.count) {
        [self.firstLayerArray makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
        [self.firstLayerArray removeAllObjects];
    }
    if (self.secondLayerArray.count) {
        [self.secondLayerArray makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
        [self.secondLayerArray removeAllObjects];
    }
}

//MARK:添加头部标题和注释
- (void)createTopHeaderTitleLabelAndNote{
    CGSize size = [self.headerTitle sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]}];
    CGFloat headerX = self.width * 0.5 - size.width * 0.5;
    CGRect frame = CGRectMake(headerX, 0, size.width, size.height);
    CATextLayer *layer = [self createTextLayerWithString:_headerTitle font:15 frame:frame];
    [self.layer addSublayer:layer];
}

//MARK:创建每个折线对应点的值
- (void)createDisplayLabel{
    if (self.isShowValue) {
        __weak typeof(self) weakSelf = self;
        int centerFlag = _dataArray.count * 0.5;
        [_dataArray enumerateObjectsUsingBlock:^(WFChartModel * _Nonnull model, NSUInteger idex, BOOL * _Nonnull stop) {
            [model.plotArray enumerateObjectsUsingBlock:^(NSString * _Nonnull string, NSUInteger i, BOOL * _Nonnull stop) {
                if (string.floatValue < 0) {
                    string = @"0";
                }
                if (weakSelf.chartType == WFChartViewTypeLine) {
                    CGSize size = [string sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10]}];
                    CATextLayer *textLayer = [self createTextLayerWithString:string font:10 frame:CGRectMake((i + 1) * weakSelf.xAxisMargin - size.width * 0.5, [weakSelf getDotArrayYxaisWithValue:string] - 5 - size.height, size.width, size.height)];
                    [weakSelf.scrollView.layer addSublayer:textLayer];
                }else{
                    CGFloat startPointx = 0;
                    int n = (int)(idex - centerFlag);
                    if (weakSelf.dataArray.count % 2 == 0) {
                        startPointx = (i + 1) * weakSelf.xAxisMargin + (0.5 + n) * weakSelf.barWidth;
                    }else{
                        startPointx = (i + 1) * weakSelf.xAxisMargin + n * weakSelf.barWidth;
                    }                    CGSize size = [string sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10]}];
                    CATextLayer *textLayer = [self createTextLayerWithString:string font:10 frame:CGRectMake(startPointx - size.width * 0.5, [weakSelf getDotArrayYxaisWithValue:string] - size.height, size.width, size.height)];
                    [weakSelf.scrollView.layer addSublayer:textLayer];
                }
            }];
        }];
    }
}

//MARK:画Y轴
- (void)drawYaxis{
    //画轴
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:_xOriginPoint];
    [path addLineToPoint:CGPointMake(yAxisToLeft, yAxisMaxY)];
    [path addLineToPoint:CGPointMake(yAxisToLeft - axisWidth - 4, yAxisMaxY + axisWidth + 4)];
    [path addLineToPoint:CGPointMake(yAxisToLeft, yAxisMaxY)];
    [path addLineToPoint:CGPointMake(yAxisToLeft + axisWidth + 4, yAxisMaxY + axisWidth + 4)];
    
    CAShapeLayer *layer = [self shapeLayerWithPath:path lineWidth:axisWidth fillColor:[UIColor clearColor] strokeColor:[UIColor darkGrayColor]];
    [self.firstLayerArray addObject:layer];
    [self.layer addSublayer:layer];
    
    for (int i = 0; i < yAxisCount + 1; i ++) {
        CGFloat avergValue = yAxisMaxValue / yAxisCount;
        NSString *string = [NSString stringWithFormat:@"%.0f",avergValue * i];
        CGSize size = [string sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:axisFont]}];
        CGRect frame = CGRectMake(0, topMargin + (yAxisCount - i) * yAxisMargin - size.height * 0.5, yAxisToLeft - yTextAxisMargin, size.height);
        CATextLayer *textLayer = [self createTextLayerWithString:string font:axisFont frame:frame];
        [self.layer addSublayer:textLayer];
    }
    
    [self insertSubview:self.scrollView atIndex:0];
    self.scrollView.frame = CGRectMake(yAxisToLeft, 0, self.width - 10, self.height);
    
    //添加Y轴提示文字
    CGSize size = [_yAxisTitle sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:axisFont]}];
    CGRect rect = CGRectMake(yAxisToLeft - size.width * 0.5, yAxisMaxY - size.height, size.width, size.height);
    CATextLayer *textLayer = [self createTextLayerWithString:_yAxisTitle font:axisFont frame:rect];
    [self.layer addSublayer:textLayer];
}

//MARK:画X轴
- (void)drawXaxis{
    //画轴
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, _xOriginPoint.y)];
    if (_chartType == WFChartViewTypeLine) {
        xAxisMaxX = (_xAxisTitleArray.count + 0.5) * self.xAxisMargin;
    }else{
        xAxisMaxX = (_xAxisTitleArray.count + 1) * self.xAxisMargin;
    }
    self.scrollView.contentSize = CGSizeMake(xAxisMaxX + xRightMargin + yAxisToLeft, 0);
    [path addLineToPoint:CGPointMake(xAxisMaxX, _xOriginPoint.y)];
    [path addLineToPoint:CGPointMake(xAxisMaxX - axisWidth - 4, _xOriginPoint.y - axisWidth - 4)];
    [path addLineToPoint:CGPointMake(xAxisMaxX, _xOriginPoint.y)];
    [path addLineToPoint:CGPointMake(xAxisMaxX - axisWidth - 4, _xOriginPoint.y + axisWidth + 4)];
    CAShapeLayer *layer = [self shapeLayerWithPath:path lineWidth:axisWidth fillColor:[UIColor clearColor] strokeColor:[UIColor darkGrayColor]];
    [self.firstLayerArray addObject:layer];
    [self.scrollView.layer addSublayer:layer];
    __weak typeof(self) weakSelf = self;
    [_xAxisTitleArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGSize size = [obj sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:axisFont]}];
        CGRect frame = CGRectMake((idx + 1) * weakSelf.xAxisMargin - size.width * 0.5, self.height - size.height, size.width, size.height);
        CATextLayer *textLayer = [self createTextLayerWithString:obj font:axisFont frame:frame];
        [weakSelf.scrollView.layer addSublayer:textLayer];
    }];
    
    //添加X轴提示文字
    CGSize size = [_xAxisTitle sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:axisFont]}];
    CGRect rect = CGRectMake(xAxisMaxX , _xOriginPoint.y - size.height * 0.5, size.width, size.height);
    CATextLayer *textLayer = [self createTextLayerWithString:_xAxisTitle font:axisFont frame:rect];
    [self.scrollView.layer addSublayer:textLayer];
}

//MARK:绘制辅助线
- (void)addYaxisSparator{
    // 添加Y轴分割线
    for (int i = 0; i < yAxisCount + 1; i++) {
        CAShapeLayer *yshapeLayer = nil;
        UIBezierPath *ySeparatorPath = [UIBezierPath bezierPath];
        CGFloat y = topMargin + (yAxisCount - i) * yAxisMargin;
        [ySeparatorPath moveToPoint:CGPointMake(0, y)];
        if (_chartType == WFChartViewTypeLine) {
            [ySeparatorPath addLineToPoint:CGPointMake((_xAxisTitleArray.count + 0.5) * self.xAxisMargin, y)];
        }else{
            [ySeparatorPath addLineToPoint:CGPointMake((_xAxisTitleArray.count + 1) * self.xAxisMargin, y)];
        }
        yshapeLayer = [self shapeLayerWithPath:ySeparatorPath lineWidth:0.5 fillColor:[UIColor clearColor] strokeColor:[UIColor lightGrayColor]];
        yshapeLayer.path = ySeparatorPath.CGPath;
        if (_isShowGridding) {
            yshapeLayer.lineDashPattern = @[@3,@3];
            [self.scrollView.layer addSublayer:yshapeLayer];
        }else{
            [self.layer addSublayer:yshapeLayer];
        }
        [self.firstLayerArray addObject:yshapeLayer];
    }
}

- (void)addXaxisSparator{
    // 添加X轴分割线
    for (int i = 0; i < _xAxisTitleArray.count; i++) {
        CAShapeLayer *xshapeLayer = nil;
        UIBezierPath *xSeparatorPath = [UIBezierPath bezierPath];
        CGSize size = [_xAxisTitleArray[i] sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:axisFont]}];
        CGFloat x = (i + 1) * self.xAxisMargin;
        CGFloat y = self.height - size.height - xTextAxisMargin;
        if (_isShowGridding) {
            [xSeparatorPath moveToPoint:CGPointMake(x, y)];
            [xSeparatorPath addLineToPoint:CGPointMake(x, topMargin)];
            xshapeLayer = [self shapeLayerWithPath:xSeparatorPath lineWidth:0.5 fillColor:[UIColor clearColor] strokeColor:[UIColor lightGrayColor]];
            xshapeLayer.path = xSeparatorPath.CGPath;
            xshapeLayer.lineDashPattern = @[@3,@3];
            [self.scrollView.layer addSublayer:xshapeLayer];
        }else{
            [xSeparatorPath moveToPoint:CGPointMake(x, y)];
            [xSeparatorPath addLineToPoint:CGPointMake(x, topMargin)];
            xshapeLayer = [self shapeLayerWithPath:xSeparatorPath lineWidth:0.5 fillColor:[UIColor clearColor] strokeColor:[UIColor lightGrayColor]];
            xshapeLayer.path = xSeparatorPath.CGPath;
            [self.layer addSublayer:xshapeLayer];
        }
        [self.firstLayerArray addObject:xshapeLayer];
    }
}

//MARK:绘制text
- (CATextLayer *)createTextLayerWithString:(NSString *)title font:(CGFloat)fontSize frame:(CGRect)frame{
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.backgroundColor = [UIColor clearColor].CGColor;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    textLayer.frame = frame;
    // 分行显示
    textLayer.wrapped = NO;
    // 超长显示时，省略号位置
    textLayer.truncationMode = kCATruncationNone;
    // 字体颜色
    textLayer.foregroundColor = [UIColor redColor].CGColor;
    // 字体名称、大小
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    textLayer.font = fontRef;
    textLayer.fontSize = font.pointSize;
    CGFontRelease(fontRef);
    // 字体对方方式
    textLayer.alignmentMode = kCAAlignmentRight;
    textLayer.string = title;
    [self.textArray addObject:textLayer];
    return textLayer;
}

//MARK:画线
- (CAShapeLayer *)shapeLayerWithPath:(UIBezierPath *)path lineWidth:(CGFloat)lineWidth fillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineWidth = lineWidth;
    shapeLayer.fillColor = fillColor.CGColor;
    shapeLayer.strokeColor = strokeColor.CGColor;
    shapeLayer.lineCap = kCALineCapButt;
    shapeLayer.lineJoin = kCALineJoinBevel;
    shapeLayer.path = path.CGPath;
    return shapeLayer;
}

#pragma mark ***************************** 绘制折线图上的点和线 *****************************
- (void)drawLineChartViewPots{
    __weak typeof(self) weakSelf = self;
    [_dataArray enumerateObjectsUsingBlock:^(WFChartModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        [model.plotArray enumerateObjectsUsingBlock:^(NSString * _Nonnull string, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(plotClickButton:) forControlEvents:UIControlEventTouchUpInside];
            CGRect frame = CGRectMake(0, 0, plotWH, plotWH);
            button.frame = frame;
            button.center = CGPointMake((idx + 1) * self.xAxisMargin, [weakSelf getDotArrayYxaisWithValue:string]);
            button.backgroundColor = model.color;
            button.layer.cornerRadius = plotWH * 0.5;
            button.layer.masksToBounds = YES;
            [button setTitle:string forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:0];
            [weakSelf.scrollView addSubview:button];
            [weakSelf.allViewsArray addObject:button];
        }];
    }];
}

- (void)plotClickButton:(UIButton *)button{
    NSLog(@"%@",button.titleLabel.text);
}

- (void)drawLineChartViewLine{
    __weak typeof(self) weakSelf = self;
    if (self.isFill) {
        [_dataArray enumerateObjectsUsingBlock:^(WFChartModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            __block CAShapeLayer *layer = nil;
            UIBezierPath *linePath = [UIBezierPath bezierPath];
            [linePath moveToPoint:CGPointMake(weakSelf.xAxisMargin, weakSelf.xOriginPoint.y)];
            [model.plotArray enumerateObjectsUsingBlock:^(NSString * _Nonnull string, NSUInteger idx, BOOL * _Nonnull stop) {
                [linePath addLineToPoint:CGPointMake((idx + 1) * weakSelf.xAxisMargin, [weakSelf getDotArrayYxaisWithValue:string])];
            }];
            [linePath addLineToPoint:CGPointMake(weakSelf.xAxisMargin * model.plotArray.count, weakSelf.xOriginPoint.y)];
            layer = [weakSelf shapeLayerWithPath:linePath lineWidth:2.f fillColor:[UIColor colorWithWhite:0 alpha:0.3] strokeColor:[UIColor orangeColor]];
            [weakSelf.secondLayerArray addObject:layer];
            [weakSelf.scrollView.layer addSublayer:layer];
        }];
    }else{
        if (self.isCurve) {
            [_dataArray enumerateObjectsUsingBlock:^(WFChartModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
                __block CAShapeLayer *layer = nil;
                UIBezierPath *linePath = [UIBezierPath bezierPath];
                [linePath moveToPoint:CGPointMake(weakSelf.xAxisMargin, [weakSelf getDotArrayYxaisWithValue:model.plotArray.firstObject])];
                [model.plotArray enumerateObjectsUsingBlock:^(NSString * _Nonnull string, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (idx >= model.plotArray.count - 1) {
                        return;
                    }
                    CGPoint start = CGPointMake((idx + 1) * weakSelf.xAxisMargin, [weakSelf getDotArrayYxaisWithValue:string]);
                    CGPoint end = CGPointMake((idx + 2) * weakSelf.xAxisMargin, [weakSelf getDotArrayYxaisWithValue:model.plotArray[idx + 1]]);
                    CGPoint middlePoint = CGPointMake((end.x + start.x) * 0.5, (end.y + start.y) * 0.5);
                    [linePath addQuadCurveToPoint:middlePoint controlPoint:[weakSelf findMiddleControlPointBetweenStartPoints:middlePoint andEndPoints:start]];
                    [linePath addQuadCurveToPoint:end controlPoint:[weakSelf findMiddleControlPointBetweenStartPoints:middlePoint andEndPoints:end]];
                }];
                layer = [weakSelf shapeLayerWithPath:linePath lineWidth:2.f fillColor:[UIColor clearColor] strokeColor:[UIColor orangeColor]];
                [weakSelf.secondLayerArray addObject:layer];
                [weakSelf.scrollView.layer addSublayer:layer];
            }];
        }else{        
            [_dataArray enumerateObjectsUsingBlock:^(WFChartModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
                __block CAShapeLayer *layer = nil;
                UIBezierPath *linePath = [UIBezierPath bezierPath];
                [linePath moveToPoint:CGPointMake(weakSelf.xAxisMargin, [weakSelf getDotArrayYxaisWithValue:model.plotArray.firstObject])];
                [model.plotArray enumerateObjectsUsingBlock:^(NSString * _Nonnull string, NSUInteger idx, BOOL * _Nonnull stop) {
                    [linePath addLineToPoint:CGPointMake((idx + 1) * weakSelf.xAxisMargin, [weakSelf getDotArrayYxaisWithValue:string])];
                }];
                layer = [weakSelf shapeLayerWithPath:linePath lineWidth:2.f fillColor:[UIColor clearColor] strokeColor:[UIColor orangeColor]];
                [weakSelf.secondLayerArray addObject:layer];
                [weakSelf.scrollView.layer addSublayer:layer];
            }];
        }
    }
}

//MARK:控制点的X为中间点的X值，Y值为结束点的Y值
- (CGPoint)findMiddleControlPointBetweenStartPoints:(CGPoint)start andEndPoints:(CGPoint)end{
    //先找到中间点
    CGPoint middlePoint = CGPointMake((end.x + start.x) * 0.5, (end.y + start.y) * 0.5);
    //结束点和中间点Y值的差
    CGFloat distanceY = ABS(end.y - middlePoint.y);
    if (start.y < end.y) {  //开始点低于结束点
        middlePoint.y += distanceY;
    }else if (start.y > end.y){     //开始点高于结束点
        middlePoint.y -= distanceY;
    }
    return middlePoint;
}

#pragma mark ***************************** 绘制柱状图 *****************************
- (void)drawBarChartViewBars{
    NSInteger centerFlag = _dataArray.count * 0.5;
    __weak typeof(self) weakSelf = self;
    [_dataArray enumerateObjectsUsingBlock:^(WFChartModel * _Nonnull model, NSUInteger idex, BOOL * _Nonnull stop) {
        [model.plotArray enumerateObjectsUsingBlock:^(NSString * _Nonnull string, NSUInteger i, BOOL * _Nonnull stop) {
            UIBezierPath *barPath = [UIBezierPath bezierPath];
            CGFloat startPointx = 0;
            int n = (int)(idex - centerFlag);
            if (weakSelf.dataArray.count % 2 == 0) {
                startPointx = (i + 1) * weakSelf.xAxisMargin + (0.5 + n) * weakSelf.barWidth;
            }else{
                startPointx = (i + 1) * weakSelf.xAxisMargin + n * weakSelf.barWidth;
            }
            [barPath moveToPoint:CGPointMake(startPointx, weakSelf.xOriginPoint.y)];
            [barPath addLineToPoint:CGPointMake(startPointx, [self getDotArrayYxaisWithValue:string])];
            CAShapeLayer *layer = [weakSelf shapeLayerWithPath:barPath lineWidth:weakSelf.barWidth fillColor:model.color strokeColor:model.color];
            [weakSelf.secondLayerArray addObject:layer];
            [weakSelf.scrollView.layer addSublayer:layer];
        }];
    }];
}

//MARK:计算数组中的值转换为坐标的值
- (CGFloat)getDotArrayYxaisWithValue:(NSString *)value{
    CGFloat y = dataChartHeight - (dataChartHeight * value.floatValue / yAxisMaxValue) + topMargin;
    return y;
}

#pragma mark ***************************** 添加动画 *****************************
- (void)addAnimation:(NSArray <CALayer *>*)layers delegate:(id<CAAnimationDelegate>)delegate duration:(NSTimeInterval)duration {
    CABasicAnimation *stroke = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    stroke.delegate = delegate;
    stroke.duration = duration;
    stroke.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    stroke.fromValue = [NSNumber numberWithFloat:0.0f];
    stroke.toValue = [NSNumber numberWithFloat:1.0f];
    for (CALayer *shapeLayer in layers) {
        [shapeLayer addAnimation:stroke forKey:nil];
    }
}

- (void)addAnimation:(BOOL)animation {
    if (animation) {
        [self.allViewsArray enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.alpha = 0.0;
        }];
        for (CAShapeLayer *layer in self.secondLayerArray) {
            layer.hidden = YES;
        }
        [self addAnimation:self.firstLayerArray delegate:self duration:0.5];
    }
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        for (CAShapeLayer *layer in self.secondLayerArray) {
            layer.hidden = NO;
        }
        [self addAnimation:self.secondLayerArray delegate:nil duration:0.8];
        
        [self.allViewsArray enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [UIView animateWithDuration:0.8 animations:^{
                obj.alpha = 1.0;
            }];
        }];
    }
}

#pragma mark ***************************** GestureRecognizer method *****************************
/** 双击 */
- (void)tapGesture:(UITapGestureRecognizer *)tap {
    if (_xAxisMargin > 100) {
        return;
    }
    if (self.chartType == WFChartViewTypeBar) {
        self.barWidth *= 1.5;
        self.originBarWidth = _barWidth;
    }
    self.xAxisMargin *= 1.5;
    self.orginXAxisMargin = _xAxisMargin;
    [self showChartView];
}

/** 捏合 */
- (void)pinchGesture:(UIPinchGestureRecognizer *)recognizer {
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:{
            self.orginAnimation = self.isAnimation;
            self.isAnimation = NO;
        }
            break;
        case UIGestureRecognizerStateChanged:{
            if (_chartType == WFChartViewTypeBar) {
                self.barWidth = recognizer.scale * _originBarWidth;
                if (_barWidth < 5) {
                    _barWidth = 5;
                }
            }
            self.xAxisMargin = recognizer.scale * _orginXAxisMargin;
            if (_xAxisMargin < 20) {
                self.xAxisMargin = 20;
            }
            [self showChartView];
        }
            break;
        case UIGestureRecognizerStateEnded:{
            if (_chartType == WFChartViewTypeBar) {
                self.originBarWidth = _barWidth;
            }
            self.orginXAxisMargin = _xAxisMargin;
            self.isAnimation = self.orginAnimation;
        }
            break;
        default:
            break;
    }
}

#pragma mark ***************************** setter and getter *****************************
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        // 双击事件
        UITapGestureRecognizer *twoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        twoTap.numberOfTapsRequired = 2;
        [_scrollView addGestureRecognizer:twoTap];
        // 捏合手势
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
        [_scrollView addGestureRecognizer:pinch];
    }
    return _scrollView;
}

- (NSMutableArray<CAShapeLayer *> *)firstLayerArray{
    if (!_firstLayerArray) {
        _firstLayerArray = [NSMutableArray array];
    }
    return _firstLayerArray;
}

- (NSMutableArray<CAShapeLayer *> *)secondLayerArray{
    if (!_secondLayerArray) {
        _secondLayerArray = [NSMutableArray array];
    }
    return _secondLayerArray;
}

- (NSMutableArray<UIView *> *)allViewsArray{
    if (!_allViewsArray) {
        _allViewsArray = [NSMutableArray array];
    }
    return _allViewsArray;
}

- (NSMutableArray<CATextLayer *> *)textArray{
    if (!_textArray) {
        _textArray = [NSMutableArray array];
    }
    return _textArray;
}

@end
