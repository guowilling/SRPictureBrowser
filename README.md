# SRPictureBrowser

## Features

* Loading image with animation.
* blurring the current view background.
* Long press the image to show action sheet.

## Show

![image](./show.gif)
![image](./show.png)

## Installation

### CocoaPods
> Add **pod 'SRPictureBrowser'** to the Podfile, then run **pod install** in the terminal.

### Manual
> Drag the **SRPictureBrowser** folder to the project.(Note: if the project has already import SDWebImage, you should remove it which in the SRPictureBrowser folder)

## Usage

````objc
UIImageView *tapedImageView = (UIImageView *)tapGestureRecognizer.view;
NSMutableArray *imageBrowserModels = [[NSMutableArray alloc] init];
for (NSInteger i = 0; i < 9; i ++) {
    SRPictureModel *imageBrowserModel = [SRPictureModel sr_pictureModelWithPicURLString:self.picURLStrings[i]
                                                                          containerView:tapedImageView.superview
                                                                    positionInContainer:[self.imageViewFrames[i] CGRectValue]
                                                                                  index:i];
    [imageBrowserModels addObject:imageBrowserModel];
}
[SRPictureBrowser sr_showPictureBrowserWithModels:imageBrowserModels currentIndex:tapedImageView.tag delegate:self];
````
See the demo for more information.

**Have Fun.**