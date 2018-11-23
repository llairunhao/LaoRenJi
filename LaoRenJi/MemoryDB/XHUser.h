//
//  XHUser.h
//  LaoRenJi
//
//  Created by 菲凡数据科技-iOS开发 on 2018/10/18.
//  Copyright © 2018 西汉科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XHAPI+API.h"

NS_ASSUME_NONNULL_BEGIN

@class XHDevice;

@interface XHUser : NSObject <XHJSONObjectDelegate>

+ (nonnull XHUser * )currentUser;

@property (nonatomic, copy, nullable) NSString *account;
@property (nonatomic, copy, nullable) NSString *password;
@property (nonatomic, copy, nullable) NSString *nickname;
@property (nonatomic, copy, nullable) NSString *avatarURLString;
@property (nonatomic, copy, nullable) NSString *token;
@property (nonatomic, copy, nullable) NSString *xgToken;

@property (nonatomic, strong) NSArray<XHDevice *> *devices;
@property (nonatomic, weak) XHDevice *currentDevice;
@property (nonatomic, readonly, nullable) NSString *currentSimMark;
@property (nonatomic, readonly) BOOL isLogin;
@property (nonatomic, readonly) BOOL autoLoginEnable;

@property (nonatomic, readonly) NSURL *avatarURL;

- (void)logout;
- (void)login;
- (void)removeDevice: (XHDevice *)device;
- (BOOL)reloginHandler: (XHAPIResultHandler)handler;

@end

NS_ASSUME_NONNULL_END
