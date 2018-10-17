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

@interface XHAPI : NSObject


+ (NSString *)urlStringByPath: (NSString *)path;

+ (NSURLSessionDataTask *)GET: (NSString *)urlString
                   parameters: (NSDictionary *) parameters
                      handler: (nullable XHAPIResultHandler) handler;

@end

NS_ASSUME_NONNULL_END

