//
//  SRPictureManager.h
//  SRPictureBrowserDemo
//
//  Created by 郭伟林 on 17/5/3.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SRPictureManager : NSObject

+ (UIImage *)pictureFromSandbox:(NSString *)URLString;

+ (void)downloadPicture:(NSString *)URLString success:(void (^)(UIImage *picture))success failure:(void (^)(NSError *error))failure;

+ (void)prefetchDownloadPicture:(NSString *)URLString;

+ (void)clearCachedImages;
    
@end
