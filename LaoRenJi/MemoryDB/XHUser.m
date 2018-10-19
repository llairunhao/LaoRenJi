//
//  XHUser.m
//  LaoRenJi
//
//  Created by 菲凡数据科技-iOS开发 on 2018/10/18.
//  Copyright © 2018 西汉科技. All rights reserved.
//

#import "XHUser.h"

@implementation XHUser

+ (nonnull XHUser * )currentUser{
    static XHUser * sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[XHUser alloc] init];
    });
    return sharedInstance;
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
    [[NSNotificationCenter defaultCenter] postNotificationName:XHDeviceDidChangeNotification object:currentDevice];
}

- (NSURL *)avatarURL {
    return [NSURL URLWithString:_avatarURLString];
}

@end
