//
//  XHAPI+API.h
//  LaoRenJi
//
//  Created by RunHao on 2018/10/14.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import "XHAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface XHAPI (API)

+ (NSURLSessionDataTask *)loginWithAccount: (NSString *)account
                                  password: (NSString *)password
                                   xgToken: (NSString *)xgToken
                                   handler: (nullable XHAPIResultHandler)handler;

@end

NS_ASSUME_NONNULL_END
