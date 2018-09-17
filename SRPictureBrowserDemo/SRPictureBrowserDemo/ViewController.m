//
//  ViewController.m
//  SRPictureBrowserDemo
//
//  Created by Willing Guo on 16/12/26.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "ViewController.h"
#import "SRPictureBrowser.h"
#import "SRPictureModel.h"
#import "SRActionSheet.h"
#import "SRPictureHUD.h"

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
        _picURLStrings = @[@"https://yixunfiles-ali.yixun.arhieason.com/37f60c4f4489e5e9d68032344997dbc1_jpg.jpg?x-oss-process=image/format,png",
                           @"https://yixunfiles-ali.yixun.arhieason.com/53dc63984fde3bc385c4d9158cbfbae1_jpg.jpg?x-oss-process=image/format,png",
                           @"https://yixunfiles-ali.yixun.arhieason.com/e15612e17e541408884ae3a83264a1bc_jpg.jpg?x-oss-process=image/format,png",
                           @"https://yixunfiles-ali.yixun.arhieason.com/2378646302510db4707ce140489777ab_jpg.jpg?x-oss-process=image/format,png",
                           @"https://yixunfiles-ali.yixun.arhieason.com/af1e7c76740360800d796c11bf920562_jpg.jpg?x-oss-process=image/format,png",
                           @"https://yixunfiles-ali.yixun.arhieason.com/075dccde0047e04c8087e422627b3057_jpg.jpg?x-oss-process=image/format,png",
                           @"https://yixunfiles-ali.yixun.arhieason.com/d5e52ff8d2d32aacb1d9212149fd91bb_jpg.jpg?x-oss-process=image/format,png",
                           @"https://yixunfiles-ali.yixun.arhieason.com/a6ae817ccd7270e9cb2ad110fd0e10b4_jpg.jpg?x-oss-process=image/format,png",
                           @"https://yixunfiles-ali.yixun.arhieason.com/319d1a79606f3a1e5415faadd0e147d8_jpg.jpg?x-oss-process=image/format,png"];
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

- (void)pictureBrowserDidLongPressPicture:(UIImage *)picture {
    [[SRActionSheet sr_actionSheetViewWithTitle:nil
                                    cancelTitle:@"Cancel"
                               destructiveTitle:@"Sure"
                                    otherTitles:@[@"Save", @"More"]
                                    otherImages:nil
                              selectActionBlock:^(SRActionSheet *actionSheet, NSInteger index) {
                                  if (index == 0) {
                                      UIImageWriteToSavedPhotosAlbum(picture, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
                                  }
                              }] show];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [SRPictureHUD showHUDInView:nil withMessage:@"Save Picture Failure!"];
    } else {
        [SRPictureHUD showHUDInView:nil withMessage:@"Save Picture Success!"];
    }
}

- (void)pictureBrowserDidDismiss {
    NSLog(@"%s", __func__);
}

@end
