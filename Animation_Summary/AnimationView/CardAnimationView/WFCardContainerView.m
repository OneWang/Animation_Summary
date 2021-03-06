//
//  WFCardContainerView.m
//  Animation_Summary
//
//  Created by Jack on 2019/3/15.
//  Copyright © 2019年 Jack. All rights reserved.
//

#import "WFCardContainerView.h"
#import "WFCardContentCell.h"
#import "UIView+WFExtension.h"

///可显示卡片数目
static const NSInteger kCardVisibleCount = 3;
///到周围的间距
static const CGFloat kContainerViewMerge = 30.0f;
///卡片放大系数
static const CGFloat kFirstCardViewScale  = 1.08f;
static const CGFloat kSecondCardViewScale = 1.04f;
///卡片之间的距离
static const CGFloat kCardViewDistance = 15.f;

@interface WFCardContainerView ()

/** 当前加载的第几个卡片 */
@property (nonatomic, assign) NSInteger loadingIndex;
/** 当前显示的卡片view */
@property (nonatomic, strong) NSMutableArray<WFCardContentCell *> *currentCardArray;
/** 当前是否在拖动 */
@property (nonatomic, assign) BOOL isMoving;
/** 第一个card的frame */
@property (nonatomic, assign) CGRect firstFrame;
/** 最后一个card的frame */
@property (nonatomic, assign) CGRect lastFrame;
/** 第一个card的center */
@property (nonatomic, assign) CGPoint cardCenterPoint;
/** 滑动的方向 */
@property (nonatomic, assign) WFCardContainerViewDragDirection dragDirection;
/** 缓存 */
@property (nonatomic, strong) NSCache *containersCache;
@property (nonatomic, strong) NSMutableArray *visible;

@end

@implementation WFCardContainerView

- (void)reloadData{
    [self p_createChildViews];
    [self p_resetCardViewsLayout];
}

- (nullable __kindof WFCardContentCell *)dequeueReusableCardContentViewWithIdentifier:(NSString *)identifier{
    return [self.containersCache objectForKey:identifier];
}

#pragma mark - private method
- (void)p_createChildViews{
    if (_dataSource && [_dataSource respondsToSelector:@selector(numberOfCountsInContainerView:)] && [_dataSource respondsToSelector:@selector(cardContainView:cardForAtIndex:)]) {
        NSInteger count = [_dataSource numberOfCountsInContainerView:self];
        NSInteger showCount = count <= kCardVisibleCount ? count : kCardVisibleCount;
        if (_loadingIndex < count) {
            for (NSInteger i = self.currentCardArray.count; i < (self.isMoving ? showCount + 1 : showCount); i ++) {
                WFCardContentCell *cardView = [self.dataSource cardContainView:self cardForAtIndex:self.loadingIndex];
                [self.visible addObject:cardView];
                if (_delegate && [_delegate respondsToSelector:@selector(cardContainViewForCardSizeWithContaninView:)]) {
                    CGSize size = [_delegate cardContainViewForCardSizeWithContaninView:self];
                    cardView.frame = CGRectMake(kContainerViewMerge, kContainerViewMerge, size.width, size.height);
                }else{
                    cardView.frame = CGRectMake(kContainerViewMerge, kContainerViewMerge, self.width - kContainerViewMerge * 2, self.width - kContainerViewMerge * 2);
                }
                if (self.loadingIndex >= 3) {
                    cardView.frame = self.lastFrame;
                }else{
                    if (CGRectIsEmpty(self.firstFrame)) {
                        self.firstFrame = cardView.frame;
                        self.cardCenterPoint = cardView.center;
                    }
                }
                [self addSubview:cardView];
                [self sendSubviewToBack:cardView];
                cardView.tag = self.loadingIndex;
                [self.currentCardArray addObject:cardView];
                
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_tapCardView:)];
                [cardView addGestureRecognizer:tapGesture];
                
                UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(p_panCardView:)];
                [cardView addGestureRecognizer:panGesture];
                
                self.loadingIndex += 1;
            }
        }
    }else{
        NSAssert(self.dataSource, @"请实现数据源方法");
    }
}

- (void)p_resetVisibleCardViews{
    [UIView animateWithDuration:0.5f delay:0.f usingSpringWithDamping:0.6f initialSpringVelocity:0.f options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction animations:^{
        [self p_resetCardViewsLayout];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)p_resetCardViewsLayout{
    [self.currentCardArray enumerateObjectsUsingBlock:^(WFCardContentCell * _Nonnull cardView, NSUInteger idx, BOOL * _Nonnull stop) {
        cardView.transform = CGAffineTransformIdentity;
        CGRect frame = self.firstFrame;
        if (idx == 0) {
            cardView.frame = frame;
            cardView.transform = CGAffineTransformScale(CGAffineTransformIdentity, kFirstCardViewScale, kFirstCardViewScale);
        }else if (idx == 1){
            frame.origin.y = frame.origin.y + (self.cardSpace ? self.cardSpace : kCardViewDistance);
            cardView.frame = frame;
            cardView.transform = CGAffineTransformScale(CGAffineTransformIdentity, kSecondCardViewScale, kSecondCardViewScale);
        }else if (idx == 2){
            frame.origin.y = frame.origin.y + (self.cardSpace ? self.cardSpace : kCardViewDistance) * 2;
            cardView.frame = frame;
            if (CGRectIsEmpty(self.lastFrame)) {
                self.lastFrame = frame;
            }
        }
    }];
}

#pragma mark - target action
- (void)p_tapCardView:(UITapGestureRecognizer *)tapGesture{
    CGPoint touchPoint = [tapGesture locationInView:self];
    if (touchPoint.x > K_Screen_Width * 0.5) {
        NSLog(@"点击右边");
    }else{
        NSLog(@"点击左边");
    }
}

- (void)p_panCardView:(UIPanGestureRecognizer *)panGesture{
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        
    }else if (panGesture.state == UIGestureRecognizerStateChanged){
        WFCardContentCell *cardView = (WFCardContentCell *)panGesture.view;
        CGPoint point = [panGesture translationInView:self];
        CGPoint beginPoint = [panGesture locationInView:self];
        //点击位置偏上
        BOOL isUp = beginPoint.y < (cardView.height * 0.5);
        CGPoint movintPoint = CGPointMake(panGesture.view.center.x + point.x, panGesture.view.center.y + point.y);
        cardView.center = movintPoint;
        [panGesture setTranslation:CGPointZero inView:self];
        float widthRatio = (panGesture.view.center.x - self.cardCenterPoint.x) / self.cardCenterPoint.x;
        
        [self p_handleDifferentScale:widthRatio];
        
        CGFloat roation = 0.f;
        if (widthRatio > 0) { //喜欢
            self.dragDirection = WFCardContainerViewDragRight;
            if (isUp) {
                roation = M_PI_2;
            }else{
                roation = -M_PI_2;
            }
        } if (widthRatio < 0) { //讨厌
            self.dragDirection = WFCardContainerViewDragLeft;
            if (isUp) {
                roation = -M_PI_2;
            }else{
                roation = M_PI_2;
            }
        } else if (widthRatio == 0) {
            self.dragDirection = WFCardContainerViewDragDefault;
        }
        
        CGFloat ratio = (movintPoint.x - K_Screen_Width * 0.5) / K_Screen_Width;
        cardView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, ratio * roation * 0.1);
    }else if (panGesture.state == UIGestureRecognizerStateEnded || panGesture.state == UIGestureRecognizerStateCancelled) {
        float widthRatio = (panGesture.view.center.x - self.cardCenterPoint.x) / self.cardCenterPoint.x;
        float moveWidth  = (panGesture.view.center.x - self.cardCenterPoint.x);
        float moveHeight = (panGesture.view.center.y - self.cardCenterPoint.y);
        WFCardContentCell *cardView = (WFCardContentCell *)panGesture.view;
        [self p_finishedPanGesture:cardView direction:self.dragDirection scale:(moveWidth / moveHeight) disappear:fabs(widthRatio) > 0.5];
    }
}

- (void)p_finishedPanGesture:(WFCardContentCell *)cardView direction:(WFCardContainerViewDragDirection)direction scale:(CGFloat)scale disappear:(BOOL)disappear {
    if (!disappear) {
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfCountsInContainerView:)]) {
            if (self.isMoving && self.loadingIndex < [self.dataSource numberOfCountsInContainerView:self]) {
                WFCardContentCell *lastView = self.currentCardArray.lastObject;
                self.loadingIndex = lastView.tag;
                [lastView removeFromSuperview];
                [self.currentCardArray removeObject:lastView];
            }
            self.isMoving = NO;
            [self p_resetVisibleCardViews];
        }
    } else {
        NSInteger flag = direction == WFCardContainerViewDragLeft ? -1 : 2;
        [UIView animateWithDuration:0.5f delay:0.0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction animations:^{
            cardView.center = CGPointMake(K_Screen_Width * flag, K_Screen_Width * flag / scale + self.cardCenterPoint.y);
        } completion:^(BOOL finished) {
            [cardView removeFromSuperview];
            cardView.transform = CGAffineTransformIdentity;
            [self.containersCache setObject:cardView forKey:cardView.reuseIdentifier];
        }];
        [self.currentCardArray removeObject:cardView];
        self.isMoving = NO;
        [self p_resetVisibleCardViews];
        if ([self.delegate respondsToSelector:@selector(cardContainerView:dragDirection:didSelectIndex:)]) {
            [self.delegate cardContainerView:self dragDirection:self.dragDirection didSelectIndex:cardView.tag];
        }
    }
}

- (void)p_handleDifferentScale:(CGFloat)scale{
    if (!self.isMoving) {
        self.isMoving = YES;
        [self p_createChildViews];
    }else{
        [self p_movingVisibleCardViews:scale];
    }
}

- (void)p_movingVisibleCardViews:(CGFloat)scale{
    scale = fabs(scale) >= 0.5 ? 0.5 : fabs(scale);
    CGFloat sPoor = kFirstCardViewScale - kSecondCardViewScale;
    CGFloat tPoor = sPoor / (0.5 / scale);
    CGFloat yPoor = kCardViewDistance / (0.5 / scale);
    
    [self.currentCardArray enumerateObjectsUsingBlock:^(WFCardContentCell * _Nonnull cardView, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 1) {
            CGAffineTransform scale = CGAffineTransformScale(CGAffineTransformIdentity, tPoor + kSecondCardViewScale, tPoor + kSecondCardViewScale);
            CGAffineTransform translate = CGAffineTransformTranslate(scale, 0, -yPoor);
            cardView.transform = translate;
        }else if (idx == 2){
            CGAffineTransform scale = CGAffineTransformScale(CGAffineTransformIdentity, tPoor + 1, tPoor + 1);
            CGAffineTransform translate = CGAffineTransformTranslate(scale, 0, -yPoor);
            cardView.transform = translate;
        }
    }];
}

#pragma mark - setter and getter
- (NSMutableArray<WFCardContentCell *> *)currentCardArray{
    if (!_currentCardArray) {
        _currentCardArray = [NSMutableArray array];
    }
    return _currentCardArray;
}

- (NSCache *)containersCache{
    if (!_containersCache) {
        _containersCache = [[NSCache alloc] init];
    }
    return _containersCache;
}

- (void)setDataSource:(id<WFCardContainerViewDataSource>)dataSource{
    _dataSource = dataSource;
    [self reloadData];
}

- (NSMutableArray *)visible{
    if (!_visible) {
        _visible = [NSMutableArray array];
    }
    return _visible;
}

- (NSArray<WFCardContentCell *> *)visibleArray{
    return self.visible;
}

@end
