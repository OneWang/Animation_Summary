//
//  WFTransitionEnter.m
//  Animation_Summary
//
//  Created by Jack on 2019/3/30.
//  Copyright © 2019 Jack. All rights reserved.
//

#import "WFTransitionEnter.h"
#import "UIViewController+WFTransitionAnimation.h"

@implementation WFTransitionEnter

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    NSMutableArray<UIView *> *sourceListArray = [NSMutableArray array];
    NSMutableArray<UIView *> *targetListArray = [NSMutableArray array];
    
    NSArray<NSString *> *keys = fromVC.sourceViewKeys.allKeys;
    [keys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([toVC.targetViewKeys objectForKey:obj]) {
            [sourceListArray addObject:[fromVC.sourceViewKeys objectForKey:obj]];
            [targetListArray addObject:[toVC.targetViewKeys objectForKey:obj]];
        }
    }];
    
    //获取快照列表
    NSMutableArray<UIView *> *snapshotArray = [NSMutableArray array];
    [sourceListArray enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *snapshotView = [obj snapshotViewAfterScreenUpdates:NO];
        [snapshotView convertRect:obj.frame fromView:obj.superview];
        [snapshotArray addObject:snapshotView];
    }];
    
    [sourceListArray enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = YES;
    }];
    [targetListArray enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = YES;
    }];
    
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    toVC.view.alpha = 0.f;
    
    [containerView addSubview:toVC.view];
    [snapshotArray enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [containerView addSubview:obj];
    }];
    
    [UIView animateWithDuration:duration animations:^{
        toVC.view.alpha = 1.f;
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
