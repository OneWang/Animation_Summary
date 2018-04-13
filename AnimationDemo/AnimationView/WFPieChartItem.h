//
//  WFPieChartItem.h
//  AnimationDemo
//
//  Created by Jack on 2018/4/13.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WFPieChartItem : NSObject
/** 标题 */
@property (copy, nonatomic) NSString *title;
/** 值 */
@property (assign, nonatomic) CGFloat progress;
/** 颜色 */
@property (strong, nonatomic) UIColor *color;

+ (instancetype)wf_pieChartItemWithValue:(CGFloat)progress color:(UIColor *)color title:(NSString *)title;

@end
