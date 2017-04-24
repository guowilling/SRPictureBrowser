//
//  SRPictureBrowser.h
//  SRPhotoBrowser
//
//  Created by Willing Guo on 16/12/24.
//  Copyright © 2016年 SR. All rights reserved.
//
//  GitHub: https://github.com/guowilling/SRPictureBrowser
//  If you have any questions, submit an issue or email me. <guowilling90@gmail.com>
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
 Displays a SRPictureBrowser object with pictureModels, currentIndex and delegate.

 @param pictureModels The models which contains SRPictureModel.
 @param currentIndex  The index of model which will show firstly.
 @param delegate      The delegate of this object.
 */
+ (void)sr_showPictureBrowserWithModels:(NSArray *)pictureModels currentIndex:(NSInteger)currentIndex delegate:(id<SRPictureBrowserDelegate>)delegate;

@end
