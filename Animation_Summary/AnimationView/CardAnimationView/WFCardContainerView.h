//
//  WFCardContainerView.h
//  Animation_Summary
//
//  Created by Jack on 2019/3/15.
//  Copyright © 2019年 Jack. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSInteger, WFCardContainerViewDragDirection) {
    WFCardContainerViewDragDefault     = 0,
    WFCardContainerViewDragLeft        = 1 << 0,
    WFCardContainerViewDragRight       = 1 << 1
};

@class WFCardContainerView,WFCardContentCell;
@protocol WFCardContainerViewDelegate <NSObject>
@optional
- (void)cardContainerView:(WFCardContainerView *)containerView dragDirection:(WFCardContainerViewDragDirection)direction didSelectIndex:(NSInteger)index;

- (CGSize)cardContainViewForCardSizeWithContaninView:(WFCardContainerView *)containView;

@end

@protocol WFCardContainerViewDataSource <NSObject>
@required
- (NSInteger)numberOfCountsInContainerView:(WFCardContainerView *)containView;

- (WFCardContentCell *)cardContainView:(WFCardContainerView *)containView cardForAtIndex:(NSInteger)index;

@end

@interface WFCardContainerView : UIView

@property (nonatomic, weak, nullable) id<WFCardContainerViewDataSource> dataSource;
@property (nonatomic, weak, nullable) id<WFCardContainerViewDelegate> delegate;

@property (nonatomic) CGFloat cardSpace;
@property (nonatomic) CGFloat scale;

- (void)reloadData;
- (nullable __kindof WFCardContentCell *)dequeueReusableCardContentViewWithIdentifier:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
