//
//  SRPictureBrowser.h
//  SRPhotoBrowser
//
//  Created by https://github.com/guowilling on 16/12/24.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SRPictureBrowser;

@protocol SRPictureBrowserDelegate <NSObject>

@optional
- (void)pictureBrowserDidShow:(SRPictureBrowser *)pictureBrowser;
- (void)pictureBrowserDidDismiss;

@end

@interface SRPictureBrowser : UIView

/**
 Displays a picture browser with pictureModels, currentIndex and delegate.

 @param pictureModels The models which contains SRPictureModel.
 @param currentIndex  The index of model which will show firstly.
 @param delegate      The receiver’s delegate object.
 */
+ (void)sr_showPictureBrowserWithModels:(NSArray *)pictureModels currentIndex:(NSInteger)currentIndex delegate:(id<SRPictureBrowserDelegate>)delegate;

@end
