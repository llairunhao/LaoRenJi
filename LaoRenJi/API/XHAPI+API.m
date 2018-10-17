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


@end
