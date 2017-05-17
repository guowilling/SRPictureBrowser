//
//  SRPictureHUD.h
//  SRPictureBrowserDemo
//
//  Created by Willing Guo on 2017/5/11.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRPictureHUD : UIView

@property (nonatomic, assign) BOOL autoDismiss;

@property (nonatomic, assign) NSTimeInterval duration;

+ (instancetype)showHUDInView:(UIView*)view withMessage:(NSString*)message;

- (void)hide;

@end
