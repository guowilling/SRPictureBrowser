//
//  SRPictureModel.m
//  SRPhotoBrowser
//
//  Created by https://github.com/guowilling on 16/12/24.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "SRPictureModel.h"
#import "SRPictureManager.h"

@interface SRPictureModel ()

@property (nonatomic, assign, readwrite) CGRect destinationPosition;

@end

@implementation SRPictureModel

+ (instancetype)sr_pictureModelWithPicURLString:(NSString *)picURLString containerView:(UIView *)containerView positionInContainer:(CGRect)positionInContainer index:(NSInteger)index {
    
    SRPictureModel *pictureModel = [[SRPictureModel alloc] init];
    pictureModel.picURLString = picURLString;
    if (containerView) {
        pictureModel.originPosition = [containerView convertRect:positionInContainer toView:[UIApplication sharedApplication].keyWindow];
    } else {
        pictureModel.originPosition = CGRectMake([UIScreen mainScreen].bounds.size.width * 0.5, [UIScreen mainScreen].bounds.size.height * 0.5, 0, 0);
    }
    pictureModel.index = index;
    [self calculateDestinationPositionWithPictureModel:pictureModel picture:nil];
    return pictureModel;
}

+ (void)calculateDestinationPositionWithPictureModel:(SRPictureModel *)pictureModel picture:(UIImage *)picture {
    
    if (!picture) {
        picture = [SRPictureManager pictureFromSandbox:pictureModel.picURLString];
        pictureModel->_picture = picture;
    }
    if (!picture) {
        return;
    }
    CGFloat destinationPositionX = 0;
    CGFloat destinationPositionY = 0;
    CGFloat destinationPositionW = [UIScreen mainScreen].bounds.size.width;
    CGFloat destinationPositionH = destinationPositionW / picture.size.width * picture.size.height;
    if (destinationPositionH > [UIScreen mainScreen].bounds.size.height) {
        destinationPositionH = picture.size.height;
    } else {
        destinationPositionY = ([UIScreen mainScreen].bounds.size.height - destinationPositionH) * 0.5;
    }
    pictureModel.destinationPosition = CGRectMake(destinationPositionX, destinationPositionY, destinationPositionW, destinationPositionH);
}

- (void)setPicture:(UIImage *)picture {
    
    _picture = picture;
    
    [self.class calculateDestinationPositionWithPictureModel:self picture:picture];
}

@end
