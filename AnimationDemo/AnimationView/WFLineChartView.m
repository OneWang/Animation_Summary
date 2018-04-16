//
//  WFLineChartView.m
//  AnimationDemo
//
//  Created by Jack on 2018/4/13.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import "WFLineChartView.h"
#import "UIView+WFExtension.h"

/** X轴文字的大小 */
static const CGFloat xAxisFont = 10;
/** X轴文字之间的间距 */
static const CGFloat xAxisMargin = 30;
/** 距离顶部的间距 */
static const CGFloat topMargin = 20;
/** Y轴显示的label有几个 */
static const NSInteger yAxisCount = 10;
/** Y轴显示的最大值 */
static const NSInteger yAxisMaxValue = 1000;
/** X,Y轴和文字之间的间距 */
static const CGFloat yTextAxisMargin = 8;
static const CGFloat xTextAxisMargin = 5;

/** Y轴文字的间距 */
static CGFloat yAxisMargin = 0;
/** X轴的最大长度 */
static CGFloat xAxisMaxX = 0;
/** X轴到右边的间距 */
static CGFloat xRightMargin = 20;
/** Y轴到左边的间距 */
static CGFloat yAxisToLeft = 30;
/** 数据显示区域 */
static CGFloat dataChartHeight = 0;

@interface WFLineChartView ()<UIScrollViewDelegate>
/** 滚动的scrollview */
@property (strong, nonatomic) UIScrollView *scrollView;
/** X轴绘制的起始位子 */
@property (assign, nonatomic) CGPoint xOriginPoint;
/** X中文字的高度 */
@property (assign, nonatomic) CGFloat xtextHeight;
@end

@implementation WFLineChartView

- (instancetype)initWithFrame:(CGRect)frame xTitleArray:(NSArray *)titleArray{
    if (self = [super initWithFrame:frame]) {
        _xAxisTitleArray = titleArray;
        [self drawYaxis];
        [self drawXaxis];
    }
    return self;
}

//画Y轴
- (void)drawYaxis{
    _xtextHeight = [@"x" sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:xAxisFont]}].height;
    dataChartHeight = self.height - _xtextHeight - topMargin - xTextAxisMargin;
    yAxisMargin = dataChartHeight / yAxisCount;
    _xOriginPoint = CGPointMake(yAxisToLeft, self.height - _xtextHeight - xTextAxisMargin);
    //画轴
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(yAxisToLeft, topMargin)];
    [path addLineToPoint:CGPointMake(yAxisToLeft, _xOriginPoint.y)];
    
    CAShapeLayer *layer = [self shapeLayerWithPath:path lineWidth:2 fillColor:[UIColor redColor] strokeColor:[UIColor greenColor]];
    [self.layer addSublayer:layer];
    
    for (int i = 0; i < yAxisCount; i ++) {
        NSString *string = [NSString stringWithFormat:@"%.0ld",yAxisMaxValue / yAxisCount * i];
        CGSize size = [string sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:xAxisFont]}];
        CGRect frame = CGRectMake(0, topMargin + (yAxisCount - i) * yAxisMargin, yAxisToLeft - yTextAxisMargin, size.height);
        CATextLayer *textLayer = [self createTextLayerWithString:string font:xAxisFont frame:frame];
        [self.layer addSublayer:textLayer];
    }
    
    [self insertSubview:self.scrollView atIndex:0];
    self.scrollView.frame = CGRectMake(yAxisToLeft, 0, self.width - 10, self.height);
    self.scrollView.backgroundColor = [UIColor darkGrayColor];
}

//画X轴
- (void)drawXaxis{
    //画轴
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, _xOriginPoint.y)];
    xAxisMaxX = (_xAxisTitleArray.count + 1) * xAxisMargin;
    self.scrollView.contentSize = CGSizeMake(xAxisMaxX + xRightMargin, 0);
    [path addLineToPoint:CGPointMake(xAxisMaxX, _xOriginPoint.y)];
    CAShapeLayer *layer = [self shapeLayerWithPath:path lineWidth:2 fillColor:[UIColor redColor] strokeColor:[UIColor greenColor]];
    [self.scrollView.layer addSublayer:layer];
    __weak typeof(self) weakSelf = self;
    [_xAxisTitleArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGSize size = [obj sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:xAxisFont]}];
        CGRect frame = CGRectMake((idx + 1) * xAxisMargin - size.width * 0.5, self.height - size.height, size.width, size.height);
        CATextLayer *textLayer = [self createTextLayerWithString:obj font:xAxisFont frame:frame];
        [weakSelf.scrollView.layer addSublayer:textLayer];
    }];
}

//绘制text
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
    return textLayer;
}

//画线
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

#pragma mark ***************************** GestureRecognizer method *****************************
/** 双击 */
- (void)tapGesture:(UITapGestureRecognizer *)tap {
    
}

/** 捏合 */
- (void)pinchGesture:(UIPinchGestureRecognizer *)recognizer {
    
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

@end
