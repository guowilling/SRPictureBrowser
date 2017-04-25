# SRPictureBrowser

A concise and elegant picture browser, easy-to-use and easy-to-extend.

## Screenshots

![image](./screenshot1.jpg)
![image](./screenshot2.jpg)

## Usage

````objc
/**
 Displays a SRPictureBrowser object with pictureModels, currentIndex and delegate.

 @param pictureModels The models which contains SRPictureModel.
 @param currentIndex  The index of model which will show firstly.
 @param delegate      The delegate of this object.
 */
+ (void)sr_showPictureBrowserWithModels:(NSArray *)pictureModels currentIndex:(NSInteger)currentIndex delegate:(id<SRPictureBrowserDelegate>)delegate;

/**
 Creates and returns a model of picture information.

 @param picURLString        The URL string of the picture.
 @param containerView       The super view of the picture view.
 @param positionInContainer The picture view's position in its super view.
 @param index               The index of this picture in all pictures.
 @return A SRPictureModel object.
 */
+ (instancetype)sr_pictureModelWithPicURLString:(NSString *)picURLString
                                  containerView:(UIView *)containerView
                            positionInContainer:(CGRect)positionInContainer
                                          index:(NSInteger)index;
````

````objc
UIImageView *tapedImageView = (UIImageView *)tapGestureRecognizer.view;
NSMutableArray *imageBrowserModels = [[NSMutableArray alloc] init];
for (NSInteger i = 0; i < self.picURLStrings.count; i ++) {
    SRPictureModel *imageBrowserModel = [SRPictureModel sr_pictureModelWithPicURLString:self.picURLStrings[i]
                                                                          containerView:tapedImageView.superview
                                                                    positionInContainer:[self.imageViewFrames[i] CGRectValue]
                                                                                  index:i];
    [imageBrowserModels addObject:imageBrowserModel];
}
[SRPictureBrowser sr_showPictureBrowserWithModels:imageBrowserModels currentIndex:tapedImageView.tag delegate:self];
````

## More

Author: [guowilling](https://github.com/guowilling)  
Email: <guowilling90@gmail.com>   
If you have any questions, submit an issue or email me.