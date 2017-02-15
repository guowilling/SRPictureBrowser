
Pod::Spec.new do |s|
s.name         = "SRPictureBrowser"
s.version      = "1.0.0"
s.summary      = "A concise and elegant easy-to-use picture browser, the code is clear and easy to extend.(图片浏览器)"
s.description  = "Similar to the Pengyouquan's picture browser, Loading image with animation, blurring the current view background; Long press the image to show action sheet, save image etc, you can extend it; Currently, the download image depends on SDWebImage, I will rewrite the download and cache image function, do not rely on third-party libraries some time."
s.homepage     = "https://github.com/guowilling/SRPictureBrowser"
s.license      = "MIT"
s.author       = { "guowilling" => "guowilling90@gmail.com" }
s.platform     = :ios, "7.0"
s.source       = { :git => "https://github.com/guowilling/SRPictureBrowser.git", :tag => "#{s.version}" }
s.source_files = "SRPictureBrowser/*.{h,m}"
s.requires_arc = true
s.dependency 'SDWebImage', '~> 4.0.0'
end
