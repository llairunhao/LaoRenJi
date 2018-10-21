//
//  NSString+Valid.h
//  LaoRenJi
//
//  Created by RunHao on 2018/10/20.
//  Copyright © 2018年 西汉科技. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Valid)

- (BOOL)isPhoneNumber;
- (BOOL)isNumberOnly;
- (BOOL)isAlphaNumeric;

@end

NS_ASSUME_NONNULL_END
