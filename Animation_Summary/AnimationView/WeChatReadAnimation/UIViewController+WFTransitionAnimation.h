//
//  UIViewController+WFTransitionAnimation.h
//  Animation_Summary
//
//  Created by Jack on 2019/3/30.
//  Copyright © 2019 Jack. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (WFTransitionAnimation)

@property (nonatomic, strong) NSMutableDictionary *sourceViewKeys;
@property (nonatomic, strong) NSMutableDictionary *targetViewKeys;

- (void)setSourceView:(UIView *)view andTag:(NSString *)tag;
- (void)setTargetView:(UIView *)view andTag:(NSString *)tag;
- (void)registerNavigationViewControllerDelegate;
- (void)removeNavigationViewControllerDelegate;
- (void)enableInteractiveTransition;

@end

NS_ASSUME_NONNULL_END
