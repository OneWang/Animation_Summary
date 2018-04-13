//
//  WFPieChartItem.m
//  AnimationDemo
//
//  Created by Jack on 2018/4/13.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import "WFPieChartItem.h"

@implementation WFPieChartItem

+ (instancetype)wf_pieChartItemWithValue:(CGFloat)progress color:(UIColor *)color title:(NSString *)title{
    WFPieChartItem *item = [[WFPieChartItem alloc] init];
    item.progress = progress;
    item.color = color;
    item.title = title;
    return item;
}

@end
