//
//  HTProgressHUD.h
//  HTProgressHUD
//
//  Created by Jakub Truhlar on 20.06.15.
//  Copyright (c) 2015 Jakub Truhlar. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HTProgressHUDStyle) {
	HTProgressHUDStyleDefault = 0,
	HTProgressHUDStyleGradient,
	HTProgressHUDStyleBlurLight,
	HTProgressHUDStyleBlurExtraLight,
	HTProgressHUDStyleBlurDark
};

typedef NS_ENUM(NSInteger, HTProgressHUDTransition) {
    HTProgressHUDTransitionDefault = 0,
    HTProgressHUDTransitionFade,
    HTProgressHUDTransitionNone
};

typedef NS_ENUM(NSInteger, HTProgressHUDView) {
    HTProgressHUDViewBuiltIn = 0 // Same as nil
};

@interface HTProgressHUD : UIView

/**
 View: Is your custom view (eg. Animated UIImageView or whatever you want).
 Style: Is the style of the background. Usually it is the dark color between the view and the rest of the app.
 Transition: Showing and hiding transitions.
 BackgroundAlpha: The biggest alpha for the background.
 All parameters can be setup separately.
 */
+ (void)showWithView:(UIView *)view style:(HTProgressHUDStyle)style transition:(HTProgressHUDTransition)transition backgroundAlpha:(CGFloat)backgroundAlpha;
+ (void)show;
+ (void)showWithView:(UIView *)view;
+ (void)showWithStyle:(HTProgressHUDStyle)style;
+ (void)showWithTransition:(HTProgressHUDTransition)transition;
+ (void)showWithBackgroundAlpha:(CGFloat)backgroundAlpha;

+ (void)hide;
+ (void)hideWithTransition:(HTProgressHUDTransition)transition;

+ (BOOL)isVisible;

@end
