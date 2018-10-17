//
//  XHAPIResult.h
//  LaoRenJi
//
//  Created by RunHao on 2018/10/14.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, XHAPIResultCode)   {
    XHAPIResultCodeSuccess         = 200,
    XHAPIResultCodeEmpty           = 1001,
    XHAPIResultCodeReturnNull      = 9000,
    XHAPIResultCodeLogout          = 10001,
    XHAPIResultCodeIntenalError,
};

NS_ASSUME_NONNULL_BEGIN

@interface XHAPIResult : NSObject

@property (nonatomic, assign)NSInteger code;
@property (nonatomic, copy) NSString *message;

@property (nonatomic, readonly) BOOL isSuccess;

@end

NS_ASSUME_NONNULL_END
