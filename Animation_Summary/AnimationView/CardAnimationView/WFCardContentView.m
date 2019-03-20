//
//  WFCardContentView.m
//  Animation_Summary
//
//  Created by Jack on 2019/3/11.
//  Copyright © 2019 Jack. All rights reserved.
//

#import "WFCardContentView.h"

@interface WFCardContentView ()

@end

@implementation WFCardContentView

- (instancetype)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)identifier{
    if (self = [super initWithFrame:frame]) {
        _reuseIdentifier = identifier;
        [self p_createChildViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    return [self initWithFrame:self.frame reuseIdentifier:self.reuseIdentifier];
}

- (instancetype)initWithFrame:(CGRect)frame{
    return [self initWithFrame:self.frame reuseIdentifier:self.reuseIdentifier];
}

- (void)p_createChildViews{
    self.layer.cornerRadius = 8.f;
    self.layer.masksToBounds = YES;
    self.backgroundColor = RandomColor;
    
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 1.f;
}

@end
