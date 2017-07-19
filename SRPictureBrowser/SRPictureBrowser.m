//
//  SRPictureBrowser.m
//  SRPhotoBrowser
//
//  Created by https://github.com/guowilling on 16/12/24.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "SRPictureBrowser.h"
#import "SRPictureCell.h"
#import "SRPictureView.h"
#import "SRPictureModel.h"
#import "SRPictureManager.h"
#import "SRPictureHUD.h"

@interface SRPictureBrowser () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UIActionSheetDelegate, SRPictureCellDelegate, SRPictureViewDelegate>

@property (nonatomic, weak) id<SRPictureBrowserDelegate> delegate;

@property (nonatomic, copy) NSArray *pictureModels;

@property (nonatomic, strong) UIImageView *screenImageView;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl    *pageControl;

@property (nonatomic, strong) SRPictureView *currentPictureView;

@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation SRPictureBrowser

+ (void)sr_showPictureBrowserWithModels:(NSArray *)pictureModels currentIndex:(NSInteger)currentIndex delegate:(id<SRPictureBrowserDelegate>)delegate {
    
    SRPictureBrowser *pictureBrowser = [[self alloc] initWithModels:pictureModels currentIndex:currentIndex delegate:delegate];
    [pictureBrowser show];
}

#pragma mark - Initialize

- (id)initWithModels:(NSArray *)pictureModels currentIndex:(NSInteger)currentIndex delegate:(id<SRPictureBrowserDelegate>)delegate {
    
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        _pictureModels = pictureModels;
        _currentIndex = currentIndex;
        _delegate = delegate;
        for (SRPictureModel *picModel in _pictureModels) {
            if (picModel.index == _currentIndex) {
                picModel.firstShow = YES;
                break;
            }
        }
        [self setup];
    }
    return self;
}

- (void)setup {
    
    self.backgroundColor = [UIColor blackColor];
    
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    
    [self addSubview:({
        UIGraphicsBeginImageContextWithOptions([UIScreen mainScreen].bounds.size, YES, [UIScreen mainScreen].scale);
        [[UIApplication sharedApplication].keyWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *currentScreenImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        _screenImageView = [[UIImageView alloc] initWithFrame:screenBounds];
        _screenImageView.image = currentScreenImage;
        _screenImageView.hidden = YES;
        _screenImageView;
    })];
    
    [self addSubview:({
        CGFloat flowLayoutWidth = screenBounds.size.width + 10;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(flowLayoutWidth, screenBounds.size.height);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 0.0f;
        flowLayout.sectionInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, flowLayoutWidth, screenBounds.size.height) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[SRPictureCell class] forCellWithReuseIdentifier:pictureViewID];
        [_collectionView setContentOffset:CGPointMake(self.currentIndex * flowLayoutWidth, 0.0f) animated:NO];
        _collectionView;
    })];
    
    [self addSubview:({
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, screenBounds.size.height - 40 - 10, screenBounds.size.width, 40)];
        _pageControl.numberOfPages = self.pictureModels.count;
        _pageControl.currentPage = self.currentIndex;
        _pageControl.userInteractionEnabled = NO;
        if (_pictureModels.count == 1) {
            _pageControl.hidden = YES;
        }
        _pageControl;
    })];
}

#pragma mark - Animation

- (void)show {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    if ([self.delegate respondsToSelector:@selector(pictureBrowserDidShow:)]) {
        [self.delegate pictureBrowserDidShow:self];
    }
}

- (void)dismiss {
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    _screenImageView.hidden = NO;
    _pageControl.hidden = YES;
    
    if (self.currentPictureView.zoomScale != 1.0) {
        self.currentPictureView.zoomScale = 1.0;
    }
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.currentPictureView.imageView.frame = self.currentPictureView.pictureModel.originPosition;
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(pictureBrowserDidDismiss)]) {
            [self.delegate pictureBrowserDidDismiss];
        }
        [self removeFromSuperview];
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.pictureModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SRPictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:pictureViewID forIndexPath:indexPath];
    cell.delegate = self;
    cell.pictureView.pictureViewDelegate = self;
    cell.pictureModel = self.pictureModels[indexPath.row];
    if (!_currentPictureView) {
        _currentPictureView = cell.pictureView;
    }
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger index = scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width;
    self.currentIndex = index;
    self.pageControl.currentPage = index;
    
    NSArray *cells = [self.collectionView visibleCells];
    if (cells.count == 0) {
        return;
    }
    SRPictureCell *cell = [cells objectAtIndex:0];
    if (self.currentPictureView == cell.pictureView) {
        return;
    }
    self.currentPictureView = cell.pictureView;
    
    if (self.currentIndex + 1 < self.pictureModels.count) {
        SRPictureModel *nextModel = [self.pictureModels objectAtIndex:self.currentIndex + 1];
        [SRPictureManager prefetchDownloadPicture:nextModel.picURLString success:^(UIImage *picture) {
            nextModel.picture = picture;
        }];
    }
    if (self.currentIndex - 1 >= 0) {
        SRPictureModel *preModel = [self.pictureModels objectAtIndex:self.currentIndex - 1];
        [SRPictureManager prefetchDownloadPicture:preModel.picURLString success:^(UIImage *picture) {
            preModel.picture = picture;
        }];
    }
}

#pragma mark - SRPictureCellDelegate

- (void)pictureCellDidPanToAlpha:(CGFloat)alpha {
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:alpha];
    self.pageControl.alpha = alpha;
}

- (void)pictureCellDidPanToDismiss {
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    if ([self.delegate respondsToSelector:@selector(pictureBrowserDidDismiss)]) {
        [self.delegate pictureBrowserDidDismiss];
    }
    [self removeFromSuperview];
}

#pragma mark - SRPictureViewDelegate

- (void)pictureViewDidTapToDismissPictureBrowser {
    
    [self dismiss];
}

- (void)pictureViewDidLongPress {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Save", nil];
    [actionSheet showInView:self];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        UIImageWriteToSavedPhotosAlbum(self.currentPictureView.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    if (error) {
        [SRPictureHUD showHUDInView:self withMessage:@"Save Picture Failure!"];
    } else {
        [SRPictureHUD showHUDInView:self withMessage:@"Save Picture Success!"];
    }
}

@end
