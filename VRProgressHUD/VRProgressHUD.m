//
//  VRProgressHUD.m
//  VRProgressHUD
//
//  Created by Jakub Truhlar on 20.06.15.
//  Copyright (c) 2015 Jakub Truhlar. All rights reserved.
//

#import "VRProgressHUD.h"

static VRProgressHUD *sharedInstance = nil;
static CGFloat kBGColorAlphaMax = 0.75;
static CGFloat kBGColorAlphaSkip = 0.3;
static CGFloat kAnimationDuration = 0.3;
static CGFloat kAnimationCycleDuration = 0.4;
static CGFloat kCircleWidth = 100.0;
static CGFloat kBorderWidth = 0.0;

@interface VRProgressHUD()

@property (nonatomic, strong) UIColor *styleColor1;
@property (nonatomic, strong) UIColor *styleColor2;
@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UIView *staticCircle;
@property (nonatomic, strong) UIView *movingCircle;
@property (nonatomic, strong) UIView *customView;
@property (nonatomic, assign) VRProgressHUDTransition transition;
@property (nonatomic, assign) VRProgressHUDStyle style;

@property (nonatomic, strong) UIView *circle_1;
@property (nonatomic, strong) UIView *circle_2;
@property (nonatomic, strong) UIView *circle_3;

@end

@implementation VRProgressHUD

#pragma mark - Initialization
+ (VRProgressHUD *)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [self new];
        [sharedInstance initialize];
    });
    
    return sharedInstance;
}

- (void)initialize {
    // Base
    [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
    sharedInstance.alpha = 0.0;
    sharedInstance.customView = [UIView new];
    
    // Observing
    [sharedInstance createObservers];
}

- (void)createObservers {
    [[NSNotificationCenter defaultCenter] addObserver:sharedInstance selector:@selector(changeFrame) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)changeFrame {
    sharedInstance.backgroundView.center = [UIApplication sharedApplication].keyWindow.center;
    sharedInstance.staticCircle.center = sharedInstance.backgroundView.center;
    sharedInstance.movingCircle.center = sharedInstance.backgroundView.center;
    sharedInstance.circle_1.center = sharedInstance.backgroundView.center;
    sharedInstance.circle_2.center = sharedInstance.backgroundView.center;
    sharedInstance.circle_3.center = sharedInstance.backgroundView.center;
    sharedInstance.customView.center = sharedInstance.backgroundView.center;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:sharedInstance];
}

#pragma mark - Visibility
- (BOOL)isVisible {
    return (sharedInstance.alpha == 1.0);
}

+ (BOOL)isVisible {
    return [sharedInstance isVisible];
}

#pragma mark - Displaying
+ (void)show {
    [VRProgressHUD showWithView:VRProgressHUDViewBuiltIn];
}

+ (void)showWithView:(UIView *)view {
    [VRProgressHUD showWithView:view style:VRProgressHUDStyleGradient transition:VRProgressHUDTransitionDefault backgroundAlpha:kBGColorAlphaMax];
}

+ (void)showWithStyle:(VRProgressHUDStyle)style {
    [VRProgressHUD showWithView:VRProgressHUDViewBuiltIn style:style transition:VRProgressHUDTransitionDefault backgroundAlpha:kBGColorAlphaMax];
}

+ (void)showWithTransition:(VRProgressHUDTransition)transition {
    [VRProgressHUD showWithView:VRProgressHUDViewBuiltIn style:VRProgressHUDStyleGradient transition:transition backgroundAlpha:kBGColorAlphaMax];
}

+ (void)showWithBackgroundAlpha:(CGFloat)backgroundAlpha {
    [VRProgressHUD showWithView:VRProgressHUDViewBuiltIn style:VRProgressHUDStyleGradient transition:VRProgressHUDTransitionDefault backgroundAlpha:backgroundAlpha];
}

+ (void)showWithView:(UIView *)view style:(VRProgressHUDStyle)style transition:(VRProgressHUDTransition)transition backgroundAlpha:(CGFloat)backgroundAlpha {
    if ([[VRProgressHUD sharedInstance] isVisible]) {
        return;
    }
    
    // Properties
    sharedInstance.styleColor1 = [[UIColor blackColor] colorWithAlphaComponent:backgroundAlpha - kBGColorAlphaSkip];
    sharedInstance.styleColor2 = [[UIColor blackColor] colorWithAlphaComponent:backgroundAlpha];
    sharedInstance.transition = transition;
    sharedInstance.customView = view;
    sharedInstance.style = style;
    sharedInstance.alpha = 1.0;
    
    // Style
    if (!style) {
        style = VRProgressHUDStyleDefault;
    }
    switch (style) {
        case VRProgressHUDStyleDefault:
            [sharedInstance createSolidBackground];
            [sharedInstance addBackgroundBelowHUD];
            break;
        case VRProgressHUDStyleGradient:
            [sharedInstance createGradientBackground];
            [sharedInstance addBackgroundBelowHUD];
            break;
		case VRProgressHUDStyleBlurLight:
			[sharedInstance createBlurBackgroundWithStyle:UIBlurEffectStyleLight];
			[sharedInstance addBackgroundBelowHUD];
			break;
		case VRProgressHUDStyleBlurExtraLight:
			[sharedInstance createBlurBackgroundWithStyle:UIBlurEffectStyleExtraLight];
			[sharedInstance addBackgroundBelowHUD];
			break;
		case VRProgressHUDStyleBlurDark:
			[sharedInstance createBlurBackgroundWithStyle:UIBlurEffectStyleDark];
			[sharedInstance addBackgroundBelowHUD];
			break;
        default:
            break;
    }
    
    // View
    if (view) {
        sharedInstance.customView.center = sharedInstance.backgroundView.center;
        [[UIApplication sharedApplication].keyWindow addSubview:sharedInstance.customView];
    } else {
        [sharedInstance createHTLoadingView];
    }
    
    // Transition and animation
    sharedInstance.customView.alpha = 0.0;
    switch (transition) {
        case VRProgressHUDTransitionDefault:
            sharedInstance.customView.transform = CGAffineTransformMakeScale(0.0, 0.0);
            break;
        case VRProgressHUDTransitionFade:
            sharedInstance.customView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            break;
        case VRProgressHUDTransitionNone:
            sharedInstance.customView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            break;
        default:
            break;
    }
    
    void(^animationBlock)() = ^{
        sharedInstance.customView.alpha = 1.0;
        sharedInstance.customView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        sharedInstance.backgroundView.alpha = 1.0;
    };
    
    if (transition != VRProgressHUDTransitionNone) {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            animationBlock();
        } completion:nil];
        
    } else {
        animationBlock();
    }
}

+ (void)hide {
    [VRProgressHUD hideWithTransition:VRProgressHUDTransitionDefault];
}

+ (void)hideWithTransition:(VRProgressHUDTransition)transition {
    if (![[VRProgressHUD sharedInstance] isVisible]) {
        return;
    }
    
    void(^animationBlock)() = ^{
        sharedInstance.backgroundView.alpha = 0.0;
        
        if (sharedInstance.transition == VRProgressHUDTransitionDefault) {
            CGFloat multiplier = [[UIScreen mainScreen] scale];
            sharedInstance.customView.transform = CGAffineTransformMakeScale(10.0 * multiplier, 10.0 * multiplier);
            sharedInstance.staticCircle.transform = CGAffineTransformMakeScale(10.0 * multiplier, 10.0 * multiplier);
            sharedInstance.movingCircle.transform = CGAffineTransformMakeScale(10.0 * multiplier, 10.0 * multiplier);
            sharedInstance.circle_1.transform = CGAffineTransformMakeScale(10.0 * multiplier, 10.0 * multiplier);
            sharedInstance.circle_2.transform = CGAffineTransformMakeScale(10.0 * multiplier, 10.0 * multiplier);
            sharedInstance.circle_3.transform = CGAffineTransformMakeScale(10.0 * multiplier, 10.0 * multiplier);
        }
        
        sharedInstance.customView.alpha = 0.0;
        sharedInstance.staticCircle.alpha = 0.0;
        sharedInstance.movingCircle.alpha = 0.0;
        sharedInstance.circle_1.alpha = 0.0;
        sharedInstance.circle_2.alpha = 0.0;
        sharedInstance.circle_3.alpha = 0.0;
    };
    
    void(^cleanupBlock)() = ^{
        [sharedInstance.customView removeFromSuperview];
        [sharedInstance.staticCircle removeFromSuperview];
        [sharedInstance.movingCircle removeFromSuperview];
        [sharedInstance.circle_1 removeFromSuperview];
        [sharedInstance.circle_2 removeFromSuperview];
        [sharedInstance.circle_3 removeFromSuperview];
        [sharedInstance.backgroundView removeFromSuperview];
        sharedInstance.alpha = 0.0;
    };
    
    if (transition != VRProgressHUDTransitionNone) {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            animationBlock();
            
        } completion:^(BOOL finished) {
            cleanupBlock();
        }];
        
    } else {
        animationBlock();
        cleanupBlock();
    }
}

#pragma mark - VRProgressHUDStyle
- (void)createSolidBackground {
    sharedInstance.backgroundView = [[UIImageView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    sharedInstance.backgroundView.backgroundColor = _styleColor2;
    sharedInstance.backgroundView.userInteractionEnabled = true;
    sharedInstance.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    sharedInstance.backgroundView.alpha = 0.0;
}

- (void)createGradientBackground {
    CGFloat biggerSize = MAX([UIApplication sharedApplication].keyWindow.bounds.size.width, [UIApplication sharedApplication].keyWindow.bounds.size.height);
    UIImage *gradientImage = [sharedInstance jt_imageWithRadialGradientSize:CGSizeMake(biggerSize, biggerSize) innerColor:sharedInstance.styleColor1 outerColor:sharedInstance.styleColor2 center:CGPointMake(0.5, 0.5) radius:0.85];
    sharedInstance.backgroundView = [[UIImageView alloc] initWithImage:gradientImage];
    sharedInstance.backgroundView.userInteractionEnabled = true;
    sharedInstance.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    sharedInstance.backgroundView.alpha = 0.0;
    sharedInstance.backgroundView.center = [UIApplication sharedApplication].keyWindow.center;
}

- (void)createBlurBackgroundWithStyle:(UIBlurEffectStyle)style {
	sharedInstance.backgroundView = [[UIImageView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
	sharedInstance.backgroundView.backgroundColor = [UIColor clearColor];
	sharedInstance.backgroundView.userInteractionEnabled = true;
	sharedInstance.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	sharedInstance.backgroundView.alpha = 0.0;
	
	UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect: [UIBlurEffect effectWithStyle: style]];
	blurView.frame = sharedInstance.backgroundView.bounds;
	[sharedInstance.backgroundView addSubview:blurView];
}

- (void)addBackgroundBelowHUD {
    [sharedInstance.backgroundView removeFromSuperview];
    [[UIApplication sharedApplication].keyWindow addSubview:sharedInstance.backgroundView];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:sharedInstance.backgroundView];
}

- (UIImage *)jt_imageWithRadialGradientSize:(CGSize)size innerColor:(UIColor *)innerColor outerColor:(UIColor *)outerColor center:(CGPoint)center radius:(CGFloat)radius {
    UIGraphicsBeginImageContext(size);
    CGGradientRef myGradient;
    CGColorSpaceRef myColorspace;
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat sRed, sGreen, sBlue, sAlpha, eRed, eGreen, eBlue, eAlpha;
    [innerColor getRed:&sRed green:&sGreen blue:&sBlue alpha:&sAlpha];
    [outerColor getRed:&eRed green:&eGreen blue:&eBlue alpha:&eAlpha];
    CGFloat components[8] = { sRed, sGreen, sBlue, sAlpha, eRed, eGreen, eBlue, eAlpha};
    myColorspace = CGColorSpaceCreateDeviceRGB();
    myGradient = CGGradientCreateWithColorComponents (myColorspace, components, locations, num_locations);
    center = CGPointMake(center.x * size.width, center.y * size.height);
    CGPoint startPoint = center;
    CGPoint endPoint = center;
    radius = MIN(size.width, size.height) * radius;
    CGFloat startRadius = 0;
    CGFloat endRadius = radius;
    CGContextDrawRadialGradient (UIGraphicsGetCurrentContext(), myGradient, startPoint, startRadius, endPoint, endRadius, kCGGradientDrawsAfterEndLocation);
    UIImage *gradientImg;
    gradientImg = UIGraphicsGetImageFromCurrentImageContext();
    CGColorSpaceRelease(myColorspace);
    CGGradientRelease(myGradient);
    UIGraphicsEndImageContext();
    return gradientImg;
}

#pragma mark - VRProgressHUDView

- (void)createDefaultLoadingView {
    // Default setup
    sharedInstance.staticCircle = [sharedInstance createCircleWithWidth:kCircleWidth];
    sharedInstance.movingCircle = [sharedInstance createCircleWithWidth:kCircleWidth];
    sharedInstance.staticCircle.layer.shouldRasterize = true;
    sharedInstance.staticCircle.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    // Animation
    sharedInstance.staticCircle.alpha = 0.0;
    sharedInstance.movingCircle.alpha = 0.0;
    
    if (sharedInstance.transition == VRProgressHUDTransitionDefault) {
        sharedInstance.staticCircle.transform = CGAffineTransformMakeScale(0.0, 0.0);
        sharedInstance.movingCircle.transform = CGAffineTransformMakeScale(0.0, 0.0);
    }
    
    sharedInstance.staticCircle.center = sharedInstance.backgroundView.center;
    sharedInstance.movingCircle.center = sharedInstance.backgroundView.center;
    
    [[UIApplication sharedApplication].keyWindow addSubview:sharedInstance.movingCircle];
    [[UIApplication sharedApplication].keyWindow addSubview:sharedInstance.staticCircle];
    
    // Animation
    CGFloat delay = (sharedInstance.transition != VRProgressHUDTransitionNone) ? kAnimationDuration : 0.0;
    
    [UIView animateWithDuration:delay animations:^{
        sharedInstance.staticCircle.transform = CGAffineTransformMakeScale(1.0, 1.0);
        sharedInstance.movingCircle.transform = CGAffineTransformMakeScale(1.0, 1.0);
        sharedInstance.staticCircle.alpha = 1.0;
        sharedInstance.movingCircle.alpha = 1.0;
    } completion:nil];
    
    [UIView animateWithDuration:kAnimationCycleDuration delay:delay options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveEaseOut animations:^{
        sharedInstance.movingCircle.alpha = 0.0;
        sharedInstance.movingCircle.transform = CGAffineTransformMakeScale(1.25, 1.25);
        sharedInstance.movingCircle.layer.borderWidth = kBorderWidth / 3;
        
    } completion:^(BOOL finished) {
        sharedInstance.movingCircle.alpha = 1.0;
        sharedInstance.movingCircle.transform = CGAffineTransformMakeScale(1.0, 1.0);
        sharedInstance.movingCircle.layer.borderWidth = kBorderWidth;
    }];
}

- (void)createHTLoadingView {
    // Default setup
    sharedInstance.circle_1 = [sharedInstance createCircleWithWidth:kCircleWidth];
    sharedInstance.circle_2 = [sharedInstance createCircleWithWidth:kCircleWidth];
    sharedInstance.circle_3 = [sharedInstance createCircleWithWidth:kCircleWidth];
    
    // Animation
    sharedInstance.circle_1.alpha = 0.0;
    sharedInstance.circle_2.alpha = 0.0;
    sharedInstance.circle_3.alpha = 0.0;
    
    if (sharedInstance.transition == VRProgressHUDTransitionDefault) {
        sharedInstance.circle_1.transform = CGAffineTransformMakeScale(0.0, 0.0);
        sharedInstance.circle_2.transform = CGAffineTransformMakeScale(0.0, 0.0);
        sharedInstance.circle_3.transform = CGAffineTransformMakeScale(0.0, 0.0);
    }
    
    sharedInstance.circle_1.center = sharedInstance.backgroundView.center;
    sharedInstance.circle_2.center = sharedInstance.backgroundView.center;
    sharedInstance.circle_3.center = sharedInstance.backgroundView.center;
    
    [[UIApplication sharedApplication].keyWindow addSubview:sharedInstance.circle_1];
    [[UIApplication sharedApplication].keyWindow addSubview:sharedInstance.circle_2];
    [[UIApplication sharedApplication].keyWindow addSubview:sharedInstance.circle_3];
    
    // Animation
    CGFloat delay = (sharedInstance.transition != VRProgressHUDTransitionNone) ? kAnimationDuration : 0.0;
    
    [UIView animateWithDuration:delay animations:^{
        sharedInstance.circle_1.transform = CGAffineTransformMakeScale(0.4, 0.4);
        sharedInstance.circle_2.transform = CGAffineTransformMakeScale(0.7, 0.7);
        sharedInstance.circle_3.transform = CGAffineTransformMakeScale(1.0, 1.0);
        sharedInstance.circle_1.alpha = 1.0;
        sharedInstance.circle_2.alpha = 1.0;
        sharedInstance.circle_3.alpha = 1.0;
    } completion:nil];
    
    [UIView animateWithDuration:kAnimationCycleDuration delay:delay*3 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionCurveEaseInOut animations:^{
        sharedInstance.circle_1.transform = CGAffineTransformMakeScale(0.5, 0.5);
        
    } completion:^(BOOL finished) {
        sharedInstance.circle_1.transform = CGAffineTransformMakeScale(0.4, 0.4);
    }];
    
    [UIView animateWithDuration:kAnimationCycleDuration delay:delay*2 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse| UIViewAnimationOptionCurveEaseInOut animations:^{
        sharedInstance.circle_2.transform = CGAffineTransformMakeScale(0.9, 0.9);
        
    } completion:^(BOOL finished) {
        sharedInstance.circle_2.transform = CGAffineTransformMakeScale(0.7, 0.7);
    }];
    
    [UIView animateWithDuration:kAnimationCycleDuration delay:delay options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse| UIViewAnimationOptionCurveEaseInOut animations:^{
        sharedInstance.circle_3.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        sharedInstance.circle_3.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
}

- (UIView *)createCircleWithWidth:(CGFloat)size {
    UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCircleWidth, kCircleWidth)];
    circle.layer.cornerRadius = kCircleWidth / 2;
    circle.layer.borderWidth = 0;
    circle.layer.borderColor = [UIColor clearColor].CGColor;
    circle.layer.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2].CGColor;
    circle.layer.masksToBounds = true;
    return circle;
}

@end
