//
//  WFLineChartView.h
//  AnimationDemo
//
//  Created by Jack on 2018/4/13.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WFLineChartView : UIView

/** X轴所要显示的数据 */
@property (strong, nonatomic) NSArray<NSString *> *xAxisTitleArray;

- (instancetype)initWithFrame:(CGRect)frame xTitleArray:(NSArray *)titleArray;

@end
