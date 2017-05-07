//
//  SRPictureCell.h
//  SRPhotoBrowser
//
//  Created by https://github.com/guowilling on 16/12/24.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SRPictureModel, SRPictureView;

@protocol SRPictureCellDelegate <NSObject>

@optional

- (void)pictureCellDidPanToAlpha:(CGFloat)alpha;
- (void)pictureCellDidPanToDismiss;

@end

static NSString * const pictureViewID = @"SRPictureView";

@interface SRPictureCell : UICollectionViewCell

@property (nonatomic, weak) id <SRPictureCellDelegate> delegate;

@property (nonatomic, strong) SRPictureModel *pictureModel;

@property (nonatomic, strong) SRPictureView *pictureView;

@end
