//
//  DeviceCodeInputViewController.h
//  LaoRenJi
//
//  Created by RunHao on 2018/10/26.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "XHNavigationBarController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DeviceBindingDelegate <NSObject>

- (BOOL)bindDeviceCode: (NSString *)code controller: (UIViewController *)controller;

@end

@interface DeviceCodeInputViewController : XHNavigationBarController

@property (nonatomic, weak)id<DeviceBindingDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
