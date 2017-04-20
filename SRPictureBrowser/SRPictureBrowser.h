//
//  SRPictureBrowser.h
//  SRPhotoBrowser
//
//  Created by Willing Guo on 16/12/24.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRPictureModel.h"

@interface SRPictureBrowser : UIView

/**
 Create a SRPictureBrowser object with pictureModels and the currentIndex which will first display.
 */
+ (instancetype)sr_pictureBrowserWithModels:(NSArray *)pictureModels currentIndex:(NSInteger)currentIndex;

/**
 Show picture browser.
 */
- (void)show;

@end
