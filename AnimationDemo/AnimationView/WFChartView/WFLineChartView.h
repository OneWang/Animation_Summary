//
//  WFLineChartView.h
//  AnimationDemo
//
//  Created by Jack on 2018/4/13.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WFChartViewType) {
    WFChartViewTypeLine,
    WFChartViewTypeBar
};

@class WFChartModel,WFLineChartView;
@protocol WFLineChartViewDelegate <NSObject>
@optional
- (void)wf_lineChartView:(WFLineChartView *)lineChartView didClickButtonDot:(UIButton *)button;
@end

@interface WFLineChartView : UIView

/** 代理 */
@property (weak, nonatomic) id<WFLineChartViewDelegate> delegate;

/** 头部标题 */
@property (copy, nonatomic) NSString *headerTitle;
/** X轴文字 */
@property (copy, nonatomic) NSString *xAxisTitle;
/** Y轴文字 */
@property (copy, nonatomic) NSString *yAxisTitle;

/** X轴所要显示的数据 */
@property (strong, nonatomic) NSArray<NSString *> *xAxisTitleArray;
/** 是否显示网格 */
@property (assign, nonatomic) BOOL isShowGridding;
/** 是否填充 */
@property (assign, nonatomic) BOOL isFill;
/** 是否显示每个点的值 */
@property (assign, nonatomic) BOOL isShopValue;
/** 是否显示动画 */
@property (assign, nonatomic) BOOL isAnimation;
/** bar的宽度 */
@property (assign, nonatomic) CGFloat barWidth;
/** 图形 */
@property (assign, nonatomic) WFChartViewType chartType;

- (instancetype)initWithFrame:(CGRect)frame xTitleArray:(NSArray *)titleArray;

- (void)showChartViewWithYAxisMaxValue:(CGFloat)yAxisMax dataSource:(NSArray<WFChartModel *> *)dataSource;

@end
