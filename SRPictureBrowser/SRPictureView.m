//
//  SRPictureView.m
//  SRPhotoBrowser
//
//  Created by Willing Guo on 16/12/24.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "SRPictureView.h"
#import "SRPictureModel.h"
#import "SRPictureMacro.h"
#import "SRPictureIndicator.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"

static CGFloat const kMaximumZoomScale = 3.0f;
static CGFloat const kMinimumZoomScale = 1.0f;

@interface SRPictureView () <UIScrollViewDelegate>

@property (nonatomic, strong) SRPictureIndicator *pictureIndicator;

@end

@implementation SRPictureView

- (id)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.maximumZoomScale = kMaximumZoomScale;
        self.minimumZoomScale = kMinimumZoomScale;
        self.zoomScale = 1.0f;
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.userInteractionEnabled = YES;
        [self addSubview:_imageView];
        
        [self setupGestures];
    }
    return self;
}

- (void)setupGestures {
    
    {
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [self addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [self.imageView addGestureRecognizer:doubleTap];
        
        [singleTap requireGestureRecognizerToFail:doubleTap];
    }
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self addGestureRecognizer:longPress];
}

- (void)setPictureModel:(SRPictureModel *)pictureModel {
    
    _pictureModel = pictureModel;
    
    self.zoomScale = 1.0;
    
    if (_pictureIndicator) {
        _pictureIndicator = [_pictureIndicator hide];
        _pictureIndicator = nil;
    }
    
    BOOL isImageCached = [[SDWebImageManager sharedManager] cachedImageExistsForURL:[NSURL URLWithString:self.pictureModel.picURLString]];
    if (isImageCached) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.pictureModel.picURLString]];
        
        if (self.pictureModel.isFirstShow) {
            self.imageView.frame = self.pictureModel.originPosition;
            [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:0.0 options:0 animations:^{
                self.imageView.frame = self.pictureModel.destinationPosition;
            } completion:nil];
        } else {
            self.imageView.frame = self.pictureModel.destinationPosition;
        }

    } else {
        self.imageView.image = nil;
        self.imageView.frame = self.pictureModel.destinationPosition;
        
        _pictureIndicator = [SRPictureIndicator showInView:self];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.pictureModel.picURLString]
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     _pictureIndicator = [_pictureIndicator hide];
                                     _pictureIndicator = nil;
                                 }];
    }
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    CGFloat offsetX;
    if (scrollView.bounds.size.width > scrollView.contentSize.width) {
        offsetX = (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5;
    } else {
        offsetX = 0;
    }
    
    CGFloat offsetY;
    if (scrollView.bounds.size.height > scrollView.contentSize.height) {
        offsetY = (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5;
    } else {
        offsetY = 0;
    }
    
    self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    
    [scrollView setZoomScale:scale animated:NO];
}

#pragma mark - UIGestureRecognizerHandler

- (void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer.numberOfTapsRequired == 1) {
        if ([self.pictureViewDelegate respondsToSelector:@selector(pictureViewDidTapToDismissPictureBrowser)]) {
            [self.pictureViewDelegate pictureViewDidTapToDismissPictureBrowser];
        }
    }
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)longPress {
    
    if (longPress.state == UIGestureRecognizerStateBegan) {        
        if ([self.pictureViewDelegate respondsToSelector:@selector(pictureViewDidLongPress)]) {
            [self.pictureViewDelegate pictureViewDidLongPress];
        }
    }
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer.numberOfTapsRequired == 2) {
        if (self.zoomScale == 1) {
            CGRect zoomRect = [self zoomRectForScale:self.zoomScale * 2 withCenter:[gestureRecognizer locationInView:self]];
            [self zoomToRect:zoomRect animated:YES];
        } else {
            CGRect zoomRect = [self zoomRectForScale:kMinimumZoomScale withCenter:[gestureRecognizer locationInView:self]];
            [self zoomToRect:zoomRect animated:YES];
        }
    }
}

- (CGRect)zoomRectForScale:(CGFloat)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    zoomRect.size.width = self.frame.size.width / scale;
    zoomRect.size.height = self.frame.size.height / scale;
    zoomRect.origin.x = center.x - zoomRect.size.width * 0.5;
    zoomRect.origin.y = center.y - zoomRect.size.height * 0.5;
    return zoomRect;
}

@end
