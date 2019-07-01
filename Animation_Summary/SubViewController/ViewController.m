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
#import "WFSubViewController.h"
#import "WFMainTabbarViewController.h"
#import "WFPresentationController.h"
#import "WFSecondViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
/** tableView */
@property (strong, nonatomic) UITableView *tableView;
/** header */
@property (weak, nonatomic) WFDisplayView *displayView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"动画";
    [self creatHeaderDragAnimation];
    
    NSDate *today = [NSDate date];
    NSDate *compareDay = nil;
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *beginDate = @"2019-03-15 18:23:12";
    if (beginDate) {
        compareDay = [dateFormater dateFromString:beginDate];
        if ([compareDay compare:today] == NSOrderedDescending) {
            NSLog(@"%@大于%@",compareDay,today);
        }else if ([compareDay compare:today] == NSOrderedAscending){
            NSLog(@"%@小于%@",compareDay,today);
        }else{
        }
    }
}

#pragma mark - 曲线动画
- (void)createDisplayView{
    self.view.backgroundColor = [UIColor lightGrayColor];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, K_Screen_Width, K_Screen_Height - 64) style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    _tableView = tableView;
    
    WFWaveHeader *header = [[WFWaveHeader alloc] initWithFrame:CGRectMake(0, 0, K_Screen_Width, 100) backgroundColor:[UIColor yellowColor] beforColor:[UIColor purpleColor]];
    tableView.tableHeaderView = header;
    
//    WFElasticityView *v1 = [[WFElasticityView alloc] initWithBlindScrollView:_tableView];
//    v1.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:v1];
//    [tableView addSubview:v1];
}

- (void)creatHeaderDragAnimation{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((K_Screen_Width - 30) * 0.5, 250);
    layout.minimumLineSpacing = 10.f;
    layout.minimumInteritemSpacing = 10.f;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64 + 140, K_Screen_Width, K_Screen_Height - 64 - 140) collectionViewLayout:layout];
    [self.view addSubview:collectionView];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    _collectionView = collectionView;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (int i = 0; i < 20; i ++) {
            [self.dataArray addObject:@"1"];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    });
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = RandomColor;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            cell.transform = CGAffineTransformMakeRotation(0.1);
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                cell.transform = CGAffineTransformMakeRotation(-0.1);
            }];
        });
    }
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"refresh";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld行",(long)indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WFSecondViewController *secondVC = [WFSecondViewController new];
    WFPresentationController *presentationController NS_VALID_UNTIL_END_OF_SCOPE;
    presentationController = [[WFPresentationController alloc] initWithPresentedViewController:secondVC presentingViewController:nil];
    secondVC.transitioningDelegate = presentationController;
    [self presentViewController:secondVC animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [UIView animateWithDuration:0.3 animations:^{
        cell.transform = CGAffineTransformMakeRotation(0.1);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    WFSubViewController *VC = [WFSubViewController new];
    [self presentViewController:VC animated:YES completion:NULL];
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
