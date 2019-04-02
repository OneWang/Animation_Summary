//
//  WFFlexibleButton.h
//  Animation_Summary
//
//  Created by Jack on 2019/3/14.
//  Copyright © 2019年 Jack. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,WFFlexibleButtonDirecrion) {
    WFFlexibleButtonUp,
    WFFlexibleButtonDown,
    WFFlexibleButtonRight,
    WFFlexibleButtonLeft
};

@interface WFFlexibleButton : UIView

@property(nonatomic, assign) BOOL collapseAfterSelection;
@property(nonatomic, assign) CGFloat buttonSpace;
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) NSArray<UIButton *> *buttonArray;
@property(nonatomic, assign) CGFloat animationDuration;

- (instancetype)initWithFrame:(CGRect)frame flexibleDirection:(WFFlexibleButtonDirecrion)direction NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
