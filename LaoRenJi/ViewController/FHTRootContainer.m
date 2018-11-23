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
#import "XHUser.h"
#import "XHDevice.h"

#import "UIViewController+ChildController.h"

@interface FHTRootContainer ()

@property (nonatomic, assign) BOOL logining;
@property (nonatomic, weak) UIImageView *coverView;
@property (nonatomic, weak) UIViewController *baseController;

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
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.frame = self.view.bounds;
    [self.view addSubview:imageView];
    _coverView = imageView;
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (_coverView && ![XHUser currentUser].isLogin && ![XHUser currentUser].autoLoginEnable) {
        [self showLoginViewController];
    }
}

- (void)showLoginViewController {
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    XHNavigationController *nav = [[XHNavigationController alloc] initWithRootViewController:loginViewController];
    nav.navigationBarHidden = true;
    [self presentViewController:nav animated:false completion:^{
        [self.coverView removeFromSuperview];
    }];
}

- (void)relogin {
    WEAKSELF;
    _logining = [[XHUser currentUser] reloginHandler:^(XHAPIResult * _Nonnull result, XHJSON * _Nonnull JSON) {
        if (result.isSuccess) {
            [weakSelf listOfDevices];
        }else {
            [weakSelf showLoginViewController];
            weakSelf.logining = false;
        }
    }];
}

- (void)listOfDevices {
    WEAKSELF;
    [XHAPI listOfDevicesByToken:[XHUser currentUser].token handler:^(XHAPIResult * _Nonnull result, XHJSON * _Nonnull JSON) {
        if (result.isSuccess) {
            NSArray *array1 = JSON.JSONArrayValue;
            NSMutableArray *array2 = [NSMutableArray arrayWithCapacity:array1.count];
            for (XHJSON *json in array1) {
                XHDevice *device = [[XHDevice alloc] initWithJSON:json];
                [array2 addObject:device];
            }
            [XHUser currentUser].devices = [array2 copy];
            [[NSNotificationCenter defaultCenter] postNotificationName:XHUserDidLoginNotification object:nil];
        }else {
            [weakSelf showLoginViewController];
        }
        [weakSelf.coverView removeFromSuperview];
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
