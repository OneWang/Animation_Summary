//
//  WFCardContainerView.m
//  Animation_Summary
//
//  Created by Jack on 2019/3/15.
//  Copyright © 2019年 Jack. All rights reserved.
//

#import "WFCardContainerView.h"
#import "WFCardContentView.h"
#import "UIView+WFExtension.h"

///可显示卡片数目
static const NSInteger kCardVisibleCount = 3;
///到周围的间距
static const CGFloat kContainerViewMerge = 30.0f;
///卡片放大系数
static const CGFloat kFirstCardViewScale  = 1.1f;
static const CGFloat kSecondCardViewScale = 1.08f;
///卡片之间的距离
static const CGFloat kCardViewDistance = 15.f;

typedef NS_OPTIONS(NSInteger, WFCardContainerViewDragDirection) {
    WFCardContainerViewDragDefault     = 0,
    WFCardContainerViewDragLeft        = 1 << 0,
    WFCardContainerViewDragRight       = 1 << 1
};

@interface WFCardContainerView ()

/** 当前加载的第几个卡片 */
@property (nonatomic, assign) NSInteger loadingIndex;
/** 当前显示的卡片view */
@property (nonatomic, strong) NSMutableArray<WFCardContentView *> *currentCardArray;
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

@end

@implementation WFCardContainerView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)reloadData{
    [self p_createChildViews];
    [self p_resetCardViewsLayout];
}

- (void)p_createChildViews{
    if (_dataSource && [_dataSource respondsToSelector:@selector(numberOfCountsInContainerView:)] && [_dataSource respondsToSelector:@selector(cardContainView:cardForAtIndex:)]) {
        NSInteger count = [_dataSource numberOfCountsInContainerView:self];
        NSInteger showCount = count <= kCardVisibleCount ? count : kCardVisibleCount;
        if (_loadingIndex < count) {
            for (NSInteger i = self.currentCardArray.count; i < (self.isMoving ? showCount + 1 : showCount); i ++) {
                WFCardContentView *cardView = [self.dataSource cardContainView:self cardForAtIndex:self.loadingIndex];
                cardView.frame = CGRectMake(kContainerViewMerge, kContainerViewMerge, self.width - kContainerViewMerge * 2, self.height - kContainerViewMerge);
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
                
                ///缓存当前的cardview
                [self.currentCardArray addObject:cardView];
                
                ///添加手势
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_tapCardView:)];
                [cardView addGestureRecognizer:tapGesture];
                
                UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(p_panCardView:)];
                [cardView addGestureRecognizer:panGesture];
                
                self.loadingIndex ++;
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
    [self.currentCardArray enumerateObjectsUsingBlock:^(WFCardContentView * _Nonnull cardView, NSUInteger idx, BOOL * _Nonnull stop) {
        cardView.transform = CGAffineTransformIdentity;
        if (idx == 0) {
            cardView.frame = self.firstFrame;
            cardView.transform = CGAffineTransformScale(CGAffineTransformIdentity, kFirstCardViewScale, kFirstCardViewScale);
        }else if (idx == 1){
            CGRect frame = self.firstFrame;
            frame.origin.y = frame.origin.y + kCardViewDistance;
            cardView.frame = frame;
            cardView.transform = CGAffineTransformScale(CGAffineTransformIdentity, kSecondCardViewScale, kSecondCardViewScale);
        }else{
            CGRect frame = self.firstFrame;
            frame.origin.y = frame.origin.y + kCardViewDistance * 2;
            cardView.frame = frame;
            if (CGRectIsEmpty(self.lastFrame)) {
                self.lastFrame = frame;
            }
        }
    }];
}

#pragma mark - target action
- (void)p_tapCardView:(UITapGestureRecognizer *)tapGesture{
    
}

- (void)p_panCardView:(UIPanGestureRecognizer *)panGesture{
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        
    }else if (panGesture.state == UIGestureRecognizerStateChanged){
        WFCardContentView *cardView = (WFCardContentView *)panGesture.view;
        CGPoint point = [panGesture translationInView:self];
        CGPoint movintPoint = CGPointMake(panGesture.view.center.x + point.x, panGesture.view.origin.y + point.y);
        cardView.center = movintPoint;
        cardView.transform = CGAffineTransformRotate(cardView.transform, (panGesture.view.origin.x - self.cardCenterPoint.x) / self.cardCenterPoint.x * (M_PI_4 / 12));
        [panGesture setTranslation:CGPointZero inView:self];
        
        float widthRatio = (panGesture.view.center.x - self.cardCenterPoint.x) / self.cardCenterPoint.x;
//        float heightRatio = (panGesture.view.center.y - self.cardCenterPoint.y) / self.cardCenterPoint.y;
        
        [self p_handleDifferentDirection:widthRatio];
        
        if (widthRatio > 0) {
            self.dragDirection = WFCardContainerViewDragRight;
        } if (widthRatio < 0) {
            self.dragDirection = WFCardContainerViewDragLeft;
        } else if (widthRatio == 0) {
            self.dragDirection = WFCardContainerViewDragDefault;
        }
    }
}

- (void)p_handleDifferentDirection:(CGFloat)scale{
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
    
    [self.currentCardArray enumerateObjectsUsingBlock:^(WFCardContentView * _Nonnull cardView, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 1) {
            CGAffineTransform scale = CGAffineTransformScale(CGAffineTransformIdentity, tPoor + kSecondCardViewScale, tPoor + kSecondCardViewScale);
            CGAffineTransform translate = CGAffineTransformTranslate(scale, 0, -yPoor);
            cardView.transform = translate;
        }else if (idx == 2){
            CGAffineTransform scale = CGAffineTransformScale(CGAffineTransformIdentity, tPoor + 1, tPoor + 1);
            CGAffineTransform translate = CGAffineTransformTranslate(scale, 0, -yPoor);
            cardView.transform = translate;
        }else{
            
        }
    }];
}

#pragma mark - setter and getter
- (NSMutableArray<WFCardContentView *> *)currentCardArray{
    if (!_currentCardArray) {
        _currentCardArray = [NSMutableArray array];
    }
    return _currentCardArray;
}

@end
