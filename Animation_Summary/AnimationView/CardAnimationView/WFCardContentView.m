//
//  WFCardContentView.m
//  Animation_Summary
//
//  Created by Jack on 2019/3/11.
//  Copyright © 2019 Jack. All rights reserved.
//

#import "WFCardContentView.h"

@implementation WFCardContentView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self p_createChildViews];
    }
    return self;
}

- (void)p_createChildViews{
    self.layer.cornerRadius = 8.f;
    self.layer.masksToBounds = YES;
    self.backgroundColor = RandomColor;
    
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 1.f;
}

@end
