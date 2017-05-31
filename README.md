# SRPictureBrowser

Light-weight and easy-to-extend picture browser. Not rely on any third-party libraries to download and cache picture.

![image](./screenshots.png)

## Features

* [x] There are zoom animation effects when showing or dismissing the picture browser.
* [x] There is cyclic animation effect when loading the network picture.
* [x] Support kneading or double tapping the view to zoom the picture.
* [x] Support dragging down the picture to dismiss the picture browser.
* [x] Support long pressing the picture to evoke other interactive options.

## APIs

````objc
/**
 Displays a picture browser with pictureModels, currentIndex and delegate.

 @param pictureModels The models which contains SRPictureModel.
 @param currentIndex  The index of model which will show firstly.
 @param delegate      The receiver’s delegate object.
 */
+ (void)sr_showPictureBrowserWithModels:(NSArray *)pictureModels currentIndex:(NSInteger)currentIndex delegate:(id<SRPictureBrowserDelegate>)delegate;

/**
 Creates and returns a model of picture information.

 @param picURLString        The URL string of the picture.
 @param containerView       The super view of the picture view.
 @param positionInContainer The picture view's position in its super view.
 @param index               The index of this picture in all pictures.
 @return A picture model.
 */
+ (instancetype)sr_pictureModelWithPicURLString:(NSString *)picURLString containerView:(UIView *)containerView positionInContainer:(CGRect)positionInContainer index:(NSInteger)index;
````

## Usage

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