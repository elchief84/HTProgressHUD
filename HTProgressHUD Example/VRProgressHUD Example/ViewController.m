//
//  ViewController.m
//  VRProgressHUD Example
//
//  Created by Jakub Truhlar on 20.06.15.
//  Copyright (c) 2015 Jakub Truhlar. All rights reserved.
//

#import "ViewController.h"
#import "VRProgressHUD.h"

@interface ViewController ()

@property (nonatomic, assign) bool bgWithGradient;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _bgWithGradient = true;
    _bgSwitch.on = _bgWithGradient;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)CustomBtnPressed:(id)sender {
    // Custom view
    UIImageView *animationView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150 / [[UIScreen mainScreen] scale], 50 / [[UIScreen mainScreen] scale])];
    animationView.animationImages = [NSArray arrayWithObjects:
                                     [UIImage imageNamed:@"1.png"],
                                     [UIImage imageNamed:@"2.png"],
                                     [UIImage imageNamed:@"3.png"], nil];
    animationView.animationDuration = 1.5f;
    animationView.animationRepeatCount = 0;
    [animationView startAnimating];
    
    [VRProgressHUD showWithView:animationView style:_bgWithGradient transition:VRProgressHUDTransitionDefault backgroundAlpha:0.75];
    
    // Dismiss
    [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(hideHUD) userInfo:nil repeats:false];
}

- (IBAction)BuiltBtnPressed:(id)sender {
    // Built-in animation
    [VRProgressHUD showWithStyle:_bgWithGradient];
    [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(hideHUD) userInfo:nil repeats:false];
}

- (void)hideHUD {
    [VRProgressHUD hide];
}

- (IBAction)bgSwitch:(id)sender {
    UISwitch *s = (UISwitch *)sender;
    _bgWithGradient = s.on;
}

@end
