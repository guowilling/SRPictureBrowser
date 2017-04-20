//
//  SRPictureModel.h
//  SRPhotoBrowser
//
//  Created by Willing Guo on 16/12/24.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRPictureModel : UIView

@property (nonatomic, copy) NSString *picURLString;

@property (nonatomic, assign) CGRect           originPosition;
@property (nonatomic, assign, readonly) CGRect destinationPosition;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, assign, getter=isFirstShow) BOOL firstShow;


/**
 Create a model of picture information.

 @param picURLString URL of the picture.
 @param containerView Super view of the picture view.
 @param positionInContainer Picture view's position in its super view.
 @param index This picture index in all pictures.
 @return A SRPictureModel object.
 */
+ (id)sr_pictureModelWithPicURLString:(NSString *)picURLString
                        containerView:(UIView *)containerView
                  positionInContainer:(CGRect)positionInContainer
                                index:(NSInteger)index;

@end
