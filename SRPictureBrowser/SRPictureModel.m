//
//  SRPictureModel.m
//  SRPhotoBrowser
//
//  Created by Willing Guo on 16/12/24.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "SRPictureModel.h"

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
    [self calculateDestinationPositionWithPictureModel:pictureModel];
    return pictureModel;
}

+ (void)calculateDestinationPositionWithPictureModel:(SRPictureModel *)pictureModel {
    
    CGFloat destinationPositionX = 0;
    CGFloat destinationPositionY = 0;
    CGFloat destinationPositionW = [UIScreen mainScreen].bounds.size.width;
    CGFloat destinationPositionH = destinationPositionW / pictureModel.originPosition.size.width * pictureModel.originPosition.size.height;
    if (destinationPositionH > [UIScreen mainScreen].bounds.size.height) {
        destinationPositionH = pictureModel.originPosition.size.height;
    } else {
        destinationPositionY = ([UIScreen mainScreen].bounds.size.height - destinationPositionH) * 0.5;
    }
    pictureModel.destinationPosition = CGRectMake(destinationPositionX, destinationPositionY, destinationPositionW, destinationPositionH);
}

@end
