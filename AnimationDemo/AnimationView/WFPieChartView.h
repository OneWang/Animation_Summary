//
//  WFPieChartView.h
//  AnimationDemo
//
//  Created by Jack on 2018/4/13.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFPieChartItem,WFPieChartView;
@protocol WFPieChartViewDelegate <NSObject>
@optional
- (void)wf_pieChartView:(WFPieChartView *)pieChartView didClickIndex:(NSInteger)index;
@end

@interface WFPieChartView : UIView

/** 圆环间距 */
@property (assign, nonatomic) CGFloat piePace;
/** 显示饼状图的宽度 */
@property (assign, nonatomic) CGFloat borderWidth;
/** 代理 */
@property (weak, nonatomic) id<WFPieChartViewDelegate> delegate;

/**
 初始化饼状图
 @param frame frame大小
 @param items 数据数组
 @return 饼状图
 */
- (instancetype)initWithFrame:(CGRect)frame items:(NSArray<WFPieChartItem *> *)items;

@end
