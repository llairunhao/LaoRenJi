//
//  XHAPI+API.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/14.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "XHAPI+API.h"

@implementation XHAPI (API)

+ (NSURLSessionDataTask *)loginWithAccount:(NSString *)account
                                  password:(NSString *)password
                                   xgToken:(NSString *)xgToken
                                   handler:(XHAPIResultHandler)handler {
    
    NSString *urlString = [self urlStringByPath:@"loginInterface"];
    NSDictionary *parameters = @{
                                 @"account"    : account,
                                 @"passWord"   : password,
                                 @"xgToken"    : xgToken
                                };
    return [self GET:urlString parameters:parameters handler:handler];
}

+ (NSURLSessionDataTask *)getVerificationCodeWithPhone:(NSString *)phone
                                               handler:(nullable XHAPIResultHandler)handler{
    NSString *urlString = [self urlStringByPath:@"sendCodeInterface"];
    NSDictionary *parameters = @{ @"phone" : phone };
    return [self GET:urlString parameters:parameters handler:handler];
}


+ (NSURLSessionDataTask *)pushContent:(NSString *)content
                        toDeviceToken: (NSString *)deviceToken
                              handler:(nullable XHAPIResultHandler)handler{
    
    NSString *urlString = [self urlStringByPath:@"sendCodeInterface"];
    NSDictionary *parameters = @{ @"token" : deviceToken, @"content" : deviceToken };
    return [self GET:urlString parameters:parameters handler:handler];
}


+ (NSURLSessionDataTask *)listOfAlarmClocksByToken: (NSString *)token
                                           handler:(nullable XHAPIResultHandler)handler {
    
    NSString *urlString = [self urlStringByPath:@"getAlarmClockAllInterface"];
    NSDictionary *parameters = @{ @"token" : token };
    return [self GET:urlString parameters:parameters handler:handler];
}


+ (NSURLSessionDataTask *)getAlarmClockById: (NSUInteger )clockId
                                         token: (NSString *)token
                                       handler: (nullable XHAPIResultHandler)handler {
    
    NSString *urlString = [self urlStringByPath:@"getAlarmClockByIdInterface"];
    NSDictionary *parameters = @{ @"token" : token, @"id": @(clockId) };
    return [self GET:urlString parameters:parameters handler:handler];
}

+ (NSURLSessionDataTask *)removeAlarmClockById: (NSUInteger )clockId
                                         token: (NSString *)token
                                       handler: (nullable XHAPIResultHandler)handler {
    
    NSString *urlString = [self urlStringByPath:@"delAlarmClockInterface"];
    NSDictionary *parameters = @{ @"token" : token, @"id": @(clockId) };
    return [self GET:urlString parameters:parameters handler:handler];
}

+ (NSURLSessionDataTask *)updateAlarmClockById: (NSUInteger )clockId
                                         token: (NSString *)token
                                     eventName: (NSString *)eventName
                                  eventContent: (NSString *)eventContent
                                     eventTime: (NSString *)eventTime
                                  timeInterval: (NSString *)timeInterval
                                        enable: (BOOL)enable
                                       simMark: (NSString *)simMark
                                       handler: (nullable XHAPIResultHandler)handler {
    
    NSString *urlString = [self urlStringByPath:@"saveAlarmClockAllInterface"];
    NSDictionary *parameters = @{
                                 @"token" : token,
                                 @"id": @(clockId),
                                 @"eventName" : eventName,
                                 @"eventContent" : eventContent,
                                 @"eventTime" : eventTime,
                                 @"timeInterval" : timeInterval,
                                 @"status" : @(enable ? 1 : 0),
                                 @"simMark" : simMark
                                 };
    return [self GET:urlString parameters:parameters handler:handler];
}

+ (NSURLSessionDataTask *)saveAlarmClockByToken: (NSString *)token
                                     eventName: (NSString *)eventName
                                  eventContent: (NSString *)eventContent
                                     eventTime: (NSString *)eventTime
                                  timeInterval: (NSString *)timeInterval
                                        enable: (BOOL)enable
                                       simMark: (NSString *)simMark
                                        handler: (nullable XHAPIResultHandler)handler {
    NSString *urlString = [self urlStringByPath:@"saveAlarmClockAllInterface"];
    NSDictionary *parameters = @{
                                 @"token" : token,
                                 @"eventName" : eventName,
                                 @"eventContent" : eventContent,
                                 @"eventTime" : eventTime,
                                 @"timeInterval" : timeInterval,
                                 @"status" : @(enable ? 1 : 0),
                                 @"simMark" : simMark
                                 };
    return [self GET:urlString parameters:parameters handler:handler];
}



+ (NSURLSessionDataTask *)listOfDevicesByToken: (NSString *)token
                                       handler: (nullable XHAPIResultHandler)handler {
    
    NSString *urlString = [self urlStringByPath:@"getMobileAllInterface"];
    NSDictionary *parameters = @{ @"token" : token };
    return [self GET:urlString parameters:parameters handler:handler];
}

+ (NSURLSessionDataTask *)getCurrentDeviceStateByToken:(NSString *)token handler:(XHAPIResultHandler)handler {
    NSString *urlString = [self urlStringByPath:@"getOnlineStateInterface"];
    NSDictionary *parameters = @{ @"token" : token };
    return [self GET:urlString parameters:parameters handler:handler];
}

+ (NSURLSessionDataTask *)setCurrentDeviceByToken: (NSString *)token
                                    deviceSimMark: (NSString *)simMark
                                          handler: (XHAPIResultHandler)handler {
    NSString *urlString = [self urlStringByPath:@"getOnlineStateInterface"];
    NSDictionary *parameters = @{ @"token" : token, @"simMark" : simMark };
    return [self GET:urlString parameters:parameters handler:handler];
}

+ (NSURLSessionDataTask *)listOfContactsByToken: (NSString *)token
                                        handler: (nullable XHAPIResultHandler)handler {
    
    NSString *urlString = [self urlStringByPath:@"getContactsAllInterface"];
    NSDictionary *parameters = @{ @"token" : token };
    return [self GET:urlString parameters:parameters handler:handler];
}

+ (NSURLSessionDataTask *)saveContactByToken: (NSString *)token
                                        name: (NSString *)name
                                       phone: (NSString *)phone
                                    isUrgent: (BOOL)isUrgent
                                 urgentLevel: (NSInteger)urgentLevel
                                isAutoAnswer: (BOOL)isAutoAnswer
                                     handler: (nullable XHAPIResultHandler)handler {
    
    NSString *urlString = [self urlStringByPath:@"saveContactsAllInterface"];
    NSDictionary *parameters = @{
                                 @"token" : token,
                                 @"contactName" : name,
                                 @"contactPhone" : phone,
                                 @"isUrgent" : isUrgent ? @(1) : @(0),
                                 @"urgentLevel" : @(urgentLevel),
                                 @"IsAutoAnswer" : isAutoAnswer ? @(1) : @(0)
                                 };
    return [self GET:urlString parameters:parameters handler:handler];
}

+ (NSURLSessionDataTask *)updateContactByToken: (NSString *)token
                                     contactId: (NSUInteger)contactId
                                        name: (NSString *)name
                                       phone: (NSString *)phone
                                    isUrgent: (BOOL)isUrgent
                                 urgentLevel: (NSInteger)urgentLevel
                                isAutoAnswer: (BOOL)isAutoAnswer
                                     handler: (nullable XHAPIResultHandler)handler {
    NSString *urlString = [self urlStringByPath:@"saveContactsAllInterface"];
    NSDictionary *parameters = @{
                                 @"id" : @(contactId),
                                 @"token" : token,
                                 @"contactName" : name,
                                 @"contactPhone" : phone,
                                 @"isUrgent" : isUrgent ? @(1) : @(0),
                                 @"urgentLevel" : @(urgentLevel),
                                 @"IsAutoAnswer" : isAutoAnswer ? @(1) : @(0)
                                 };
    return [self GET:urlString parameters:parameters handler:handler];
}

+ (NSURLSessionDataTask *)removeContactByToken: (NSString *)token
                                     contactId: (NSUInteger)contactId
                                       handler: (nullable XHAPIResultHandler)handler {
    
    NSString *urlString = [self urlStringByPath:@"delContactsInterface"];
    NSDictionary *parameters = @{
                                 @"id" : @(contactId),
                                 @"token" : token
                                 };
    return [self GET:urlString parameters:parameters handler:handler];
}

+ (NSURLSessionDataTask *)saveDeviceWifiByToken: (NSString *)token
                                       wifiName: (NSString *)wifiName
                                           type: (NSInteger)type
                                       password: (NSString *)password
                                        handler: (nullable XHAPIResultHandler)handler {
    NSString *urlString = [self urlStringByPath:@"addWifiInterface"];
    NSDictionary *parameters = @{
                                 @"type" : @(type),
                                 @"token" : token,
                                 @"name" : wifiName,
                                 @"password" : password
                                 };
    return [self GET:urlString parameters:parameters handler:handler];
}

@end
