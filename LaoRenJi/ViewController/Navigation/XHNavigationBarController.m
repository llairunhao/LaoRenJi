//
//  XHNavigationBarController.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/14.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "XHNavigationBarController.h"


@interface XHNavigationBarController ()
{
    XHSafeNavigationBar *_safeNavigationBar;
    XHNavigationBar *_navigationBar;
}
@end

@implementation XHNavigationBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBarHidden = false;
}


- (void)viewDidLayoutSubviews {
    if (self.safeNavigationBar) {
        [self.view bringSubviewToFront:self.safeNavigationBar];
    }
}

- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    if (self.navigationBar) {
        self.navigationBar.titleLabel.text = title;
    }
}

- (void)setNavigationBarHidden: (BOOL)isHidden {
    if (isHidden) {
        if (self.safeNavigationBar) {
            [self.safeNavigationBar removeFromSuperview];
        }
        _safeNavigationBar = nil;
    } else {
        if (!_safeNavigationBar) {
            CGRect barFrame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), [UIView navigationBarHeight] + [UIView statusBarHeight]);
            XHSafeNavigationBar *safeNavigationBar = [[XHSafeNavigationBar alloc] initWithFrame: barFrame];
            [[super view] addSubview:safeNavigationBar];
            _safeNavigationBar = safeNavigationBar;
            
            UNSAFESELF;
            XHNavigationBar *navigationBar = [[XHNavigationBar alloc] init];
            navigationBar.backHandler = ^{
                [unsafeSelf.navigationController popViewControllerAnimated:true];
            };
            [safeNavigationBar addSubview:navigationBar];
            _navigationBar = navigationBar;
        }
        self.navigationBar.titleLabel.text = self.title;
    }
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}


- (UIColor *)navigationBarBackgroundColor {
    return self.safeNavigationBar.backgroundColor;
}

- (void)setNavigationBarBackgroundColor:(UIColor *)navigationBarBackgroundColor {
    self.safeNavigationBar.backgroundColor = navigationBarBackgroundColor;
}

- (BOOL)navigationBarHidden {
    return _safeNavigationBar == nil;
}


- (XHNavigationBar *)navigationBar {
    return _navigationBar;
}

- (XHSafeNavigationBar *)safeNavigationBar {
    return _safeNavigationBar;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return false;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
