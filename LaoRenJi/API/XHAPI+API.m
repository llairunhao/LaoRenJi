//
//  XHAPI+API.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/14.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "XHAPI+API.h"
#import "AFNetworking.h"

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

+ (NSURLSessionDataTask *)registerWithAccount: (NSString *)account
                                  password: (NSString *)password
                                     nickname: (NSString *)nickname
                                   code: (NSString *)code
                                   handler: (nullable XHAPIResultHandler)handler {
    
    NSString *urlString = [self urlStringByPath:@"regeditInterface"];
    NSDictionary *parameters = @{
                                 @"account"    : account,
                                 @"passWord"   : password,
                                 @"nickName"   : nickname,
                                 @"smsCode"    : code,
                                 };
    return [self GET:urlString parameters:parameters handler:handler];
}

+ (NSURLSessionDataTask *)resetPasswordWithAccount: (NSString *)account
                                         password: (NSString *)password
                                         code: (NSString *)code
                                      handler: (nullable XHAPIResultHandler)handler {
    
    NSString *urlString = [self urlStringByPath:@"retrievePasswordInterface"];
    NSDictionary *parameters = @{
                                 @"account"    : account,
                                 @"passWord"   : password,
                                 @"smsCode"    : code,
                                 };
    return [self GET:urlString parameters:parameters handler:handler];
}

+ (NSURLSessionDataTask *)resetPasswordWithToken: (NSString *)token
                                     oldPassword: (NSString *)oldPassword
                                     newPassword: (NSString *)newPassword
                                         handler: (nullable XHAPIResultHandler)handler {
    NSString *urlString = [self urlStringByPath:@"updatePasswordInterface"];
    NSDictionary *parameters = @{
                                 @"token" : token,
                                 @"newPassWord" : newPassword,
                                 @"oldPassWord" : oldPassword,
                                 };
    return [self GET:urlString parameters:parameters handler:handler];
}

+ (NSURLSessionDataTask *)bindDeviceByToken:(NSString *)token
                                    simMark:(NSString *)simMark
                                 deviceName:(NSString *)deviceName
                                    handler:(XHAPIResultHandler)handler {
    NSString *urlString = [self urlStringByPath:@"bindingMobileInterface"];
    NSDictionary *parameters = @{
                                 @"token"    : token,
                                 @"simMark"   : simMark,
                                 @"mobileName" : deviceName,
                                 };
    return [self GET:urlString parameters:parameters handler:handler];
}

+ (NSURLSessionDataTask *)unbindDeviceByToken:(NSString *)token
                                    appAccount:(NSString *)appAccount
                                    handler:(XHAPIResultHandler)handler {
    NSString *urlString = [self urlStringByPath:@"untieMobileInterface"];
    NSDictionary *parameters = @{
                                 @"token"    : token,
                                 @"appAccount"   : appAccount
                                 };
    return [self GET:urlString parameters:parameters handler:handler];
}

+ (NSURLSessionDataTask *)getVerificationCodeByPhone:(NSString *)phone
                                            handler:(nullable XHAPIResultHandler)handler{
    NSString *urlString = [self urlStringByPath:@"sendCodeInterface"];
    NSDictionary *parameters = @{ @"phone" : phone };
    return [self GET:urlString parameters:parameters handler:handler];
}


+ (NSURLSessionDataTask *)pushContent:(NSString *)content
                        toDeviceToken: (NSString *)deviceToken
                              handler:(nullable XHAPIResultHandler)handler{
    
    NSString *urlString = [self urlStringByPath:@"phshMsgAccountInterface"];
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

+ (NSURLSessionDataTask *)uploadAudioData: (NSData *)data
                                   suffix: (NSString *)suffix
                                    token: (NSString *)token
                                  handler: (nullable XHAPIResultHandler)handler {
 
    NSString *urlString = [self urlStringByPath:@"uploadMessageApp"];
    NSDictionary *parameters = @{
                                 @"token" : token,
                                 @"suffix" : suffix
                                 };
    
    void (^block)(id <AFMultipartFormData> formData) = ^(id<AFMultipartFormData>  _Nonnull formData) {
        NSString *name = @"file";
        [formData appendPartWithFileData:data name:name fileName:name mimeType:@"file"];
    };
    return [[self sharedSessionManager] POST:urlString
                                  parameters:parameters
                   constructingBodyWithBlock:block
                                    progress:nil
                                     success:[self successHandler:handler]
                                     failure:[self failureHandler:handler]];
}

+ (NSURLSessionDataTask *)listOfAudiosByToken:(NSString *)token
                                      handler:(nullable XHAPIResultHandler)handler {
    NSString *urlString = [self urlStringByPath:@"getMessageBoardAllByAppInterface"];
    NSDictionary *parameters = @{ @"token" : token };
    return [self GET:urlString parameters:parameters handler:handler];
}

+ (NSURLSessionDataTask *)updateAudioReadStateById: (NSUInteger)audioId
                                           handler: (nullable XHAPIResultHandler)handler {
    
    NSString *urlString = [self urlStringByPath:@"messageBoardByidInterface"];
    NSDictionary *parameters = @{ @"id" : @(audioId) };
    return [self GET:urlString parameters:parameters handler:handler];
}

+ (NSURLSessionDataTask *)locateDeviceByToken: (NSString *)token
                                       status: (XHLocationStatus)status
                                     duration: (NSUInteger)duration
                                        count: (NSUInteger)count
                                     accuracy: (XHLocationAccuracy)accuracy
                                      handler: (nullable XHAPIResultHandler)handler {
    
    NSString *urlString = [self urlStringByPath:@"onOrOffLocationInterface"];
    NSDictionary *parameters = @{
                                 @"token" : token,
                                 @"status" : status,
                                 @"count" : @(count),
                                 @"type" : @(accuracy),
                                 @"dur" : @(duration)
                                 };
    return [self GET:urlString parameters:parameters handler:handler];
}

+ (NSURLSessionDataTask *)getDeviceFenceByToken: (NSString *)token
                                        handler: (nullable XHAPIResultHandler)handler {
    NSString *urlString = [self urlStringByPath:@"getEnclosureInterface"];
    NSDictionary *parameters = @{ @"token" : token };
    return [self GET:urlString parameters:parameters handler:handler];
}

+ (NSURLSessionDataTask *)setDeviceFenceByToken:(NSString *)token
                                      longitude:(CGFloat)longitude
                                        latitude:(CGFloat)latitude
                                         radius:(NSUInteger)radius
                                           name:(NSString *)name
                                        handler:(XHAPIResultHandler)handler {
    NSString *urlString = [self urlStringByPath:@"addEnclosureInterface"];
    NSDictionary *parameters = @{
                                 @"token" : token,
                                 @"longitude":@(longitude),
                                 @"latitude":@(latitude),
                                 @"radius":@(radius),
                                 @"enclosureName" : name
                                 };
    return [self GET:urlString parameters:parameters handler:handler];
}

+ (NSURLSessionDataTask *)listOfLocationsByToken:(NSString *)token
                                       startTime:(NSString *)startTime
                                         endTime:(NSString *)endTime
                                         handler:(XHAPIResultHandler)handler {
    NSString *urlString = [self urlStringByPath:@"getNavigationByMaxMinTimeInterface"];
    NSDictionary *parameters = @{
                                 @"token" : token,
                                 @"startTime": startTime,
                                 @"endTime":endTime,
                                 };
    return [self GET:urlString parameters:parameters handler:handler];
}

+ (NSURLSessionDataTask *)startLiveByToken: (NSString *)token
                                  liveType: (XHLiveType)liveType
                                cameraType: (XHCameraType)cameraType
                                   handler: (nullable XHAPIResultHandler)handler {
    NSString *urlString = [self urlStringByPath:@"startMonitorInterface"];
    NSDictionary *parameters = @{
                                 @"token" : token,
                                 @"type": @(liveType),
                                 @"cameraId" : @(cameraType)
                                 };
    return [self GET:urlString parameters:parameters handler:handler];
}

@end
