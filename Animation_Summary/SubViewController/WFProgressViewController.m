//
//  WFProgressViewController.m
//  AnimationDemo
//
//  Created by Jack on 2018/3/30.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import "WFProgressViewController.h"
#import "WFCircleProgressView.h"
#import "WFSphereWaveProgressView.h"
#import "WFPieChartItem.h"
#import "WFPieChartView.h"
#import "WFCircleAnimationView.h"
#import "WFShimmerView.h"

@interface WFProgressViewController ()
/** 圆环进度条 */
@property (weak, nonatomic) WFCircleProgressView *progressView;
/** 球形进度条 */
@property (weak, nonatomic) WFSphereWaveProgressView *sphereView;
@end

@implementation WFProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createCircleProgressView];
    [self createSphereProgressView];
    [self createPieChartView];
    [self createCilcleAnimationView];
    [self createShimmerView];
}

#pragma mark - 闪烁动画
- (void)createShimmerView{
    WFShimmerView *shimmerView = [[WFShimmerView alloc] initWithFrame:CGRectMake(50, 300, 100, 100)];
    [self.view addSubview:shimmerView];
}

#pragma mark - 圆形动画
- (void)createCilcleAnimationView{
    WFCircleAnimationView *circleView = [[WFCircleAnimationView alloc] initWithFrame:CGRectMake(220, 240, 100, 100)];
    [self.view addSubview:circleView];
}

#pragma mark - 圆环进度条
- (void)createCircleProgressView{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"进度条动画";
    
    WFCircleProgressView *progress = [[WFCircleProgressView alloc] initWithFrame:CGRectMake(20, 100, 100, 100) lineWidth:20.f progressColor:[[UIColor redColor] colorWithAlphaComponent:0.5] backgroundColor:[UIColor orangeColor]];
    self.progressView = progress;
    progress.progressColor = [UIColor purpleColor];
    [self.view addSubview:progress];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(140, 200, 200, 10)];
    [self.view addSubview:slider];
    slider.minimumValue = 0.f;
    slider.maximumValue = 1.0f;
    [slider addTarget:self action:@selector(sliderClick:) forControlEvents:UIControlEventValueChanged];
}

- (void)sliderClick:(UISlider *)slider{
    _progressView.progress = slider.value;
    _sphereView.progress = slider.value;
}

#pragma mark - 球形进度条
- (void)createSphereProgressView{
    WFSphereWaveProgressView *sphere = [[WFSphereWaveProgressView alloc] initWithFrame:CGRectMake(20, 240, 100, 100) backgroundColor:[UIColor yellowColor] beforColor:[UIColor greenColor]];
    [self.view addSubview:sphere];
    self.sphereView = sphere;
}

#pragma mark - 饼状图
- (void)createPieChartView{
    NSArray *array = @[[WFPieChartItem wf_pieChartItemWithValue:10 color:[UIColor purpleColor] title:@"测试1" titleColor:[UIColor blueColor]],
                       [WFPieChartItem wf_pieChartItemWithValue:20 color:[UIColor yellowColor] title:@"测试2" titleColor:[UIColor blueColor]],
                       [WFPieChartItem wf_pieChartItemWithValue:40 color:[UIColor greenColor] title:@"测试3" titleColor:[UIColor blueColor]]];
    WFPieChartView *pieChart = [[WFPieChartView alloc] initWithFrame:CGRectMake(100, 350, 200, 200) items:array radius:80];
    pieChart.piePace = 10.f;
    pieChart.borderWidth = 40.f;
    [self.view addSubview:pieChart];
}

@end
