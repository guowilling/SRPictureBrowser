# SRPictureBrowser

## Features

* Similar to the Pengyouquan's picture browser, Loading image with animation, blurring the current view background.
* Long press the image to show action sheet, save image etc, you can extend it.
* Currently, the download image depends on SDWebImage, I will rewrite the download and cache image function, do not rely on third-party libraries some time.

***

* 类似于朋友圈的图片浏览器, 图片加载动画, 模糊当前视图背景.
* 长按弹出选择器, 保存图片等, 你可以自行扩展它的功能.
* 目前图片下载缓存使用 SDWebImage, 以后再不依赖于第三方库, 重写下载缓存图片的功能.

## Show pictures

![image](./show.gif)

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
SRPictureBrowser *pictureBrowser = [SRPictureBrowser sr_pictureBrowserWithModels:imageBrowserModels currentIndex:tapedImageView.tag];
[pictureBrowser show];
````
See the demo for more information.

**If you have any question, submit an issue or contact me.**   
**If this repo helps you, please give it a star, thanks a lot.**  
**Have Fun.**