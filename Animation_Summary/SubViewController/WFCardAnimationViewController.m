//
//  WFCardAnimationViewController.m
//  Animation_Summary
//
//  Created by Jack on 2019/3/11.
//  Copyright © 2019 Jack. All rights reserved.
//

#import "WFCardAnimationViewController.h"
#import "WFCardContentView.h"
#import "WFCardContainerView.h"

@interface WFCardAnimationViewController ()<WFCardContainerViewDelegate,WFCardContainerViewDataSource>
@property (nonatomic, strong) WFCardContainerView *container;
@end

@implementation WFCardAnimationViewController

- (void)loadUI {
    self.container = [[WFCardContainerView alloc] initWithFrame:CGRectMake(0, 88, K_Screen_Width, K_Screen_Height)];
    self.container.delegate = self;
    self.container.dataSource = self;
    [_container reloadData];
    [self.view addSubview:self.container];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self loadUI];
}

#pragma mark - WFCardContainerViewDelegate,WFCardContainerViewDataSource
- (NSInteger)numberOfCountsInContainerView:(WFCardContainerView *)containView{
    return 10;
}

- (WFCardContentView *)cardContainView:(WFCardContainerView *)containView cardForAtIndex:(NSInteger)index{
    static NSString * const idenfitier = @"WFCardContainerView";
    WFCardContentView *view = [containView dequeueReusableCardContentViewWithIdentifier:idenfitier];
    if (!view) {
        view = [[WFCardContentView alloc] initWithFrame:containView.bounds reuseIdentifier:idenfitier];
    }
    return view;
}

- (void)cardContainerView:(WFCardContainerView *)containerView dragDirection:(WFCardContainerViewDragDirection)direction{
    
}

@end
