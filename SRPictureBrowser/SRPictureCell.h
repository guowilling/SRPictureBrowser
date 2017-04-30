//
//  SRPictureCell.h
//  SRPhotoBrowser
//
//  Created by Willing Guo on 16/12/24.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SRPictureModel, SRPictureView;

static NSString * const pictureViewID = @"SRPictureView";

@interface SRPictureCell : UICollectionViewCell

@property (nonatomic, strong) SRPictureModel *pictureModel;

@property (nonatomic, strong) SRPictureView  *pictureView;

@end
