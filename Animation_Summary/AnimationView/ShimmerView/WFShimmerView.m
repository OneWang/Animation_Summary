//
//  WFShimmerView.m
//  Animation_Summary
//
//  Created by Jack on 2019/7/5.
//  Copyright © 2019 Jack. All rights reserved.
//

#import "WFShimmerView.h"

@interface WFShimmerView ()

@property(nonatomic, strong) NSArray *viewArray;

@end

@implementation WFShimmerView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)didMoveToWindow{
    [super didMoveToWindow];
    CGFloat scale = 3;
    CGFloat duration = self.viewArray.count;
    CGFloat delay = 0.0;
    for (UIView *view in self.viewArray) {
        [self addSubview:view];
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionRepeat animations:^{
            view.transform = CGAffineTransformMakeScale(scale, scale);
            view.alpha = 0.f;
        } completion:^(BOOL finished) {}];
        delay += 1;
    }
}

- (void)didAddSubview:(UIView *)subview{
    
}

#pragma mark - setter and getter
- (NSArray *)viewArray{
    if (!_viewArray) {
        _viewArray = @[[self createView],[self createView],[self createView],[self createView]];
    }
    return _viewArray;
}

- (UIView *)createView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    view.center = self.center;
    view.layer.cornerRadius = 40;
    view.backgroundColor = [UIColor colorWithRed:0 green:117/255.0 blue:255/255.0 alpha:1.0];
    return view;
}

@end
