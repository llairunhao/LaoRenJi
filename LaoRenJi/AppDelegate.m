//
//  AppDelegate.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/13.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "AppDelegate.h"
#import "FHTRootContainer.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <QQ_XGPush/XGPush.h>
#import "XHUser.h"
#import "XHRemoteNotificationHelper.h"
#import <Bugly/Bugly.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif


@interface AppDelegate ()<XGPushDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [FHTRootContainer rootContainer];
    [self.window makeKeyAndVisible];
    
    [AMapServices sharedServices].apiKey = @"d31a63b706c0987305d663fab59f09eb";
    [AMapServices sharedServices].enableHTTPS = YES;
    
    BuglyConfig * config = [[BuglyConfig alloc] init];
    // 设置自定义日志上报的级别，默认不上报自定义日志
    config.reportLogLevel = BuglyLogLevelInfo;
    config.debugMode = false;
    config.blockMonitorEnable = true;
    config.unexpectedTerminatingDetectionEnable = true;
    config.channel = @"XHKJ";
    [Bugly startWithAppId:@"b0a9dc1637" config:config];
    
    [self setupXGPush: launchOptions];
    
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    if ([XHUser currentUser].token.length > 0) {
        [[XHUser currentUser] reloginHandler:^(XHAPIResult * _Nonnull result, XHJSON * _Nonnull JSON) {
            
        }];
    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"[XGDemo] register APNS fail.\n[XGDemo] reason : %@", error);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"registerDeviceFailed" object:nil];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"didReceiveRemoteNotification: %@",userInfo);
}

/**
 收到通知消息的回调，通常此消息意味着有新数据可以读取（iOS 7.0+）
 
 @param application  UIApplication 实例
 @param userInfo 推送时指定的参数
 @param completionHandler 完成回调
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"[XGDemo] receive slient Notification");
    NSLog(@"[XGDemo] userinfo %@", userInfo);
    [XHRemoteNotificationHelper handleNotificaion: userInfo];
    [[XGPush defaultManager] reportXGNotificationInfo:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark-
- (void)setupXGPush: (NSDictionary *)launchOptions{
    [[XGPush defaultManager] setEnableDebug:YES];
    [[XGPush defaultManager] startXGWithAppID:2200318371 appKey:@"I356GTHM4C4M" delegate:self];
    [[XGPush defaultManager] setXgApplicationBadgeNumber:0];
    [[XGPush defaultManager] reportXGNotificationInfo:launchOptions];
}

#pragma mark - XGPushDelegate
- (void)xgPushDidFinishStart:(BOOL)isSuccess error:(NSError *)error {
    NSLog(@"%s, result %@, error %@", __FUNCTION__, isSuccess?@"OK":@"NO", error);
    
}

- (void)xgPushDidFinishStop:(BOOL)isSuccess error:(NSError *)error {
    
}

- (void)xgPushDidRegisteredDeviceToken:(NSString *)deviceToken error:(NSError *)error {
    NSLog(@"%s, result %@, error %@", __FUNCTION__, error?@"NO":@"OK", error);
    [XHUser currentUser].xgToken = deviceToken;
    [[FHTRootContainer rootContainer] relogin];
}

// iOS 10 新增 API
// iOS 10 会走新 API, iOS 10 以前会走到老 API
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// App 用户点击通知
// App 用户选择通知中的行为
// App 用户在通知中心清除消息
// 无论本地推送还是远程推送都会走这个回调
- (void)xgPushUserNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
//    NSLog(@"[XGDemo] click notification");
//    if ([response.actionIdentifier isEqualToString:@"xgaction001"]) {
//        NSLog(@"click from Action1");
//    } else if ([response.actionIdentifier isEqualToString:@"xgaction002"]) {
//        NSLog(@"click from Action2");
//    }
//
     NSLog(@"didReceiveNotificationResponse :%@", response);
    [[XGPush defaultManager] reportXGNotificationResponse:response];
    
    completionHandler();
   
}

//App 在前台弹通知需要调用这个接口
- (void)xgPushUserNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler  API_AVAILABLE(ios(10.0)){
    [[XGPush defaultManager] reportXGNotificationInfo:notification.request.content.userInfo];
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}
#endif

- (void)xgPushDidReceiveRemoteNotification:(id)notification withCompletionHandler:(void (^)(NSUInteger))completionHandler {
    if ([notification isKindOfClass:[NSDictionary class]]) {
        [[XGPush defaultManager] reportXGNotificationInfo:(NSDictionary *)notification];
        completionHandler(UIBackgroundFetchResultNewData);
    } else if (@available(iOS 10.0, *)) {
        if ([notification isKindOfClass:[UNNotification class]]) {
            [[XGPush defaultManager] reportXGNotificationInfo:((UNNotification *)notification).request.content.userInfo];
            completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
            
            NSLog(@"10----->xgPushDidReceiveRemoteNotification: %@", ((UNNotification *)notification).request.content.userInfo);
        }
    } else {
        // Fallback on earlier versions
    }
   
}

- (void)xgPushDidSetBadge:(BOOL)isSuccess error:(NSError *)error {
    NSLog(@"%s, result %@, error %@", __FUNCTION__, error?@"NO":@"OK", error);
}


@end
