//
//  SRPictureBrowser.h
//  SRPhotoBrowser
//
//  Created by Willing Guo on 16/12/24.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRPictureModel.h"

@class SRPictureBrowser;

@protocol SRPictureBrowserDelegate <NSObject>

@optional
- (void)pictureBrowserDidShow:(SRPictureBrowser *)pictureBrowser;
- (void)pictureBrowserDidDismiss;

@end

@interface SRPictureBrowser : UIView

/**
 Show a SRPictureBrowser object.

 @param pictureModels Models which contains SRPictureModel.
 @param currentIndex  Index of model which will show firstly
 @param delegate      A SRPictureBrowser delegate object.
 */
+ (void)sr_showPictureBrowserWithModels:(NSArray *)pictureModels currentIndex:(NSInteger)currentIndex delegate:(id<SRPictureBrowserDelegate>)delegate;

@end
