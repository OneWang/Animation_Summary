//
//  UIViewController+WFTransitionAnimation.m
//  Animation_Summary
//
//  Created by Jack on 2019/3/30.
//  Copyright © 2019 Jack. All rights reserved.
//

#import "UIViewController+WFTransitionAnimation.h"
#import "WFTransitionEnter.h"
#import "WFTransitionExit.h"
#import <objc/runtime.h>
#import "UIView+WFExtension.h"

static void *sourceKeys = &sourceKeys;
static void *targetKeys = &targetKeys;
static void *interactiveTransition = &interactiveTransition;

@interface UIViewController ()<UINavigationControllerDelegate>

/** 交互式动画 */
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactiveTransition;

@end

@implementation UIViewController (WFTransitionAnimation)

- (void)setSourceView:(UIView *)view andTag:(NSString *)tag{
    if (!self.sourceViewKeys) {
        self.sourceViewKeys = [NSMutableDictionary dictionary];
    }
    [self.sourceViewKeys setValue:view forKey:tag];
}

- (void)setTargetView:(UIView *)view andTag:(NSString *)tag{
    if (!self.targetViewKeys) {
        self.targetViewKeys = [NSMutableDictionary dictionary];
    }
    [self.targetViewKeys setValue:view forKey:tag];
}

- (void)registerNavigationViewControllerDelegate{
    self.navigationController.delegate = self;
}

- (void)removeNavigationViewControllerDelegate{
    if (self.navigationController.delegate == self) {
        self.navigationController.delegate = nil;
    }
}

- (void)enableInteractiveTransition{
    UIScreenEdgePanGestureRecognizer *panGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(p_handlePopRecognizer:)];
    panGesture.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:panGesture];
}

#pragma mark - setter and getter
- (void)setTargetViewKeys:(NSMutableDictionary *)keys{
    objc_setAssociatedObject(self, &targetKeys, keys, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)targetViewKeys{
    return objc_getAssociatedObject(self, &targetKeys);
}

- (void)setSourceViewKeys:(NSMutableDictionary *)keys{
    objc_setAssociatedObject(self, &sourceKeys, keys, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)sourceViewKeys{
    return objc_getAssociatedObject(self, &sourceKeys);
}

- (void)setInteractiveTransition:(UIPercentDrivenInteractiveTransition *)transition{
    objc_setAssociatedObject(self, &interactiveTransition, transition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIPercentDrivenInteractiveTransition *)interactiveTransition{
    return objc_getAssociatedObject(self, &interactiveTransition);
}

#pragma mark - UINavigationControllerDelegate
- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    if ([animationController isKindOfClass:WFTransitionExit.class]) {
        return self.interactiveTransition;
    }else{
        return nil;
    }
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    if (fromVC == self) {
        if (operation == UINavigationControllerOperationPush && self.sourceViewKeys.count) {
            return [WFTransitionEnter new];
        }else if(operation == UINavigationControllerOperationPop && self.targetViewKeys.count){
            return [WFTransitionExit new];
        }
    }
    return nil;
}

#pragma mark - private method
- (void)p_handlePopRecognizer:(UIScreenEdgePanGestureRecognizer *)panGesture{
    CGFloat progress = [panGesture translationInView:self.view].x / self.view.width;
    progress = MIN(1, MAX(0, progress));
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        self.interactiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self.navigationController popViewControllerAnimated:YES];
    }else if (panGesture.state == UIGestureRecognizerStateChanged){
        [self.interactiveTransition updateInteractiveTransition:progress];
    }else if(panGesture.state == UIGestureRecognizerStateEnded || panGesture.state == UIGestureRecognizerStateCancelled){
        if (progress > 0.5) {
            [self.interactiveTransition finishInteractiveTransition];
        }else{
            [self.interactiveTransition cancelInteractiveTransition];
        }
        self.interactiveTransition = nil;
    }
}

@end
