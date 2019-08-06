//
//  VRProgressHUD.h
//  VRProgressHUD
//
//  Created by Jakub Truhlar on 20.06.15.
//  Copyright (c) 2015 Jakub Truhlar. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, VRProgressHUDStyle) {
	VRProgressHUDStyleDefault = 0,
	VRProgressHUDStyleGradient,
	VRProgressHUDStyleBlurLight,
	VRProgressHUDStyleBlurExtraLight,
	VRProgressHUDStyleBlurDark
};

typedef NS_ENUM(NSInteger, VRProgressHUDTransition) {
    VRProgressHUDTransitionDefault = 0,
    VRProgressHUDTransitionFade,
    VRProgressHUDTransitionNone
};

typedef NS_ENUM(NSInteger, VRProgressHUDView) {
    VRProgressHUDViewBuiltIn = 0 // Same as nil
};

@interface VRProgressHUD : UIView

/**
 View: Is your custom view (eg. Animated UIImageView or whatever you want).
 Style: Is the style of the background. Usually it is the dark color between the view and the rest of the app.
 Transition: Showing and hiding transitions.
 BackgroundAlpha: The biggest alpha for the background.
 All parameters can be setup separately.
 */
+ (void)showWithView:(UIView *)view style:(VRProgressHUDStyle)style transition:(VRProgressHUDTransition)transition backgroundAlpha:(CGFloat)backgroundAlpha;
+ (void)show;
+ (void)showWithView:(UIView *)view;
+ (void)showWithStyle:(VRProgressHUDStyle)style;
+ (void)showWithTransition:(VRProgressHUDTransition)transition;
+ (void)showWithBackgroundAlpha:(CGFloat)backgroundAlpha;

+ (void)hide;
+ (void)hideWithTransition:(VRProgressHUDTransition)transition;

+ (BOOL)isVisible;

@end
