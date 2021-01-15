//
//  WFCardAnimationViewController.m
//  Animation_Summary
//
//  Created by Jack on 2019/3/11.
//  Copyright © 2019 Jack. All rights reserved.
//

#import "WFCardAnimationViewController.h"
#import "WFCardContentCell.h"
#import "WFCardContainerView.h"
#import "WFCardTestCell.h"
#import "WFCardBackAnimation.h"

@interface WFCardAnimationViewController ()<WFCardContainerViewDelegate,WFCardContainerViewDataSource>
@property (nonatomic, strong) WFCardContainerView *container;
@property(nonatomic, weak) WFCardBackAnimation *cardView;
@end

@implementation WFCardAnimationViewController

- (void)loadUI {
//    self.container = [[WFCardContainerView alloc] initWithFrame:CGRectMake(0, 88, K_Screen_Width, K_Screen_Height)];
//    self.container.cardSpace = 40;
//    self.container.delegate = self;
//    self.container.dataSource = self;
//    [self.view addSubview:self.container];
    WFCardBackAnimation *cardView  =  [[WFCardBackAnimation alloc] initWithFrame:CGRectMake(0, 100, K_Screen_Width, K_Screen_Height - 200)];
    _cardView = cardView;
    [self.view addSubview:cardView];
    [cardView startAnimation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self loadUI];
}

-  (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.cardView.isFinish = YES;
}

#pragma mark - WFCardContainerViewDelegate,WFCardContainerViewDataSource
- (NSInteger)numberOfCountsInContainerView:(WFCardContainerView *)containView{
    return 10;
}

- (WFCardContentCell *)cardContainView:(WFCardContainerView *)containView cardForAtIndex:(NSInteger)index{
    static NSString * const idenfitier = @"WFCardContainerView";
    WFCardTestCell *view = [containView dequeueReusableCardContentViewWithIdentifier:idenfitier];
    if (!view) {
        view = [[WFCardTestCell alloc] initWithStyle:WFCardContentCellStyleDefault reuseIdentifier:idenfitier];
    }
    view.text = [NSString stringWithFormat:@"奥迪%zd",index];
    return view;
}

- (void)cardContainerView:(WFCardContainerView *)containerView dragDirection:(WFCardContainerViewDragDirection)direction didSelectIndex:(NSInteger)index{
    
}

@end
