//
//  XHUser.m
//  LaoRenJi
//
//  Created by 菲凡数据科技-iOS开发 on 2018/10/18.
//  Copyright © 2018 西汉科技. All rights reserved.
//

#import "XHUser.h"
#import <QQ_XGPush/XGPush.h>
#import "XHDevice.h"
#import "DBManager.h"

@implementation XHUser

+ (nonnull XHUser * )currentUser{
    static XHUser * sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[XHUser alloc] init];
        
        
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.account = [[NSUserDefaults standardUserDefaults] stringForKey:@"dashabi_account"];
        self.password = [[NSUserDefaults standardUserDefaults] stringForKey:@"dashabi_password"];
        self.xgToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"dashabi_deviceToken"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvLoginNoti:) name:XHUserDidLoginNotification object:nil];
    }
    return self;
}

- (instancetype)initWithJSON:(XHJSON *)JSON {
    self = [super init];
    if (self) {
        [self setupWithJSON:JSON];
    }
    return self;
}

- (void)setupWithJSON:(XHJSON *)JSON {
    self.token              = [JSON JSONForKey:@"token"].stringValue;
    self.nickname           = [JSON JSONForKey:@"nickName"].stringValue;
    self.avatarURLString    = [JSON JSONForKey:@"headPortrait"].stringValue;
}

- (void)setDevices:(NSArray<XHDevice *> *)devices {
    _devices = devices;
    self.currentDevice = devices.firstObject;
}

- (void)setCurrentDevice:(XHDevice *)currentDevice {
    _currentDevice = currentDevice;
    [[NSUserDefaults standardUserDefaults] setObject:currentDevice.simMark forKey:@"dashabi_simMark"];
    [[NSNotificationCenter defaultCenter] postNotificationName:XHCurrentDeviceDidChangeNotification object:currentDevice];
}

- (NSString *)currentSimMark {
    if (self.currentDevice) {
        return self.currentDevice.simMark;
    }
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"dashabi_simMark"];
}

- (NSURL *)avatarURL {
    return [NSURL URLWithString:_avatarURLString];
}

- (BOOL)isLogin {
    return self.token.length > 0;
}

- (void)logout {
    self.password           =   @"";
    self.token              =   @"";
    self.nickname           =   @"";
    self.avatarURLString    =   @"";
    self.devices            =   @[];
    self.currentDevice      =   nil;
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"dashabi_password"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"dashabi_simMark"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"dashabi_deviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[XGPush defaultManager] stopXGNotification];
    [[DBManager sharedInstance] close];
}

- (BOOL)autoLoginEnable {
    return self.account.length > 0 && self.password.length > 0;
}

- (BOOL)reloginHandler: (XHAPIResultHandler)handler {
    
    if (self.account && self.password && self.xgToken) {
        
        WEAKSELF;
        [XHAPI loginWithAccount:self.account password:self.password xgToken:self.xgToken handler:^(XHAPIResult * _Nonnull result, XHJSON * _Nonnull JSON) {
            if (result.isSuccess) {
                [weakSelf setupWithJSON:JSON];
            }
            if (handler) {
                handler(result, JSON);
            }
            
        }];
        return true;
    }
    return false;
}

- (void)login {
    
    [[NSUserDefaults standardUserDefaults]setObject:self.account forKey:@"dashabi_account"];
    [[NSUserDefaults standardUserDefaults]setObject:self.password forKey:@"dashabi_password"];
    [[NSUserDefaults standardUserDefaults]setObject:self.xgToken forKey:@"dashabi_deviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeDevice:(XHDevice *)device {
    NSMutableArray *array = [ NSMutableArray arrayWithArray:_devices];
    [array removeObject:device];
    self.devices = array;
    if (!self.currentDevice) {
        self.currentDevice = array.firstObject;
    }
}

- (void)recvLoginNoti: (NSNotification *)noti {
    [self login];
}

@end
