//
//  WFTransitionExit.m
//  Animation_Summary
//
//  Created by Jack on 2019/3/30.
//  Copyright © 2019 Jack. All rights reserved.
//

#import "WFTransitionExit.h"
#import "UIViewController+WFTransitionAnimation.h"

@implementation WFTransitionExit

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    NSMutableArray<UIView *> *sourceListArray = [NSMutableArray array];
    NSMutableArray<UIView *> *targetListArray = [NSMutableArray array];
    
    NSArray<NSString *> *keys = fromVC.targetViewKeys.allKeys;
    [keys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([toVC.sourceViewKeys objectForKey:obj]) {
            [sourceListArray addObject:[fromVC.targetViewKeys objectForKey:obj]];
            [targetListArray addObject:[toVC.sourceViewKeys objectForKey:obj]];
        }
    }];
    
    //获取快照列表
    NSMutableArray<UIView *> *snapshotArray = [NSMutableArray array];
    [sourceListArray enumerateObjectsUsingBlock:^(UIView * _Nonnull sourceView, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *snapshotView = [sourceView snapshotViewAfterScreenUpdates:NO];
        snapshotView.frame = [containerView convertRect:sourceView.frame fromView:sourceView.superview];
        [snapshotArray addObject:snapshotView];
    }];
    
    [sourceListArray enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = YES;
    }];
    [targetListArray enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = YES;
    }];
    
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    [containerView insertSubview:toVC.view belowSubview:fromVC.view];
    
    [snapshotArray enumerateObjectsUsingBlock:^(UIView * _Nonnull snapshot, NSUInteger idx, BOOL * _Nonnull stop) {
        [containerView addSubview:snapshot];
    }];
    
    [UIView animateWithDuration:duration animations:^{
        fromVC.view.alpha = 0.f;
        [targetListArray enumerateObjectsUsingBlock:^(UIView * _Nonnull targetView, NSUInteger idx, BOOL * _Nonnull stop) {
            UIView *snapshotView = [snapshotArray objectAtIndex:idx];
            CGRect frame = [containerView convertRect:targetView.frame fromView:targetView.superview];
            snapshotView.frame = frame;
        }];
    } completion:^(BOOL finished) {
        [sourceListArray enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hidden = NO;
        }];
        [targetListArray enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hidden = NO;
        }];
        [snapshotArray enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3f;
}


@end
