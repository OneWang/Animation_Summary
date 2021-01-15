//
//  WFPresentTransition.m
//  Animation_Summary
//
//  Created by Jack on 2020/7/2.
//  Copyright © 2020 Jack. All rights reserved.
//

#import "WFPresentTransition.h"

@implementation WFPresentTransition

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController * toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    CGRect finalFrameForVc = [transitionContext finalFrameForViewController:toVc];
    CGRect bounds = [[UIScreen mainScreen] bounds];
    toVc.view.frame = CGRectOffset(finalFrameForVc, 0, bounds.size.height);
    [[transitionContext containerView] addSubview:toVc.view];
    UIView *containerView = [transitionContext containerView];
    containerView.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toVc.view.frame = finalFrameForVc;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3f;
}

@end
