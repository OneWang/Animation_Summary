//
//  WFPopAnimation.h
//  AnimationDemo
//
//  Created by Jack on 2018/4/9.
//  Copyright © 2018年 Jack. All rights reserved.
//  自定义 pop 返回的转场动画

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface WFPopAnimation : NSObject

/** to转场时间 默认0.5 */
@property (nonatomic, assign) NSTimeInterval toDuration;
/** back转场时间 默认0.5 */
@property (nonatomic, assign) NSTimeInterval backDuration;

@end

@interface WFNavigationInteractiveTransition : NSObject

/** 初始化方法 */
- (instancetype)initWithViewController:(UIViewController *)targetVC;
- (void)handleControllerPop:(UIPanGestureRecognizer *)recognizer;

@end
NS_ASSUME_NONNULL_END
