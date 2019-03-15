//
//  WFCardContainerView.h
//  Animation_Summary
//
//  Created by Jack on 2019/3/15.
//  Copyright © 2019年 Jack. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class WFCardContainerView,WFCardContentView;
@protocol WFCardContainerViewDataSource <NSObject>

- (NSInteger)numberOfCountsInContainerView:(WFCardContainerView *)containView;

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (WFCardContentView *)cardContainView:(WFCardContainerView *)containView cardForAtIndex:(NSInteger)index;

@end

@interface WFCardContainerView : UIView

@property (nonatomic, weak, nullable) id<WFCardContainerViewDataSource> dataSource;

@end

NS_ASSUME_NONNULL_END
