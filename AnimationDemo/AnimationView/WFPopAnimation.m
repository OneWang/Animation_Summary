//
//  WFPopAnimation.m
//  AnimationDemo
//
//  Created by Jack on 2018/4/9.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import "WFPopAnimation.h"
#import <UIKit/UIKit.h>

//自定义动画对象
@interface WFPopAnimation ()<UIViewControllerAnimatedTransitioning,CAAnimationDelegate>
/** 此代理是想改变系统切换的动画方式 */
@property (weak, nonatomic) id<UIViewControllerContextTransitioning> transitionContext;
@end

@implementation WFPopAnimation

/** transitionContext可以看作是一个工具，用来执行一系列动画的相关的对象，并且通知系统动画是否完成等功能 */
- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    //获取来自哪个控制器
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    //获取到哪个控制器
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //转场动画是两个控制器之间的动画，需要一个containerView作为舞台来执行动画
    UIView *containerView = [transitionContext containerView];
    [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
    
    NSTimeInterval interval = [self transitionDuration:transitionContext];
    //执行动画
    [UIView animateWithDuration:interval delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        fromViewController.view.transform = CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width, 0);
    } completion:^(BOOL finished) {
        //动画执行完毕之后这个方法必须调用，否则系统会认为你的其余任何操作都在动画执行过程中；
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
    
//    _transitionContext = transitionContext;
//    //切换动画方式
//    [UIView beginAnimations:@"View Flip" context:nil];
//    [UIView setAnimationDuration:interval];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:containerView cache:YES];
//    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:)];
//    [UIView commitAnimations];
//    [containerView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
}

/** 返回动画的执行时间 */
- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animationDidStop:(CATransition *)anim finished:(BOOL)flag {
    [_transitionContext completeTransition:!_transitionContext.transitionWasCancelled];
}

@end

//专门处理交互对象的,换掉系统的动画切换方式为自定义的动画方式
@interface WFNavigationInteractiveTransition ()<UINavigationControllerDelegate>
/** 导航控制器 */
@property (weak, nonatomic) UINavigationController *navigationVC;
/** interactivePopTransition */
@property (strong, nonatomic) UIPercentDrivenInteractiveTransition *interactivePopTransition;
@end

@implementation WFNavigationInteractiveTransition

- (instancetype)initWithViewController:(UIViewController *)targetVC{
    if (self = [super init]) {
        self.navigationVC = (UINavigationController *)targetVC;
        self.navigationVC.delegate = self;
    }
    return self;
}

/** 系统提供的自定义动画的转场方式 */
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC{
    //pop操作的话就返回自定义的动画转场
    if (operation == UINavigationControllerOperationPop) {
        return [[WFPopAnimation alloc] init];
    }
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    //会返回当前动画对象（animationController），如果当前动画对象是我们自定义的pop动画对象，就返回interactivePopTransition来监控动画的完成度
    if ([animationController isKindOfClass:[WFPopAnimation class]]) {
        return self.interactivePopTransition;
    }
    return nil;
}

- (void)handleControllerPop:(UIPanGestureRecognizer *)recognizer{
    CGFloat progress = [recognizer translationInView:recognizer.view].x / recognizer.view.frame.size.width;
    progress = MIN(1.0, MAX(0.0, progress));
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.interactivePopTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self.navigationVC popViewControllerAnimated:YES];
    }else if (recognizer.state == UIGestureRecognizerStateChanged){
        //更改手势进度
        [self.interactivePopTransition updateInteractiveTransition:progress];
    }else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled){
        //进度执行
        if (progress > 0.5) {
            [self.interactivePopTransition finishInteractiveTransition];
        }else{
            [self.interactivePopTransition cancelInteractiveTransition];
        }
        self.interactivePopTransition = nil;
    }
}

@end

