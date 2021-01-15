//
//  WFNavigationSubViewController.m
//  Animation_Summary
//
//  Created by Jack on 2018/11/11.
//  Copyright © 2018 Jack. All rights reserved.
//

#import "WFNavigationSubViewController.h"
#import "UIViewController+WFTransitionAnimation.h"

@interface WFNavigationSubViewController ()

@end

@implementation WFNavigationSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    // Do any additional setup after loading the view.
    
//    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
//    back.frame = CGRectMake(15, 0, 44, 44);
//    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    [back setTitle:@"返回" forState:UIControlStateNormal];
//    [back setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    
    [self p_initLayout];
    [self enableInteractiveTransition];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self registerNavigationViewControllerDelegate];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self removeNavigationViewControllerDelegate];
}

#pragma mark - init
- (void)p_initLayout{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 80, 200, 300)];
    [imageView setImage:[UIImage imageNamed:@"arrow_right_44px"]];
    [self.view addSubview:imageView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, 400, 250, 100)];
    [view setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:view];
    
    [self setTargetView:imageView andTag:@"imageView"];
    [self setTargetView:view andTag:@"view"];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
