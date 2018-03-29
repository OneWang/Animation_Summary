//
//  ViewController.m
//  AnimationDemo
//
//  Created by Jack on 2018/3/20.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import "ViewController.h"
#import "WFCircleProgressView.h"
#import "WFSphereWaveProgressView.h"
#import "WFRefreshHeaderView.h"
#import "WFDisplayView.h"
#import "WFElasticityView.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
/** 圆环进度条 */
@property (weak, nonatomic) WFCircleProgressView *progressView;
/** 球形进度条 */
@property (weak, nonatomic) WFSphereWaveProgressView *sphereView;
/** tableView */
@property (strong, nonatomic) UITableView *tableView;
/** header */
@property (weak, nonatomic) WFRefreshHeaderView *headerView;
/** header */
@property (weak, nonatomic) WFElasticityView *displayView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"动画";
    
//    [self createCircleProgressView];
//
//    [self createSphereProgressView];
//
//    [self createRefreshHeaderView];
    [self createDisplayView];
}

#pragma mark - 曲线动画
- (void)createDisplayView{
    self.view.backgroundColor = [UIColor whiteColor];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, K_Screen_Width, K_Screen_Height - 64) style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    _tableView = tableView;
    
    WFElasticityView *v1 = [[WFElasticityView alloc] initWithBlindScrollView:_tableView];
    [v1 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:v1];
    [tableView addSubview:v1];
}

#pragma mark - 圆环进度条
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
    _sphereView.progress = slider.value;
}

#pragma mark - 球形进度条
- (void)createSphereProgressView{
    WFSphereWaveProgressView *sphere = [[WFSphereWaveProgressView alloc] initWithFrame:CGRectMake(20, 140, 100, 100) backgroundColor:[UIColor yellowColor] beforColor:[UIColor greenColor]];
    [self.view addSubview:sphere];
    self.sphereView = sphere;
}

#pragma mark -
- (void)createRefreshHeaderView{
    WFRefreshHeaderView *header = [[WFRefreshHeaderView alloc] initWithFrame:CGRectMake(20, 250, 100, 100)];
    header.backgroundColor = [UIColor yellowColor];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,250, self.view.frame.size.width, self.view.frame.size.height - 250) style:UITableViewStyleGrouped];
    _headerView = header;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.tableHeaderView = header;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identif = @"refresh";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identif];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identif];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第%zd行",indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0000001f;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    [_headerView startAnimation];

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    [_headerView endAnimation];
}

@end
