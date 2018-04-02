//
//  ViewController.m
//  AnimationDemo
//
//  Created by Jack on 2018/3/20.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import "ViewController.h"
#import "WFDisplayView.h"
#import "WFElasticityView.h"
#import "WFWaveHeader.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
/** tableView */
@property (strong, nonatomic) UITableView *tableView;
/** header */
@property (weak, nonatomic) WFDisplayView *displayView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"动画";
    
    [self createDisplayView];
    
//    [self creatHeaderDragAnimation];
}

#pragma mark - 曲线动画
- (void)createDisplayView{
//    self.view.backgroundColor = [UIColor whiteColor];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, K_Screen_Width, K_Screen_Height - 64) style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    _tableView = tableView;
    
//    WFWaveHeader *header = [[WFWaveHeader alloc] initWithFrame:CGRectMake(0, 0, K_Screen_Width, 100) backgroundColor:[UIColor yellowColor] beforColor:[UIColor purpleColor]];
//    tableView.tableHeaderView = header;
    
    WFElasticityView *v1 = [[WFElasticityView alloc] initWithBlindScrollView:_tableView];
    [v1 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:v1];
    [tableView addSubview:v1];
}

- (void)creatHeaderDragAnimation{
    WFDisplayView *v1 = [[WFDisplayView alloc] initWithFrame:CGRectMake( 0, 64, K_Screen_Width, 140)];
    v1.backgroundColor = [UIColor yellowColor];
    _displayView = v1;
    [self.view addSubview:v1];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 140, K_Screen_Width, K_Screen_Height - 64 - 140) style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.delegate = self;
    tableView.dataSource = self;
    _tableView = tableView;
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
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld行",(long)indexPath.row];
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
    _displayView.offsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    [_headerView endAnimation];
}

@end
