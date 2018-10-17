//
//  FHTRootContainer.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/13.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "FHTRootContainer.h"
#import "XHNavigationController.h"
#import "LoginViewController.h"
#import "MainViewController.h"

#import "UIViewController+ChildController.h"

@interface FHTRootContainer ()
{
    __weak UIViewController *_baseController;
    BOOL login;
}
@end

@implementation FHTRootContainer

+ (FHTRootContainer *)rootContainer {
    static FHTRootContainer * sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FHTRootContainer alloc] init];
    });
    return sharedInstance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    MainViewController *mainController = [[MainViewController alloc] init];
    XHNavigationController *navigationController = [[XHNavigationController alloc] initWithRootViewController:mainController];
    navigationController.navigationBarHidden = true;
    [self addController:navigationController];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!login) {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        XHNavigationController *nav = [[XHNavigationController alloc] initWithRootViewController:loginViewController];
        nav.navigationBarHidden = true;
        [self presentViewController:nav animated:nil completion:nil];
        login = true;
    }
   
  
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
