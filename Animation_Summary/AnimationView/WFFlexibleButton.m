//
//  WFFlexibleButton.m
//  Animation_Summary
//
//  Created by Jack on 2019/3/14.
//  Copyright © 2019年 Jack. All rights reserved.
//

#import "WFFlexibleButton.h"
#import "UIView+WFExtension.h"

static CGFloat const kAnimationDuration = 0.25f;

@interface WFFlexibleButton ()<UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGRect lastFrame;

@property(nonatomic, assign) CGFloat highLightAlpha;
@property(nonatomic, assign) CGFloat defaultAlpha;
@property(nonatomic, assign) BOOL contentAnimationing;
@property(nonatomic, assign) BOOL isCollapsed;
@property(nonatomic, assign) BOOL collapseAfterSelection;

@end

@implementation WFFlexibleButton

- (instancetype)initWithFrame:(CGRect)frame flexibleDirection:(WFFlexibleButtonDirecrion)direction{
    if (self = [super initWithFrame:frame]) {
        [self p_setupDefault];
    }
    return self;
}

- (void)p_setupDefault{
    _buttonSpace = 10;
    _highLightAlpha = 0.3;
    _defaultAlpha = 1.f;
    _contentAnimationing = YES;
    _lastFrame = self.frame;
    _isCollapsed = YES;
    _collapseAfterSelection = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_tap:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}

- (void)p_tap:(UITapGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        CGPoint touchLocation = [gesture locationOfTouch:0 inView:self];
        if (_collapseAfterSelection && _isCollapsed == NO && CGRectContainsPoint(self.contentView.frame, touchLocation) == false) {
            [self p_dismissButtons];
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    if (CGRectContainsPoint(_contentView.frame, [touch locationInView:self])) {
        [self p_setUpHighLighted:YES];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    [self p_setUpHighLighted:NO];
    if (CGRectContainsPoint(_contentView.frame, [touch locationInView:self])) {
        if (_isCollapsed) {
            [self p_showButtons];
        }else{
            [self p_dismissButtons];
        }
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    [self p_setUpHighLighted:NO];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    [self p_setUpHighLighted:CGRectContainsPoint(_contentView.frame, [touches.anyObject locationInView:self])];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self) {
        if (_isCollapsed) {
            return self;
        }else{
            return [self p_subviewForPoint:point];
        }
    }
    return hitView;
}

#pragma mark - private method
- (UIView *)p_subviewForPoint:(CGPoint)point {
    for (UIView *subview in self.subviews) {
        if (CGRectContainsPoint(subview.frame, point)) {
            return subview;
        }
    }
    return self;
}

- (void)p_showButtons{
    [self p_prepareForButtonUnfold];
    
    self.userInteractionEnabled = NO;
    [CATransaction begin];
    [CATransaction setAnimationDuration:_animationDuration];
    __weak __typeof(self)weakSelf = self;
    [CATransaction setCompletionBlock:^{
        for (UIButton *button in weakSelf.buttonArray) {
            button.transform = CGAffineTransformIdentity;
        }
        self.userInteractionEnabled = YES;
    }];
    
    [_buttonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger lastIndex = weakSelf.buttonArray.count - (idx + 1);
        UIButton *lastButton = weakSelf.buttonArray[lastIndex];
        button.hidden = NO;
        
        CGPoint originPosition,finalPoition;
        switch (weakSelf.flexibleDirection) {
            case WFFlexibleButtonUp:
            {
                originPosition = CGPointMake(self.width * 0.5, self.height - self.contentView.height);
                finalPoition = CGPointMake(self.width * 0.5, self.height - self.contentView.height - self.buttonSpace - lastButton.height * 0.5 - (lastButton.height + self.buttonSpace) * lastIndex);
            }
                break;
            case WFFlexibleButtonDown:
            {
                originPosition = CGPointMake(self.width * 0.5, self.contentView.height);
                finalPoition = CGPointMake(self.width * 0.5, self.contentView.height + self.buttonSpace + lastButton.height * 0.5 + (lastButton.height + self.buttonSpace) * lastIndex);
            }
                break;
            case WFFlexibleButtonLeft:
            {
                originPosition = CGPointMake(self.width - self.contentView.width, self.height * 0.5);
                finalPoition = CGPointMake(self.width - self.contentView.width - self.buttonSpace - lastButton.width * 0.5 - (lastButton.width + self.buttonSpace) * lastIndex, self.height * 0.5);
            }
                break;
            case WFFlexibleButtonRight:
            {
                originPosition = CGPointMake(self.contentView.width, self.height * 0.5);
                finalPoition = CGPointMake(self.contentView.width + self.buttonSpace + lastButton.width * 0.5 + (lastButton.width + self.buttonSpace) * lastIndex, self.height * 0.5);
            }
                break;
            default:
                break;
        }
        
        CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        positionAnimation.duration = weakSelf.animationDuration;
        positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        positionAnimation.fromValue = [NSValue valueWithCGPoint:originPosition];
        positionAnimation.toValue = [NSValue valueWithCGPoint:finalPoition];
        positionAnimation.beginTime = CACurrentMediaTime() + (weakSelf.animationDuration / weakSelf.buttonArray.count * idx);
        positionAnimation.fillMode = kCAFillModeForwards;
        positionAnimation.removedOnCompletion = NO;
        [lastButton.layer addAnimation:positionAnimation forKey:@"positionAnimation"];
        
        lastButton.layer.position = finalPoition;
        
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.duration = weakSelf.animationDuration;
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        scaleAnimation.fromValue = [NSNumber numberWithFloat:0.01f];
        scaleAnimation.toValue = [NSNumber numberWithFloat:1.f];
        scaleAnimation.beginTime = CACurrentMediaTime() + (weakSelf.animationDuration/weakSelf.buttonArray.count * idx) + 0.03f;
        scaleAnimation.fillMode = kCAFillModeForwards;
        scaleAnimation.removedOnCompletion = NO;
        [lastButton.layer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
        lastButton.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
    }];
    
    [CATransaction commit];
    _isCollapsed = NO;
}

- (void)p_dismissButtons{
    self.userInteractionEnabled = NO;
    [CATransaction begin];
    [CATransaction setAnimationDuration:_animationDuration];
    [CATransaction setCompletionBlock:^{
        self.frame = self.lastFrame;
        for (UIButton *button in self.buttonArray) {
            button.hidden = YES;
            button.transform = CGAffineTransformIdentity;
        }
        self.userInteractionEnabled = YES;
    }];
    
    __weak __typeof(self)weakSelf = self;
    [_buttonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger lastIndex = weakSelf.buttonArray.count - 1 - idx;
        UIButton *lastButton = weakSelf.buttonArray[lastIndex];
        
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.duration = weakSelf.animationDuration;
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        scaleAnimation.fromValue = @1;
        scaleAnimation.toValue = @0.01;
        scaleAnimation.beginTime = CACurrentMediaTime() + (weakSelf.animationDuration / weakSelf.buttonArray.count * idx) + 0.03;
        scaleAnimation.removedOnCompletion = NO;
        scaleAnimation.fillMode = kCAFillModeForwards;
        
        [lastButton.layer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
        lastButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
        CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        CGPoint originPosition = lastButton.layer.position;
        CGPoint finalPoition = CGPointZero;
        switch (weakSelf.flexibleDirection) {
            case WFFlexibleButtonUp:
            {
                finalPoition = CGPointMake(self.width * 0.5, self.height - self.contentView.height);
            }
                break;
            case WFFlexibleButtonDown:
            {
                finalPoition = CGPointMake(self.width * 0.5, self.contentView.height);
            }
                break;
            case WFFlexibleButtonLeft:
            {
                finalPoition = CGPointMake(self.width - self.contentView.width, self.height * 0.5);
            }
                break;
            case WFFlexibleButtonRight:
            {
                finalPoition = CGPointMake(self.contentView.width, self.height * 0.5);
            }
                break;
            default:
                break;
        }
        positionAnimation.duration = weakSelf.animationDuration;
        positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        positionAnimation.fromValue = [NSValue valueWithCGPoint:originPosition];
        positionAnimation.toValue = [NSValue valueWithCGPoint:finalPoition];
        positionAnimation.beginTime = CACurrentMediaTime() + (weakSelf.animationDuration/weakSelf.buttonArray.count * idx);
        positionAnimation.fillMode = kCAFillModeForwards;
        positionAnimation.removedOnCompletion = NO;
        [lastButton.layer addAnimation:positionAnimation forKey:@"positionAnimation"];
        
        lastButton.layer.position = originPosition;
    }];
    [CATransaction commit];
    _isCollapsed = YES;
}

- (void)p_prepareForButtonUnfold{
    __block CGFloat width,height;
    __weak __typeof(self)weakSelf = self;
    [_buttonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
        width += button.width + weakSelf.buttonSpace;
        height += button.height + weakSelf.buttonSpace;
    }];
    switch (_flexibleDirection) {
        case WFFlexibleButtonUp:
        {
            _contentView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
            self.top = self.top - height;
            self.height = self.height + height;
        }
            break;
        case WFFlexibleButtonDown:
        {
            _contentView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
            self.height = self.height + height;
        }
            break;
        case WFFlexibleButtonLeft:
        {
            _contentView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            self.left = self.left - width;
            self.width = self.width + width;
        }
            break;
        case WFFlexibleButtonRight:
        {
            _contentView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
            self.width = self.width + width;
        }
            break;
        default:
            break;
    }
    
}

- (void)p_setUpHighLighted:(BOOL)highlighted{
    CGFloat alpha = highlighted ? _highLightAlpha : _defaultAlpha;
    if (_contentView.alpha == alpha) return;
    __weak __typeof(self)weakSelf = self;
    if (_contentAnimationing) {
        [self p_addAnimationComplete:^{
            if (weakSelf.contentView) {
                weakSelf.contentView.alpha = alpha;
            }
        }];
    }else{
        if (self.contentView) {
            self.contentView.alpha = alpha;
        }
    }
}

- (void)p_addAnimationComplete:(void(^)(void))animationBlock{
    [UIView transitionWithView:self duration:kAnimationDuration options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:animationBlock completion:nil];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint touchLocation = [touch locationInView:self];
    if ([self p_subviewForPoint:touchLocation] != self && _collapseAfterSelection) {
        return YES;
    }
    return NO;
}

#pragma mark - setter and getter
- (void)setContentView:(UIView *)contentView{
    if (_contentView != contentView) {
        _contentView = contentView;
        [self addSubview:contentView];
    }
}

- (void)setButtonArray:(NSArray<UIButton *> *)buttonArray{
    _buttonArray = buttonArray;
    [buttonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addSubview:obj];
        obj.hidden = YES;
    }];
}

- (void)p_buttonClick:(UIButton *)button{
    __weak __typeof(self)weakSelf = self;
    if (button.selected) {
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [weakSelf.buttonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.center = CGPointMake((50 + weakSelf.buttonSpace) * (idx + 1) + 25, 25);
            }];
            weakSelf.frame = CGRectMake(weakSelf.origin.x, weakSelf.origin.y, weakSelf.width + 200, weakSelf.height);
        } completion:nil];
    }else{
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [weakSelf.buttonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.center = CGPointMake(50 * 0.5, 25);
            }];
//            weakSelf.frame = CGRectMake(weakSelf.origin.x, weakSelf.origin.y, weakSelf.lastWidth, weakSelf.height);
        } completion:nil];
    }
    button.selected = !button.selected;
}

@end
