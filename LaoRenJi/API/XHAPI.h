//
//  XHAPI.h
//  LaoRenJi
//
//  Created by RunHao on 2018/10/13.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XHAPIResult.h"


typedef void(^XHAPIResultHandler)(XHAPIResult * _Nonnull result, XHJSON * _Nonnull JSON);

NS_ASSUME_NONNULL_BEGIN

@class AFHTTPSessionManager;

@interface XHAPI : NSObject

typedef void(^AFSuccessHandler)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject);
typedef void(^AFFailureHandler)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error);

+ (nonnull AFHTTPSessionManager * )sharedSessionManager;

+ (NSString *)urlStringByPath: (NSString *)path;

+ (NSURLSessionDataTask *)GET: (NSString *)urlString
                   parameters: (NSDictionary *) parameters
                      handler: (nullable XHAPIResultHandler) handler;

+ (NSURLSessionDownloadTask *)downloadFileFromUrlString: (NSString *)urlString
                                             toFilePath: (NSString *)filePath
                                                handler: (nullable XHAPIResultHandler)handler;

+ (AFSuccessHandler)successHandler: (nullable XHAPIResultHandler) handler;
+ (AFFailureHandler)failureHandler: (nullable XHAPIResultHandler) handler;
@end

NS_ASSUME_NONNULL_END

