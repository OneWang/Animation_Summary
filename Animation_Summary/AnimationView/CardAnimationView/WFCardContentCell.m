//
//  WFCardContentCell.m
//  Animation_Summary
//
//  Created by Jack on 2019/3/11.
//  Copyright © 2019 Jack. All rights reserved.
//

#import "WFCardContentCell.h"

@interface WFCardContentCell ()
@property (nonatomic, assign) WFCardContentCellStyle style;
@end

@implementation WFCardContentCell

- (instancetype)initWithStyle:(WFCardContentCellStyle)style reuseIdentifier:(NSString *)identifier{
    if (self = [super initWithFrame:self.frame]) {
        _reuseIdentifier = identifier;
        _style = style;
        [self p_createChildViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    return [self initWithStyle:_style reuseIdentifier:_reuseIdentifier];
}

- (instancetype)initWithFrame:(CGRect)frame{
    return [self initWithStyle:_style reuseIdentifier:_reuseIdentifier];
}

- (void)p_createChildViews{
    self.layer.cornerRadius = 8.f;
    self.layer.masksToBounds = YES;
    self.backgroundColor = RandomColor;
    
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 1.f;
}

- (void)dealloc{
    NSLog(@"当前卡片被释放了");
}

@end
