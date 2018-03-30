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
@end