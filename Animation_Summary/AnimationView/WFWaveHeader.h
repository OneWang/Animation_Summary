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

- (instancetype)initWithFrame:(CGRect)frame backgroundColor:(UIColor *)backColor beforColor:(UIColor *)beforColor;

@end
