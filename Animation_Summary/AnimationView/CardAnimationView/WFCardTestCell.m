//
//  WFCardTestCell.m
//  Animation_Summary
//
//  Created by Jack on 2019/3/21.
//  Copyright © 2019 Jack. All rights reserved.
//

#import "WFCardTestCell.h"

@interface WFCardTestCell ()
@property (nonatomic, weak) UILabel *label;

@end

@implementation WFCardTestCell

- (instancetype)initWithStyle:(WFCardContentCellStyle)style reuseIdentifier:(NSString *)identifier{
    if (self = [super initWithStyle:(WFCardContentCellStyle)style reuseIdentifier:identifier]) {
        UILabel *label = [[UILabel alloc] init];
        [self addSubview:label];
        label.frame = CGRectMake(10, 10, 100, 40);
        label.font = [UIFont systemFontOfSize:20];
        _label = label;
    }
    return self;
}

- (void)setText:(NSString *)text{
    _text = text;
    _label.text = text;
}

@end
