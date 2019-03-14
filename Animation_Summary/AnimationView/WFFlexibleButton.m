//
//  WFFlexibleButton.m
//  Animation_Summary
//
//  Created by Jack on 2019/3/14.
//  Copyright © 2019年 Jack. All rights reserved.
//

#import "WFFlexibleButton.h"
#import "UIView+WFExtension.h"

@interface WFFlexibleButton ()

@property (nonatomic, assign) CGFloat lastWidth;
@property (nonatomic, strong) NSMutableArray<UIButton *> *buttonArray;

@end

@implementation WFFlexibleButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self p_createChildViews];
    }
    return self;
}

- (void)p_createChildViews{
    self.backgroundColor = [UIColor orangeColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = self.bounds;
    button.backgroundColor = [UIColor greenColor];
    button.layer.cornerRadius = self.width * 0.5;
    button.clipsToBounds = YES;
    [button setTitle:@"点击" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(p_buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _lastWidth = self.width;
    
    for (int i = 0; i < 4; i ++) {
        UIButton *buttons = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttons setTitle:[NSString stringWithFormat:@"按钮%d",i] forState:UIControlStateNormal];
        buttons.backgroundColor = RandomColor;
        buttons.frame = self.bounds;
        buttons.layer.cornerRadius = self.width * 0.5;
        buttons.layer.masksToBounds = YES;
        [self addSubview:buttons];
        [self.buttonArray addObject:buttons];
    }
    [self addSubview:button];
}

#pragma mark - private method
- (void)p_buttonClick:(UIButton *)button{
    if (button.selected) {
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.buttonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.center = CGPointMake(50 * (idx + 1) + 25 , 25);
            }];
            self.frame = CGRectMake(self.origin.x, self.origin.y, self.width + 200, self.height);
        } completion:nil];
    }else{
        __weak __typeof(self)weakSelf = self;
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.buttonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.center = CGPointMake(50 * 0.5, 25);
            }];
            self.frame = CGRectMake(self.origin.x, self.origin.y, weakSelf.lastWidth, self.height);
        } completion:nil];
    }
    button.selected = !button.selected;
}

- (NSMutableArray<UIButton *> *)buttonArray{
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

@end
