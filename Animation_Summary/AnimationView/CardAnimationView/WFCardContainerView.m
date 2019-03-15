//
//  WFCardContainerView.m
//  Animation_Summary
//
//  Created by Jack on 2019/3/15.
//  Copyright © 2019年 Jack. All rights reserved.
//

#import "WFCardContainerView.h"
#import "WFCardContentView.h"

static const NSInteger kCardVisibleCount = 3;

@interface WFCardContainerView ()

@end

@implementation WFCardContainerView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)p_createChildViews{
    if (_dataSource && [_dataSource respondsToSelector:@selector(numberOfCountsInContainerView:)] && [_dataSource respondsToSelector:@selector(cardContainView:cardForAtIndex:)]) {
        NSInteger count = [_dataSource numberOfCountsInContainerView:self];
        NSInteger showCount = count <= kCardVisibleCount ? count : kCardVisibleCount;
        if (count) {
            
        }
    }
}

@end
