//
//  DBManager.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/20.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "DBManager.h"
#import "XHUser.h"
#import "XHDevice.h"

@implementation DBManager

+ (nonnull DBManager * )sharedInstance {
    static DBManager * sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DBManager alloc] init];
    });
    return sharedInstance;
}

- (NSString *)getCurrentDevicePhone {
    XHUser *user = [XHUser currentUser];
    XHDevice *device = user.currentDevice;
    if (!device) {
        return nil;
    }
    NSString *key = [NSString stringWithFormat:@"%@_%@",user.account, device.simMark];
    return [[NSUserDefaults standardUserDefaults] stringForKey:key];
}

- (void)setCurrentDevicePhone:(NSString *)phone {
    XHUser *user = [XHUser currentUser];
    XHDevice *device = user.currentDevice;
    if (!device) {
        return;
    }
    NSString *key = [NSString stringWithFormat:@"%@_%@",user.account, device.simMark];
    [[NSUserDefaults standardUserDefaults] setObject:phone forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
