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
 Show a SRPictureBrowser object with pictureModels and the currentIndex which will first display.
 */
+ (void)sr_showPictureBrowserWithModels:(NSArray *)pictureModels currentIndex:(NSInteger)currentIndex delegate:(id<SRPictureBrowserDelegate>)delegate;

@end
