# SRPictureBrowser

### A concise and elegant easy-to-use picture browser.

## Features

* Similar to the Pengyouquan's picture browser.
* Loading image with animation, blurring the current view background.
* Currently, the download image depends on SDWebImage, I will rewrite the download and cache image function, do not rely on third-party libraries.

## Show pictures

![image](./show.gif)    
![image](./show.png)

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

// You can see the demo for more information.
````

**If you have any question, please issue or contact me.**   
**If this repo helps you, please give it a star, thanks a lot.**  
**Have Fun.**