//
//  DeviceInfoViewController.h
//  LaoRenJi
//
//  Created by RunHao on 2018/11/3.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "XHNavigationBarController.h"

NS_ASSUME_NONNULL_BEGIN

@class XHDevice;

@interface DeviceInfoViewController : XHNavigationBarController

@property (nonatomic, weak) XHDevice *device;

@end

NS_ASSUME_NONNULL_END
