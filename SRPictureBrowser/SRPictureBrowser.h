//
//  SRPictureBrowser.h
//  SRPhotoBrowser
//
//  Created by Willing Guo on 16/12/24.
//  Copyright © 2016年 SR. All rights reserved.
//

/**
 *  If you have any question, submit an issue or contact me.
 *  QQ: 1990991510
 *  Email: guowilling@qq.com
 *  If this repo helps you, please give it a star.
 *  Github: https://github.com/guowilling/SRPictureBrowser
 *  Have Fun.
 */

#import <UIKit/UIKit.h>
#import "SRPictureModel.h"

@interface SRPictureBrowser : UIView

/**
 Create a SRPictureBrowser object with pictureModels and the currentIndex which will first display.
 */
+ (instancetype)sr_pictureBrowserWithModels:(NSArray *)pictureModels currentIndex:(NSInteger)currentIndex;

/**
 Show the picture browser.
 */
- (void)show;

@end
