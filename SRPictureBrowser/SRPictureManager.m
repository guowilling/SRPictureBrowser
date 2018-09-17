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

//#define SRPictureName(URLString) [URLString lastPathComponent]

//#define SRPicturePath(URLString) [SRPicturesDirectory stringByAppendingPathComponent:SRPictureName(URLString)]

@implementation SRPictureManager

+ (void)load {
    NSString *directory = SRPicturesDirectory;
    BOOL isDirectory = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExists = [fileManager fileExistsAtPath:directory isDirectory:&isDirectory];
    if (!isExists || !isDirectory) {
        [fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearCachedPictures) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}

+ (NSString *)picturePath:(NSString *)URLString {
    NSString *pictureName = nil;
    NSString *query = [NSURL URLWithString:URLString].query;
    if (query) {
        pictureName = [URLString stringByReplacingOccurrencesOfString:query withString:@""];
        pictureName = [pictureName stringByReplacingOccurrencesOfString:@"?" withString:@""];
    }
    pictureName = pictureName.lastPathComponent;
    return [SRPicturesDirectory stringByAppendingPathComponent:pictureName];
}

+ (UIImage *)pictureFromSandbox:(NSString *)URLString {
    NSString *picturePath = [self picturePath:URLString];
    NSData *data = [NSData dataWithContentsOfFile:picturePath];
    if (data.length > 0 ) {
        return [UIImage imageWithData:data];
    } else {
        [[NSFileManager defaultManager] removeItemAtPath:picturePath error:NULL];
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
        [data writeToFile:[self picturePath:URLString] atomically:YES];
        UIImage *picture = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                success(picture);
            }
        });
    }] resume];
}

+ (void)prefetchDownloadPicture:(NSString *)URLString success:(void (^)(UIImage *picture))success {
    [self downloadPicture:URLString success:success failure:nil];
}

+ (void)clearCachedPictures {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *fileNames = [fileManager contentsOfDirectoryAtPath:SRPicturesDirectory error:nil];
    for (NSString *fileName in fileNames) {
        [fileManager removeItemAtPath:[SRPicturesDirectory stringByAppendingPathComponent:fileName] error:nil];
    }
}

@end
