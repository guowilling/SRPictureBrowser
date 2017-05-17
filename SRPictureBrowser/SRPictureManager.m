//
//  SRPictureManager.m
//  SRPictureBrowserDemo
//
//  Created by https://github.com/guowilling on 17/5/3.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "SRPictureManager.h"

#define SRPicturesDirectory      [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] \
stringByAppendingPathComponent:NSStringFromClass([self class])]

#define SRPictureName(URLString) [URLString lastPathComponent]

#define SRPicturePath(URLString) [SRPicturesDirectory stringByAppendingPathComponent:SRPictureName(URLString)]

@implementation SRPictureManager

+ (void)load {
    
    NSString *imagesDirectory = SRPicturesDirectory;
    BOOL isDirectory = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExists = [fileManager fileExistsAtPath:imagesDirectory isDirectory:&isDirectory];
    if (!isExists || !isDirectory) {
        [fileManager createDirectoryAtPath:imagesDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

+ (UIImage *)pictureFromSandbox:(NSString *)URLString {
    
    NSString *imagePath = SRPicturePath(URLString);
    NSData *data = [NSData dataWithContentsOfFile:imagePath];
    if (data.length > 0 ) {
        return [UIImage imageWithData:data];
    } else {
        [[NSFileManager defaultManager] removeItemAtPath:imagePath error:NULL];
    }
    return nil;
}

+ (void)downloadPicture:(NSString *)URLString success:(void (^)(UIImage *picture))success failure:(void (^)(NSError *error))failure {
    
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:URLString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            if (failure) {
                failure(error);
            }
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                UIImage *image = [UIImage imageWithData:data];
                success(image);
            }
        });
        [data writeToFile:SRPicturePath(URLString) atomically:YES];
    }] resume];
}

+ (void)prefetchDownloadPicture:(NSString *)URLString success:(void (^)(UIImage *picture))success {
    
    [self downloadPicture:URLString success:success failure:nil];
}

+ (void)clearCachedImages {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *fileNames = [fileManager contentsOfDirectoryAtPath:SRPicturesDirectory error:nil];
    for (NSString *fileName in fileNames) {
        [fileManager removeItemAtPath:[SRPicturesDirectory stringByAppendingPathComponent:fileName] error:nil];
    }
}

@end
