//
//  XHAPI.m
//  LaoRenJi
//
//  Created by RunHao on 2018/10/13.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "XHAPI.h"
#import "AFNetworking.h"


typedef void(^AFSuccessHandler)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject);
typedef void(^AFFailureHandler)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error);


@implementation XHAPI

+ (nonnull AFHTTPSessionManager * )sharedSessionManager{
    static AFHTTPSessionManager * sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [AFHTTPSessionManager manager];
        // 2.设置非校验证书模式
        //   sharedInstance.securityPolicy.allowInvalidCertificates = YES;
        [sharedInstance.securityPolicy setValidatesDomainName:NO];
        [sharedInstance.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        sharedInstance.requestSerializer.timeoutInterval = 8.f;
        [sharedInstance.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    });
    return sharedInstance;
}

+ (nonnull NSString *)urlStringByPath: (nonnull NSString *)path {
    return [NSString stringWithFormat:@"%@%@", @"", path];
}


+ (NSURLSessionDataTask *)GET: (nonnull NSString *)urlString
                   parameters: (nonnull NSDictionary *) parameters
                      handler: (nullable XHAPIResultHandler) handler {
    
    AFHTTPSessionManager *manager = [self sharedSessionManager];
    AFSuccessHandler success = [self successHandler:handler];
    AFFailureHandler failure = [self failureHandler:handler];
    return [manager GET:urlString parameters:parameters progress:nil success:success failure:failure];
}


+ (nonnull AFSuccessHandler )successHandler: (nullable XHAPIResultHandler) handler {
    AFSuccessHandler success = ^(NSURLSessionDataTask * _Nullable task , id _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        
        if (!handler) {
            return;
        }
        
        XHAPIResult *result = [[XHAPIResult alloc] init];
        if (responseObject == nil) {
            result.code = XHAPIResultCodeReturnNull;
            result.message = @"空数据";
            handler(result, [XHJSON nullJSON]);
            return;
        }
        
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            result.code = XHAPIResultCodeIntenalError;
            result.message = @"无法解析的数据格式";
            handler(result, [XHJSON nullJSON]);
            return;
        }
        
        XHJSON *JSON = [XHJSON JSONWithValue:responseObject];
        result.code = [JSON JSONForKey:@"code"].integerValue;
        result.message =  [JSON JSONForKey:@"msg"].stringValue;
        if (result.message.length == 0) {
            result.message = [NSString stringWithFormat:@"未知错误:%@", @(result.code)];
        }
         handler(result, [JSON JSONForKey:@"object"]);
        
    };
    return success;
}

+ (nonnull AFFailureHandler)failureHandler: (nullable XHAPIResultHandler) handler {
    AFFailureHandler failure = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (handler) {
            XHAPIResult *result = [[XHAPIResult alloc] init];
            result.code = error.code;
            result.message = error.localizedDescription;
            handler(result, [XHJSON nullJSON]);
        }
        NSLog(@"%@", error);
    };
    return failure;
}

@end
