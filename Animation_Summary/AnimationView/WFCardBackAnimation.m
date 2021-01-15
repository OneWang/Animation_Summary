//
//  WFCardBackAnimation.m
//  Animation_Summary
//
//  Created by Jack on 2020/5/20.
//  Copyright © 2020 Jack. All rights reserved.
//

#import "WFCardBackAnimation.h"

@interface WFCardBackAnimation ()<CAAnimationDelegate>

@property(nonatomic, strong) UIView *firstView;
@property(nonatomic, strong) UIView *secondView;
@property(nonatomic, strong) UIView *thirdView;
@property(nonatomic, strong) CAAnimation *animation;
@property(nonatomic, strong) UIImageView *avatorView;

@end

@implementation WFCardBackAnimation

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.firstView];
        [self addSubview:self.secondView];
        [self addSubview:self.thirdView];
    }
    return self;
}

- (void)startAnimation{
    [UIView animateWithDuration:.6 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.firstView.transform = CGAffineTransformIdentity;
        self.firstView.frame = CGRectMake(50, 0, K_Screen_Width - 100, K_Screen_Height - 500);
        self.firstView.alpha = 0.8;
    } completion:^(BOOL finished) {
        
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:.6 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.secondView.transform = CGAffineTransformIdentity;
            self.secondView.frame = CGRectMake(40, 10, K_Screen_Width - 80, K_Screen_Height - 500);
            self.secondView.alpha = 0.9;
        } completion:^(BOOL finished) {

        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:.6 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.thirdView.transform = CGAffineTransformIdentity;
                self.thirdView.frame = CGRectMake(30, 20, K_Screen_Width - 60, K_Screen_Height - 500);
            } completion:^(BOOL finished) {
                [self.thirdView addSubview:self.avatorView];
                self.avatorView.center = self.thirdView.center;
            }];
        });
    });
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@(0.8), @(1.1), @(0.9), @(1),@(0.8)];
    animation.keyTimes = @[@(0), @(0.4), @(0.6), @(0.8),@(1)];
    animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    animation.duration = 3.f;
    animation.removedOnCompletion = NO;
    animation.repeatCount = MAXFLOAT;
    animation.delegate = self;
    self.animation = animation;
    [self.avatorView.layer addAnimation:animation forKey:@"scale"];
}

- (void)setIsFinish:(BOOL)isFinish{
    _isFinish = isFinish;
    [self.avatorView.layer removeAllAnimations];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag) {
        NSLog(@"动画结束啦");
    }
}

- (UIView *)firstView{
    if (!_firstView) {
        _firstView  = [[UIView alloc] initWithFrame:CGRectMake(-K_Screen_Width - 60, 100,K_Screen_Width - 100, K_Screen_Height - 500)];
        _firstView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, -0.9);
//        _firstView.layer.anchorPoint = CGPointMake(0.8, 0.5);
        _firstView.layer.cornerRadius =  8;
        _firstView.backgroundColor = RandomColor;
    }
    return _firstView;
}

- (UIView *)secondView{
    if (!_secondView) {
        _secondView = [[UIView alloc] initWithFrame:CGRectMake(-K_Screen_Width - 80, 150, K_Screen_Width - 100, K_Screen_Height - 500)];
        _secondView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, -1.1);
//        _secondView.layer.anchorPoint = CGPointMake(0.8, 0.5);
        _secondView.layer.cornerRadius =  8;
        _secondView.backgroundColor = RandomColor;
    }
    return _secondView;
}

- (UIView *)thirdView{
    if (!_thirdView) {
        _thirdView = [[UIView alloc] initWithFrame:CGRectMake(-K_Screen_Width - 100, 200, K_Screen_Width - 100, K_Screen_Height - 500)];
        _thirdView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, -1.3);
//        _thirdView.layer.anchorPoint = CGPointMake(0.8, 0.5);
        _thirdView.layer.cornerRadius =  8;
        _thirdView.backgroundColor = RandomColor;
    }
    return _thirdView;
}

- (UIImageView *)avatorView{
    if (!_avatorView) {
        _avatorView = [[UIImageView alloc] init];
        _avatorView.layer.cornerRadius = 52.f;
        _avatorView.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.7].CGColor;
        _avatorView.layer.borderWidth = 4.f;
        _avatorView.layer.masksToBounds = YES;
        _avatorView.backgroundColor = [UIColor redColor];
//        _avatorView.transform = CGAffineTransformMakeScale(0, 0);
        _avatorView.frame = CGRectMake(0, 0, 104, 104);
    }
    return _avatorView;
}


@end
