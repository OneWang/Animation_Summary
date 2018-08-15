//
//  WFCircleProgressView.h
//  AnimationDemo
//
//  Created by Jack on 2018/3/20.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WFCircleProgressView : UIView

/** 圆环的宽度 */
@property (assign, nonatomic) CGFloat lineWidth;
/** 圆环的进度 */
@property (assign, nonatomic) CGFloat progress;
/** 圆换的颜色 */
@property (strong, nonatomic) UIColor *progressColor;
/**
 初始化方式

 @param frame frame
 @param lineWidth 线宽
 @param progressColor 进度的颜色
 @param backgroundColor 背景颜色
 @return view
 */
- (instancetype)initWithFrame:(CGRect)frame lineWidth:(CGFloat)lineWidth progressColor:(UIColor *)progressColor backgroundColor:(UIColor *)backgroundColor;
@end
