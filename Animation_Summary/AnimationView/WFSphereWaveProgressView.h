//
//  WFSphereWaveProgressView.h
//  AnimationDemo
//
//  Created by Jack on 2018/3/21.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WFSphereWaveProgressView : UIView

/** 进度 */
@property (assign, nonatomic) CGFloat progress;

/**
 初始化方法

 @param frame frame
 @param backColor 背景色
 @param beforColor 前景色
 @return WFSphereWaveProgressView
 */
- (instancetype)initWithFrame:(CGRect)frame backgroundColor:(UIColor *)backColor beforColor:(UIColor *)beforColor;

@end
