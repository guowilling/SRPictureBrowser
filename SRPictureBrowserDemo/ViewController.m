//
//  ViewController.m
//  SRPictureBrowserDemo
//
//  Created by 郭伟林 on 16/12/26.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "ViewController.h"
#import "SRPictureBrowser.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray *picURLStrings;
@property (nonatomic, strong) NSMutableArray *imageViewFrames;

@end

@implementation ViewController

- (NSMutableArray *)imageViewFrames {
    
    if (!_imageViewFrames) {
        _imageViewFrames = [NSMutableArray array];
    }
    return _imageViewFrames;
}

- (NSArray *)picURLStrings {
    
    if (!_picURLStrings) {
        _picURLStrings = @[@"http://p1.bqimg.com/4851/112faa5cf03658c9.jpg",
                           @"http://p1.bpimg.com/4851/4c2e56725b2e6fcb.jpg",
                           @"http://p1.bqimg.com/4851/afddcbe86ba32096.jpg",
                           @"http://p1.bqimg.com/4851/c0138afeb25153f7.jpg",
                           @"http://p1.bqimg.com/4851/80cb0ce1f27d15bc.jpg",
                           @"http://p1.bqimg.com/4851/7625ce564dfa0e6f.jpg",
                           @"http://p1.bqimg.com/4851/962e137e74c15d37.jpg",
                           @"http://p1.bqimg.com/4851/5ffe412ee4a35098.jpg",
                           @"http://p1.bqimg.com/4851/5f1b7d156349843f.jpg"];
    }
    return _picURLStrings;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"SRPhotoBrowser";
    
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
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"coldplay%02d.jpg", i + 1]];
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
    SRPictureBrowser *pictureBrowser = [SRPictureBrowser sr_pictureBrowserWithModels:imageBrowserModels currentIndex:tapedImageView.tag];
    [pictureBrowser show];
}

@end
