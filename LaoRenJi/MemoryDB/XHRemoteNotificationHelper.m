//
//  XHRemoteNotificationHelper.m
//  LaoRenJi
//
//  Created by 菲凡数据科技-iOS开发 on 2018/11/21.
//  Copyright © 2018 西汉科技. All rights reserved.
//

#import "XHRemoteNotificationHelper.h"
#import <UserNotifications/UserNotifications.h>
#import "DBManager+DeviceLog.h"

@implementation XHRemoteNotificationHelper


+ (void)handleNotificaion: (NSDictionary *)userInfo {
    XHJSON *JSON = [XHJSON JSONWithValue:userInfo];
    JSON = [JSON JSONForKey:@"aps"];
    JSON = [JSON JSONForKey:@"body"];
    NSString *string = JSON.stringValue;
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        NSLog(@"%@", error);
        return;
    }
    [self handleNotificationContent:content];
}


+ (void)handleNotificationContent: (NSDictionary *)content {
    XHJSON *JSON = [XHJSON JSONWithValue:content];
    NSString *cmd = [JSON JSONForKey:@"cmd"].stringValue;
    
    if (cmd.length > 0) {
        if ([cmd isEqualToString:@"readyMonitor"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:XHDeviceDidReadyMonitorNotification object:@([JSON JSONForKey:@"status"].integerValue)];
        }else if ([cmd isEqualToString:@"lowElectricQuantity"]) {
            //低电量告警
            [[DBManager sharedInstance] saveCurrentDeviceLog:XHDeviceLogTypeLowPower timeSp:[[NSDate date] timeIntervalSince1970]];
            [[NSNotificationCenter defaultCenter] postNotificationName:XHNewDeviceLogNotification object:nil];
        }else if ([cmd isEqualToString:@"GoOnline"] || [cmd isEqualToString:@"OffLine"]) {
            //设备上下线
            [[NSNotificationCenter defaultCenter] postNotificationName:XHCurrentDeviceDidChangeNotification object:nil];
        }else if ([cmd isEqualToString:@"messageBoard"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:XHNewMessageNotification object:nil];
        }
    }else {
        cmd = [JSON JSONForKey:@"status"].stringValue;
        if ([cmd isEqualToString:@"navigation"]) {
            //跨略围栏告警推送
            [[DBManager sharedInstance] saveCurrentDeviceLog:XHDeviceLogTypeLeaveFence timeSp:[[NSDate date] timeIntervalSince1970]];
            [[NSNotificationCenter defaultCenter] postNotificationName:XHNewDeviceLogNotification object:nil];
        }else if ([cmd isEqualToString:@"fallAlarm"]) {
            //跌倒告警推送
            [[DBManager sharedInstance] saveCurrentDeviceLog:XHDeviceLogTypeFall timeSp:[[NSDate date] timeIntervalSince1970]];
            [[NSNotificationCenter defaultCenter] postNotificationName:XHNewDeviceLogNotification object:nil];
        }
    }
}

- (void)loaclNotification: (NSString *)text  {
    // 使用 UNUserNotificationCenter 来管理通知
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        //需创建一个包含待通知内容的 UNMutableNotificationContent 对象，注意不是 UNNotificationContent ,此对象为不可变对象。
        UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
        content.title = [NSString localizedUserNotificationStringForKey:@"警告!" arguments:nil];
        content.body = [NSString localizedUserNotificationStringForKey:text
                                                             arguments:nil];
        content.sound = [UNNotificationSound defaultSound];
        
        // 在 alertTime 后推送本地推送
        UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger
                                                      triggerWithTimeInterval:0 repeats:NO];
        
        UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:@"FiveSecond"
                                                                              content:content trigger:trigger];
        
        //添加推送成功后的处理！
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"本地通知" message:@"成功添加推送" preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//            [alert addAction:cancelAction];
//            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
            NSLog(@"推送完成");
        }];
    } else {
        [self loaclNotificationBeforeIOS10:text];
    }
    
    

}


- (void)loaclNotificationBeforeIOS10: (NSString *)text {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    // 设置触发通知的时间
    NSDate *fireDate = [NSDate date];
    NSLog(@"fireDate=%@",fireDate);
    
    notification.fireDate = fireDate;
    // 时区
    notification.timeZone = [NSTimeZone defaultTimeZone];
    // 设置重复的间隔
    notification.repeatInterval = 0;
    
    // 通知内容
    notification.alertTitle = @"警告";
    notification.alertBody =  text;
    notification.applicationIconBadgeNumber = 1;
    // 通知被触发时播放的声音
    notification.soundName = UILocalNotificationDefaultSoundName;
    // 通知参数
//    NSDictionary *userDict = [NSDictionary dictionaryWithObject:@"开始学习iOS开发了" forKey:@"key"];
//    notification.userInfo = userDict;
    
    // ios8后，需要添加这个注册，才能得到授权
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        // 通知重复提示的单位，可以是天、周、月
        notification.repeatInterval = 0;
    } else {
        // 通知重复提示的单位，可以是天、周、月
        notification.repeatInterval = 0;
    }
    
    // 执行通知注册
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}
@end
