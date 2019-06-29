//
//  WFPhotoPreviewCell.m
//  Animation_Summary
//
//  Created by Jack on 2019/6/29.
//  Copyright © 2019 Jack. All rights reserved.
//

#import "WFPhotoPreviewCell.h"

@interface WFPhotoPreviewCell ()<UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIImageView *photoView;
@end

@implementation WFPhotoPreviewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self p_createChildView];
    }
    return self;
}

#pragma mark - private method
- (void)p_createChildView{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.contentView addSubview:scrollView];
    scrollView.frame = UIScreen.mainScreen.bounds;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.minimumZoomScale = 1;
    scrollView.delegate = self;
    scrollView.bouncesZoom = YES;
    scrollView.maximumZoomScale = 2;
    _scrollView = scrollView;
    
    UITapGestureRecognizer *doubleGecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_doubleClick:)];
    doubleGecognizer.numberOfTapsRequired = 2;
    [scrollView addGestureRecognizer:doubleGecognizer];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [scrollView addSubview:imageView];
    imageView.frame = UIScreen.mainScreen.bounds;
    _photoView = imageView;
    imageView.image = [UIImage imageNamed:@"heheda"];
}

- (void)p_doubleClick:(UITapGestureRecognizer *)gesture{
    if (self.scrollView.zoomScale > 1.0) {
        [self.scrollView setZoomScale:1.0 animated:YES];
    }else{
        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height;
        CGFloat newZoomScale = self.scrollView.maximumZoomScale;
        CGPoint touchPoint = [gesture locationInView:self.photoView];
        CGFloat xsize = width / newZoomScale;
        CGFloat ysize = height / newZoomScale;
        [self.scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.photoView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.frame.size.width > scrollView.contentSize.width) ? (scrollView.frame.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.frame.size.height > scrollView.contentSize.height) ? (scrollView.frame.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.photoView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}


@end
