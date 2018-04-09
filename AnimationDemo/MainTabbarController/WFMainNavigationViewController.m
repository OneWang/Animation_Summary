//
//  WFMainNavigationViewController.m
//  AnimationDemo
//
//  Created by Jack on 2018/4/9.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import "WFMainNavigationViewController.h"
#import "WFPopAnimation.h"

@interface WFMainNavigationViewController ()<UIGestureRecognizerDelegate>
/** 转场动画 */
@property (strong, nonatomic) WFNavigationInteractiveTransition *transition;
@end

@implementation WFMainNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //首先将系统的手势关闭掉
    self.interactivePopGestureRecognizer.enabled = NO;
    
    //创建自定义手势
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] init];
    [self.interactivePopGestureRecognizer.view addGestureRecognizer:panGesture];
    panGesture.delegate = self;
    panGesture.maximumNumberOfTouches = 1;
    
    _transition = [[WFNavigationInteractiveTransition alloc] initWithViewController:self];
    [panGesture addTarget:_transition action:@selector(handleControllerPop:)];
    
//    //获取系统手势的target数组
//    NSMutableArray *_targets = [self.interactivePopGestureRecognizer valueForKey:@"_targets"];
//    //获取它的唯一对象，我们知道它是一个叫UIGestureRecognizerTarget的私有类，它有一个属性叫_target
//    id gestureRecognizerTarget = [_targets firstObject];
//    //获取_target:_UINavigationInteractiveTransition，它有一个方法叫handleNavigationTransition:
//    id navigationInteractiveTransition = [gestureRecognizerTarget valueForKey:@"_target"];
//    //通过前面的打印，我们从控制台获取出来它的方法签名。
//    SEL handleTransition = NSSelectorFromString(@"handleNavigationTransition:");
//    //创建一个与系统一模一样的手势，我们只把它的类改为UIPanGestureRecognizer
//    [panGesture addTarget:navigationInteractiveTransition action:handleTransition];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

#pragma mark ***************************** UIGestureRecognizerDelegate *****************************
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    //这里有两个条件不允许手势执行，1、当前控制器为根控制器；2、如果这个push、pop动画正在执行（私有属性）
    return self.viewControllers.count != 1 && ![[self valueForKey:@"_isTransitioning"] boolValue];
}

@end
