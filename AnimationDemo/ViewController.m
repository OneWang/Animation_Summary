//
//  ViewController.m
//  AnimationDemo
//
//  Created by Jack on 2018/3/20.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import "ViewController.h"
#import "WFCircleProgressView.h"

@interface ViewController ()
/** 圆环进度条 */
@property (weak, nonatomic) WFCircleProgressView *progressView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createCircleProgressView];
}

- (void)createCircleProgressView{
    WFCircleProgressView *progress = [[WFCircleProgressView alloc] initWithFrame:CGRectMake(20, 20, 100, 100) lineWidth:20.f progressColor:[UIColor redColor] backgroundColor:[UIColor orangeColor]];
    self.progressView = progress;
    progress.progressColor = [UIColor purpleColor];
    [self.view addSubview:progress];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(140, 100, 200, 10)];
    [self.view addSubview:slider];
    slider.minimumValue = 0.f;
    slider.maximumValue = 1.0f;
    [slider addTarget:self action:@selector(sliderClick:) forControlEvents:UIControlEventValueChanged];
}

- (void)sliderClick:(UISlider *)slider{
    _progressView.progress = slider.value;
}

@end
