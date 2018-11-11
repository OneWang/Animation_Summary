//
//  WFNavigationViewController.m
//  Animation_Summary
//
//  Created by Jack on 2018/11/11.
//  Copyright © 2018 Jack. All rights reserved.
//

#import "WFNavigationViewController.h"
#import "WFNavigationSubViewController.h"

@interface WFNavigationViewController ()

@end

@implementation WFNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    WFNavigationSubViewController *subVC = [[WFNavigationSubViewController alloc] init];
    [self.navigationController pushViewController:subVC animated:YES];
}

@end
