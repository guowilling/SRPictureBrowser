//
//  ViewController.m
//  SRPictureBrowserDemo
//
//  Created by 郭伟林 on 16/12/26.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "ViewController.h"
#import "SRPictureBrowser.h"
#import "SRPictureModel.h"

@interface ViewController () <SRPictureBrowserDelegate>

@property (nonatomic, strong) NSArray *picURLStrings;

@property (nonatomic, strong) NSMutableArray *imageViewFrames;

@end

@implementation ViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (NSMutableArray *)imageViewFrames {
    if (!_imageViewFrames) {
        _imageViewFrames = [NSMutableArray array];
    }
    return _imageViewFrames;
}

- (NSArray *)picURLStrings {
    if (!_picURLStrings) {
        _picURLStrings = @[@"http://i1.piimg.com/593517/dcd2b32545e44ca0.jpg",
                           @"http://i1.piimg.com/593517/200c2de8ea0ce7aa.jpg",
                           @"http://i1.piimg.com/593517/31386bf8c82df9b4.jpg",
                           @"http://i1.piimg.com/593517/91e3e497b0317894.jpg",
                           @"http://i1.piimg.com/593517/182ef6ae1dbc9387.jpg",
                           @"http://i1.piimg.com/593517/544edc9a6aedb6be.jpg",
                           @"http://i1.piimg.com/593517/50385447a659214a.jpg",
                           @"http://i1.piimg.com/593517/c584637b3f869b53.jpg",
                           @"http://i1.piimg.com/593517/11035002ebf2781f.jpg"];
    }
    return _picURLStrings;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *container = [[UIView alloc] init];
    container.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:({
        container.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width);
        container.center = self.view.center;
        container;
    })];
    
    CGFloat margin = 10;
    CGFloat imageViewWH = (self.view.frame.size.width - 4 * margin) / 3;
    for (int i = 0 ; i < self.picURLStrings.count; i++) {
        int col = i % 3;
        int row = i / 3;
        [container addSubview:({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.tag = i;
            CGFloat imageViewX = margin + col * (margin + imageViewWH);
            CGFloat imageViewY = margin + row * (margin + imageViewWH);
            imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewWH, imageViewWH);
            [self.imageViewFrames addObject:[NSValue valueWithCGRect:imageView.frame]];
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"GameofThrones%d", i + 1]];
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapAction:)];
            [imageView addGestureRecognizer:tapGestureRecognizer];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            imageView;
        })];
    }
}

- (void)imageTapAction:(UITapGestureRecognizer *)tapGestureRecognizer {
    UIImageView *tapedImageView = (UIImageView *)tapGestureRecognizer.view;
    NSMutableArray *imageBrowserModels = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self.picURLStrings.count; i ++) {
        SRPictureModel *imageBrowserModel = [SRPictureModel sr_pictureModelWithPicURLString:self.picURLStrings[i]
                                                                              containerView:tapedImageView.superview
                                                                        positionInContainer:[self.imageViewFrames[i] CGRectValue]
                                                                                      index:i];
        [imageBrowserModels addObject:imageBrowserModel];
    }
    [SRPictureBrowser sr_showPictureBrowserWithModels:imageBrowserModels currentIndex:tapedImageView.tag delegate:self];
}

- (void)pictureBrowserDidShow:(SRPictureBrowser *)pictureBrowser {
    NSLog(@"%s", __func__);
}

- (void)pictureBrowserDidDismiss {
    NSLog(@"%s", __func__);
}

@end
