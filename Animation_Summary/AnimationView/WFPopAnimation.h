//
//  WFPopAnimation.h
//  AnimationDemo
//
//  Created by Jack on 2018/4/9.
//  Copyright © 2018年 Jack. All rights reserved.
//  自定义转场动画

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WFPopAnimation : NSObject

@end

@interface WFNavigationInteractiveTransition : NSObject

/** 初始化方法 */
- (instancetype)initWithViewController:(UIViewController *)targetVC;
- (void)handleControllerPop:(UIPanGestureRecognizer *)recognizer;

@end

