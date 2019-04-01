//
//  WFNavigationViewController.m
//  Animation_Summary
//
//  Created by Jack on 2018/11/11.
//  Copyright © 2018 Jack. All rights reserved.
//

#import "WFNavigationViewController.h"
#import "WFNavigationSubViewController.h"
#import "WFFlexibleButton.h"
#import "WFParabolaAnimation.h"
#import "UIViewController+WFTransitionAnimation.h"

@interface WFNavigationViewController ()

@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIButton *shoppingCartButton;
@property (nonatomic, strong) UILabel *goodsNumLabel;

@end

@implementation WFNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    // Do any additional setup after loading the view.
    
    WFFlexibleButton *button = [[WFFlexibleButton alloc] initWithFrame:CGRectMake(10, 500, 50, 50)];
    [self.view addSubview:button];
    
    [self setUpUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self registerNavigationViewControllerDelegate];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self removeNavigationViewControllerDelegate];
}

- (void)setUpUI {
    self.addButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 120, 550, 120, 50)];
    [self.view addSubview:self.addButton];
    self.addButton.backgroundColor = [UIColor redColor];
    [self.addButton setTitle:@"加入购物车" forState:UIControlStateNormal];
    [self.addButton addTarget:self action:@selector(addButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.shoppingCartButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 120 - 50 - 120, 550, 50, 50)];
    [self.view addSubview:self.shoppingCartButton];
    [self.shoppingCartButton setImage:[UIImage imageNamed:@"cart"] forState:UIControlStateNormal];
    [self.shoppingCartButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.goodsNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.shoppingCartButton.center.x, 550, 30, 15)];
    [self.view addSubview:self.goodsNumLabel];
    self.goodsNumLabel.backgroundColor = [UIColor redColor];
    self.goodsNumLabel.textColor = [UIColor whiteColor];
    self.goodsNumLabel.textAlignment = NSTextAlignmentCenter;
    self.goodsNumLabel.font = [UIFont systemFontOfSize:10];
    self.goodsNumLabel.layer.cornerRadius = 7;
    self.goodsNumLabel.clipsToBounds = YES;
    self.goodsNumLabel.text = @"99+";
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 250, 100, 150)];
    [imageView setImage:[UIImage imageNamed:@"arrow_right_44px"]];
    [self.view addSubview:imageView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(150, 250, 100, 100)];
    [view setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:view];
    
    UIButton *normalButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [normalButton setTitle:@"跳转页面3" forState:UIControlStateNormal];
    [normalButton setBackgroundColor:[UIColor blackColor]];
    [normalButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:normalButton];
    
    [self setSourceView:imageView andTag:@"imageView"];
    [self setSourceView:view andTag:@"view"];
}

- (void)addButtonClicked:(UIButton *)sender {
    [WFParabolaAnimation addParabolaAnimation:[UIImage imageNamed:@"heheda"] startPoint:self.addButton.center endPoint:self.shoppingCartButton.center completion:^(BOOL finished) {
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
        scaleAnimation.toValue = [NSNumber numberWithFloat:0.7];
        scaleAnimation.duration = 0.1;
        scaleAnimation.repeatCount = 2; 
        scaleAnimation.autoreverses = YES;
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [self.goodsNumLabel.layer addAnimation:scaleAnimation forKey:nil];
    }];
}

- (void)onClick:(id)sender {
    [self.navigationController pushViewController:[[WFNavigationSubViewController alloc] init] animated:YES];
}

@end
