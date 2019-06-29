//
//  WFPhotoBrowseViewController.m
//  Animation_Summary
//
//  Created by Jack on 2019/6/29.
//  Copyright © 2019 Jack. All rights reserved.
//

#import "WFPhotoBrowseViewController.h"
#import "WFPhotoPreviewCell.h"

@interface WFPhotoBrowseViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic, strong) UICollectionView *collectionView;
@end

@implementation WFPhotoBrowseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_setupUI];
}

#pragma mark - private method
- (void)p_setupUI{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:UIScreen.mainScreen.bounds collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.pagingEnabled = YES;
    [collectionView registerClass:WFPhotoPreviewCell.class forCellWithReuseIdentifier:@"WFPhotoPreviewCell"];
    [self.view addSubview:collectionView];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WFPhotoPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WFPhotoPreviewCell" forIndexPath:indexPath];
    return cell;
}

@end
