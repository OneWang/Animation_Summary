//
//  WFCardContentView.h
//  Animation_Summary
//
//  Created by Jack on 2019/3/11.
//  Copyright © 2019 Jack. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFCardContentView : UIView

@property (nonatomic, readonly, copy, nullable) NSString *reuseIdentifier;

- (instancetype)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)identifier NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
