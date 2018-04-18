//
//  WFChartViewController.m
//  AnimationDemo
//
//  Created by Jack on 2018/4/17.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import "WFChartViewController.h"
#import "WFLineChartView.h"
#import "WFChartModel.h"

@interface WFChartViewController ()

@end

@implementation WFChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    WFLineChartView *lineView = [[WFLineChartView alloc] initWithFrame:CGRectMake(0, 100, K_Screen_Width, 300) xTitleArray:@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"]];
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.isShowGridding = YES;
    lineView.isShopValue = YES;
    lineView.isAnimation = YES;
    lineView.chartType = WFChartViewTypeBar;
    lineView.barWidth = 20.f;
    lineView.headerTitle = @"折线图";
    WFChartModel *model = [WFChartModel modelWithColor:RandomColor plots:[self randomArrayWithCount:12] project:@"1组"];
    WFChartModel *model1 = [WFChartModel modelWithColor:RandomColor plots:[self randomArrayWithCount:12] project:@"2组"];
    WFChartModel *model2 = [WFChartModel modelWithColor:RandomColor plots:[self randomArrayWithCount:12] project:@"3组"];
    NSArray *dataSource = @[model,model1,model2];
    [lineView showChartViewWithYAxisMaxValue:1200 dataSource:dataSource];
    [self.view addSubview:lineView];
}

- (NSArray *)randomArrayWithCount:(NSInteger)dataCounts {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < dataCounts; i++) {
        NSString *number = [NSString stringWithFormat:@"%d",arc4random_uniform(1000)];
        [array addObject:number];
    }
    return array.copy;
}

@end
