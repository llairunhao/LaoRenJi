//
//  XHNavigationController.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/14.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "XHNavigationController.h"

@interface XHNavigationController ()<UINavigationControllerDelegate>

@property (nonatomic, weak) id PopDelegate;

@end

@implementation XHNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.PopDelegate = self.interactivePopGestureRecognizer.delegate;
    self.delegate = self;
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (viewController == self.viewControllers[0]) {
        self.interactivePopGestureRecognizer.delegate = self.PopDelegate;
    }else{
        self.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
    CGRect frame = self.tabBarController.tabBar.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height;
    self.tabBarController.tabBar.frame = frame;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.viewControllers.lastObject;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.viewControllers.lastObject;
}

- (BOOL)shouldAutorotate{
    UIViewController *controller = self.topViewController;
    return [controller shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    UIViewController *controller = self.topViewController;
    return [controller supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    UIViewController *controller = self.topViewController;
    return [controller preferredInterfaceOrientationForPresentation];
}


@end
