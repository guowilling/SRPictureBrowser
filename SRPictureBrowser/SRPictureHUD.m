//
//  SRPictureHUD.m
//  SRPictureBrowserDemo
//
//  Created by Willing Guo on 2017/5/11.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "SRPictureHUD.h"

@implementation SRPictureHUD

+ (instancetype)showHUDInView:(UIView*)view withMessage:(NSString*)message {
    
    SRPictureHUD *hud = [[SRPictureHUD alloc] initWithFrame:view.bounds mesasge:message];
    [view addSubview:hud];
    return hud;
}

- (instancetype)initWithFrame:(CGRect)frame mesasge:(NSString*)message {
    
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = NO;
        _autoDismiss = YES;
        _duration = 1.5;
        [self setupHUDWithMessage:message];
    }
    return self;
}

- (void)setupHUDWithMessage:(NSString*)message {
    
    CGSize fitSize = [message boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:17]}
                                           context:nil].size;
    CGFloat margin = 25;
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, fitSize.width + margin, fitSize.height + margin)];
    container.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    container.center = self.center;
    container.layer.cornerRadius = 5;
    container.layer.masksToBounds = YES;
    [self addSubview:container];
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = container.bounds;
    [container addSubview:effectView];
    
    UILabel *hudLabel = [[UILabel alloc] initWithFrame:effectView.bounds];
    hudLabel.text = message;
    hudLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1];
    hudLabel.textAlignment = NSTextAlignmentCenter;
    hudLabel.font = [UIFont boldSystemFontOfSize:17];
    [container addSubview:hudLabel];
    
    [self performSelector:@selector(hide) withObject:nil afterDelay:_duration];
}

- (void)setAutoDismiss:(BOOL)autoDismiss {
    
    _autoDismiss = autoDismiss;
    
    if (!autoDismiss) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }
}

- (void)setDuration:(NSTimeInterval)duration {
    
    _duration = duration;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(hide) withObject:nil afterDelay:_duration];
}

- (void)hide {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.01;
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
