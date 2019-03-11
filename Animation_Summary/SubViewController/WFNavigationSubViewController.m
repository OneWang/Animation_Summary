//
//  WFNavigationSubViewController.m
//  Animation_Summary
//
//  Created by Jack on 2018/11/11.
//  Copyright © 2018 Jack. All rights reserved.
//

#import "WFNavigationSubViewController.h"

@interface WFNavigationSubViewController ()

@end

@implementation WFNavigationSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    // Do any additional setup after loading the view.
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(15, 0, 44, 44);
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [back setTitle:@"返回" forState:UIControlStateNormal];
    [back setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
