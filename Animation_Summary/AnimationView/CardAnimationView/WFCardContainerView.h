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

@class WFCardContainerView,WFCardContentView;
@protocol WFCardContainerViewDelegate <NSObject>
@optional
- (void)cardContainerView:(WFCardContainerView *)containerView dragDirection:(WFCardContainerViewDragDirection)direction;

@end

@protocol WFCardContainerViewDataSource <NSObject>

- (NSInteger)numberOfCountsInContainerView:(WFCardContainerView *)containView;

- (WFCardContentView *)cardContainView:(WFCardContainerView *)containView cardForAtIndex:(NSInteger)index;

@end

@interface WFCardContainerView : UIView

@property (nonatomic, weak, nullable) id<WFCardContainerViewDataSource> dataSource;
@property (nonatomic, weak, nullable) id<WFCardContainerViewDelegate> delegate;

- (void)reloadData;
- (WFCardContentView *)dequeueReusableCardContentViewWithIdentifier:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
