//
//  SRPictureCell.m
//  SRPhotoBrowser
//
//  Created by Willing Guo on 16/12/24.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "SRPictureCell.h"
#import "SRPictureModel.h"
#import "SRPictureView.h"
#import "SRPictureMacro.h"

@implementation SRPictureCell

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _pictureView = [[SRPictureView alloc] initWithFrame:SR_SCREEN_BOUNDS];
        [self.contentView addSubview:_pictureView];
    }
    return self;
}

- (void)setPictureModel:(SRPictureModel *)pictureModel {
    
    _pictureModel = pictureModel;
    
    _pictureView.pictureModel = pictureModel;
}

@end
