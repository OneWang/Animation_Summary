//
//  WFWaveHeader.h
//  AnimationDemo
//
//  Created by Jack on 2018/3/30.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WFWaveHeader : UIView

/** 波浪的回调Y值 */
@property (copy, nonatomic) void(^callBack)(CGFloat offsetY);

/**
 初始化方法

 @param frame  frame
 @param backColor  背景颜色
 @param beforColor 前景颜色
 @return 实例化 view
 */
- (instancetype)initWithFrame:(CGRect)frame backgroundColor:(UIColor *)backColor beforColor:(UIColor *)beforColor;

@end
