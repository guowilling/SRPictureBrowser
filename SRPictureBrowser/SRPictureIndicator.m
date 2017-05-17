//
//  SRPictureIndicator.m
//  SRPhotoBrowser
//
//  Created by https://github.com/guowilling on 16/12/24.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "SRPictureIndicator.h"

static NSString * const rotationAnimationKey = @"rotationAnimation";
static NSString * const strokeAnimationKey   = @"strokeAnimation";

@interface SRPictureIndicator ()

@property (nonatomic, strong) CAShapeLayer *progressLayer;

@property (nonatomic, assign, getter=isAnimating) BOOL animating;

@end

@implementation SRPictureIndicator

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

+ (instancetype)showInView:(UIView *)view {
    
    if (!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    SRPictureIndicator *pictureIndicator = [[SRPictureIndicator alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [view addSubview:pictureIndicator];
    [pictureIndicator startAnimating];
    return pictureIndicator;
}

- (instancetype)hide {
    
    [self stopAnimating];
    [self removeFromSuperview];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.center = [UIApplication sharedApplication].keyWindow.center;
        self.tintColor = [UIColor colorWithWhite:1.0 alpha:0.75];
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.strokeColor = self.tintColor.CGColor;
        _progressLayer.fillColor = nil;
        _progressLayer.lineWidth = 2.0;
        [self.layer addSublayer:_progressLayer];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidBecomeActive)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.progressLayer.frame = self.bounds;
    
    CGPoint center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    CGFloat radius = MIN(center.x, center.y) - self.progressLayer.lineWidth * 0.5;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:2 * M_PI clockwise:YES];
    self.progressLayer.path = path.CGPath;
    self.progressLayer.strokeStart = 0.0;
    self.progressLayer.strokeEnd = 0.0;
}

- (void)tintColorDidChange {
    
    [super tintColorDidChange];
    
    self.progressLayer.strokeColor = self.tintColor.CGColor;
}

- (void)startAnimating {
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath     = @"transform.rotation";
    animation.duration    = 4.f;
    animation.fromValue   = @(0.f);
    animation.toValue     = @(2 * M_PI);
    animation.repeatCount = INFINITY;
    [self.progressLayer addAnimation:animation forKey:rotationAnimationKey];
    
    CABasicAnimation *headAnimation = [CABasicAnimation animation];
    headAnimation.keyPath   = @"strokeStart";
    headAnimation.duration  = 1.f;
    headAnimation.fromValue = @(0.f);
    headAnimation.toValue   = @(0.25f);
    headAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation *tailAnimation = [CABasicAnimation animation];
    tailAnimation.keyPath   = @"strokeEnd";
    tailAnimation.duration  = 1.f;
    tailAnimation.fromValue = @(0.f);
    tailAnimation.toValue   = @(1.f);
    tailAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    
    CABasicAnimation *endHeadAnimation = [CABasicAnimation animation];
    endHeadAnimation.keyPath   = @"strokeStart";
    endHeadAnimation.beginTime = 1.f;
    endHeadAnimation.duration  = 0.5f;
    endHeadAnimation.fromValue = @(0.25f);
    endHeadAnimation.toValue   = @(1.f);
    endHeadAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation *endTailAnimation = [CABasicAnimation animation];
    endTailAnimation.keyPath   = @"strokeEnd";
    endTailAnimation.beginTime = 1.f;
    endTailAnimation.duration  = 0.5f;
    endTailAnimation.fromValue = @(1.f);
    endTailAnimation.toValue   = @(1.f);
    endTailAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CAAnimationGroup *animations = [CAAnimationGroup animation];
    animations.duration = 1.5;
    animations.animations = @[headAnimation, tailAnimation, endHeadAnimation, endTailAnimation];
    animations.repeatCount = INFINITY;
    [self.progressLayer addAnimation:animations forKey:strokeAnimationKey];
}

- (void)stopAnimating {
    
    [self.progressLayer removeAnimationForKey:rotationAnimationKey];
    [self.progressLayer removeAnimationForKey:strokeAnimationKey];
}

- (void)applicationDidBecomeActive {
    
    [self stopAnimating];
    [self startAnimating];
}

@end
