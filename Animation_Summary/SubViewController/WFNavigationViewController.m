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
    
    WFFlexibleButton *button = [[WFFlexibleButton alloc] initWithFrame:CGRectMake(10, 50, 50, 50)];
    [self.view addSubview:button];
    
    [self setUpUI];
}


- (void)setUpUI {
    self.addButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 220, 550, 120, 50)];
    [self.view addSubview:self.addButton];
    self.addButton.backgroundColor = [UIColor redColor];
    [self.addButton setTitle:@"加入购物车" forState:UIControlStateNormal];
    [self.addButton addTarget:self action:@selector(addButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.shoppingCartButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 220 - 50 - 20, 550, 50, 50)];
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

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    WFNavigationSubViewController *subVC = [[WFNavigationSubViewController alloc] init];
    [self.navigationController pushViewController:subVC animated:YES];
}

@end
